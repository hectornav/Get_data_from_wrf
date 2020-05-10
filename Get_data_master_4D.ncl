
;++++++++++++++++++++++++++++++++++++++++++++++
;+       Hector Navarro Barboza 2019          +
;++++++++++++++++++++++++++++++++++++++++++++++
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
;
;****************************************************************************
;***    Coords
lat_x = -7.15
lon_x = -76.91
;choose the level which you want to extract data from 0-31 in my case
;because my wrfout has 32 levels
lev_x= 0
;Path of file
DIR_DATA = "/home/hector/Build_WRF/WRF-4.1.5/run/"
;WRF file
in_file = "wrfout_d02_2020-04-01_00:00:00"
;ID
f = addfile(DIR_DATA+in_file,"r")
;Variale
nz = 32 ; levels in your wrf file
VAR = f->PM10 ;varible with 4 dim

t_char = f->Times
printVarSummary(t_char)
n=dimsizes(t_char)
tim = ispan(1,n(0),1)
lat = f->XLAT(0,:,1)
lon = f->XLONG(0,1,:)
lev = ispan(0,nz-1,1); here is a vector with 32 levels

;********************
VAR!0    = "time"
VAR!1    = "lev"
VAR!2    = "lat"
VAR!3    = "lon"
VAR&time =   tim
VAR&lev  =   lev
VAR&lat  =   lat
VAR&lon  =   lon
printVarSummary(VAR)
; Extrayendo la serie de tiempo del punto mas cercano a lat = -12.0, lon = -75.0
V = VAR(:,{lev_x},{lat_x},{lon_x})
printVarSummary(V)
;***    Obteniendo los valores de las fechas en UTC
yy = stringtofloat(t_char(:,0:3))
mm = stringtofloat(t_char(:,5:7))
dd = stringtofloat(t_char(:,8:10))
hh = stringtofloat(t_char(:,11:12))
;printVarSummary(yy)
;print(yy)
write_table("PM10.csv","a",[/"Year","month","day","hour","PM10(ug/m3)"/], \
              "%s, %s, %s, %s, %s")
write_table("PM10.csv","a",[/yy,mm,dd,hh,V/], \
              "%4.0f,%4.0f,%4.0f,%4.0f,%8.4f")

end

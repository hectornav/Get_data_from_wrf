;*****************************************************
;* Created by Hector Navarro-Barboza 2019            *
;*****************************************************
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRF_contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

begin
;
;****************************************************************************
;***    Coords
lat_x = -7
lon_x = -76.9166666667
;Path of file
DIR_DATA = "/home/hector/Build_WRF/WRF-4.1.5/run/"
;WRF file
in_file = "wrfout_d02_2020-04-01_00:00:00"
;ID
f = addfile(DIR_DATA+in_file,"r")
;Variable
VAR = f->T2-273

t_char = f->Times
printVarSummary(t_char)
n=dimsizes(t_char)
tim = ispan(1,n(0),1)
lat = f->XLAT(0,:,1)
lon = f->XLONG(0,1,:)

VAR!0    = "time"
VAR!1    = "lat"
VAR!2    = "lon"
VAR&time =   tim
VAR&lat  =   lat
VAR&lon  =   lon
printVarSummary(VAR)

V = VAR(:,{lat_x},{lon_x})
printVarSummary(V)
;***
yy = stringtofloat(t_char(:,0:3))
mm = stringtofloat(t_char(:,5:7))
dd = stringtofloat(t_char(:,8:10))
hh = stringtofloat(t_char(:,11:12))

write_table("T2.csv","a",[/"Year","month","day","hour","T2 (C)"/], \
              "%s, %s, %s, %s, %s")
write_table("T2.csv","a",[/yy,mm,dd,hh,V/], \
              "%4.0f,%4.0f,%4.0f,%4.0f,%8.4f")

end

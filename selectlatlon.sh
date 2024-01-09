#!/bin/bash
# selecting latitudes and longitudes from all data
##### Inputs and Outputs ###########################
input_file="/data/Climate/agcd_v2-0-1_precip_total_r001_monthly_ALL.nc" 
output_file="/data/Climate/agcd_v2_precipt_Noongar_monthly_ALL.nc"

#if file already exists, delete
rm -f ${output_file}

#select longitude and latitude box
cdo sellonlatbox,114.80,123.80,-35.26,-29.76 ${input_file} ${output_file}

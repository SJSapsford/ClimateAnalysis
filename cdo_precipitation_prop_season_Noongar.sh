#!/bin/bash
#script to run CDO
#the following uses the results from cdo_precipitation_season.sh
#to calculate the proportional change in precipitation (not absolute)
# step 1:
##### Inputs ########################### 
input_file_diff="/Programs/Climate/processed/Precipitation/agcd_v2_precip_makuru_1993_2022_minus_1961_1990.nc"
input_file_hist="/Programs/Climate/processed/Precipitation/agcd_v2_precip_makurutimmean_1961_to_1990.nc"


output_dir="/Programs/Climate/processed/Precipitation/"

#we are using 1951-1980 has historic
#1993-2022 as current

hyear_in="1961"
hyear_out="1990"

cyear_in="1993"
cyear_out="2022"

########################################
# code starts here
# create the output_dir in case it does not already exit
mkdir -p ${output_dir}

#definte output file
winter_diff_prop=${output_dir}agcd_v2_precip_winter_prop_makuru_${cyear_in}_${cyear_out}_minus_${hyear_in}_${hyear_out}.nc

#delete if already there
rm -f ${winter_diff_prop}

#divide by historic
#cdo div ${input_file_diff} ${input_file_hist} ${winter_diff_prop}

#suggestion to do the following
cdo -b 64 div ${input_file_diff} ${input_file_hist} ${winter_diff_prop} 

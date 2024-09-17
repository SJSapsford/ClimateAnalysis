#!/bin/bash
#script to run CDO
#the following uses the results from cdo_precipitation_season.sh
#to calculate the proportional change in precipitation (not absolute)
#this will be done for 4 seasons and Noongar seasons
#I just change the input and output file each time before running the code
# step 1:
##### Inputs ########################### 
input_file_diff="/Programs/Climate/NoongarProcessedMarch24/agcd_v2_precip_spring_1993_2022_minus_1961_1990.nc"
input_file_hist="/Programs/Climate/NoongarProcessedMarch24/agcd_v2_precip_springtimmean_1961_to_1990.nc"


output_dir="/Programs/Climate/NoongarProcessedMarch24/"

#we are using 1961-1990 has historic
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
winter_diff_prop=${output_dir}agcd_v2_precip_prop_spring_${cyear_in}_${cyear_out}_minus_${hyear_in}_${hyear_out}.nc

#delete if already there
rm -f ${winter_diff_prop}

#divide by historic
cdo div ${input_file_diff} ${input_file_hist} ${winter_diff_prop}

#suggestion to do the following
#cdo -b 64 div ${input_file_diff} ${input_file_hist} ${winter_diff_prop} 

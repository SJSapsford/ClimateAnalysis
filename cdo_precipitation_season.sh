#!/bin/bash
#script to run CDO
#the following selects specific months
#e.g. winter months to determine changes in winter precipitation
# step 1: need to extract the months of interest from main SWWA file
##### Inputs ###########################
input_file="/data/Climate/agcd_v2_precip_SWWA_monthly_ALL.nc" 

#step 2: need to select the months of interest for each file
#winter precipitation: May-September (05/09)
month_start="05"
month_end="09"
output_dir="/data/Climate/processed/Precipitation/"
########################################
# code starts here
# create the output_dir in case it does not already exit
mkdir -p ${output_dir}

# define an output file name that makes sense
file_out_winter=${output_dir}agcd_v2_precip_winteryearsum_${month_start}_to_${month_end}.nc

# delete the output file in case it already exists
rm -f ${file_out_winter}

#select own season and take sum of precipitation for that season
cdo -yearsum -select,season=MJJAS ${input_file} ${file_out_winter}

#step 3 select year ranges you want to compare
#we are using 1951-1980 has historic
#1993-2022 as current

hyear_in="1961"
hyear_out="1990"

cyear_in="1993"
cyear_out="2022"

#define output file
winter_hist=${output_dir}agcd_v2_precip_wintertimmean_${hyear_in}_to_${hyear_out}.nc
winter_curr=${output_dir}agcd_v2_precip_wintertimmean_${cyear_in}_to_${cyear_out}.nc

#delete the outputs if already there
rm -f ${winter_hist}
rm -f ${winter_curr}

#select and sum years
cdo -timmean -selyear,${hyear_in}/${hyear_out} ${file_out_winter} ${winter_hist}
cdo -timmean -selyear,${cyear_in}/${cyear_out} ${file_out_winter} ${winter_curr}

#step 4: compare historic to current
#define output
winter_diff=${output_dir}agcd_v2_precip_winter_${cyear_in}_${cyear_out}_minus_${hyear_in}_${hyear_out}.nc

#delete if already there
rm -f ${winter_diff}

#calculate difference
cdo sub ${winter_curr} ${winter_hist} ${winter_diff}

#!/bin/bash
#script to run CDO
#the following selects specific months
#e.g. winter months to determine changes in winter precipitation
# step 1: need to extract the months of interest from main SWWA file
##### Inputs ###########################
input_file="/Programs/Climate/agcd_v2_precip_SWWA_monthly_ALL.nc" 

#step 2: need to select the months of interest for each file
#winter precipitation: May-September (05/09)
month_start="05"
month_end="09"
output_dir="/Programs/Climate/processed/Precipitation/"
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

#step 3 select year ranges
#want 2022 winter precipitation
cyear="2022"

#define output file
winter_curr=${output_dir}agcd_v2_precip_wintersum_${cyear}.nc

#delete the outputs if already there
rm -f ${winter_curr}

#select and sum years
cdo selyear,${cyear} ${file_out_winter} ${winter_curr}

#!/bin/bash
#script to run CDO
#the following selects specific months
#e.g. winter months to determine changes in temperature (min)
#or e.g. summer months (tmax) (see comments and where code could be hashed out) - some areas didn't hash out but changed actual file names
# step 1: need to extract the months of interest from main SWWA file
##### Inputs ###########################
#input_file="/data/Climate/agcd_v1_tmin_mean_SWWA_monthly_ALL.nc" 
input_file="/data/Climate/agcd_v1_tmax_mean_SWWA_monthly_ALL.nc"
#step 2: need to select the months of interest for each file
#winter min temp: May-September (05/09)
#month_start="05"
month_start="12"
#month_end="09"
month_end="02"

output_dir="/data/Climate/processed/Temperature/"
########################################
# code starts here
# create the output_dir in case it does not already exit
mkdir -p ${output_dir}

# define an output file name that makes sense
#file_out_winter=${output_dir}agcd_v1_tmin_winteryearmean_${month_start}_to_${month_end}.nc
file_out_summer=${output_dir}agcd_v1_tmax_summeryearmean_${month_start}_to_${month_end}.nc

# delete the output file in case it already exists
#rm -f ${file_out_winter}
rm -f ${file_out_summer}

#select own season and take sum of precipitation for that season
#cdo -yearmean -select,season=MJJAS ${input_file} ${file_out_winter}

#select summer months and take the mean temperature of those months
cdo -seasmean -select,season=DJF ${input_file} ${file_out_summer}

#step 3 select year ranges you want to compare
#we are using 1951-1980 has historic
#1993-2022 as current

hyear_in="1961"
hyear_out="1990"

cyear_in="1993"
cyear_out="2022"

#define output file
#winter_hist=${output_dir}agcd_v1_tmin_wintertimmean_${hyear_in}_to_${hyear_out}.nc
#winter_curr=${output_dir}agcd_v1_tmin_wintertimmean_${cyear_in}_to_${cyear_out}.nc

summer_hist=${output_dir}agcd_v1_tmax_summertimmean_${hyear_in}_to_${hyear_out}.nc
summer_curr=${output_dir}agcd_v1_tmax_summertimmean_${cyear_in}_to_${cyear_out}.nc

#delete the outputs if already there
#rm -f ${winter_hist}
#rm -f ${winter_curr}
rm -f ${summer_hist}
rm -f ${summer_curr}


#select and sum years
cdo -timmean -selyear,${hyear_in}/${hyear_out} ${file_out_summer} ${summer_hist}
cdo -timmean -selyear,${cyear_in}/${cyear_out} ${file_out_summer} ${summer_curr}

#step 4: compare historic to current
#define output
summer_diff=${output_dir}agcd_v1_tmax_summer_${cyear_in}_${cyear_out}_minus_${hyear_in}_${hyear_out}.nc

#delete if already there
#rm -f ${winter_diff}
rm -f ${summer_diff}

#calculate difference
cdo sub ${summer_curr} ${summer_hist} ${summer_diff}

#!/bin/bash
#the following script is to run CDO to calculate annual precipitation changes
#following the four western hemisphere seasons (Summer, Autumn, Winter, Spring)
#first step is to select the months of each season (3 months for each season)
#we will calculate the sum of precipitation for each season
# step 1: need to extract the months of interest from main SWWA file
##### Inputs ###########################
input_file="/Programs/Climate/NoongarProcessedMarch24/agcd_v2_precip_total_r001_monthly_ALL.nc" 

#Four seasons
#Summer season:December-January-February (12/01/02)
#season="summer"
#Autumn: March-April-May (03/04/05)
#season="autumn"
#winter: June-July-August (06/07/08)
#season="winter"
#Spring: September-October-November (09/10/11)
season="spring"

month_start="09"
month_end="11"
output_dir="/Programs/Climate/NoongarProcessedMarch24/"
########################################
# code starts here
# create the output_dir in case it does not already exit
mkdir -p ${output_dir}

# define an output file name that makes sense
file_out_winter=${output_dir}agcd_v2_precip_sum${season}_${month_start}_to_${month_end}.nc

# delete the output file in case it already exists
rm -f ${file_out_winter}

#select own season and take sum of precipitation for that season
#when calculating over Dec/Jan you need to use seassum or seasmean
#however, every other time period yearsum or yearmean is used
#cdo -seassum -select,season=DJF ${input_file} ${file_out_winter}
cdo -yearsum -select,season=SON ${input_file} ${file_out_winter}

#step 2 select year ranges you want to compare
#we are using 1961-1990 as historic
#1993-2022 as current

hyear_in="1961"
hyear_out="1990"

cyear_in="1993"
cyear_out="2022"

#define output file
winter_hist=${output_dir}agcd_v2_precip_${season}timmean_${hyear_in}_to_${hyear_out}.nc
winter_curr=${output_dir}agcd_v2_precip_${season}timmean_${cyear_in}_to_${cyear_out}.nc

#delete the outputs if already there
rm -f ${winter_hist}
rm -f ${winter_curr}

#select and sum years
cdo -timmean -selyear,${hyear_in}/${hyear_out} ${file_out_winter} ${winter_hist}
cdo -timmean -selyear,${cyear_in}/${cyear_out} ${file_out_winter} ${winter_curr}

#step 4: compare historic to current
#define output
winter_diff=${output_dir}agcd_v2_precip_${season}_${cyear_in}_${cyear_out}_minus_${hyear_in}_${hyear_out}.nc

#delete if already there
rm -f ${winter_diff}

#calculate difference
cdo sub ${winter_curr} ${winter_hist} ${winter_diff}

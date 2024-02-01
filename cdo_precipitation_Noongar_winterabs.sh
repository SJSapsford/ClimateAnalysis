#!/bin/bash
#the following script is to run CDO to calculate annual precipitation changes
#following the six Noongar seasons
#first step is to select the months of each season (2 months for each season)
#we will calculate the sum of precipitation for each season
# step 1: need to extract the months of interest from main SWWA file
##### Inputs ###########################
input_file="/Programs/Climate/agcd_v2_precip_SWWA_monthly_ALL.nc" 

#Noongar seasons
#Birak season:December-January (12/01)
#season="birak"
#Bunuru: February-March (02/03)
#season="bunuru"
#Djeran: April-May (04/05)
#season="djeran"
#Makuru: June-July (06/07)
season="makuru"
#Djilba: August-September (08/09)
#season="djilba"
#Kambarang: October-November (10/11) 
#season="kambarang"

month_start="06"
month_end="07"
output_dir="/Programs/Climate/processed/Precipitation/"
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
#cdo -seassum -select,season=DJ ${input_file} ${file_out_winter}
cdo -yearsum -select,season=JJ ${input_file} ${file_out_winter}

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

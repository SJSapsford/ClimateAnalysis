#!/bin/bash
#the following script is to run CDO to calculate rainfall anomolies for Noongar seasons

# step 1: need to extract the months of interest from main SWWA file
##### Inputs ###########################
input_file="/Programs/Climate/NoongarProcessedMarch24/Anomalies/masked_precipitation_noongar.nc" 

#Four seasons
#Summer season:December-January-February (12/01/02)
season="summer"
#Autumn: March-April-May (03/04/05)
#season="autumn"
#Winter: June-July-August (06/07/08)
#season="winter"
#spring: September-October-November (09/10/11) 
#season="spring"

# Define the season of interest (e.g., June to August for winter in the Southern Hemisphere)
month_start="12"  # Replace with your specific months
month_end="02"

# Define the climatology period (e.g., 1981-2010)
year_in="1961"
year_out="1990"


# Define output files
seasonal_output=${output_dir}${season}_precip.nc
climatology_output=${output_dir}${year_in}_to_${year_out}_${season}.nc
anomaly_output=${output_dir}${season}_precip_anomaly.nc
anomaly_mean_output=${output_dir}${season}_precip_mean_anomaly.nc

# Extract seasonal precipitation for each year
#when calculating over Dec/Jan you need to use seassum or seasmean
#however, every other time period yearsum or yearmean is used

cdo -seassum -select,season=DJF $input_file $seasonal_output
#cdo -yearsum -select,season=FM $input_file $seasonal_output

# Calculate the 30-year climatology for the season of interest
cdo -timmean -selyear,${year_in}/${year_out} $seasonal_output $climatology_output

# Calculate anomalies: (seasonal precipitation - climatology)
cdo sub $seasonal_output $climatology_output $anomaly_output

#calculate field mean
cdo fldmean $anomaly_output $anomaly_mean_output

#old code from before
#month_start="12"
#month_end="01"
#output_dir="/Programs/Climate/NoongarProcessedMarch24/Anomalies/"
########################################
# code starts here
# create the output_dir in case it does not already exist
#mkdir -p ${output_dir}

# define an output file name that makes sense
#file_out=${output_dir}precip_sum${season}_${month_start}_to_${month_end}.nc

# delete the output file in case it already exists
#rm -f ${file_out}

#select own season and take sum of precipitation for that season
#when calculating over Dec/Jan you need to use seassum or seasmean
#however, every other time period yearsum or yearmean is used
#cdo -seassum -select,season=DJ ${input_file} ${file_out}
#cdo -yearsum -select,season=ON ${input_file} ${file_out_winter}

#step 2 select year ranges you want to compare
#we are using 1961-1990 as historic
#1993-2022 as current

#hyear_in="1961"
#hyear_out="1990"

#cyear_in="1993"
#cyear_out="2022"

#define output file
#winter_hist=${output_dir}precip_${season}timmean_${hyear_in}_to_${hyear_out}.nc
#winter_curr=${output_dir}precip_${season}timmean_${cyear_in}_to_${cyear_out}.nc

#delete the outputs if already there
#rm -f ${winter_hist}
#rm -f ${winter_curr}

#select and sum years
#cdo -timmean -selyear,${hyear_in}/${hyear_out} ${file_out_winter} ${winter_hist}
#cdo -timmean -selyear,${cyear_in}/${cyear_out} ${file_out_winter} ${winter_curr}

#step 4: compare historic to current
#define output
#winter_diff=${output_dir}agcd_v2_precip_${season}_${cyear_in}_${cyear_out}_minus_${hyear_in}_${hyear_out}.nc

#delete if already there
#rm -f ${winter_diff}

#calculate difference
#cdo sub ${winter_curr} ${winter_hist} ${winter_diff}

#!/bin/bash
#the following script is to run CDO to calculate rainfall anomolies for Noongar seasons

# step 1: need to extract the months of interest from main SWWA file
##### Inputs ###########################
input_file="/Programs/Climate/NoongarProcessedMarch24/Anomalies/masked_precipitation_noongar.nc" 

#Noongar seasons
#Birak season:December-January (12/01)
#season="birak"
#Bunuru: February-March (02/03)
#season="bunuru"
#Djeran: April-May (04/05)
#season="djeran"
#Makuru: June-July (06/07)
#season="makuru"
#Djilba: August-September (08/09)
#season="djilba"
#Kambarang: October-November (10/11) 
#season="kambarang"
seasons=("birak" "bunuru" "djeran" "makuru" "djilba" "kambarang")

# Define the season of interest (e.g., June to August for winter in the Southern Hemisphere)
#month_start="12"  # Replace with your specific months
#month_end="01"
seasons_months=("DJ" "FM" "AM" "JJ" "AS" "ON")

# Define the climatology period (e.g., 1961-1990)
year_in="1961"
year_out="1990"

output_dir="/Programs/Climate/NoongarProcessedMarch24/Anomalies/"

#Get array length
length=${#seasons[@]}

#Loop through the array
for ((i=0; i<$length; i++))
do

# Define output files
seasonal_output=${output_dir}${seasons[$i]}_precip.nc
climatology_output=${output_dir}${year_in}_to_${year_out}_${seasons[$i]}.nc
anomaly_output=${output_dir}${seasons[$i]}_precip_anomaly.nc
mean_anomaly_output=${output_dir}${seasons[$i]}_precip_mean_anomaly.nc

cdo -seassum -select,season=${seasons_months[$i]} $input_file $seasonal_output

cdo -timmean -selyear,${year_in}/${year_out} $seasonal_output $climatology_output

cdo sub $seasonal_output $climatology_output $anomaly_output

cdo fldmean $anomaly_output $mean_anomaly_output

done


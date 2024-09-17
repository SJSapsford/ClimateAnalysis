#!/bin/bash
#the following script is to run CDO to calculate rainfall anomolies for EACH MONTH
#this is to tease out trends we are seeing in the different seasons

# step 1: need to extract the months of interest from main SWWA file
##### Inputs ###########################
input_file="/Programs/Climate/NoongarProcessedMarch24/Anomalies/masked_precipitation_noongar.nc" 

#Months of the year
months=("01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12")

# Define the climatology period (e.g., 1961-1990)
year_in="1961"
year_out="1990"

output_dir="/Programs/Climate/NoongarProcessedMarch24/Anomalies/MonthlyAnomolies/"

#Get array length
length=${#months[@]}

#Loop through the array
for ((i=0; i<$length; i++))
do

# Define output files
monthly_output=${output_dir}${months[$i]}_precip.nc
climatology_output=${output_dir}${year_in}_to_${year_out}_${months[$i]}.nc
anomaly_output=${output_dir}${months[$i]}_precip_anomaly.nc
mean_anomaly_output=${output_dir}${months[$i]}_precip_mean_anomaly.nc

cdo -selmon -select,month=${months[$i]} $input_file $monthly_output

cdo -timmean -selyear,${year_in}/${year_out} $monthly_output $climatology_output

cdo sub $monthly_output $climatology_output $anomaly_output

cdo fldmean $anomaly_output $mean_anomaly_output

done


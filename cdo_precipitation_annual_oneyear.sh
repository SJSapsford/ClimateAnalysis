#!/bin/bash
#script to run CDO on precipitation data
#want annual precipitation for 2022 (most recent time)

#following by mean across time
##### Inputs ###########################
input_file="/Programs/Climate/agcd_v2_precip_SWWA_monthly_ALL.nc" 

#current year
cyear="2022"

#define output directory: this will be precipitation or temperature
output_dir="/Programs/Climate/processed/Precipitation/"
########################################
# code starts here for selecting year ranges
# create the output_dir in case it does not already exit
mkdir -p ${output_dir}

# define an output file
file_out=${output_dir}agcd_v2_precip_monthly_${cyear}.nc

# delete the output files in case they already exists
rm -f ${file_out}

#select year
cdo selyear,${cyear} ${input_file} ${file_out}

##############################################
# taking the annual precipitation (sum)
#the input files will be the output files of previous step (from selyear function)

#define output file for annual means for each range
file_out_csum=${output_dir}agcd_v2_precip_yearsum_${cyear}.nc

#remove output files in case already exist
rm -f ${file_out_csum}

#annual means
cdo yearsum ${file_out} ${file_out_csum}

########################################

#!/bin/bash
#script to run CDO: steo 1: extract data over a particular range of years
##### Inputs ###########################
input_file="/data/Climate/agcd_v2_precip_SWWA_monthly_ALL.nc" 

# select data from two particular years
year_start="2017"
year_end="2022"
output_dir="/data/Climate/processed/"
########################################
# code starts here
# create the output_dir in case it does not already exit
mkdir -p ${output_dir}

# define an output file name that makes sense
file_out=${output_dir}agcd_v2_precip_monthly_${year_start}_to_${year_end}.nc
#echo "${file_out}"

# delete the output file in case it already exists
rm -f ${file_out}
cdo selyear,${year_start}/${year_end} ${input_file} ${file_out}

## now calculate yearly sums (annual precipitation) on file_out
#define an output file for yearly sums
sum_out=${output_dir}agcd_v2_precip_sum_${year_start}_to_${year_end}.nc
cdo yearsum ${file_out} ${sum_out}

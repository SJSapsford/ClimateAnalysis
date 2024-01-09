#!/bin/bash
#script to run CDO on precipitation data, to extract data over a particular range of years
#then takes the annual sum of the years
#following by mean across time
##### Inputs ###########################
input_file="/data/Climate/agcd_v2_precip_SWWA_monthly_ALL.nc" 

# select data from two particular ranges
#historic 1961-1990
hyear_start="1961"
hyear_end="1990"

#current: this could be whatever you want to compare to historic range
#for now use 1993-2022, but maybe 2017-2022?
cyear_start="1993"
cyear_end="2022"

#define output directory: this will be precipitation or temperature
output_dir="/data/Climate/processed/Precipitation/"
########################################
# code starts here for selecting year ranges
# create the output_dir in case it does not already exit
mkdir -p ${output_dir}

# define an output file for historic range
file_out_his=${output_dir}agcd_v2_precip_monthly_${hyear_start}_to_${hyear_end}.nc

#define an output file for current range
file_out_cur=${output_dir}agcd_v2_precip_monthly_${cyear_start}_to_${cyear_end}.nc

# delete the output files in case they already exists
rm -f ${file_out_his}
rm -f ${file_out_cur}

#select historic range
cdo selyear,${hyear_start}/${hyear_end} ${input_file} ${file_out_his}

#select current range
cdo selyear,${cyear_start}/${cyear_end} ${input_file} ${file_out_cur}

##############################################
# taking the annual precipitation (sum)
#the input files will be the output files of previous step (from selyear function)

#define output file for annual means for each range
file_out_hsum=${output_dir}agcd_v2_precip_yearsum_${hyear_start}_to_${hyear_end}.nc
file_out_csum=${output_dir}agcd_v2_precip_yearsum_${cyear_start}_to_${cyear_end}.nc

#remove output files in case already exist
rm -f ${file_out_hsum}
rm -f ${file_out_csum}

#annual means
cdo yearsum ${file_out_his} ${file_out_hsum}
cdo yearsum ${file_out_cur} ${file_out_csum}

############################################
#need to take the mean across the whole time series so have a single point
#then substract current range from historic range to get difference
#the inputs will be the outputs from the yearsum function above

#define output file for timmean function
file_out_htimmean=${output_dir}agcd_v2_precip_timmean_${hyear_start}_to_${hyear_end}.nc
file_out_ctimmean=${output_dir}agcd_v2_precip_timmean_${cyear_start}_to_${cyear_end}.nc

#remove output files in case already exist
rm -f ${file_out_htimmean}
rm -f ${file_out_ctimmean}

#run timmean function
cdo timmean ${file_out_hsum} ${file_out_htimmean}
cdo timmean ${file_out_csum} ${file_out_ctimmean}

#substract two files from each other
#define output file
final_output=${output_dir}agcd_v2_precip_${cyear_start}_${cyear_end}_minus_${hyear_start}_${hyear_end}.nc

#delete output file if already exists
rm -f ${final_output}

#run function
cdo sub ${file_out_ctimmean} ${file_out_htimmean} ${final_output}


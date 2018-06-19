#!/bin/bash
#
#
session_id=$1
service_id=$2
status_file=$3
result_file_volume=$4
result_file_surface=$5
file_to_upload_volume=$6
file_to_upload_surface=$7
gss_output_folder=$8

#start: added for orientation optimization
slices_in=$9
hatch_thickness=${10}
out_uri_volume=${11}
out_uri_surface=${12}
#end

logFile=/tmp/training_log.txt

echo "0" > $target_dir/$status_file_basename

echo -e "\n\nAsync service deployed on 10.30.1.106" >> $logFile
echo "service_id: $service_id" >> $logFile
echo "status_file: $status_file" >> $logFile

status_file_basename=$(basename "$status_file")
result_file_basename=$(basename "$result_file")
file_to_upload_basename=$(basename "$file_to_upload")
echo "status_file_basename: $status_file_basename" >> $logFile

target_dir=/tmp/$service_id
echo "target_dir: $target_dir"

# Create the target dir on the local and remote machine.
#mkdir -p $target_dir <-- done from java from before
#ssh root@10.30.1.112 mkdir -p $target_dir
mkdir -p $target_dir

# Make sure there is a status file:
echo "10" > $target_dir/$status_file_basename

# Start the long running job on the compute machine
echo "Starting the remote job ..."  >> $logFile
#ssh root@10.30.1.112 "/usr/local/bin/asyncSleeper.sh $session_id $target_dir/$status_file_basename $target_dir/$file_to_upload_basename $target_dir/$result_file_basename $gss_output_folder"

cmd="/usr/local/bin/slice2mesh.sh $session_id $slices_in $out_uri_volume $out_uri_surface $hatch_thickness $target_dir $status_file_basename $result_file_volume $result_file_surface $file_to_upload_volume $file_to_upload_surface "

echo "RUNNING $cmd"

$cmd

echo "The remote job is done."  >> $logFile

# Fetch the data.
#scp root@10.30.1.112:$target_dir/$result_file_basename $target_dir/$result_file_basename

# Print status to remote status file (which is the one being read by getServiceStatus
#ssh root@10.30.1.112 "echo 100 > $target_dir/$status_file_basename"
echo "100" > $target_dir/$status_file_basename

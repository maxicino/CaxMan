#!/bin/bash

TOKEN_GSS=$1
INPUT_MODEL_GSS=$2
OUTPUT_MODEL_GSS=$3

TARGET_DIR=$4
RESULT_FILE=$5

OUTPUT_FILE=$6

DOWNLOAD_TOOL="/root/infrastructureClients/gssClients/gssPythonClients/download_gss.py"
UPLOAD_TOOL="/root/infrastructureClients/gssClients/gssPythonClients/upload_gss.py"

DEG_CLEANER_TOOL="/root/CaxMan/demo_services/degenerate_cleaner/build/deg_cleaner"

DOWNLOADED_FILE=$TARGET_DIR/input.off

rm -f $DOWNLOADED_FILE
rm -f $OUTPUT_FILE

# download file from gss
cmd_download="python $DOWNLOAD_TOOL $INPUT_MODEL_GSS $DOWNLOADED_FILE $TOKEN_GSS"

echo $cmd_download

$cmd_download

# run orientation optimization
$DEG_CLEANER_TOOL $DOWNLOADED_FILE $OUTPUT_FILE

# upload outputt file to gss
cmd_upload="python $UPLOAD_TOOL $OUTPUT_MODEL_GSS $OUTPUT_FILE $TOKEN_GSS"

echo $cmd_upload

$cmd_upload > $RESULT_FILE

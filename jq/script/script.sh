#!/bin/bash

# Purpose : Script to combine JSON File and delete the file and take backup

# Execution Time
current_time=$(date +%F_%H%M%S)

if ls ../jq/*.json 1> /dev/null 2>&1; then
  /usr/bin/jq -s 'add' ../jq/*.json > ../jq/final_output.json # Merge Json File
  tar --remove-files --exclude ../jq/final_output.json -cvzf ../archive/jq_${current_time}.tar.gz ../jq/*.json 2>/dev/null # Backup and Delete Files
else
  exit
fi

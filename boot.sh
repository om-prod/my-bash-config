#!/bin/bash
# this is ran by the on-start service
json_file="/home/sysadmin/my_bash_config/variables.json"

json_init="$(jq '.keyPriority = "int"' $json_file)"
echo $json_init > $json_file
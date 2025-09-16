#!/bin/bash

mongo1_port=27017
mongo2_port=27018
mongo3_port=27019

# host=phx-support-tools-staging-1.corp.nutanix.com

host=localhost
# check if the corresponding mongod instances are running

mongo1_pid=$(ps -ef | grep mongod | grep $mongo1_port | awk '{print $2}')
mongo2_pid=$(ps -ef | grep mongod | grep $mongo2_port | awk '{print $2}')
mongo3_pid=$(ps -ef | grep mongod | grep $mongo3_port | awk '{print $2}')

if [ -z "$mongo1_pid" ]; then
  echo -e "\n❌ mongod instance for mongo1 is not running"
else
  echo -e "\n✅ mongod instance for mongo1 is running with pid $mongo1_pid & port $mongo1_port"
fi

if [ -z "$mongo2_pid" ]; then
  echo -e "\n❌ mongod instance for mongo2 is not running"
else
  echo -e "\n✅ mongod instance for mongo2 is running with pid $mongo2_pid & port $mongo2_port"
fi

if [ -z "$mongo3_pid" ]; then
  echo -e "\n❌ mongod instance for mongo3 is not running"
else
  echo -e "\n✅ mongod instance for mongo3 is running with pid $mongo3_pid & port $mongo3_port"
fi

# now connect to one available instance & run rs.status(), then exit

if [ ! -z "$mongo1_pid" ]; then
  status_output=$(mongosh --host $host --port $mongo1_port --eval "rs.status()" --quiet)
else
  if [ ! -z "$mongo2_pid" ]; then
    status_output=$(mongosh --host $host --port $mongo2_port --eval "rs.status()" --quiet)
  else
    if [ ! -z "$mongo3_pid" ]; then
      status_output=$(mongosh --host $host --port $mongo3_port --eval "rs.status()" --quiet)
    fi
  fi
fi

if [ -z "$status_output" ]; then
  echo "No available mongod instance to connect to!"
  exit 1
fi



# grep "PRIMARY" with 4 lines before & save it to a var

primary=$(echo "$status_output" | grep -B 4 "PRIMARY" | grep "name" | awk '{print $2}' | tr -d ',"')

secondary=$(echo "$status_output" | grep -B 4 "SECONDARY" | grep "name" | awk '{print $2}' | tr -d ',"')




echo -e "\n====================================="
echo -e "\nPRIMARY: $primary"
echo -e "\n====================================="
echo -e "\nSECONDARY:\n$secondary"
echo -e "\n=====================================\n\n"
#!/bin/bash

instance=$1

if [ -z "$instance" ]; then
  echo "Usage: start.sh <instance>"
  exit 1
fi



# if mongo1 then port is 27017
if [ "$instance" == "mongo1" ]; then
  port=27017
fi

# if mongo2 then port is 27018
if [ "$instance" == "mongo2" ]; then
  port=27018
fi

# if mongo3 then port is 27019
if [ "$instance" == "mongo3" ]; then
  port=27019
fi

# if invalid instance then exit

if [ -z "$port" ]; then
  echo "Invalid instance - $instance! It should be mongo1, mongo2 or mongo3"
  exit 1
fi

# stop the corresponding mongod instance
# get the process id using the port number & kill

pid=$(ps -ef | grep mongod | grep $port | awk '{print $2}')

if [ -z "$pid" ]; then
  echo "mongod instance for $instance is not running"
  exit 1
fi

kill $pid

echo "Stopped mongod instance for $instance"
#!/bin/bash

# This script should be used as a framework to test a service

# curl -sS http://127.0.0.1:3001

# $1 == $SERVICE_NAME
# $2 == "key" being searched for to know if service is successfully runnning. If found, exit(0)
# $3 == timeout - if exceeded, service failed. exit(1)

name=$1
match=$2
timeOut=$3
START=$SECONDS

contID=`docker ps -aqf "name=$name"`
api="$(cut -d'.' -f2 <<<"$1")"

####################### Loop until until either MATCH is found or TIMEOUT is exceeded #####################
while true; do
    # exec into container and curl service
    line=`curl -sS http://127.0.0.1:3001`

    # MATCH was found
    if grep -q -m 1 "$match" <<< "$line"; then
        exit 0

    # TIMEOUT was exceeded
    elif [ "$(($SECONDS - $START))" -ge "$timeOut" ]; then
        exit 1
    fi

    sleep 1;

done
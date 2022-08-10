#!/bin/sh 
yum -y update
amazon-linux-extras install epel -y
yum install stress -y
# --backoff wait N microseconds before work starts
# --cpu n workers
# --timeout timeout after n seconds
stress --cpu 3 --backoff 180000000 --timeout 600
#!/usr/bin/bash
# SJP 9 Nov 2021
#
# Append the argument to a file, with datestamp

theDate=$(\date -I)     # ISO 8601, natch

# Where to store the log file
logFile=~/box/leger/etc/superLog.txt


# to log a value, the user must include it as an argument
if [ -z $1 ]
    then 
        echo "Usage: provide an argument for super.sh to append to the log"
        exit 1
fi

echo $theDate   $1 >> $logFile



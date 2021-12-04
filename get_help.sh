#!/usr/bin/env bash

# CONFIGURATION
MEM_THRESHOLD=10
CPU_THRESHOLD=30
DISK_THRESHOLD=90

# Store 1 if the usage is high, store 0 otherwise
MEM_HIGH=0
CPU_HIGH=0
DISK_HIGH=0

# function to return CPU usage as 0-100 integer
function cpu_usage() {
   cpu=$(free | awk 'NR == 2 {print $3/$2*100}' | cut -f 1 -d ".")
   echo $cpu
}

# function to return memory usage as 0-100 integer
function mem_usage() {
    mem=$(top -b -n 1 | grep Cpu | awk '{print $8}'| cut -f 2 -d "," | cut -f 1 -d ".")
    echo $mem
}

# function to return disk usage as 0-100 integer
function disk_usage() {
    disk=$(df -P | grep /dev/ |  awk '{print $5}' | cut -f 1 -d "%")
    echo $disk
}

function just_echo () {
    echo "I am just testing output"
}

disk=$(disk_usage)
cpu=$(cpu_usage)
mem=$(mem_usage)

if (( mem >= MEM_THRESHOLD )); then
    MEM_HIGH=1
fi

if (( cpu >= CPU_THRESHOLD )); then
    CPU_HIGH=1
fi

if (( disk >= DISK_THRESHOLD )); then
    DISK_HIGH=1
fi

USAGE_TIER=$(( MEM_HIGH + CPU_HIGH + DISK_HIGH ))
STATUS_PREFIX="HELP TIER:"

# This will be logged as the tier of help we are about to get
if (( USAGE_TIER > 2 )); then
    echo "$STATUS_PREFIX I need a lot of help"
elif (( USAGE_TIER > 1 )); then
    echo "$STATUS_PREFIX I need some help"
elif (( USAGE_TIER > 0 )); then
    echo "$STATUS_PREFIX I need a bit of help"
else
    echo "$STATUS_PREFIX I don't need help"
fi

NUM_MSGS=$(( 10 * USAGE_TIER^2 ))
echo "I will send $NUM_MSGS messages"

for ((i=0; i< NUM_MSGS; i ++ )); do
    line=$(shuf -n 1 tier2.txt)
    wall "$stuff"
done

# todo: behavior should be:
# 1. Check all the system thresholds
# 2. Choose 'tier' of message based on how many thresholds are exceeded
# 3. Select and wall random message from tier
# 4. Look into printing the message to log files as well
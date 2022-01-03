#!/usr/bin/env bash

################## CONFIGURATION ###################
# Thresholds
MEM_THRESHOLD=10
CPU_THRESHOLD=30
DISK_THRESHOLD=90
# Controls whether to print out debugging statements
DEBUG=true
# Path to the files containing the help messages
MSG_PATH=./etc/get_help
# Maximum wait time (ms) in-betwen log messages
# Make sure MAXWAIT*TIER3_COUNT is shorter than the
# interval
MAXWAIT=2000
############## END CONFIGURATION ###################

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

# Call this with an output line to send it wherever
# quality outputs are sold
function outputs() {
    wall "$1"
    logger "$1"
    echo "$1"
}

# Get usages and set the "high-or-not" booleans as appropriate
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
if [ $DEBUG = true ]; then
    if (( USAGE_TIER > 2 )); then
        echo "$STATUS_PREFIX I need a lot of help"
    elif (( USAGE_TIER > 1 )); then
        echo "$STATUS_PREFIX I need some help"
    elif (( USAGE_TIER > 0 )); then
        echo "$STATUS_PREFIX I need a bit of help"
    else
        echo "$STATUS_PREFIX I don't need help"
    fi
fi

NUM_MSGS=$(( 10 * USAGE_TIER^2 ))

if [ $DEBUG = true ]; then
    echo "I will send $NUM_MSGS messages"
fi

for ((i=0; i< NUM_MSGS; i ++ )); do
    wait_ms=$((RANDOM % MAXWAIT))

    if [ $DEBUG = true ]; then
        echo "Waiting for $wait_ms before sending message"
    fi

    sleep "0.$wait_ms"
    line=$(shuf -n 1 "$MSG_PATH/tier$USAGE_TIER.txt")
    outputs "$line"
done
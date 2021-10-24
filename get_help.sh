#!/usr/bin/env bash

# CONFIGURATION
MEM_THRESHOLD=90
CPU_THRESHOLD=90
DISK_THRESHOLD=90

MEM=$(free | awk 'NR == 2 {print $3/$2*100}')
MEM_HIGH=0
CPU_HIGH=0
DISK_HIGH=0

if [ "$MEM" -ge $MEM_THRESHOLD ]; then
    MEM_HIGH=1
fi

# todo: behavior should be:
# 1. Check all the system thresholds
# 2. Choose 'tier' of message based on how many thresholds are exceeded
# 3. Select and wall random message from tier
# 4. Look into printing the message to log files as well
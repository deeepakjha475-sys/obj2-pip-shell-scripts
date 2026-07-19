#!/bin/bash

###########################################################
# Script Name : disk_check.sh
# Purpose     : Display disk usage information
# Author      : Deepak Kumar Jha
###########################################################

LOG_FILE="disk_check.log"

WARNING_THRESHOLD=70
CRITICAL_THRESHOLD=90

show_help() {
    echo "============================================="
    echo "Disk Usage Monitoring Utility"
    echo "============================================="
    echo "Usage:"
    echo "  sh disk_check.sh [-w warning] [-c critical]"
    echo
    echo "Options:"
    echo "  -w    Warning Threshold (Default: 70)"
    echo "  -c    Critical Threshold (Default: 90)"
    echo "  -h    Display Help"
}

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

validate_inputs() {

    if ! [[ "$WARNING_THRESHOLD" =~ ^[0-9]+$ ]]; then
        echo "Invalid warning threshold."
        exit 1
    fi

    if ! [[ "$CRITICAL_THRESHOLD" =~ ^[0-9]+$ ]]; then
        echo "Invalid critical threshold."
        exit 1
    fi

    if [ "$WARNING_THRESHOLD" -ge "$CRITICAL_THRESHOLD" ]; then
        echo "Critical threshold must be greater than warning threshold."
        exit 1
    fi
}

check_command() {

    if ! command -v df >/dev/null 2>&1
    then
        echo "ERROR : df command not found."
        exit 2
    fi

}

while getopts "w:c:h" option
do
    case "$option" in
        w) WARNING_THRESHOLD=$OPTARG ;;
        c) CRITICAL_THRESHOLD=$OPTARG ;;
        h)
            show_help
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

validate_inputs
check_command

log_message "Disk usage check started."

echo
echo "Warning Threshold : ${WARNING_THRESHOLD}%"
echo "Critical Threshold: ${CRITICAL_THRESHOLD}%"

echo
echo "Current Disk Usage"
echo "------------------"

df -h

echo
echo "Threshold Status"

CURRENT=$(df -P | tail -1 | awk '{print $(NF-1)}' | tr -d '%')

if [[ "$CURRENT" =~ ^[0-9]+$ ]]
then

    if [ "$CURRENT" -ge "$CRITICAL_THRESHOLD" ]
    then
        STATUS="CRITICAL"
    elif [ "$CURRENT" -ge "$WARNING_THRESHOLD" ]
    then
        STATUS="WARNING"
    else
        STATUS="OK"
    fi

    echo "Current Usage : ${CURRENT}%"
    echo "Status        : $STATUS"

    log_message "Current Usage : ${CURRENT}%"
    log_message "Status : $STATUS"

else

    echo "Unable to determine usage percentage."
    log_message "Unable to determine usage."

fi

log_message "Disk usage check completed."

exit 0

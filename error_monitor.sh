#!/bin/bash

###########################################################
# Script Name : error_monitor.sh
# Purpose     : Search log files for configurable patterns
# Author      : Deepak Kumar Jha
###########################################################

LOG_FILE="error_monitor.log"

INPUT_FILE=""
PATTERN="ERROR"

show_help() {

    echo "========================================="
    echo "Error Log Monitoring Utility"
    echo "========================================="
    echo "Usage:"
    echo "  sh error_monitor.sh -f <logfile> [-p pattern]"
    echo
    echo "Options:"
    echo "  -f    Log file"
    echo "  -p    Search pattern (Default: ERROR)"
    echo "  -h    Help"

}

log_message() {

    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"

}

while getopts "f:p:h" option
do
    case "$option" in
        f)
            INPUT_FILE=$OPTARG
            ;;
        p)
            PATTERN=$OPTARG
            ;;
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

if [ -z "$INPUT_FILE" ]
then
    echo "Please provide a log file."
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]
then
    echo "Log file not found."
    exit 2
fi

if ! command -v grep >/dev/null 2>&1
then
    echo "grep command not available."
    exit 3
fi

log_message "Monitoring started."
log_message "File : $INPUT_FILE"
log_message "Pattern : $PATTERN"

COUNT=$(grep -ic "$PATTERN" "$INPUT_FILE")

echo
echo "Search Pattern : $PATTERN"
echo "Matches Found  : $COUNT"
echo

if [ "$COUNT" -gt 0 ]
then
    echo "Matching Entries"
    echo "----------------"
    grep -in "$PATTERN" "$INPUT_FILE"
else
    echo "No matching entries found."
fi

log_message "Matches : $COUNT"
log_message "Monitoring completed."

exit 0

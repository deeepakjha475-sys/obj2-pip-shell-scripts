#!/bin/bash

###########################################################
# Script Name : process_check.sh
# Purpose     : Check whether a process is running
# Author      : Deepak Kumar Jha
###########################################################

LOG_FILE="process_check.log"

PROCESS_NAME=""

show_help() {

    echo "========================================="
    echo "Process Health Check Utility"
    echo "========================================="
    echo "Usage:"
    echo "  sh process_check.sh -p <process_name>"
    echo
    echo "Options:"
    echo "  -p    Process name"
    echo "  -h    Help"

}

log_message() {

    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"

}

while getopts "p:h" option
do
    case "$option" in
        p)
            PROCESS_NAME=$OPTARG
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

if [ -z "$PROCESS_NAME" ]
then
    echo "Please provide a process name."
    exit 1
fi

if ! command -v ps >/dev/null 2>&1
then
    echo "ps command not available."
    exit 2
fi

if ! command -v grep >/dev/null 2>&1
then
    echo "grep command not available."
    exit 2
fi

log_message "Checking process : $PROCESS_NAME"

PROCESS_LIST=$(ps -ef | grep -i "$PROCESS_NAME" | grep -v grep | grep -v process_check.sh)

if [ -n "$PROCESS_LIST" ]
then
    echo
    echo "Process Status : RUNNING"
    echo
    echo "Matching Processes"
    echo "------------------"
    echo "$PROCESS_LIST"

    log_message "Process running."

else
    echo
    echo "Process Status : NOT RUNNING"

    log_message "Process not running."
fi

log_message "Process check completed."

exit 0

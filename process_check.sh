#!/bin/bash

###########################################################
# Script Name : process_check.sh
# Purpose     : Check whether a process is running
# Author      : Deepak Kumar Jha
###########################################################

LOG_FILE="process_check.log"

PROCESS_NAME=""

# Exit Codes
EXIT_SUCCESS=0
EXIT_INVALID_INPUT=1
EXIT_DEPENDENCY_MISSING=2
EXIT_PROCESS_NOT_RUNNING=3

show_help() {

echo "============================================================"
echo "Process Health Check Utility"
echo "============================================================"
echo
echo "Purpose:"
echo "  Check whether a specified process is currently running."
echo
echo "Syntax:"
echo "  sh process_check.sh -p <process_name>"
echo
echo "Options:"
echo "  -p <process_name>    Process name (Mandatory)"
echo "  -h                   Display Help"
echo
echo "Examples:"
echo "  sh process_check.sh -p sshd"
echo "  sh process_check.sh -p java"
echo
echo "Exit Codes:"
echo "  0  Process Running"
echo "  1  Invalid Input"
echo "  2  Required Command Missing"
echo "  3  Process Not Running"
echo "============================================================"

}

log_message() {

echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"

}

# Validate mandatory input
if [ $# -eq 0 ]
then
    show_help
    exit $EXIT_INVALID_INPUT
fi

while getopts "p:h" option
do
    case "$option" in

        p)
            PROCESS_NAME=$OPTARG
            ;;

        h)
            show_help
            exit $EXIT_SUCCESS
            ;;

        *)
            show_help
            exit $EXIT_INVALID_INPUT
            ;;

    esac
done

# Validate process name
if [ -z "$PROCESS_NAME" ]
then
    echo "ERROR: Please provide a process name."
    exit $EXIT_INVALID_INPUT
fi

# Validate required commands
if ! command -v ps >/dev/null 2>&1
then
    echo "ERROR: ps command not available."
    exit $EXIT_DEPENDENCY_MISSING
fi

if ! command -v grep >/dev/null 2>&1
then
    echo "ERROR: grep command not available."
    exit $EXIT_DEPENDENCY_MISSING
fi

log_message "=================================================="
log_message "Execution Started"
log_message "Process Name : $PROCESS_NAME"

echo
echo "Checking process..."
echo

# Search for exact process name while excluding grep and this script
PROCESS_LIST=$(ps -ef | grep -w "$PROCESS_NAME" | grep -v grep | grep -v process_check.sh)

if [ -n "$PROCESS_LIST" ]
then

    echo "Process Status : RUNNING"
    echo
    echo "Matching Processes"
    echo "--------------------------------------------------"
    echo "$PROCESS_LIST"

    log_message "Status : RUNNING"
    log_message "Matching Process Found"

    EXIT_CODE=$EXIT_SUCCESS

else

    echo "Process Status : NOT RUNNING"

    log_message "Status : NOT RUNNING"

    EXIT_CODE=$EXIT_PROCESS_NOT_RUNNING

fi

log_message "Execution Completed"
log_message "Exit Code : $EXIT_CODE"
log_message "=================================================="

exit $EXIT_CODE

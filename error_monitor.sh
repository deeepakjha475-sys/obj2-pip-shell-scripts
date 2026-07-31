#!/bin/bash

###########################################################
# Script Name : error_monitor.sh
# Purpose     : Search log files for configurable patterns
# Author      : Deepak Kumar Jha
###########################################################

LOG_FILE="error_monitor.log"

INPUT_FILE=""
PATTERN="ERROR"

# Exit Codes
EXIT_SUCCESS=0
EXIT_INVALID_INPUT=1
EXIT_FILE_NOT_FOUND=2
EXIT_DEPENDENCY_MISSING=3
EXIT_NO_MATCHES=4

show_help() {

echo "============================================================"
echo "Error Log Monitoring Utility"
echo "============================================================"
echo
echo "Purpose:"
echo "  Search log files for configurable patterns."
echo
echo "Syntax:"
echo "  sh error_monitor.sh -f <logfile> [-p pattern]"
echo
echo "Options:"
echo "  -f <logfile>     Log file (Mandatory)"
echo "  -p <pattern>     Search pattern (Default: ERROR)"
echo "  -h               Display Help"
echo
echo "Examples:"
echo "  sh error_monitor.sh -f application.log"
echo "  sh error_monitor.sh -f application.log -p WARNING"
echo "  sh error_monitor.sh -f server.log -p Exception"
echo
echo "Exit Codes:"
echo "  0  Success"
echo "  1  Invalid Input"
echo "  2  Log File Not Found"
echo "  3  Required Command Missing"
echo "  4  Pattern Not Found"
echo "============================================================"

}

log_message() {

echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"

}

# Display help if no arguments are supplied
if [ $# -eq 0 ]
then
    show_help
    exit $EXIT_INVALID_INPUT
fi

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
            exit $EXIT_SUCCESS
            ;;

        *)
            show_help
            exit $EXIT_INVALID_INPUT
            ;;

    esac
done

# Validate mandatory input
if [ -z "$INPUT_FILE" ]
then
    echo "ERROR: Please provide a log file."

    exit $EXIT_INVALID_INPUT
fi

# Validate log file
if [ ! -f "$INPUT_FILE" ]
then
    echo "ERROR: Log file not found."

    exit $EXIT_FILE_NOT_FOUND
fi

# Verify grep command availability
if ! command -v grep >/dev/null 2>&1
then
    echo "ERROR: grep command not available."

    exit $EXIT_DEPENDENCY_MISSING
fi

log_message "=================================================="
log_message "Execution Started"
log_message "Input File : $INPUT_FILE"
log_message "Pattern : $PATTERN"

echo
echo "Searching log file..."
echo

# Count matching entries (case-insensitive)
COUNT=$(grep -ic "$PATTERN" "$INPUT_FILE")

echo "Search Pattern : $PATTERN"
echo "Matches Found  : $COUNT"
echo

if [ "$COUNT" -gt 0 ]
then

    echo "Matching Entries"
    echo "--------------------------------------------------"

    # Display matching lines with line numbers
    grep -in "$PATTERN" "$INPUT_FILE"

    log_message "Status : Matches Found"
    log_message "Total Matches : $COUNT"

    EXIT_CODE=$EXIT_SUCCESS

else

    echo "No matching entries found."

    log_message "Status : No Matches Found"

    EXIT_CODE=$EXIT_NO_MATCHES

fi

log_message "Execution Completed"
log_message "Exit Code : $EXIT_CODE"
log_message "=================================================="

exit $EXIT_CODE

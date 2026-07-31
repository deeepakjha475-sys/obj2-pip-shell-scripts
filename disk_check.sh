#!/bin/bash

###########################################################
# Script Name : disk_check.sh
# Purpose     : Monitor disk usage and report health status
# Author      : Deepak Kumar Jha
###########################################################

LOG_FILE="disk_check.log"

# Default Thresholds
WARNING_THRESHOLD=70
CRITICAL_THRESHOLD=90

# Exit Codes
EXIT_OK=0
EXIT_INVALID_INPUT=1
EXIT_DEPENDENCY_MISSING=2
EXIT_WARNING=3
EXIT_CRITICAL=4

show_help() {
    echo "============================================================"
    echo "Disk Usage Monitoring Utility"
    echo "============================================================"
    echo
    echo "Purpose:"
    echo "  Monitor filesystem disk usage and report health status."
    echo
    echo "Syntax:"
    echo "  sh disk_check.sh [OPTIONS]"
    echo
    echo "Options:"
    echo "  -w <value>    Warning Threshold (Default: 70)"
    echo "  -c <value>    Critical Threshold (Default: 90)"
    echo "  -h            Display this help menu"
    echo
    echo "Validation Rules:"
    echo "  - Thresholds must be numeric"
    echo "  - Thresholds must be between 0 and 100"
    echo "  - Warning threshold must be less than Critical threshold"
    echo
    echo "Examples:"
    echo "  sh disk_check.sh"
    echo "  sh disk_check.sh -w 75 -c 90"
    echo
    echo "Exit Codes:"
    echo "  0  Disk usage within threshold"
    echo "  1  Invalid input"
    echo "  2  Required command missing"
    echo "  3  Warning threshold reached"
    echo "  4  Critical threshold reached"
    echo "============================================================"
}

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

# Validate threshold values
validate_inputs() {

    if ! [[ "$WARNING_THRESHOLD" =~ ^[0-9]+$ ]]; then
        echo "ERROR: Warning threshold must be numeric."
        exit $EXIT_INVALID_INPUT
    fi

    if ! [[ "$CRITICAL_THRESHOLD" =~ ^[0-9]+$ ]]; then
        echo "ERROR: Critical threshold must be numeric."
        exit $EXIT_INVALID_INPUT
    fi

    if [ "$WARNING_THRESHOLD" -lt 0 ] || [ "$WARNING_THRESHOLD" -gt 100 ]; then
        echo "ERROR: Warning threshold must be between 0 and 100."
        exit $EXIT_INVALID_INPUT
    fi

    if [ "$CRITICAL_THRESHOLD" -lt 0 ] || [ "$CRITICAL_THRESHOLD" -gt 100 ]; then
        echo "ERROR: Critical threshold must be between 0 and 100."
        exit $EXIT_INVALID_INPUT
    fi

    if [ "$WARNING_THRESHOLD" -ge "$CRITICAL_THRESHOLD" ]; then
        echo "ERROR: Warning threshold must be less than Critical threshold."
        exit $EXIT_INVALID_INPUT
    fi
}

# Verify required command exists
check_command() {

    if ! command -v df >/dev/null 2>&1
    then
        echo "ERROR: Required command 'df' not found."

        log_message "Dependency validation failed : df command missing"

        exit $EXIT_DEPENDENCY_MISSING
    fi
}

while getopts "w:c:h" option
do
    case "$option" in
        w) WARNING_THRESHOLD=$OPTARG ;;
        c) CRITICAL_THRESHOLD=$OPTARG ;;
        h)
            show_help
            exit $EXIT_OK
            ;;
        *)
            show_help
            exit $EXIT_INVALID_INPUT
            ;;
    esac
done

validate_inputs
check_command

log_message "================================================="
log_message "Execution Started"
log_message "Warning Threshold : ${WARNING_THRESHOLD}%"
log_message "Critical Threshold : ${CRITICAL_THRESHOLD}%"
log_message "Validation Successful"

echo
echo "Warning Threshold : ${WARNING_THRESHOLD}%"
echo "Critical Threshold: ${CRITICAL_THRESHOLD}%"

echo
echo "Disk Usage Summary"
echo "-------------------------------------------------------------"
printf "%-20s %-10s %-12s %-10s\n" "Filesystem" "Usage" "Mounted On" "Status"
echo "-------------------------------------------------------------"

EXIT_STATUS=$EXIT_OK

# Read every mounted filesystem and evaluate its utilization
while read -r FILESYSTEM USAGE MOUNT
do

    CURRENT=${USAGE%\%}

    if ! [[ "$CURRENT" =~ ^[0-9]+$ ]]; then
        continue
    fi

    if [ "$CURRENT" -ge "$CRITICAL_THRESHOLD" ]; then
        STATUS="CRITICAL"
        CODE=$EXIT_CRITICAL

    elif [ "$CURRENT" -ge "$WARNING_THRESHOLD" ]; then
        STATUS="WARNING"
        CODE=$EXIT_WARNING

    else
        STATUS="OK"
        CODE=$EXIT_OK
    fi

    printf "%-20s %-10s %-12s %-10s\n" "$FILESYSTEM" "$USAGE" "$MOUNT" "$STATUS"

    log_message "Filesystem=$FILESYSTEM Usage=$USAGE Mount=$MOUNT Status=$STATUS"

    if [ "$CODE" -gt "$EXIT_STATUS" ]; then
        EXIT_STATUS=$CODE
    fi

done < <(df -P | awk 'NR>1 {print $1,$5,$6}')

echo "-------------------------------------------------------------"

case $EXIT_STATUS in
    0)
        echo "Overall Status : OK"
        ;;
    3)
        echo "Overall Status : WARNING"
        ;;
    4)
        echo "Overall Status : CRITICAL"
        ;;
esac

log_message "Overall Exit Code : $EXIT_STATUS"
log_message "Execution Completed"
log_message "================================================="

exit $EXIT_STATUS

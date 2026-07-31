#!/bin/bash

###########################################################
# Script Name : log_cleanup.sh
# Purpose     : Manage old log files (Dry Run/Delete/Archive)
# Author      : Deepak Kumar Jha
###########################################################

LOG_FILE="cleanup.log"

DIRECTORY="."
RETENTION=7
MODE="dry-run"

# Exit Codes
EXIT_SUCCESS=0
EXIT_INVALID_INPUT=1
EXIT_DIRECTORY_NOT_FOUND=2
EXIT_OPERATION_CANCELLED=3
EXIT_FILES_PROCESSED=4

show_help() {

echo "============================================================"
echo "Log Cleanup Utility"
echo "============================================================"
echo
echo "Purpose:"
echo "  Identify old log files and perform Dry Run,"
echo "  Archive or Delete operations."
echo
echo "Syntax:"
echo "  sh log_cleanup.sh [OPTIONS]"
echo
echo "Options:"
echo "  -d <directory>   Log directory (Mandatory)"
echo "  -r <days>        Retention period (Default: 7)"
echo "  -n               Dry Run Mode (Default)"
echo "  -a               Archive Mode"
echo "  -x               Delete Mode"
echo "  -h               Display Help"
echo
echo "Validation:"
echo "  • Retention must be a non-negative integer."
echo "  • Retention 0 means all .log files are processed."
echo "  • Unsafe directories are rejected."
echo
echo "Examples:"
echo "  sh log_cleanup.sh -d ./logs"
echo "  sh log_cleanup.sh -d ./logs -r 30 -n"
echo "  sh log_cleanup.sh -d ./logs -r 15 -a"
echo "  sh log_cleanup.sh -d ./logs -r 7 -x"
echo
echo "Exit Codes:"
echo "  0  Success"
echo "  1  Invalid Input"
echo "  2  Directory Not Found"
echo "  3  Operation Cancelled"
echo "  4  Files Processed"
echo "============================================================"

}

log_message() {

echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"

}

# Validate retention period
validate_retention() {

if ! [[ "$RETENTION" =~ ^[0-9]+$ ]]
then
    echo "ERROR: Retention period must be numeric."
    exit $EXIT_INVALID_INPUT
fi

if [ "$RETENTION" -lt 0 ]
then
    echo "ERROR: Retention period cannot be negative."
    exit $EXIT_INVALID_INPUT
fi

}

# Prevent accidental execution on critical locations
validate_directory() {

case "$DIRECTORY" in
    ""|"/"|"."|"/bin"|"/boot"|"/dev"|"/etc"|"/lib"|"/proc"|"/root"|"/sys"|"/usr")
        echo "ERROR: Unsafe directory specified."
        exit $EXIT_INVALID_INPUT
        ;;
esac

}

while getopts "d:r:naxh" option
do

case "$option" in

d)
DIRECTORY=$OPTARG
;;

r)
RETENTION=$OPTARG
;;

n)
MODE="dry-run"
;;

a)
MODE="archive"
;;

x)
MODE="delete"
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

# Verify target directory exists
if [ ! -d "$DIRECTORY" ]
then
    echo "ERROR: Directory not found."
    exit $EXIT_DIRECTORY_NOT_FOUND
fi

validate_retention
validate_directory

log_message "=================================================="
log_message "Execution Started"
log_message "Directory : $DIRECTORY"
log_message "Retention : $RETENTION Days"
log_message "Mode : $MODE"

echo
echo "Searching log files..."
echo
# Locate eligible log files
if [ "$RETENTION" -eq 0 ]
then
    FIND_CMD=(find "$DIRECTORY" -type f -name "*.log" -print0)
else
    FIND_CMD=(find "$DIRECTORY" -type f -name "*.log" -mtime +"$RETENTION" -print0)
fi

FILE_COUNT=0

echo "Files Found"
echo "------------------------------------------------------------"

while IFS= read -r -d '' file
do
    echo "$file"
    FILE_COUNT=$((FILE_COUNT + 1))
done < <("${FIND_CMD[@]}")

echo "------------------------------------------------------------"

if [ "$FILE_COUNT" -eq 0 ]
then
    echo
    echo "No eligible log files found."

    log_message "No log files matched the selection criteria."
    log_message "Execution Completed"
    log_message "Exit Code : $EXIT_SUCCESS"
    log_message "=================================================="

    exit $EXIT_SUCCESS
fi

log_message "Files Identified : $FILE_COUNT"

case "$MODE" in

dry-run)

    echo
    echo "Dry Run completed."
    echo "No files were modified."

    log_message "Action Performed : Dry Run"
    log_message "Files Listed : $FILE_COUNT"

    EXIT_CODE=$EXIT_SUCCESS
;;

archive)

    ARCHIVE_DIR="$DIRECTORY/archive"

    # Create archive directory if it does not exist
    mkdir -p "$ARCHIVE_DIR"

    while IFS= read -r -d '' file
    do

        log_message "Archiving : $file"

        mv "$file" "$ARCHIVE_DIR"/

    done < <("${FIND_CMD[@]}")

    echo
    echo "Files archived successfully."
    echo "Archive Location : $ARCHIVE_DIR"

    log_message "Action Performed : Archive"
    log_message "Archive Directory : $ARCHIVE_DIR"
    log_message "Files Archived : $FILE_COUNT"

    EXIT_CODE=$EXIT_FILES_PROCESSED
;;

delete)

    echo
    read -p "Type YES to permanently delete the listed files: " answer

    if [ "$answer" != "YES" ]
    then

        echo
        echo "Operation cancelled."

        log_message "Delete operation cancelled by user."

        exit $EXIT_OPERATION_CANCELLED

    fi

    while IFS= read -r -d '' file
    do

        log_message "Deleting : $file"

        rm -f "$file"

    done < <("${FIND_CMD[@]}")

    echo
    echo "Files deleted successfully."

    log_message "Action Performed : Delete"
    log_message "Files Deleted : $FILE_COUNT"

    EXIT_CODE=$EXIT_FILES_PROCESSED
;;

*)

    echo "Invalid mode selected."

    exit $EXIT_INVALID_INPUT
;;

esac

log_message "Execution Completed"
log_message "Exit Code : $EXIT_CODE"
log_message "=================================================="

exit $EXIT_CODE

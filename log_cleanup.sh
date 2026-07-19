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

show_help() {
    echo "============================================="
    echo "Log Cleanup Utility"
    echo "============================================="
    echo "Usage:"
    echo "  sh log_cleanup.sh -d <directory> -r <days> [OPTION]"

    echo
    echo "Options:"
    echo "  -d    Log directory"
    echo "  -r    Retention days (Default: 7)"
    echo "  -n    Dry Run"
    echo "  -a    Archive files"
    echo "  -x    Delete files"
    echo "  -h    Help"
}

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') : $1" >> "$LOG_FILE"
}

# Handle long options
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
            exit 0
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done


if [ ! -d "$DIRECTORY" ]
then
    echo "Directory not found."
    exit 2
fi

if ! [[ "$RETENTION" =~ ^[0-9]+$ ]]
then
    echo "Retention days must be numeric."
    exit 1
fi

log_message "Cleanup started."
log_message "Directory : $DIRECTORY"
log_message "Retention : $RETENTION Days"
log_message "Mode : $MODE"

if [ "$RETENTION" -eq 0 ]; then
    FILES=$(find "$DIRECTORY" -type f -name "*.log")
else
    FILES=$(find "$DIRECTORY" -type f -name "*.log" -mtime +"$RETENTION")
fi

if [ -z "$FILES" ]
then
    echo "No old log files found."
    log_message "No files found."
    exit 0
fi

echo
echo "Files Found"
echo "-----------"
echo "$FILES"

case "$MODE" in

dry-run)

    echo
    echo "Dry run completed. No files were modified."
    log_message "Dry run completed."
    ;;

delete)

    echo
    read -p "Delete these files? (yes/no): " answer

    if [ "$answer" != "yes" ]
    then
        echo "Operation cancelled."
        exit 3
    fi

    echo "$FILES" | xargs rm -f

    echo "Files deleted."
    log_message "Files deleted."
    ;;

archive)

    mkdir -p "$DIRECTORY/archive"

    for file in $FILES
    do
        mv "$file" "$DIRECTORY/archive/"
    done

    echo "Files archived."
    log_message "Files archived."
    ;;

esac

log_message "Cleanup completed."

exit 0

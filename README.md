# Shell Script Utilities

## Overview

Shell Script Utilities is a collection of reusable Unix/Linux shell scripts developed to automate common operational and system administration tasks. These utilities are designed for L1/L2 support engineers and demonstrate the use of configurable parameters, input validation, logging, meaningful exit codes, and operational best practices.

---

## Features

- Configurable command-line parameters
- Input validation
- Dependency validation
- Consistent logging
- Help menu for each script
- Script-specific exit codes
- Safe file handling
- Reusable operational utilities
- Compatible with Linux and Git Bash

---

## Repository Structure

```
Shell_Script_Utilities/
│
├── disk_check.sh
├── log_cleanup.sh
├── process_check.sh
├── error_monitor.sh
├── README.md
├── disk_check.log
├── cleanup.log
├── process_check.log
└── error_monitor.log
```

---

# Scripts

## 1. disk_check.sh

### Purpose

Monitors disk utilization and reports the current disk status based on configurable warning and critical thresholds.

### Features

- Configurable warning threshold
- Configurable critical threshold
- Threshold validation
- Dependency validation
- Disk utilization monitoring
- Status reporting (OK / WARNING / CRITICAL)
- Logging
- Help menu

### Usage

```bash
bash disk_check.sh [-w warning_threshold] [-c critical_threshold]
```

### Example

```bash
bash disk_check.sh -w 70 -c 90
```

---

## 2. log_cleanup.sh

### Purpose

Identifies old log files and performs cleanup operations using Dry Run, Archive, or Delete modes.

### Features

- Configurable directory
- Configurable retention period
- Dry Run mode
- Archive mode
- Delete mode
- Safety validation
- Confirmation before deletion
- Automatic archive folder creation
- Logging
- Help menu

### Usage

```bash
bash log_cleanup.sh -d <directory> -r <days> [-n | -a | -x]
```

### Examples

```bash
bash log_cleanup.sh -d logs -r 7 -n
```

```bash
bash log_cleanup.sh -d logs -r 7 -a
```

```bash
bash log_cleanup.sh -d logs -r 7 -x
```

---

## 3. process_check.sh

### Purpose

Checks whether a specified process is currently running.

### Features

- Process validation
- Exact process matching
- Dependency validation
- Logging
- Help menu
- Meaningful exit codes

### Usage

```bash
bash process_check.sh -p <process_name>
```

### Example

```bash
bash process_check.sh -p bash
```

---

## 4. error_monitor.sh

### Purpose

Searches log files for configurable error patterns.

### Features

- Configurable search pattern
- Case-insensitive search
- Line number display
- Match count
- Logging
- Help menu
- Input validation

### Usage

```bash
bash error_monitor.sh -f <log_file> [-p pattern]
```

### Example

```bash
bash error_monitor.sh -f sample.log -p ERROR
```

---

# Exit Codes

## disk_check.sh

| Exit Code | Description |
|-----------|-------------|
| 0 | Successful execution |
| 1 | Invalid threshold values |
| 2 | Required command missing |

---

## log_cleanup.sh

| Exit Code | Description |
|-----------|-------------|
| 0 | Successful execution |
| 1 | Invalid input or unsafe directory |
| 2 | Directory not found |
| 3 | Operation cancelled |
| 4 | Archive/Delete operation completed (as implemented) |

---

## process_check.sh

| Exit Code | Description |
|-----------|-------------|
| 0 | Process running |
| 1 | Invalid input |
| 2 | Required command missing |
| 3 | Process not running |

---

## error_monitor.sh

| Exit Code | Description |
|-----------|-------------|
| 0 | Pattern found |
| 1 | Invalid input |
| 2 | Log file not found |
| 3 | Required command missing |
| 4 | Pattern not found |

---

# Validation Performed

The following scenarios were successfully validated:

- Help menu execution
- Successful execution
- Invalid input handling
- Missing dependency validation
- Invalid directory validation
- Invalid threshold validation
- Process running validation
- Process not running validation
- Pattern found validation
- Pattern not found validation
- Dry Run execution
- Archive execution
- Delete execution
- Log generation
- Exit code verification
- Bash syntax validation

---

# Logging

Each utility generates its own execution log.

| Script | Log File |
|----------|----------|
| disk_check.sh | disk_check.log |
| log_cleanup.sh | cleanup.log |
| process_check.sh | process_check.log |
| error_monitor.sh | error_monitor.log |

Each log records:

- Execution start time
- Input parameters
- Validation results
- Operation performed
- Execution status
- Exit code
- Completion time

---

# Prerequisites

- Linux or Git Bash
- Bash shell
- Required utilities:
  - df
  - find
  - grep
  - ps
  - awk
  - mkdir
  - mv
  - rm

---

# Documentation

The project includes:

- README
- Detailed Runbook
- Execution Screenshots
- Test Evidence

---

# Author

**Deepak Kumar Jha**

---

# Version

**Version 2.0**

Enhanced based on review feedback with improved validation, logging, operational safety, configurable parameters, help menus, and reusable shell scripting practices.

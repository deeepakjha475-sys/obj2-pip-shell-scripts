# Shell Script Utilities

## Project Overview

This repository contains a collection of reusable Unix/Linux shell scripts developed for common system administration and application support tasks. The scripts are designed with configurable parameters, input validation, logging, error handling, and meaningful exit codes to improve usability and maintainability.

These utilities were developed as part of a professional scripting enhancement project to demonstrate automation of routine operational activities.

---

## Features

- Configurable input parameters
- Input validation
- Command/dependency validation
- Logging for script execution
- Help menu (`-h`)
- Meaningful exit codes
- Error handling
- Unix/Linux compatible commands
- Modular and reusable scripts

---

## Repository Structure

```
ShellScriptUtilities/
│
├── disk_check.sh
├── log_cleanup.sh
├── error_monitor.sh
├── process_check.sh
│
├── README.md
│
├── disk_check.log
├── cleanup.log
├── error_monitor.log
└── process_check.log
```

---

## Scripts Included

### 1. disk_check.sh

Checks current disk usage and compares it against configurable warning and critical thresholds.

### Features

- Configurable warning threshold
- Configurable critical threshold
- Input validation
- Dependency validation
- Logging
- Help menu
- Exit codes

### Usage

```bash
sh disk_check.sh
```

```bash
sh disk_check.sh -w 70 -c 90
```

```bash
sh disk_check.sh -h
```

---

### 2. log_cleanup.sh

Identifies old log files and performs cleanup operations.

### Features

- Configurable log directory
- Configurable retention period
- Dry Run mode
- Archive mode
- Delete mode
- Confirmation before deletion
- Logging
- Input validation
- Exit codes

### Usage

```bash
sh log_cleanup.sh -d logs -r 30 -n
```

Dry Run

```bash
sh log_cleanup.sh -d logs -r 30 -a
```

Archive Files

```bash
sh log_cleanup.sh -d logs -r 30 -x
```

Delete Files

```bash
sh log_cleanup.sh -h
```

Help

---

### 3. error_monitor.sh

Searches a log file for configurable error patterns.

### Features

- Configurable log file
- Configurable search pattern
- Case-insensitive search
- Match count
- Displays matching entries with line numbers
- Logging
- Exit codes

### Usage

```bash
sh error_monitor.sh -f application.log
```

Default Pattern (ERROR)

```bash
sh error_monitor.sh -f application.log -p WARNING
```

Custom Pattern

```bash
sh error_monitor.sh -h
```

Help

---

### 4. process_check.sh

Checks whether a specified process is currently running.

### Features

- Configurable process name
- Unix/Linux compatible commands
- Logging
- Input validation
- Help menu
- Exit codes

### Usage

```bash
sh process_check.sh -p bash
```

```bash
sh process_check.sh -p git
```

```bash
sh process_check.sh -h
```

---

## Prerequisites

- Git Bash or Linux Environment
- Bash Shell
- grep
- find
- df
- ps

---

## Logging

Each script generates its own log file.

| Script | Log File |
|---------|----------|
| disk_check.sh | disk_check.log |
| log_cleanup.sh | cleanup.log |
| error_monitor.sh | error_monitor.log |
| process_check.sh | process_check.log |

---

## Exit Codes

| Exit Code | Description |
|------------|-------------|
| 0 | Success |
| 1 | Invalid input |
| 2 | Dependency missing / Invalid path |
| 3 | Operation cancelled (where applicable) |
| 4 | Unexpected runtime error (where applicable) |

---

## Test Scenarios

| Script | Success Scenario | Failure Scenario |
|---------|------------------|------------------|
| disk_check.sh | Valid threshold values | Invalid threshold values |
| log_cleanup.sh | Dry run, archive, delete | Invalid directory |
| error_monitor.sh | Pattern found | Log file not found |
| process_check.sh | Running process detected | Process not running |

---

## Error Handling

The scripts perform validation before execution to handle common issues such as:

- Missing required parameters
- Invalid input values
- Missing commands
- Invalid directories
- Missing log files
- User cancellation during delete operations

---

## Author

**Deepak Kumar Jha**

# DevOps Monitoring Toolkit

A practical toolkit with two essential monitoring scripts designed for reliability and clarity. This repository provides solutions for tracking server health (CPU, memory, disk) via a Bash script and verifying application uptime using a Python script.

## Overview

In modern operations, effective monitoring is foundational. This toolkit provides two fundamental scripts that address two distinct layers of the stack: the underlying system infrastructure and the outward-facing application.

The selection of a different language for each script was a deliberate design choice, reflecting the "right tool for the job" philosophy.
*   **Bash** was chosen for system-level monitoring due to its native performance and direct access to kernel information and core utilities.
*   **Python** was selected for application-level checks for its powerful libraries, robust error handling, and superior capabilities in handling network communications.

## Scripts Included

### 1. System Health Monitor (`system_health_monitor.sh`)

This script provides a real-time snapshot of a Linux system's core vitals. It is written in pure Bash to ensure maximum portability and minimal overhead.

**Core Functions:**
*   **Monitors Key Metrics:** Tracks CPU utilization, memory consumption, root filesystem disk space, and the status of critical running processes.
*   **Configurable Thresholds:** Alerting thresholds are defined in variables at the top of the script for easy configuration without altering the core logic.
*   **Robust Logging:** Alerts are timestamped and logged to both the console and a persistent log file (`/var/log/system_health.log`), ensuring a complete audit trail.

**Design Notes:**
The commands used for metric collection, particularly for CPU usage via `top`, have been carefully constructed to maintain compatibility across different Linux distributions and their slightly varied command outputs. This avoids common parsing errors found in less robust scripts.

### 2. Application Health Checker (`app_health_checker.py`)

This Python script determines the availability and correctness of any web-based application by analyzing its HTTP response.

**Core Functions:**
*   **HTTP Status Checks:** Validates an application's health by expecting a successful HTTP status code (2xx). Any other code is flagged as a potential issue.
*   **Graceful Error Handling:** The script is wrapped in comprehensive `try...except` blocks to gracefully manage network failures, such as connection errors or request timeouts.
*   **Intelligent Timeouts:** A non-negotiable timeout is included in every request to prevent the script from hanging indefinitely, a critical feature for any automated monitoring tool.

**Design Notes:**
The use of the `requests` library provides a high-level, human-readable interface for network operations. The script is structured to be runnable both as a standalone tool with command-line arguments and as a module that could be imported into a larger monitoring framework.

## Usage

### Prerequisites

*   For the Python script, the `requests` library must be installed:
    ```
    pip install requests
    ```

### Running the Scripts

1.  **System Health Monitor:**
    Ensure the script is executable and run it.
    ```
    chmod +x system_health_monitor.sh
    ./system_health_monitor.sh
    ```
    *Note: The script may require `sudo` privileges to write to `/var/log/`.*

2.  **Application Health Checker:**
    Run the script with Python, optionally providing a URL as a command-line argument.
    ```
    # Check the default URL (http://google.com)
    python app_health_checker.py

    # Check a specific application
    python app_health_checker.py https://yourapplication.com
    ```
```

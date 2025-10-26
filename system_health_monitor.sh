#!/bin/bash

# --- 1. Configuration ---
# Define thresholds for alerts (in percent)
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80

# Define the log file location
LOG_FILE="/var/log/system_health.log"

# --- 2. Alerting Function ---
# A reusable function to log alerts to the console and a file.
log_alert() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ALERT: $1" | tee -a $LOG_FILE
}

# --- 3. Health Checks ---

# Check 1: CPU Usage
CPU_USAGE=$(top -bn1 | awk '/^CPU:/ {idle=$8; sub(/%/, "", idle); print 100 - idle}')
if [ $CPU_USAGE -gt $CPU_THRESHOLD ]; then
    log_alert "High CPU usage detected: ${CPU_USAGE}%"
fi

# Check 2: Memory Usage
MEM_USAGE=$(free -m | awk 'NR==2{printf "%.0f", $3*100/$2 }')
if [ $MEM_USAGE -gt $MEM_THRESHOLD ]; then
    log_alert "High Memory usage detected: ${MEM_USAGE}%"
fi

# Check 3: Disk Space Usage for the Root Filesystem
DISK_USAGE=$(df -h / | awk 'NR==2{print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
    log_alert "Low Disk Space on root partition ('/'): ${DISK_USAGE}% used"
fi

# Check 4: Critical Process Status
# Checks if a specified process (e.g., 'nginx') is running.
PROCESS_NAME="nginx" # Change this to a process you want to monitor
if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
    log_alert "Critical process '$PROCESS_NAME' is not running."
fi

# --- 4. Completion Log ---
echo "$(date '+%Y-%m-%d %H:%M:%S') - System health check complete." | tee -a $LOG_FILE

#!/bin/bash

echo "=========================================="
echo "        SERVER PERFORMANCE STATS"
echo "=========================================="
echo "Date       : $(date)"
echo "Hostname   : $(hostname)"
echo "OS Version : $(grep PRETTY_NAME /etc/os-release | cut -d '"' -f 2)"
echo "Uptime     : $(uptime -p)"
echo "Load Avg   : $(uptime | awk -F'load average:' '{print $2}')"
echo "=========================================="
echo ""

echo "1. TOTAL CPU USAGE"
echo "------------------------------------------"
CPU_USAGE=$(top -bn1 | grep "%Cpu(s)" | awk '{print 100 - $8}')
printf "CPU Usage: %.2f%%\n" "$CPU_USAGE"
echo ""

echo "2. MEMORY USAGE"
echo "------------------------------------------"
free | grep "Mem:" | awk '{
    total=$2
    used=$3
    free=$4
    available=$7

    printf "Total Memory    : %.2f GiB\n", total/1024/1024
    printf "Used Memory     : %.2f GiB (%.2f%%)\n", used/1024/1024, used/total*100
    printf "Free Memory     : %.2f GiB (%.2f%%)\n", free/1024/1024, free/total*100
    printf "Available Memory: %.2f GiB (%.2f%%)\n", available/1024/1024, available/total*100
}'
echo ""

echo "3. DISK USAGE"
echo "------------------------------------------"
df -h / | awk 'NR==2 {
    printf "Total Disk     : %s\n", $2
    printf "Used Disk      : %s (%s)\n", $3, $5
    printf "Available Disk : %s\n", $4
}'
echo ""

echo "4. TOP 5 PROCESSES BY CPU USAGE"
echo "------------------------------------------"
ps aux --sort=-%cpu | head -n 6 | awk '{
    printf "%-12s %-8s %-8s %s\n", $1, $2, $3, $11
}'
echo ""

echo "5. TOP 5 PROCESSES BY MEMORY USAGE"
echo "------------------------------------------"
ps aux --sort=-%mem | head -n 6 | awk '{
    printf "%-12s %-8s %-8s %s\n", $1, $2, $4, $11
}'
echo ""

echo "6. LOGGED-IN USERS"
echo "------------------------------------------"
who
echo ""

echo "7. FAILED LOGIN ATTEMPTS"
echo "------------------------------------------"
if command -v lastb >/dev/null 2>&1; then
    sudo lastb | head -n 5
else
    echo "lastb command not available on this system."
fi

echo ""
echo "=========================================="
echo "        REPORT COMPLETED"
echo "=========================================="



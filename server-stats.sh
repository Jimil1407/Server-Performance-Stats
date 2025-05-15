#!/bin/bash

echo "===== Server Performance Stats ====="

# CPU Usage
echo -e "\n--- Total CPU Usage ---"
top -bn1 | grep "Cpu(s)" | \
awk '{print "CPU Usage: " 100 - $8 "%"}'

# Memory Usage
echo -e "\n--- Memory Usage ---"
free -m | awk 'NR==2 {
  total=$2; used=$3; free=$4;
  printf "Total: %s MB\nUsed: %s MB\nFree: %s MB\nUsage: %.2f%%\n", 
  total, used, free, used/total*100
}'

# Disk Usage
echo -e "\n--- Disk Usage (Root Partition) ---"
df -h / | awk 'NR==2 {
  printf "Total: %s\nUsed: %s\nAvailable: %s\nUsage: %s\n", 
  $2, $3, $4, $5
}'

# Top 5 processes by CPU
echo -e "\n--- Top 5 Processes by CPU Usage ---"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6 | \
awk 'NR==1{print "PID\tCOMMAND\t%CPU\t%MEM"} NR>1{print}'

# Top 5 processes by Memory
echo -e "\n--- Top 5 Processes by Memory Usage ---"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 6 | \
awk 'NR==1{print "PID\tCOMMAND\t%CPU\t%MEM"} NR>1{print}'

echo -e "\n===== End of Report ====="


#!/bin/bash

echo "===== Server Performance Stats ====="

# CPU Usage
echo -e "\n--- Total CPU Usage ---"
CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
printf "CPU Usage: %.2f%%\n" "$CPU_USAGE"

# Memory Usage
echo -e "\n--- Memory Usage ---"
VM_STATS=$(vm_stat)
PAGES_FREE=$(echo "$VM_STATS" | grep "Pages free" | awk '{print $3}' | tr -d '.')
PAGES_ACTIVE=$(echo "$VM_STATS" | grep "Pages active" | awk '{print $3}' | tr -d '.')
PAGES_INACTIVE=$(echo "$VM_STATS" | grep "Pages inactive" | awk '{print $3}' | tr -d '.')
PAGES_SPECULATIVE=$(echo "$VM_STATS" | grep "Pages speculative" | awk '{print $3}' | tr -d '.')
PAGES_WIRED=$(echo "$VM_STATS" | grep "Pages wired down" | awk '{print $4}' | tr -d '.')

PAGE_SIZE=$(sysctl -n hw.pagesize)
TOTAL_USED_PAGES=$((PAGES_ACTIVE + PAGES_INACTIVE + PAGES_SPECULATIVE + PAGES_WIRED))
TOTAL_FREE_PAGES=$PAGES_FREE
TOTAL_MEM_PAGES=$((TOTAL_USED_PAGES + TOTAL_FREE_PAGES))

TOTAL_USED_MB=$((TOTAL_USED_PAGES * PAGE_SIZE / 1024 / 1024))
TOTAL_FREE_MB=$((TOTAL_FREE_PAGES * PAGE_SIZE / 1024 / 1024))
TOTAL_MEM_MB=$((TOTAL_MEM_PAGES * PAGE_SIZE / 1024 / 1024))
USAGE_PERCENT=$(echo "scale=2; $TOTAL_USED_MB * 100 / $TOTAL_MEM_MB" | bc)

echo "Total Memory: ${TOTAL_MEM_MB} MB"
echo "Used Memory: ${TOTAL_USED_MB} MB"
echo "Free Memory: ${TOTAL_FREE_MB} MB"
echo "Usage: ${USAGE_PERCENT}%"

# Disk Usage
echo -e "\n--- Disk Usage (Root Partition) ---"
df -h / | awk 'NR==2 {
  printf "Total: %s\nUsed: %s\nAvailable: %s\nUsage: %s\n",
  $2, $3, $4, $5
}'

# Top 5 processes by CPU
echo -e "\n--- Top 5 Processes by CPU Usage ---"
ps -A -o pid,comm,%cpu,%mem | sort -k3 -nr | head -n 6

# Top 5 processes by Memory
echo -e "\n--- Top 5 Processes by Memory Usage ---"
ps -A -o pid,comm,%cpu,%mem | sort -k4 -nr | head -n 6

echo -e "\n===== End of Report ====="


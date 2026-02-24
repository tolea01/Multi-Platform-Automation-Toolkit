#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

check_requirements() {
	if ! command -v bc &> /dev/null; then
		echo -e "${YELLOW}Script requires bc package${NC}"
		exit 1
	fi
}

check_system_load() {
 CPU_LOAD=$(uptime | awk -F 'load average:' '{print $2}' | cut -d, -f1 | xargs)

	echo -ne "CPU Load (1 min): $CPU_LOAD"

	if (( $(echo "$CPU_LOAD > 2.0" | bc -l) )); then
		echo -e "[${RED}HIGHT LOAD${NC}]"
	else
		echo -e " [${GREEN}OK${NC}]"
	fi

	MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

	printf "Memory Usage: %.2f%% " $MEM_USAGE

	if (( $(echo "$MEM_USAGE > 80.0" | bc -l) )); then
		echo -e "[${RED}CRITICAL${NC}]"
	else
		echo -e "[${GREEN}OK${NC}]"
	fi

	DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed ' s/%//g')

	echo -ne "Disk Usage (/): ${DISK_USAGE}% "

	if [[ "$DISK_USAGE" -gt 85 ]]; then
		echo -e "[${RED}LOW SPACE${NC}]"
	else
		echo -e "[${GREEN}OK${NC}]"
	fi
}

echo -e "${YELLOW}=== System Health Report - $(date) ===${NC}"

check_requirements
check_system_load

echo -e "${YELLOW}--------------------------------------${NC}"
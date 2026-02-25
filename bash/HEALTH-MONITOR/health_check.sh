#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

LOG_FILE="system_stats.log"
LOG_PATH=$(readlink -f "$LOG_FILE")
DISK_THRESHOLD=85
MEM_THRESHOLD=80.0
CPU_THRESHOLD=2.0

check_requirements() {
	if ! command -v bc &> /dev/null; then
		echo -e "${YELLOW}Script requires bc package${NC}"
		exit 1
	fi
}

show_help() {
	echo "Usage: $0 [OPTIONS]"
	echo "Options:"
  echo "  --disk THRESHOLD    Set disk usage threshold (default: 85)"
	echo "  --mem THRESHOLD    Set memory usage threshold (default: 80)"
	echo "  --mem THRESHOLD    Set cpu usage threshold (default: 2.0)"
  echo -e "  --help, -h          Show this help message\n"
  echo "Example:"
  echo -e "  $0 --disk 90        Check disk with 90% threshold\n"
	echo ""
	exit 0				
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --disk)
            DISK_THRESHOLD="$2"
            shift 2
            ;;
        --mem)
            MEM_THRESHOLD="$2"
            shift 2
            ;;
        --cpu)
            CPU_THRESHOLD="$2"
            shift 2
            ;;
        --help|-h)
            show_help
            ;;
        *)
            echo "Error: Unknown option '$1'"
            show_help
            exit 1
            ;;
    esac
done

check_system_load() {
	echo -e "${YELLOW}=== System Health Report - $(date) ===${NC}"

	CPU_LOAD=$(uptime | awk -F 'load average:' '{print $2}' | cut -d, -f1 | xargs)

	echo -ne "CPU Load (1 min): $CPU_LOAD"

	if (( $(echo "$CPU_LOAD > $CPU_THRESHOLD" | bc -l) )); then
		echo -e "[${RED}HIGHT LOAD${NC}]"
	else
		echo -e " [${GREEN}OK${NC}]"
	fi

	MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

	printf "Memory Usage: %.2f%% " $MEM_USAGE

	if (( $(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc -l) )); then
		echo -e "[${RED}CRITICAL${NC}]"
	else
		echo -e "[${GREEN}OK${NC}]"
	fi

	DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed ' s/%//g')

	echo -ne "Disk Usage (/): ${DISK_USAGE}% "

	if [[ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]]; then
		echo -e "[${RED}LOW SPACE${NC}]"
	else
		echo -e "[${GREEN}OK${NC}]\n"
	fi

	echo -e "${YELLOW}3 process that consume the most resources:${NC}"

	ps -eo user,pid,%cpu,%mem --sort=-%mem | head -4

	echo -e "${YELLOW}Log file: $LOG_PATH"

	echo -e "${YELLOW}--------------------------------------${NC}"
}

check_requirements
check_system_load | tee -a $LOG_FILE
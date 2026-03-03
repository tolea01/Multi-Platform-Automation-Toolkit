#!/bin/bash

LOG_FILE="./access.log"
AWK_SCRIPT="./log-parser.awk"
IP_API=""

if [ ! -f "$LOG_FILE" ]; then
	echo "Fisierul $LOG_FILE nu exista"
	exit 1
fi

if [ -f "$AWK_SCRIPT" ]; then
	chmod +x "$AWK_SCRIPT"
else
	echo "Scriptul $AWK_SCRIPT nu exista"
	exit 1
fi

get_ip_info() {}
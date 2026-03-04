#!/bin/bash

LOG_FILE="./access.log"
AWK_SCRIPT="./log-parser.awk"
IP_API="api.ip2location.io"

if [ ! -f "$LOG_FILE" ]; then
 echo "Fisierul $LOG_FILE nu exista" >&2
 exit 1
fi

if [ -f "$AWK_SCRIPT" ]; then
 chmod +x "$AWK_SCRIPT"
else
 echo "Scriptul $AWK_SCRIPT nu exista" >&2
 exit 1
fi

if ! command -v curl &> /dev/null || ! command -v jq &> /dev/null; then
 echo "curl or jq package is missing" >&2
 exit 1
fi

get_ip_info() {
 local ip_addr="$1"

 if [[ ! -z "$ip_addr" ]] && [[ ! "$ip_addr" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Eroare fromat adresa ip" >&2
  return 1
 fi

 local api_res

 if ! api_res=$(curl -s --fail "$IP_API?ip=$ip_addr" 2>/dev/null); then
  echo "API error" >&2
  return 1
 fi

 echo "$api_res" | jq -r '.country_name'
}
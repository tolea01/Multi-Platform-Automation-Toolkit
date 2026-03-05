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
  echo "Error ip address format" >&2
  return 1
 fi

 local api_res

 if ! api_res=$(curl -s --fail "$IP_API?ip=$ip_addr" 2>/dev/null); then
  echo "API error" >&2
  return 1
 fi

 echo "$api_res" | jq -r '.country_name'
}

send_alert_message() {
	local message="$1"
	local webhook_url="https://discord.com/api/webhooks/1479104889316573216/G79JQqLAdp8HzKsc-TTGknHDkGBRvkqELxCHh06blXR-uC2DRVUF7p-NSgZ5j4LvFWt_"

	curl -H "Content-Type: application/json" \
		-X POST \
		-d "{\"content\": \"$message\"}" \
		"$webhook_url"
}

log_parser_handler() {
	while read -r line; do
		local type_attack=$(echo "$line" | awk -F ':' '{print $1}')
		local ip=$(echo "$line" | awk -F ':' '{split($2, ip, " "); print ip[1]}')
		local count=$(echo "$line" | awk -F'[()]' '{print $2}')
		local country_ip=$(get_ip_info "$ip")

		local msg="$type_attack | IP: $ip | Country: $country_ip | Attempts: $count"

		printf 'sudo iptables -A INPUT -s "%s" -j DROP\n' "$ip" >> block_ip.sh

		send_alert_message "$msg"

	done < <("$AWK_SCRIPT" "$LOG_FILE")
}

log_parser_handler
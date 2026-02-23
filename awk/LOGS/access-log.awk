#!/usr/bin/awk -f

BEGIN {
	FS = "\""
	IGNORECASE = 1
}

{
	user_agent = tolower($4)

	split($1, ip, " ")
	split($2, req_page, " ")
	split($3, req_status, " ")
	split(ip[3], date, "[/\\[\\]]") 
	split(date[4], hour, ":")

	if (req_status[1] == 401 && req_page[2] ~ /login/) {
		brut_force[ip[1]]++
	}

	if ($5 > page_request_processing[req_page[2]]) {
		page_request_processing[req_page[2]] = $5
	}

	if (req_status[1] == 500) {
		server_errors[hour[2]]++
	}

	if (user_agent ~ /curl|python|bot|scan|nmap/) {
		suspicious[ip[1]] = user_agent
	}


}

END {
	print "Brut force: "

	for (brut_force_ip in brut_force) {
		if (brut_force[brut_force_ip] > 10) {
			printf "%s - Tried to log in %s times\n", brut_force_ip, brut_force[brut_force_ip]
		}
	}

	print "\nServer errors: "
		
	for (time in server_errors) {
		printf "at %s o'clock %s server errors were recorded\n", time, server_errors[time]
	}

	print "\nSuspicious trafic: "

	for (ip_add in suspicious) {
		printf "%s - %s\n", ip_add, suspicious[ip_add]
	}

	print "\nSlowest pages: "
		
	for (page in page_request_processing) {
		print page_request_processing[page] " milliseconds -", page | "sort -nr | head -n 5"
	}

	close("sort -nr | head -n 5")

}
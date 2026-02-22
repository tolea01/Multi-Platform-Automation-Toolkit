#!/usr/bin/awk -f

BEGIN {
	FS = "\""
}

{
	split($1, ip, " ")
	split($2, req_page, " ")
	split($3, req_status, " ")
	split($4, user_agent, "")
	split(ip[3], date, "[/\\[\\]]")
	split(date[4], hour, ":")

	page_request_processing[req_page[2]] = $5 + 0

	if (req_status[1] == 401) {
		brut_force[date[4]] = ip[1]
	}

	if (req_status[1] == 500) {
		server_errors[hour[2]]++
	}

	if (user_agent[1] ~ /curl|python|bot|scan|nmap/) {
		suspicious[ip[1]] = user_agent[1]
	}


}

END {
	print "Brut force: "

	for (brut_force_time in brut_force) {
		print brut_force_time " - " brut_force[brut_force_time]
	}

	print "Slowest pages: "
		
	for (page in page_request_processing) {
		print page " - " page_request_processing[page] | "sort -n | head -n 5"
	}

	close("sort -n | head -n 5")

	print "Server errors: "
		
	for (time in server_errors) {
		print "at " time " o'clock " server_errors[time] " server errors were recorded"
	}

	print "Suspicious trafic: "

	for (ip_add in suspicious) {
		print ip_add " - " suspicious[ip_add]
	}
}
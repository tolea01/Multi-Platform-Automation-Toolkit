#!/usr/bin/awk -f

BEGIN {
	FS = "[\"]"
}

{
	split($2, req_page, " ")
	split($3,req_status, " ")

	ip = $1

	if (req_status[1] ~ "401|403|404") {
		count[ip]++
	}

	if (req_page) {}
}

END {
	print $2
	print $3
}
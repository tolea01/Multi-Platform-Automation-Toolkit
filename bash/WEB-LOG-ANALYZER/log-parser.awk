#!/usr/bin/gawk -f

BEGIN {
	FS = "\""
	IGNORECASE = 1
}

{
	split($1, parts, " ")
  ip = parts[1]
	req_page = $2

	sql_regex = "(union[[:space:]]+select|or[[:space:]]+[0-9]+=[0-9]+|and[[:space:]]+[0-9]+=[0-9]+|sleep[[:space:]]*\\(|benchmark[[:space:]]*\\(|extractvalue|updatexml|@@|--|drop[[:space:]]+table|'[[:space:]]*(or|and))"
	lfi_regex = "(\\.\\./|\\.\\.%2f|%00|/etc/passwd|/etc/shadow|wp-config\\.php|php://|expect://)"
	wp_regex = "(wp-login\\.php|/wp-admin/|/xmlrpc\\.php|/wp-json/|/wp-content/|/wp-includes/|\\?author=[0-9]+|/wp-json/wp/v2/users|readme\\.txt|license\\.txt)"
	command_injection_regex = "(;|\\|\\||\\||`|\\$\\(|&&|\\b(cat|ls|id|whoami|uname|bash|sh|wget|curl|nc)\\b)"
	server_side_request_regex = "(url=|src=|proxy\\?url=|fetch\\?url=|load\\?url=).*(127\\.0\\.0\\.1|localhost|0\\.0\\.0\\.0|169\\.254\\.169\\.254|file://|gopher://|ftp://)"

	if (req_page ~ sql_regex) {
			sql_inject_attack[ip]++
	} else if (req_page ~ lfi_regex) {
			lfi_attack[ip]++
	} else if (req_page ~ wp_regex) {
			wp_attack[ip]++
	} else if (req_page ~ command_injection_regex) {
			command_injection_attack[ip]++
	} else if (req_page ~ server_side_request_regex) {
			ssrf_attack[ip]++
	} else {
			normal_traffic[ip]++
	}

}

END {
	for (sql_inject_ip in sql_inject_attack) {
		if (sql_inject_attack[sql_inject_ip] > 5) {
			printf "SQL inject attack: %s (%s times)\n", sql_inject_ip, sql_inject_attack[sql_inject_ip]
		}
	}

	for (lfi_ip in lfi_attack) {
		if (lfi_attack[lfi_ip] > 5) {
			printf "LFI attack: %s (%s times)\n", lfi_ip, lfi_attack[lfi_ip]
		}
	}

	for (wp_ip in wp_attack) {
		if (wp_attack[wp_ip] > 5) {
			printf "Word Press attack: %s (%s times)\n", wp_ip, wp_attack[wp_ip]
		}
	}

	for (command_injection_ip in command_injection_attack) {
		if (command_injection_attack[command_injection_ip] > 5) {
			printf "Command injection attack: %s (%s times)\n", command_injection_ip, command_injection_attack[command_injection_ip]
		}
	}

	for (ssrf_ip in ssrf_attack) {
		if (ssrf_attack[ssrf_ip] > 5) {
			printf "SSRF attack: %s (%s times)\n", ssrf_ip, ssrf_attack[ssrf_ip]
		}
	}

}
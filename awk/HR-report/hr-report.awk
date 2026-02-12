#!/usr/bin/awk -f

BEGIN {
	FS = ","
	title = "HR REPORT"
	min_salary = 999999999
	max_salary = 0
}

NR > 1 {
	name = $1
	username = $2
	departmant = $3
	salary = $4

	total_employees = total_employees + 1
	total_salary += salary
	average_salary = total_salary / total_employees

	if (salary > max_salary) {
		max_salary = salary
	}

	if (salary < min_salary) {
		min_salary = salary
	}

}

END {
	print "==========" title "=========="
	print "Total emplyees: " total_employees
	print "Total salary: " total_salary
	print "Average salary: " average_salary
	print "Min salary: " min_salary
	print "Max salary: " max_salary
}
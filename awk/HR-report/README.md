# 📊 HR Report Generator

An AWK-based tool for generating comprehensive HR reports from employee CSV data.

## ✨ Key Features
- **Employee Statistics:** Calculates total employees, total salary, average, min, and max salary
- **Department Breakdown:** Shows employee count per department
- **Top Earners:** Displays the top 3 highest salaries
- **CSV Parsing:** Processes employee data from comma-separated files

## 🛠️ Usage
```bash
# Make the script executable
chmod +x hr_report.awk

# Generate report from CSV file
./hr_report.awk employees.csv

# Pipe data directly
cat employees.csv | ./hr_report.awk
```

# 👥 HR Report 2 - User & Tax Management

An advanced HR analytics tool that processes employee data and generates system user creation scripts with tax calculations.

## ✨ Key Features
- **Tax Calculation:** Automatic tax bracket calculation based on salary
- **Department Budget Analysis:** Percentage breakdown of salary budget per department
- **User Management:** Generates Linux user and group creation scripts
- **System Integration:** Checks existing users/groups before generation
- **Salary Estimation:** Marks missing salaries as [ESTIMATED]
# 🔍 Log Analyzer - Security & Performance Monitoring

An AWK-based log analysis tool that detects security threats and performance issues from web server logs.

## ✨ Key Features
- **Brute Force Detection:** Identifies IPs with multiple failed login attempts (401 status on login pages)
- **Server Error Monitoring:** Tracks 500 Internal Server Errors by hour
- **Suspicious Traffic Detection:** Identifies requests from bots, scanners, and malicious tools (curl, python, nmap, etc.)
- **Performance Analysis:** Finds the slowest loading pages by processing time
- **Real-time Analysis:** Processes standard web server log formats

## 🛠️ Usage
```bash
# Make the script executable
chmod +x log_analyzer.awk

# Analyze a log file
./log_analyzer.awk access.log

# Process multiple log files
./log_analyzer.awk access.log.1 access.log.2

# Pipe logs directly
cat access.log | ./log_analyzer.awk

# Analyze compressed logs
zcat access.log.gz | ./log_analyzer.awk
```
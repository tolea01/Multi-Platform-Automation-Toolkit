
# 📊 System Health Monitor

A lightweight system auditing tool that provides a quick snapshot of server performance.

## ✨ Key Features
- **Visual Feedback:** ANSI colors for instant status recognition (Green/Yellow/Red).
- **Threshold-Based Alerts:** Configurable limits for CPU, RAM, and Storage.

## 🛠️ Usage
```bash
# Check with default thresholds
./health_check.sh

# Set custom threshold for memory
./health_check.sh --mem 98

# Set custom threshold for cpu load
./health_check.sh --cpu 1.5

# Set custom threshold for storage
./health_check.sh --disk 98

# Display help
./health_check.sh --help
```

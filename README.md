# Sqlmap Advanced Bulk Scan

# SQLMap Bulk Scanner

This script automates SQLMap scanning for a list of URLs using customizable parameters like risk level, tamper scripts, cookies, etc.

## 📄 Features

- Takes a file of URLs and scans each one
- Allows use of SQLMap options like `--cookie`, `--tamper`, `--flush-session`, etc.
- Saves output in uniquely named directories under `sqlmap_results/`

## 🚀 Usage

1. Clone this repo or download `bulk_sqlmap_scanner.sh`  
2. Make the script executable:

   ```bash
   chmod +x bulk_sqlmap_scanner.sh

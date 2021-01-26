#! /bin/bash

# Path to logFile
logfile=/home/ubuntupc/Downloads/access.log

# 1. Top 10 IP with Req (1-line number, 2-IP, 3-Count)
echo "Top 10 IP with count of Request"
awk '{print $1}' $logfile | sort | uniq -c | sort -rn | head -10 | awk 'BEGIN {print "Number IP COUNT"} {print FNR,$2,$1}' | column -t

echo "---------------------------------------"

# 2. Top 10 Req addresses
echo "Top 10 Req addresses"
awk '/ HTTP/ {print $7}' $logfile | sort | uniq -c | sort -rn | head -10 | awk 'BEGIN {print "COUNT ADDRESS"} {print $1,$2}' | column -t

echo "---------------------------------------"

# 3. Errors from last start
echo "Errors from last start"
awk '{if ($9 >= 400) print $9}' $logfile | sort | uniq -c | sort -nr | awk 'BEGIN {print "COUNT ERROR"} {print $1,$2}' | column -t

echo "---------------------------------------"

# 4. All response code from last start
echo "All response code from last start"
awk '/HTTP/{print $9}' $logfile | sort | uniq -c | sort -nr | awk 'BEGIN {print "COUNT RESPONSE"} {print $1,$2}' | column -t

echo "---------------------------------------"
#! /bin/bash

# Path to logFile
#logfile=$HOME/Downloads/access.log
logfile=./temp.log
#logfile=$1

num=$(head -1 $HOME/Downloads/CountLines)
#num=$2

echo "File $logfile has $num lines in it"

# 1. Top 10 IP with Req (1-line number, 2-IP, 3-Count)
echo "Top 10 IP with count of Request"
awk 'NR > '$num' {print $1}' $logfile | sort | uniq -c | sort -rn | head -10 | awk 'BEGIN {print "Number IP COUNT"} {print FNR,$2,$1}' | column -t

echo "---------------------------------------"

# 2. Top 10 Req addresses
echo "Top 10 Req addresses"
awk 'NR > '$num'' $logfile  | awk '/ HTTP/ {print $7}' | sort | uniq -c | sort -rn | head -10 | awk 'BEGIN {print "COUNT ADDRESS"} {print $1,$2}' | column -t

echo "---------------------------------------"

# 3. Errors from last start
echo "Errors from last start"
awk 'NR > '$num'' $logfile | awk '{if ($9 >= 400) print $9}' | sort | uniq -c | sort -nr | awk 'BEGIN {print "COUNT ERROR"} {print $1,$2}' | column -t

echo "---------------------------------------"

# 4. All response code from last start
echo "All response code from last start"
awk 'NR > '$num'' $logfile | awk '/HTTP/ {print $9}' | sort | uniq -c | sort -nr | awk 'BEGIN {print "COUNT RESPONSE"} {print $1,$2}' | column -t

echo "---------------------------------------"

# 5. Count of lines in this moment 
echo "Lines was counted in CountLines.txt"
echo "Before was $num lines"
count=$(cat $logfile | wc -l)
echo $count > CountLines
echo "Now is $count lines"

# The reference to file 
FILE=$1
while read LINE; do
     echo "$LINE"
     sleep 2
done < $FILE

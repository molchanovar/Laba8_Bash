# Top 10 IP адресов в порядке уменьшения кол-ва запросов с указанием кол-ва запросов c момента последнего запуска скрипта
more /home/ubuntupc/Downloads/access.log | awk '{print $1}' | sort | uniq -c | sort -rn | head -10

# Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
more /home/ubuntupc/Downloads/access.log | awk '/ HTTP/ {print $7}' | sort | uniq -c | sort -rn | head -10

# все ошибки c момента последнего запуска
more /home/ubuntupc/Downloads/access.log | awk '/ HTTP/ {print $9}' | sort | uniq -c | sort -rn

# список всех кодов возврата с указанием их кол-ва с момента последнего запуска




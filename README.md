# Laba8_Bash
## Bash_scripting

### Task

Написать скрипт для крона, который раз в час присылает на заданную почту
- X IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
- все ошибки c момента последнего запуска
- список всех кодов возврата с указанием их кол-ва с момента последнего запуска

### файлы 
Результат выполнения скрипта - файл **result.txt** -  он же приходит пользователю на почту.
**script** - сам **Bash** скрипт, крутится в Cron и выполяняется раз в час. 
**test.sh* - простой скрипт, выполняет построчное чтение лога, нужен для записи нового лога, который читается скриптом. 
**access.log** - лог Nginx'а


### How it works: 
Запуск построчной записи в новый файл с логами `./test.sh access.log >> temp.log`

Скрипт запускается раз в минуту `* * * * * $HOME/Downloads/script.sh >> %HOME/Downloads/resultRun`


должна быть реализована защита от мультизапуска ??? 


#### Сделано: 

1. Скрипт крутится в кроне (раз в минуту) + надо добавить, что при исполнеии скрипта руту приходит письмо о выполнении (в черновом варианте готово через POSIX)
~~~
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday;
# │ │ │ │ │                                   7 is also Sunday on some systems)
# │ │ │ │ │
# │ │ │ │ │
# * * * * * <command to execute>

#  * * * * * /home/ubuntupc/Downloads/script >> /home/ubuntupc/Downloads/result

~~~

2. Есть основной большой лог <b>accesses.log</b> из него построчно копируются файлы в <b>my.log</b> (./test.sh /home/ubuntupc/Downloads/access.log 1> ~/Downloads/my.log)
~~~
#!/bin/bash

FILE=$1
while read LINE; do
     echo "Это строка: $LINE"
     sleep 2
done < $FILE
~~~

3. my.log должен читаться с момента последнего запуска скрипта (находить строку на которой остановился в последний раз и с нее продолжить чтение)
Для хранения строки на которой в последний раз остановился скрипт используется файл <b>CountLines</b>
В него запись осуществляется wc + awk 
~~~
wc my.log | awk '{print $1}' >> CountLines
~~~
Из него основной скрипт будет получать номер строки на которой он остановился 

4. Сам скрипт (script) на входе получает лог файл который далее обрабатывает: 
~~~
#! /bin/bash

# Path to logFile
#logfile=/home/ubuntupc/Downloads/access.log
logfile=/home/ubuntupc/Downloads/my.log
#logfile=$1

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
awk 'NR > '$NUM'' $logfile | awk '/HTTP/ {print $9}' | sort | uniq -c | sort -nr | awk 'BEGIN {print "COUNT RESPONSE"} {print $1,$2}' | column -t
echo "---------------------------------------"
~~~
Результат исполнения скрипта пишется в файл <b>result</b>

### Команды для теста скрипта:
Top 10 IP адресов в порядке уменьшения кол-ва запросов с указанием кол-ва запросов c момента последнего запуска скрипта
```
more /home/ubuntupc/Downloads/access.log | awk '{print $1}' | sort | uniq -c | sort -rn | head -10
```
Y запрашиваемых адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта
```
more /home/ubuntupc/Downloads/access.log | awk '/ HTTP/ {print $7}' | sort | uniq -c | sort -rn | head -10
```
Все ошибки c момента последнего запуска
```
more /home/ubuntupc/Downloads/access.log | awk '/ HTTP/ {print $9}' | sort | uniq -c | sort -rn
awk '{if ($9 >= 400) print $9}' access.log | sort | uniq -c | sort -nr
```
Список всех кодов возврата с указанием их кол-ва с момента последнего запуска (Все коды возврата) 
```
awk '/HTTP/{print $9}' access.log | sort | uniq -c | sort -nr
```

## P.S.
Скрипт на построчноу чтение из файла
```
FILE=$1
while read LINE; do
     echo "Это строка: $LINE"
     sleep 2
done < $FILE
```
Бесконечный цикл `(do {тело цикла} done)`
```
while true
do
        echo hello
        sleep 2
done
```
Просмотр файла в режиме реального времени: `tail -f`



Перенаправления:
- `2>/dev/null`  - ошибки 
- `1>my.log`     - вывод результата

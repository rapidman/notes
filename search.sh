//run as server
nohup node server.js > /dev/null 2>&1 &

nohup means: Do not terminate this process even when the stty is cut off.
> /dev/null means: stdout goes to /dev/null (which is a dummy device that does not record any output).
2>&1 means: stderr also goes to the stdout (which is already redirected to /dev/null). You may replace &1 with a file path to keep a log of errors, e.g.: 2>/tmp/myLog
& at the end means: run this command as a background task.


count lines
wc -l <filename>
 
//unique lines
cat file | cut -d',' -f 2 | sort -n | uniq
//дуппликаты строк
sort registr22.csv | uniq -d > registr_duppl  
 
//and to get that list in sorted order (by frequency) you can
sort filename | uniq -c | sort -nr
 
//нахождение дуппликатов логинов
zcat mobile.log-20160217.gz| grep -o -P '(?<=hash=).*(?=,)' |sort -nr | uniq -c | sort -nr > /tmp/sed2
zcat mobile.log-20160217.gz| grep -o -P '(?<=cardId=).*(?=,)' | sort -nr | uniq -c | sort -nr > /tmp/sed2
cat mobile.log| grep -o -P '(?<=hash=).*(?=,)' > /tmp/sed1
cat sed1 | uniq -c | sort -nr > sed2
 
//http://www.cyberciti.biz/faq/howto-search-find-file-for-text-string/
egrep -R "word-1|word-2” directory-path
 
//If you want to grep recursively in all .gz files, you can use:
find -name \*client.log*.gz -print0 | xargs -0 zgrep "41956331"
find -name mobile.log-20160217.gz -print0 | xargs -0 zgrep "b41a1420955128e1d0f2efe62a73948d5e74f783"
find -name \*.* -print0 | xargs -0 grep "71547727511"

//cut log file
sed -n '8,12p' yourfile
...will send lines 8 through 12 of yourfile to standard out.

If you want to prepend the line number, you may wish to use cat -n first:

cat -n yourfile | sed -n '8,12p'

//extract token by prefix
grep -Po 'spring.profiles.active=\K[^ ]+' <<<'00:28:04 /usr/lib/jvm/jre/bin/java -DJDBC_CONNECTION_STRING= -Dspring.profiles.active=qa -XX:MaxPermSize=256'
grep -Po '"type":"\K[^"]+' <<< '[customer-gtw2]  2018-02-14 05:37:53.180 INFO  [customerGtwEndpoint-14-C-1] [com.neklo.ustaxi.gateway.service.impl.CustomerTaskExecutorRedisImpl] [partition=27, offset=1493501, key=e3f581e3-7a96-45e0-b8f8-7fea82719655] - Send json response to user [e3f581e3-7a96-45e0-b8f8-7fea82719655] to session [tD8ZE_LxNzEdRPoxO6niEZ6j]: {"type":"CUSTOMER_TRACKING_CARS_BY_ZONE_COORD_RESP","sequence_id"

//convert to comma delimited string
tr -d '\r' < deportation.csv > deportation2.csv
tr -d '\n' < deportation2.csv > deportation3.csv
cat deportation3.csv | sed "s/  /','/g" > deportation4.csv

//extract by pattern
echo "type=CUSTOMER_ERROR, customerId=c2c9fb52-40b1-4f4d-9869-23109315ad76, errorDescription=null"|grep -o 'customerId=[a-ZA-Z0-9\-]\+'
echo 'any string to skip "log": " 2018-04-18 ' |grep -o 'log": ".*'
 echo "Here is a string" | grep -o -P '(?<=Here).*(?=string)'

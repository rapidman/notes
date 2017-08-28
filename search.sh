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

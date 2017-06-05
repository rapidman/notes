
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

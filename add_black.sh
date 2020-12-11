#!/bin/bash

#自动加黑名单到nginx配置

#黑名单IP文件路径 需要在nginx.conf中include
blackFile=/etc/nginx/blackip.conf
#读取多少行
tailLine=1000000
#请求超过多少次就加黑名单
minCount=10000
#nginx access日志路径
logFile=/var/log/nginx/access.log
#获取请求前50名
ip_count=`tail -n $tailLine $logFile | awk '{print $1}' | sort | uniq -c | sort -nr -k1 | head -n 50`
i=0
addStr=""
needAdd=false
blackIp=`cat $blackFile`
for ip in $ip_count; 
do
   b=$(( $i % 2 ))
   if [ $b == 0 ]
   then
      if [ $ip -gt $minCount ];then 
         needAdd=true
      fi 
   else
      if [ $needAdd == true ];then
        if [[ $blackIp =~ $ip ]];then
             echo "$ip exist"
           else
             addStr="${addStr}deny $ip;\n"           
        fi
        needAdd=false
      fi
   fi
   i=$(( $i + 1 ))
done
addStr=${addStr%??}
if [ ${#addStr} -gt 0 ];then
   echo -e $addStr
   echo -e $addStr >> $blackFile
   `nginx -s reload`
fi

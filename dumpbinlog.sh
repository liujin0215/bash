#!/bin/bash

set -e

host="localhost"
port="3306"
user="root"
password=""
database=""
backdir="/home/liujin/binlog/"
outfile=""
binlogdir="/var/lib/mysql/"

while getopts "h:P:u:p:D:d:o:b:" opt; do
  case $opt in
    h)
      host=${OPTARG}
      ;;
    P)
      port=${OPTARG}
      ;;
    u)
      user=${OPTARG}
      ;;
    p)
      password=${OPTARG}
      ;;
    D)
      database=${OPTARG}
      ;;
    d)
      backdir=${OPTARG}
      ;;
    o)
      outfile=${OPTARG}
      ;;
    b)
      binlogdir=${OPTARG}
      ;;
  esac
done

echo "host:${host};port:${port};user:${user};password:${password};database:${database};backdir:${backdir};outfile:${outfile};binlogdir:${binlogdir};"

#锁表
echo "flush tables with read lock;" | mysql -h${host} -P${port} -u${user} -p${password}

#刷新binlog日志，目的是保证所有已完成的操作都可读
echo "flush logs;" | mysql -h${host} -P${port} -u${user} -p${password}

for logfile in $(ls "${binlogdir}" | grep "binlog.[0-9]*$")
do
  cp "${binlogdir}${logfile}" "${backdir}${logfile}"
done

#删除binlog日志，目的是防止重复读取
echo "reset master;" | mysql -h${host} -P${port} -u${user} -p${password}

#解锁
echo "unlock tables;" | mysql -h${host} -P${port} -u${user} -p${password}

#导出binlog
cd "${backdir}"
mysqlbinlog --skip-gtids --database="${database}" $(ls | grep "binlog.[0-9]*$") > "${outfile}"

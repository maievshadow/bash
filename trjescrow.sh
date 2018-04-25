#!/bin/bash
cd /home/trjescw-git
outlog='/var/log/trjescrow.log'
cat /dev/null >/tmp/gitlog.txt
SERVERS="192.168.10.84:scc-beanstalk-supervison"

echo -e "\n### Script exe at `date +%F/%T` by `who am i|awk '{print $1" "$2" "$5}'` ###\n" >> $outlog

git remote update origin --prune

read -p "【trjescrow更新】请输入需要切换的分支:" BRANCH

if [ "$BRANCH" == "" ] ;then
	echo -e "没有输入分支，使用默认分支test"
	BRANCH='test'
fi

git branch | grep $BRANCH > /tmp/gitlog.txt

if [[ -s /tmp/gitlog.txt ]]
 then
   echo -e "分支$BRANCH已存在，现在进行更新" | tee -a $outlog
   git checkout $BRANCH
   git pull origin $BRANCH | tee -a $outlog
 else
   echo -e "分支$BRANCH不存在，现在进行创建" | tee -a $outlog
   git checkout -b $BRANCH origin/$BRANCH | tee -a $outlog
fi

if [ $? -eq 0 ]
 then
   echo  -e "\e[32;1m OK\e[0m GIT update" | tee -a $shell_log
 else
	echo  -e "\e[32;1m fail\e[0m GIT update" | tee -a $shell_log
	git add .
	git commit -m '提交合并冲突'
	git checkout master
	git branch -D $BRANCH
	git checkout $BRANCH
	echo "delete done,exit" | tee -a $shell_log
	exit 1
fi


#样式编译
cd public
compass clean
compass init

#提交编译后的样式
#git add .
#git commit -m '系统提交编译样式'
#git push origin $BRANCH

##同步更新的目录文件到站点
rsync -vzrtopg --delete-after --exclude-from=/bin/tourongjia/paicu.txt   /home/trjescw-git/ /var/www/trjescrow/ &>/dev/null

if [ $? -eq 0 ]
  then
    echo  -e "\e[32;1m OK\e[0m 目录1同步成功" |tee -a $mylog
  else
    echo  -e "\e[32;1m FAIL\e[0m 目录1同步失败" |tee -a $mylog
    exit 1
fi

##同步更新的目录文件到站点2
rsync -vzrtopg --delete-after --exclude-from=/bin/tourongjia/paicu.txt   /home/trjescw-git/ /var/www/trjescrow2/ &>/dev/null

if [ $? -eq 0 ]
  then
    echo  -e "\e[32;1m OK\e[0m 目录2同步成功" |tee -a $mylog
  else
    echo  -e "\e[32;1m FAIL\e[0m 目录2同步失败" |tee -a $mylog
    exit 1
fi

rm -rf /var/www/trjescrow/app/Runtime/*
if [ $? -eq 0 ]
 then
   echo  -e "\e[32;1m OK\e[0m Clear 1 caches" |tee -a $outlog
 else
   echo  -e "\e[31;5m Fail\e[0m Clear 1 caches" |tee -a $outlog
fi

rm -rf /var/www/trjescrow2/app/Runtime/*
if [ $? -eq 0 ]
 then
   echo  -e "\e[32;1m OK\e[0m Clear 2 caches" |tee -a $outlog
 else
   echo  -e "\e[31;5m Fail\e[0m Clear 2 caches" |tee -a $outlog
fi

chown -R apache:apache /var/www/trjescrow
if [ $? -eq 0 ]
 then
   echo  -e "\e[32;1m OK\e[0m Modify files1 Owner" |tee -a $outlog
 else
   echo  -e "\e[31;5m Fail\e[0m Modify files1 Owner" |tee -a $outlog
fi

chown -R apache:apache /var/www/trjescrow2
if [ $? -eq 0 ]
 then
   echo  -e "\e[32;1m OK\e[0m Modify files2 Owner" |tee -a $outlog
 else
   echo  -e "\e[31;5m Fail\e[0m Modify files2 Owner" |tee -a $outlog
fi
function RSYNC {
for ip in $SERVERS
  do
    ip1=$(echo $ip |awk -F: '{print $1}')
    rsync -vzrtopg --delete-after  --password-file=/bin/tourongjia/pass --exclude-from=/bin/tourongjia/list1.txt /var/www/trjescrow/ backup@$ip1::trjescrow >/dev/null && echo -e  "\e[32;1m OK\e[0m Rsync to $ip"|tee -a $outlog || echo  -e "\e[31;5m Fail\e[0m Rsync to $ip"|tee -a $outlog &
  done

wait
}
RSYNC

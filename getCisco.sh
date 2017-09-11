#!/bin/bash


##################################################
##
## Developed by Ilya Vasilyev aka Nadz Goldman
##
##################################################


set -f


adminName=AdminLogin
myIP=1.2.3.4


# rsh -l $adminName 10.0.0.1 sh run > zzzz
#
# ip rcmd remote-host $adminName 89.223.96.2 root enable

#myArr[0]="5.32.12.1"          # c2901
#myArr[1]="5.32.54.1"          # c3750
#myArr[3]="5.32.108.2"         # c7201

myArr[16]="12.16.1.4"          # client-1
myArr[17]="4.10.2.58"          # client-2
myArr[18]="8.131.82.44"        # client-3




myMainPath="/tftpboot";

myDate=`/bin/date "+%Y-%m-%d"`;

#if [ ! -d "$myMainPath/$myDate/" ]
#    then mkdir "$myMainPath/$myDate/"
#fi

#cd "$myMainPath/$myDate/"

cd $myMainPath

for item in ${myArr[*]}
do

touch $item.cfg
chmod 666 $item.cfg

{
  echo "Doing $item"
  rsh -l $adminName $item copy running-conf tftp://$myIP/$item.cfg
  echo
}

mv $item.cfg $item.cfg-$myDate

# {
#    sleep 5
#    rsh -l $adminName $item show running-config > "$myMainPath/temp.txt"
#    sleep 15
#    # o, da! heroten esche ta!
#    echo "Trying $item"
#    dos2unix temp.txt
#    cat temp.txt | grep -vE "(ntp clock-period)|Building|(Current configuration)|(version 12)|\!|^$" > $item.cfg
# }
# echo "empty file =)" > temp.txt
# chown -R bkp:bkp /bkp/

done

if [ -f "temp.txt"  ]
    then rm "temp.txt"
fi



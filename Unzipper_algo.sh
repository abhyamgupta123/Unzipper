#!/bin/bash
unzip_var1=$(tail -1 /var/local/Unzipper_log_file.txt)
unzip_var2=${unzip_var1//$".zip"/}

killall notify-osd
notify-send "UNZIPPER" "$unzip_var1 is created in Downloads"
sleep 0.3
SUBSTR='.zip'

if grep -q "$SUBSTR" <<< "$unzip_var1"; then
  killall notify-osd
  notify-send "UNZIPPER" "Waiting for the Zip file to be downloaded completely."
  sleep 0.3
  while true ; do
    if [ -f "/home/USER/Downloads/$unzip_var1.part" ];then
      continue
    fi
    flag=$(zip -T /home/USER/Downloads/"$unzip_var1")
    if grep -q "OK" <<< "$flag"; then
      killall notify-osd
      notify-send "UNZIPPER" "Unzipping $unzip_var1"
      mkdir /home/USER/Downloads/"$unzip_var2"
      unzip /home/USER/Downloads/"$unzip_var1" -d /home/USER/Downloads/"$unzip_var2"
      chmod -R 777 /home/USER/Downloads/"$unzip_var2"
      rm /home/USER/Downloads/"$unzip_var1"
      killall notify-osd
      notify-send "UNZIPPER" "$unzip_var1 is Unzipped..!!"
      break
    elif  grep -q "Nothing to do!" <<< "$flag" ; then
      killall notify-osd
      notify-send "UNZIPPER" "Zip file is deleted Unexpectedly..!!"
      break
    fi
  done
fi

sudo systemctl stop Unzipper@"$unzip_var2".service

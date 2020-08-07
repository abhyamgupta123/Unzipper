#!/bin/bash
unzip_var1=$(tail -1 /var/local/Unzipper_log_file.txt)
unzip_name_only="${unzip_var1%%.*}"      # To remove all the string part after first dot.
unzip_var2=${unzip_var1//$".zip"/}       # To remove .zip extention from the string name
killall notify-osd
notify-send "UNZIPPER" "$unzip_var1 is created in Downloads"
sleep 0.3
SUBSTR1='.zip'
SUBSTR2='.tar'
if grep -q "$SUBSTR1" <<< "$unzip_var1" ; then
    killall notify-osd
    notify-send "UNZIPPER" "Waiting for the Zip file to be downloaded completely."
    sleep 0.2

  while true ; do
    if [ -f "/home/USER/Downloads/$unzip_var1.part" ];then
      sleep 2
      continue
    fi
    flag=$(zip -T /home/USER/Downloads/"$unzip_var1")
    if grep -q "OK" <<< "$flag"; then
      killall notify-osd
      notify-send "UNZIPPER" "Unzipping $unzip_var1"
      mkdir /home/USER/Downloads/"$unzip_var2"
      chmod 777 /home/USER/Downloads/"$unzip_var2"
      unzip /home/USER/Downloads/"$unzip_var1" -d /home/USER/Downloads/"$unzip_var2"
      zenity --question --text='Do you want to delete the existing Archived file '$unzip_var1' ? '
      if [ $? = 0 ] ; then
        rm /home/USER/Downloads/"$unzip_var1"
      fi
      killall notify-osd
      notify-send "UNZIPPER" "$unzip_var1 is extracted successfully..!!"
      break
    elif  grep -q "Nothing to do!" <<< "$flag" ; then
      killall notify-osd
      notify-send "UNZIPPER" "Zip file is deleted Unexpectedly..!!"
      break
    fi
  done
elif grep -q "$SUBSTR2" <<< "$unzip_var1" ; then
  unzip_last_extention="${unzip_var1##*.}"            # To obtain last extention part of file string
  unzip_var3=${unzip_var1//$".tar.$unzip_last_extention"/}          # To obtain the name after removing .tar.zomething from string name
  killall notify-osd
  notify-send "UNZIPPER" "Waiting for the tar file to be downloaded completely."
  sleep 0.2

  while true ; do
    if [ -f "/home/USER/Downloads/$unzip_var1.part" ] ; then
      continue
    fi
    sleep 0.3
    if [ -f /home/USER/Downloads/"$unzip_var1" && ! -f "/home/USER/Downloads/$unzip_var1.part" ] ; then
      killall notify-osd
      notify-send "UNZIPPER" "Unzipping $unzip_var1"
      mkdir /home/USER/Downloads/"$unzip_var3"
      chmod 777 /home/USER/Downloads/"$unzip_var3"
      tar -xf /home/USER/Downloads/"$unzip_var1" -C /home/USER/Downloads/"$unzip_var3"
      zenity --question --text='Do you want to delete the existing Archived file ? '
      if [ $? = 0 ] ; then
        rm /home/USER/Downloads/"$unzip_var1"
      fi
      killall notify-osd
      notify-send "UNZIPPER" "$unzip_var1 is extracted successfully..!!"
      break
    elif [ ! -f /home/USER/Downloads/"$unzip_var1" ] ; then
      killall notify-osd
      notify-send "UNZIPPER" "tar file is deleted Unexpectedly..!!"
      break
    fi
  done
fi

sudo systemctl stop Unzipper@"$unzip_name_only".service

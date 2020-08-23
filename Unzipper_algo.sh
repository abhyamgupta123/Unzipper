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
    if [ -f "/home/abhyam/Downloads/$unzip_var1.part" ];then
      sleep 2
      continue
    fi
    flag=$(zip -T /home/abhyam/Downloads/"$unzip_var1")
    if grep -q "OK" <<< "$flag"; then
      killall notify-osd
      notify-send "UNZIPPER" "Unzipping $unzip_var1"
      mkdir /home/abhyam/Downloads/"$unzip_var2"
      #chmod 777 /home/abhyam/Downloads/"$unzip_var2"
      unzip /home/abhyam/Downloads/"$unzip_var1" -d /home/abhyam/Downloads/"$unzip_var2"
      chmod -R 777 /home/abhyam/Downloads/"$unzip_var2"
      zenity --question --text="Do you want to delete the existing Archived file '$unzip_var1' ?"
      if [ $? = 0 ] ; then
        rm /home/abhyam/Downloads/"$unzip_var1"
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
    if [ -f "/home/abhyam/Downloads/$unzip_var1.part" ]; then
      continue
    fi
    sleep 2
    dtrx -l /home/abhyam/Downloads/"$unzip_var1" > /dev/null 2>&1
    if [ -f /home/abhyam/Downloads/"$unzip_var1" ]; then 
      if [ $? -ne 1 ];then 
      killall notify-osd
      notify-send "UNZIPPER" "Unzipping $unzip_var1"
      cd /home/abhyam/Downloads/
      dtrx -no /home/abhyam/Downloads/"$unzip_var1"
      #chmod 777 /home/abhyam/Downloads/"$unzip_var3"
      #tar -xf /home/abhyam/Downloads/"$unzip_var1" -C /home/abhyam/Downloads/"$unzip_var3"
      chmod -R 777 /home/abhyam/Downloads/"$unzip_var3"
      zenity --question --text='Do you want to delete the existing Archived file ? '
      if [ $? = 0 ] ; then
        rm /home/abhyam/Downloads/"$unzip_var1"
      fi
      killall notify-osd
      notify-send "UNZIPPER" "$unzip_var1 is extracted successfully..!!"
      break
      fi
    elif [ ! -f /home/abhyam/Downloads/"$unzip_var1" ] ; then
      killall notify-osd
      notify-send "UNZIPPER" "tar file is deleted Unexpectedly..!!"
      break
    fi
  done
fi

sudo systemctl stop Unzipper@"$unzip_name_only".service

#!/bin/bash
read -p "Enter the User name of your computer using command 'whoami' : " name
if [ -e /usr/local/bin/Unzip_service_starter.sh ];then
  sudo rm /usr/local/bin/Unzip_service_starter.sh
fi
if [ -e /usr/local/bin/Unzipper_log_name_writer.sh ];then
  sudo rm /usr/local/bin/Unzipper_log_name_writer.sh
fi
if [ -e /usr/local/bin/Unzipper_algo.sh ];then
  sudo rm /usr/local/bin/Unzipper_algo.sh
fi

if [ -e /etc/systemd/system/Unzipper@.service ];then
  sudo rm /etc/systemd/system/Unzipper@.service
fi
if [ -e /var/local/Unzipper_log_file.txt ];then
  sudo rm /var/local/Unzipper_log_file.txt
fi
sudo sed -i '/^'$name'*$/d' /etc/incron.allow
sudo sed -i '/Unzipper_log_name_writer.sh/d'  /var/spool/incron/"$name"
sudo sed -i '/Unzip_service_starter.sh/d'  /var/spool/incron/"$name"
sudo systemctl daemon-reload
cd ..
sudo systemctl stop Unzipper*
cd -
echo ""
echo "Removed Sucessfully..."

#!/bin/bash
# read -p "Enter the User name of your computer using command 'whoami' : " name
#LOADING REQUIRED ENVIRONMENT VARIABLES:-
name=$(whoami)
echo ""
systemctl --user import-environment
disp=$(systemctl --user show-environment | grep DISPLAY)
auth=$(systemctl --user show-environment | grep XAUTHORITY)
var_home_setup="HOME=/home/$name"
var_user_setup="USER=$name"
echo "Environment Variables needed:"
echo " $disp"
echo " $auth"
echo " $var_home_setup"
echo " $var_user_setup"
echo ""


#Updating AND UPGRADING SYSTEM:-
echo "Updating your system..."
echo ""
sudo apt-get -y update
echo ""
read -p "Do you want to upgrade your system? [y/n] " value
if [ $value == "y" ];then
  sudo apt-get -y upgrade
fi


#INSTALLING REQUIRED PACKAGES:-
echo ""
echo "Installing Incron...!!"
echo ""
sudo apt-get -y install incron
echo ""
echo "Installing Sed...!!"
echo ""
sudo apt-get -y install sed
echo ""
echo "Installing dtrx system tool..!!"
sudo apt-get install dtrx
echo ""


#CONFIGURING INCRONTAB DEAMON:-
if ! sudo grep -Fxq "$name" /etc/incron.allow;then
  sudo sh -c "echo 'NOT_PRESENT_EARLIER' >> /var/local/.unzipper_flag"
  sudo sh -c "echo $name >> /etc/incron.allow"
fi
sudo sh -c "echo '/home/'$name'/Downloads IN_CREATE /usr/local/bin/Unzipper_log_name_writer.sh '$'#' >> /var/spool/incron/"$name""
sudo sh -c "echo '/var/local/Unzipper_log_file.txt IN_MODIFY /usr/local/bin/Unzip_service_starter.sh' >> /var/spool/incron/"$name""
sudo cp ./Unzip_service_starter.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/Unzip_service_starter.sh
echo "completing....20%"


#CONFIGURIION STEP-1
sudo cp ./Unzipper_log_name_writer.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/Unzipper_log_name_writer.sh
echo "completing....40%"


#CONFIGURIION STEP-2
sed "s/USER/$name/g" ./Unzipper_algo.sh > ./.Unzipper_algo.sh
sudo cp ./.Unzipper_algo.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/.Unzipper_algo.sh
sudo mv /usr/local/bin/.Unzipper_algo.sh /usr/local/bin/Unzipper_algo.sh
echo "completing....60%"


#CONFIGURIION STEP-3, SYSTEMD SERVICE FILE CONFIGURATION:-
sed -e "s~DISP~$disp~" -e "s~auth~$auth~" -e "s~var_user~$var_user_setup~" -e "s~var_home~$var_home_setup~" ./Unzipper@.service > ./.Unzipper@.service
# sed "s/USER/$name/g" ./Unzipper@.service > ./.Unzipper@.service
# sed  "s/x_auth/$xauth/g" ./.Unzipper@.service
sudo cp ./.Unzipper@.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/.Unzipper@.service
sudo mv /etc/systemd/system/.Unzipper@.service /etc/systemd/system/Unzipper@.service
echo "completing....80%"


#CONFIGURATION STEP-4, SETTING UP PATH FOR LOG FILE:-
sudo cp ./Unzipper_log_file.txt /var/local/
sudo chmod 777 /var/local/Unzipper_log_file.txt
echo "completing....100%"


#RELOADING ALL DEAMONS AND FINIALISING EVERYTHING:-
sudo systemctl daemon-reload
sudo systemctl restart incron.service
cd ..
sudo systemctl stop Unzipper@*.service
cd -
echo ""
sudo rm ./.Unzipper_algo.sh
sudo rm ./.Unzipper@.service
echo "Initialised Sucessfully..."
echo "Now you are ready to go..!!"

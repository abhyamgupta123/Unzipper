#!/bin/bash
read -p "Enter the User name of your computer using command 'whoami' : " name
echo ""
systemctl --user import-environment
disp=$(systemctl --user show-environment | grep DISPLAY)
auth=$(systemctl --user show-environment | grep XAUTHORITY)
echo $disp
echo $auth
echo "Updating your system..."
echo ""
sudo apt-get -y update
echo ""
read -p "Do you want to upgrade your system? [y/n] " value
if [ $value == "y" ];then
  sudo apt-get -y upgrade
fi
echo ""
echo "Installing Incron...!!"
echo ""
sudo apt-get -y install incron
echo ""
echo "Installing Sed...!!"
echo ""
sudo apt-get -y install sed
echo ""
echo "Installing gawk...!!"
echo ""
sudo apt-get install -y gawk
echo ""
sudo sh -c "echo $name >> /etc/incron.allow"
sudo sh -c "echo '/home/'$name'/Downloads IN_CREATE /usr/local/bin/Unzipper_log_name_writer.sh '$'#' >> /var/spool/incron/"$name""
sudo sh -c "echo '/var/local/Unzipper_log_file.txt IN_MODIFY /usr/local/bin/Unzip_service_starter.sh' >> /var/spool/incron/"$name""
sudo cp ./Unzip_service_starter.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/Unzip_service_starter.sh
echo "completing....20%"
sudo cp ./Unzipper_log_name_writer.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/Unzipper_log_name_writer.sh
echo "completing....40%"
sed "s/USER/$name/g" ./Unzipper_algo.sh > ./.Unzipper_algo.sh
sudo cp ./.Unzipper_algo.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/.Unzipper_algo.sh
sudo mv /usr/local/bin/.Unzipper_algo.sh /usr/local/bin/Unzipper_algo.sh
echo "completing....60%"
# sed "s/USER/$name/g" ./Unzipper@.service > ./.Unzipper@.service
sed -e "s/DISP/$disp/g" -e "s~auth~$auth~" ./Unzipper@.service > ./.Unzipper@.service
# sed  "s/x_auth/$xauth/g" ./.Unzipper@.service
sudo cp ./.Unzipper@.service /etc/systemd/system/
sudo chmod 644 /etc/systemd/system/.Unzipper@.service
sudo mv /etc/systemd/system/.Unzipper@.service /etc/systemd/system/Unzipper@.service
echo "completing....80%"
sudo cp ./Unzipper_log_file.txt /var/local/
sudo chmod 777 /var/local/Unzipper_log_file.txt
echo "completing....100%"
sudo systemctl restart incron.service
sudo systemctl daemon-reload
cd ..
sudo systemctl stop Unzipper@*.service
cd -
echo ""
sudo rm ./.Unzipper_algo.sh
sudo rm ./.Unzipper@.service
echo "Initialised Sucessfully..."
echo "Now you are ready to go..!!"

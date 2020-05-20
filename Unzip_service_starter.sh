#!/bin/bash
starter_var1=$(tail -1 /var/local/Unzipper_log_file.txt)
starter_var2=${starter_var1//$".zip"/}
sudo systemctl start Unzipper@"$starter_var2".service

#!/bin/bash
SUBSTR2='.tar'
starter_var1=$(tail -1 /var/local/Unzipper_log_file.txt)
starter_name_only="${starter_var1%%.*}"                  # To remove all the string part after first dot.


sudo systemctl start Unzipper@"$starter_name_only".service

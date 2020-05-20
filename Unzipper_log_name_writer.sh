#!/bin/bash
echo "$1" >> /var/local/Unzipper_log_file.txt
sed '/^$/d' /var/local/Unzipper_log_file.txt

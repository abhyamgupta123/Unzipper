# Unzipper
This utility is designed for linux based systems to automatically extact .zip, .tar or any other compressed files downloaded from browsers in `/home/<USER>/Download/` folder of system. This has been tested in the linux based systems running systemd and in ubuntu 16.04 and above.

<br>
<hr>

## Installation
>***Run each and every command without sudo and give the sudo password only when it asks or prompts.***

To install this utility:-

- Clone this repo at desired place and go to this directory.
  ```
  $ git clone https://github.com/abhyamgupta123/Unzipper
  $ cd Unzipper
  ```

- Give file setup.sh executable permission.
  ```
  $ chmod +x ./setup.sh
  ```
- Run <mark> *__(WITHOUT SUDO COMMAND)__* </mark> the file to install and setup the utility automatically.
  ```
  $ ./setup.sh
  ```
  or if it doesn't work then try:-
  ```
  $ bash ./setup.sh
  ```

>In case of any errors during Installation please refer to the [Troubleshoot](#Troubleshooting) section of this page.

<hr>

## Removing Utility
>***Run each and every command without sudo and give the sudo password only when it asks or prompts***.

>Steps wil  l be same as Installation steps process only the file will be different.

To completely remove the Utility:-
- Clone this repo at desired place and go to this directory.
  ```
  $ git clone https://github.com/abhyamgupta123/Unzipper
  $ cd Unzipper
  ```

- Give file remove.sh executable permission.
  ```
  $ chmod +x ./remove.sh
  ```
- Run <mark> *__(WITHOUT SUDO COMMAND)__* </mark> the file to remove the utility completely.
  ```
  $ ./remove.sh
  ```
  or if it doesn't works then try:-
  ```
  $ bash ./remove.sh
  ```

<hr>

### Working of code files
- **Unzip_service_starter.sh**

  This plays a vital role in activation of Unzipping process. Here's how:-

  - On Running this shell file it takes the input from `Unzipper_log_file` by reading the last line of the file which consists of latest downloaded archived file name, and creates different instance of the main service file (described below) by modifying its name with the current name of zip file.

  - This behaviour of this shell file enables the Utility to run the same script for different archived files by making **different Instances** of the same service by its name.(archived file name)

- **Unzipper@.service file**

  This is a system service file which is responsible for triggering the script to run when invoked by some command.
  It uses various envornment variables to function properly in a GUI interactive mode (like to display notifications).
  The variables are:-
  - Xauthority - Responsible for displaying messages or notifications in the User session (plays a vital role in Xserver GUI handling tasks).
  - User - Helps in getting required file access priviledges.
  - Display - Responsible for Displaying stuffs related to GUI in correct user session, if set different then it can able to show notifications in VNC related sessions too otherwise it is disabled by default. Configure is behaviours by changing this enviornment variable according to your session variable.(*Default - DISPLAY=:0.0* ).
  - HOME - Another variable to make Utility work properly.

  Its main role is to run the main script which contains all the algorithm to perform the task of Unzipping.

- **Unzipper_algo.sh**

  This shell file contains all primary algo to detect and determine type of file and to Unzip it.

  It works like, first it takes the name of currently downloaded Archived file as input from `Unzipper_log_file` by reading last line of the file and then determines type of file followed by extraction.

- **Unzipper_log_name_writer.sh**

  This shell file just takes the one input of Archived file name and writes it into `/var/local/Unzipper_log_file.txt` as the very last line.

  This script is invoked(run) by the Incrontab service, which also provides the latest archived file name to the script as input.

- **setup.sh**

  This script configures all the files, services and enviornment variables of this Utility to their desired paths in system configuration folders.

  Incrontab Daemon settings and configurations are configured by this `setup.sh` file also.

  * Incrontab Daemon is responsible for invoking two scripts, `Unzip_service_starter.sh` and `Unzipper_log_name_writer.sh`
  * This Daemon continuosly checks the creation of new files at path `/home/<USER>/Downloads`, and when some file is created it writes it's name in `/var/local/Unzipper_log_file.txt` by using script `Unzipper_log_name_writer.sh` and also invokes the Service to unarchive the file if it is an archived file.

- **remove.sh**

  This deconfigures all the settings and configurations (including Incrontab Deamon) of this utility from all the places, thereby uninstalling the Utility.

- **Unzipper_log_file.txt**

  This is just an empty text file which records all the file names that will be created in `/home/<USER>/Downloads`.

  This file will be copied to it's required location(`/var/local/Unzipper_log_file.txt`) by `setup.sh` at the time of installation.

<br>

>***Majour browser(Chrome, Firefox etc.) have their Download path '/home/<USER>/Downloads' as default locations to download archived or any other files. That's why this Utility is set up to Unarchive the files at this path only.***

>You can manually configure it's working path according to your convenience from its script if you have enough knowledge of its working.

<hr>

## Troubleshooting

If this utility doesn't work in your system then check the following paths and files for troubleshooting:-

- First check if the `setup.sh` file is executed with or without `sudo` permission.
  As mentioned before **Don't run setup.sh** with sudo priviledges as this results in setting up wrong enviornment variables as you can see in the service file.

  To solve this:-
  * Go to `/etc/systemd/system/.Unzipper@.service` and edit it with your favourite editor as like nano:-
    ```
    $ sudo nano /etc/systemd/system/.Unzipper@.service
    ```
  * Now note the enviornment variables by executing commands in other fresh terminal by `Ctrl+Alt+T`.
    ```
    $ systemctl --user import-environment
    $ systemctl --user show-environment | grep DISPLAY
    $ systemctl --user show-environment | grep XAUTHORITY
    ```
  * edit `/etc/systemd/system/.Unzipper@.service` as `Environment="DISPLAY=<Disaplay environment variable>"` and `Environment="XAUTHORITY=<xauth enviornment variable>`, now replace <> fields with the data obtained by executing above commands at their respective places.

    Finally, reload the daemon by:-
    ```
    $ sudo systemctl daemon-reload
    ```

  Check if problem is solved...!!


- Make sure your system is up-to-date. To do so execute:-
  ```
  $ sudo apt-get update; sudo apt-get upgrade
  $ sudo apt-get autoremove; sudo apt-get autoclean
  ```
  after this install all the required packages mentioned in the `setup.sh` file while execution namely `Incrontab` and `sed`, to do so execute:-
  ```
  $ sudo apt-get -y install incron
  $ sudo apt-get -y install sed
  ```
  Now reinstall utility:-
  ```
  $ ./remove.sh
  $ ./setup.sh
  ```

  Check if problem is solved...!!

- Check if your user name is there or not in file `/etc/incron.allow`.
  If not then execute command:
  ```
  $ whoami
  ```
  note your system user name and by using your favourite editor edit `/etc/incron.allow` like with nano:-
  ```
  $ sudo nano /etc/incron.allow
  ```
  now add your obtained username after executing command to last line of file and save and exit by `Ctrl+x` and then press `y` followed by `Enter`.

  Now reload the incron service by:-
  ```
  $ sudo systemctl restart incron.service
  ```

  Check if problem is solved...!!

- Maybe your incrontab table is not upgraded as desired to be.
  To ensure its table is up-to-date, please manually configure it by following steps:-

  * Enter below command in fresh terminal (`Ctrl+Alt+t`) to check the incrontable.
    ```
    $ incrontab -l
    ```
    if the output contains something exactly like-
    `/home/<USER>/Downloads IN_CREATE /usr/local/bin/Unzipper_log_name_writer.sh $ #` and
    `/var/local/Unzipper_log_file.txt IN_MODIFY /usr/local/bin/Unzip_service_starter.sh`
    then there is no need to modify this, and follow other troubleshooting procedure.

    Here in place of <USER> there should be your system name obtained by:-
    ```
    $ whoami
    ```

  * If the output is not like above mentioned test then edit the incrontable by executing:-
    ```
    $ incrontab -e
    ```
    now paste the same thing as mentioned above in the editor opened in terminal i.e paste `/home/<USER>/Downloads IN_CREATE /usr/local/bin/Unzipper_log_name_writer.sh $ #` and
    `/var/local/Unzipper_log_file.txt IN_MODIFY /usr/local/bin/Unzip_service_starter.sh` in the editor.

    save it and exit. In case of nano editor do `Ctrl+x` press `y` and `Enter key`.

    **_Here must replace the <USER> keyword with your system user name as obtained in previous step._**

  * Now at last reload the incron daemon and service files by:-
    ```
    $ sudo systemctl restart incron.service
    $ sudo systemctl daemon-reload
    ```

  * Make sure the file `Unzipper_algo.sh` at `/usr/local/bin/Unzipper_algo.sh` contains the correct username variable in it at all the places, you can take help from the original file present in this repo by the same name, where `$name` must be replaced by your system username at all places in your system file at path `/usr/local/bin/Unzipper_algo.sh`.
  To obtain system username :-

    ```
    $ whoami
    ```

  Check if problem is solved...!!

<br><br>
After doing all the above steps please make sure to first restart all services and configuration files and also reboot the system if possible. To do so:-
```
$ sudo systemctl daemon-reload
$ sudo systemctl restart incron.service
$ sudo reboot
```
*Hope this may help you....*

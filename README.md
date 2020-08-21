# Unzipper
This is utility designed for linux based systems to automatically extact .zip, .tar or any other compressed files downloaded from browsers in `/home/<USER>/Download/` folder of system. This has been tested in the linux based systems running systemd and in ubuntu 16.04 and above.

<br>
<hr>

## Installation
>***Run each and every command without sudo and give the sudo password only when it asks or prompts.***

To install this utility:-

- Clone this repo at desied place and go to this directory.
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
  or if it doesn't works then try:-
  ```
  $ bash ./setup.sh
  ```

>In case of any errors during Installation please refer to the Troubleshoot section of this page.

<br>
<hr>

## Removing Utility
>***Run each and every command without sudo and give the sudo password only when it asks or prompts***.

>Steps wil  l be same as Installation steps process only the file will be different.

To completely remove the Utility:-
- Clone this repo at desied place and go to this directory.
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

<br>
<hr>

### Working of code files
- **Unzip_service_starter.sh**

  This plays a vital role in activation of Unzipping process. Here's how:-

  - On Running this shell file it takes the input from `Unzipper_log_file` by reading last line of the file which id of latest downloaded archived file, and creates different instance of the main service file (described below) by modifying its name with the current name of zip file.

  - This behavious of this shell file anables the Utility to run the same scrpit for different archived files by making **different Instances** of the same service by its name.(archived file name)

- **Unzipper@.service file**

  This is system service file which is responsible for triggering the script to run when invoked by some command.
  it uses various envornment variables to function properly in a GUI interactive mode (like to display notifications).
  the variables are:-
  - Xauthority - Responsible for displaying messages or notifications in the User session (plays a vital role in Xserver GUI handling tasks).
  - User - Helps in getting required file access priviledges.
  - Display - Responsible for Displaying stuffs related to GUI in correct user session, if set different then can able to show in VNC related sessions too (*Default - DISPLAY=:0.0* ).
  - HOME - Another variable to make Utility work properly.

  Its main role is to run the main script which contains all the algorithm to perform the task of Unzipping.

- **Unzipper_algo.sh**

  This shell file contains all primary algo to detect and determing type of file and to Unzip it.

  It works like first it takes the name of currently downloaded Archived file as input from `Unzipper_log_file` by reading last line of the file and then determines type of file followed by extraction.

- **Unzipper_log_name_writer.sh**

  This shell file just takes the one input of Archived file name and writes it into `/var/local/Unzipper_log_file.txt` as a very last line.

  This script is invoked(run) by the Incrontab service, which also provides the lates archived file name to the script as input.

- **setup.sh**

  This script configures all the files, services and enviornment variables of this Utility to their desired paths in system configuration folders.

  Incrontab Daemon settings and configurations are configured by this `setup.sh` file also.

  * Incrontab Deamon is responsible for invoking two scripts, `Unzip_service_starter.sh` and `Unzipper_log_name_writer.sh`
  * This Daemon continously checks the creation of new files at path `/home/<USER>/Downloads`, and when some file is created it writes it's name in `/var/local/Unzipper_log_file.txt` by using script `Unzipper_log_name_writer.sh` and also invokes the Service to unarchive the file if it is an arhived file.

- **remove.sh**

  This deconfigures all the settings and configurations (including Incrontab Deamon) of this utility from all the places, thereby uninstalling the Utility.

- **Unzipper_log_file.txt**

  This is just an empty text file which records all the file names that will be created in `/home/<USER>/Downloads`.

  This file will be copied to it's required location(`/var/local/Unzipper_log_file.txt`) by `setup.sh` at time of installation.

<br>
> Majour browser have their Download path `/home/<USER>/Downloads` as default locations to download archived or any other files. That's why this Utility is set up to Unarchive the files at this path only.

>You can manually configure it's working path according to your convenience from its script if you have enough knowledge of its working.

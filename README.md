# Unzipper
This is utility designed for linux based systems to automatically extact .zip, .tar or any other compressed files downloaded from browsers in `/home/<USER>/Download/` folder of system. This has been tested in the linux based systems running systemd and in ubuntu 16.04 and above.

<br>

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

### Working of code files
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

    *<p>This shell file contains all primary algo to detect and determing type of file and to Unzip it.</p>*

    **This works like** - It takes the name of currently downloaded Archived file as input from `Unzipper_log_file` by reading last line of the file and then determines type of file followed by extraction.

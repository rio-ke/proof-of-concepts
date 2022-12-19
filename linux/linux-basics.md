LINUX BASICS

_Defintion to OS_

Operating System lies in the category of system software. It is a fully integrated set of specialized programs that handle all the operations of the computer

_How to Install OS:_

Package (.exe file) --> Windows(Paid)--> Linux (Free)
      
_Father of Linux - Unix_

Linus Benedict Torvalds is a Finnish-American software engineer who is the creator and, historically, the lead developer of the Linux kernel

_D/B Windows and Linux:_

_Windows:_

* It is basically a GUI - Graphical use interface concept
* N'number of 'software' can be utilised
* Great chance of Virus attack

_Linux:_

* Plain Space & No GUI
* Command line Interface via Terminal
* It has N number of 'OS'
* No Chance of Virus attack
    
_Basic Requirement of a Machine:_

* OS Installation
* Internet
* User Manager
* Storage (File Manager/Capacity)
* Service Manager

 _How to install apackage in Linux:_
 
* sudo apt install docker.io
* apt --> ubuntu package manager, helps in installing any software applications
* apt update - for updating the system functions
* apt upgrade 
    
_Version Details:_

* Even version (22, 20, 18, 16, 14...) Gives a total of 5 years support
* Odd Version (19, 17, 15..) Gives only one year of support
* LTS - Long Term Support
* For Windows - we have administrator has a Head role.
* For Linux - we have root user has a head role administrating all the system programs.
* Short cut Key for terminal (in Ubuntu Desktop) - Ctrl+Alt+T 
* To kill a process running - Ctrl+C
      
_Linux Basic Commands_
 
* Use the command `whoami` to know as which user we are logged in.
* Use the command `top` to check the processes running, usage of RAM, hard disk, CPU consumption.
* Use command `echo` to print the given content as ouput 
* Command - `echo Hi Welcome World`  Output = `Hi Welcome World`
* To check the RAM usage and availablity: Command : `free -mh`
* To check how many CPU : `top` and then type `1`
* To check the storage/disk space: `df -Th`
* To list the files in directory: `ls`
* To list all files/directory (including hidden files) Hidden files starts with (.): `ls -a`
* To list all files/directory with detailed/additional information: `ls -l`
* To list files and directories in human readable format: `ls -lh`
* To reverse the order in which your files and Directories are listed: `ls -r`
* To get the list files together with the contents of directories present in the path: `ls -R`
* To see the last modified file and the Directories: `ls -lt`
* To Sort the files and Directories by their sizes from greater to smaller: `ls -lS`
  
_FILE CREATION_
 
* To create a file: `touch bea.txt`  Touch calls the path `usr/bin/touch`
* To read a file: `cat bea.txt`
* To rename a file: `mv currentfilename newfilename`
* To copy a fiele: `cp existingfilename copyfilename`
* To remove/delete a file: `rm existingfilename`
* To read the date: `date`
 
_DIRECTORY_
 
* To create a directory: `mkdir 'directoryname'`
* To change the directory: `cd directoryname`
* To make n number if directories: `mkdir name1, name2, name3`
* To create recursice directories: `mkdir -p dirname/dirname/dirname`
* To remove a directory: `rm -rfdirecname`
 
 _File Handling_
 
* To create a file with content: `echo "hi welcome" > main.txt` (If the file is there with the name it will override the content with the new data, else it will create a new file with the data given in the command.)
* To read the content: `cat main.txt`
* To replace a file with new content: `echo "hi world" >> main.txt`
* > =| tee and >> = |tee -a

 _Note_: tee Cannot be used for file creation as it eliminates duplication.
  
_DIRECTORY STRUCTURE:_
 
      Linux directory structure
      
      / – The root directory
      /bin – Binaries
      /dev – Device files (usb/CD)
      /etc – Configuration files (application configuration files)
      /usr – User binaries and program data (user accessible information)
      /home – User personal data (/home/beau)
      /lib – Shared libraries
      /sbin – System binaries (super binary - can be accessed only by root user)
      /tmp – Temporary files (data loss while shutdown)
      /var – Variable data files (Storage location of any particular application)
      /boot – Boot files (WHile loading the OS - Kernel)
      /proc – Process and kernel files (root user home directory)
      /opt – Optional software (Optional location)
      /root – The home directory of the root
      /media – Mount point for removable media
      /mnt – Mount directory (eg: Hard disk)
      /srv – Service data
      /swapfile - allocates the memory for the app in use by swapping with the not used app
      
 _USER CREATION:_
 
 * To create a new user: `adduser username`
 * To see the list of users and their informations: `cat /etc/passwd`
 * To see their groups: `cat /etc/group`
 * To switch user: `su username`

_PERMISSION:_

* Read - 4, Write -2, Execute - 1 = Total Value = 7
* For a directory - Default access given while creation of directory = 755
* For a File - Default access given while creation of file = 644
* To modify the existing permission `chmod 700 demo.txt`
* To modify the existing ownership `chown mike: root demo.txt`
* Umask for the root user is 022

_Octal value : Permission_

* 0 : read, write and execute
* 1 : read and write
* 2 : read and execute
* 3 : read only
* 4 : write and execute
* 5 : write only
* 6 : execute only
* 7 : no permissions

_UMASK_


Bit	Targeted at	            File permission
0	Owner	                  read, write and execute
7	Group	                  No permissions
7	Others	            No permissions

_HOST CREATION_

* 
      
      

 
 
 
 
 
 
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
    

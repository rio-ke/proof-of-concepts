#### Cron

---

cron is job scheduling utility present unix like systems . 
crond is daemon enable the cron functionality and runs in backround
 
cron reads the crontab(crontables) and run predefine script

For users cron checking /vars/spool/cron/crontabs
In order to use cron job admin allow cron job to user

check first crontab -e and find users list . If user is not allow to using crontab go to /etc/cron.allow and update username in th e file

If user need to deny the cron go and edit /etc/cron.deny and update username in the list

check cron service on linux

systemctl status cron.service

Cron job syntax
Crontabs use the following flags for adding and listing cron jobs.

crontab -e: edits crontab entries to add, delete, or edit cron jobs.
crontab -l: list all the cron jobs for the current user.
crontab -u username -l: list another user's crons.
crontab -u username -e: edit another user's crons

# Cron job example
* * * * * sh /path/to/script.sh

In the above example,

* *  * * * represents minute(s) hour(s) day(s) month(s) weekday(s), respectively.
VALUE	DESCRIPTION
Minutes	0-59	Command would be executed at the specific minute.
Hours	0-23	Command would be executed at the specific hour.
Days	1-31	Commands would be executed in these days of the months.
Months	1-12	The month in which tasks need to be executed.
Weekdays	0-6	Days of the week where commands would run. Here, 0 is Sunday.
sh represents that the script is a bash script and should be run from /bin/bash.
/path/to/script.sh specifies the path to script.

Cron Examples
Create on script date.sh
Given permission to the script chmod 7777 date.sh

Add the script to crontabe -e using below format

vi crontab -e ---> */1 * * * * * /bin/sh  date.sh

this job run per minute

If you change above job to run per hour  * */1 * * * /bin/sh date.sh





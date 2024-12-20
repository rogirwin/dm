# dm - Docker Manager

A very simple docker manger that allows you to view logs, connect to or restart running docker containers.

* [L] View Log File
* [C] Connect
* [R] Restart 
* [T] Top

## Usage

Name                             Hostname
* 1  apache-php                    webserver
* 2  phpmyadmin                    phpmyadmin
* 3  mysql                         database
* 4  nginxproxymanager             nginx
* 5  mailserver                    mail
* Command: [L] View Log File [C] Connect [R] Restart [T] Top [H] Help [Q] Exit & Host Number:

* Enter the command and the number of the Container you want.
*   eg Type r6 to restart container number 6.
*   Type c3 to connect to container number 3.
*   Type t4 to view the processes running on container 4

### Installing

* Copy dm to /usr/local/bin or anywhere in your path.

# dm - Docker Manager

A very simple docker manger that allows you to view logs, connect to or restart running docker containers.

## Usage
``` 
Name                             Hostname
1  apache-php                    webserver
2  phpmyadmin                    phpmyadmin
3  mysql                         database
4  nginxproxymanager             nginx
5  mailserver                    mail
Command: [L] View Log File [C] Connect [R] Restart [T] Top [H] Help [Q] Exit & Host Number:
```

Enter the command and the number of the Container you want.
* Type R5 to restart container number 5.
* Type C3 to connect to container number 3.
* Type T4 to view the processes running on container 4

### Installing
* Copy dm to /usr/local/bin or anywhere in your path.

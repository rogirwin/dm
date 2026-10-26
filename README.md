# dm - Docker Manager

A very simple docker manager that allows you to view logs, connect to, start, stop, restart, pause, kill, inspect and remove docker containers.

## Usage
```
    Name                          Hostname            Status
1   apache-php                    webserver           running
2   phpmyadmin                    phpmyadmin          running
3   mysql                         database            running
4   nginxproxymanager             nginx               running
5   mailserver                    mail                paused
Command: [L]og [C]onnect [R]estart [T]op [S]tart [X] Stop [K]ill [P]ause [D]elete
         [I]nspect P[O]rts [M] Stats [E]xec [A]ll [G] Images [H]elp [Q] Exit & Host Number:
```

Enter the command and the number of the Container you want.
* Type R5 to restart container number 5.
* Type C3 to connect to container number 3.
* Type T4 to view the processes running on container 4.

### Container commands (followed by a container number)
| Key | Action |
|-----|--------|
| L | Follow the container log (last 100 lines) |
| C | Connect with bash (falls back to sh) |
| R | Restart |
| T | Run top inside the container |
| S | Start a stopped container |
| X | Stop |
| K | Kill (asks for confirmation) |
| P | Pause / unpause |
| D | Delete the container (asks for confirmation) |
| I | Inspect (shown in less) |
| O | Show published ports |
| M | Live CPU / memory stats |
| E | Execute a one-off command |

### Global commands (no number needed)
| Key | Action |
|-----|--------|
| A | Toggle showing stopped containers |
| M | Stats snapshot for all running containers |
| G | List images |
| H | Help |
| Q | Exit |

### Installing
* Copy dm to /usr/local/bin or anywhere in your path.

# Linux cheatsheet

## Process management
```bash
ps aux                     # list all running processes
ps aux | grep <name>       # find a specific process
top                        # interactive process monitor
htop                       # enhanced interactive monitor (install if missing)
kill <PID>                 # send SIGTERM to a process
kill -9 <PID>              # force kill (SIGKILL)
pgrep <name>               # find PID by process name
pkill <name>               # kill by process name
```

## systemd / journald
```bash
systemctl status <service>         # check service status
systemctl start|stop|restart <svc> # manage a service
systemctl enable|disable <svc>     # persist across reboots
journalctl -u <service>            # logs for a specific unit
journalctl -u <service> -f         # follow logs live
journalctl --since "1 hour ago"    # time-filtered logs
journalctl -p err                  # only error-level entries
```

## Networking basics
```bash
ip addr                    # show interfaces and IPs
ip route                   # show routing table
ss -tlnp                   # listening TCP sockets (replaces netstat)
curl -v http://<host>      # test HTTP connectivity verbosely
wget -qO- http://<host>    # quick HTTP GET
ping <host>                # ICMP reachability check
traceroute <host>          # path to host
nslookup <hostname>        # DNS lookup
dig <hostname>             # detailed DNS query
```

## File and disk
```bash
df -h                      # disk usage per filesystem
du -sh <dir>               # size of a directory
ls -lah                    # list files with sizes and permissions
find /path -name "*.log"   # find files by name pattern
tail -f /var/log/syslog    # follow a log file
grep -r "pattern" /path    # recursive text search
```

## Permissions
```bash
chmod 755 <file>           # set rwxr-xr-x
chown user:group <file>    # change owner
id                         # show current user and groups
sudo -l                    # list allowed sudo commands
```

## Useful one-liners
```bash
# What is listening on port 8080?
ss -tlnp | grep 8080

# Which process is using a file?
lsof /path/to/file

# Count lines in a log matching a pattern
grep "ERROR" app.log | wc -l

# Show environment variables of a running process (PID)
cat /proc/<PID>/environ | tr '\0' '\n'
```

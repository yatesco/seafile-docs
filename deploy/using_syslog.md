## Configure Seafile To Use Syslog

Since seafile 5.1.2 community edition and seafile 5.1.4 pro edition, we support syslog functionality.

### Configure Syslog For Seafile Controller and Server

Add follow configuration to `general` section in `seafile.conf`:
```
enable_syslog = true
```

If there is not `general` section in `seafile.conf`, append follow option to `seafile.conf`:
```
[general]
enable_syslog = true
```

Restart seafile server, you will find follow log info in `/var/log/syslog`:
```
May 10 23:45:19 ubuntu seafile-controller[16385]: seafile-controller.c(154): starting ccnet-server ...
May 10 23:45:19 ubuntu seafile-controller[16385]: seafile-controller.c(73): spawn_process: ccnet-server -F /home/plt/haiwen/conf -c /home/plt/haiwen/ccnet -f /home/plt/haiwen/logs/ccnet.log -d -P /home/plt/haiwen/pids/ccnet.pid
```
```
May 12 01:00:51 ubuntu seaf-server[21552]: ../common/mq-mgr.c(60): [mq client] mq cilent is started
May 12 01:00:51 ubuntu seaf-server[21552]: ../common/mq-mgr.c(106): [mq mgr] publish to hearbeat mq: seaf_server.heartbeat
```

### Pro Edition Configure Syslog For Seafevents

Add follow configuration to `seafevents.conf`:
```
[Syslog]
enabled = true
```

Restart seafile server, you will find follow log info in `/var/log/syslog`
```
May 12 01:00:52 ubuntu seafevents[21542]: [seafevents] database: mysql, name: seahub-pro
May 12 01:00:52 ubuntu seafevents[21542]: seafes enabled: True
May 12 01:00:52 ubuntu seafevents[21542]: seafes dir: /home/plt/pro-haiwen/seafile-pro-server-5.1.4/pro/python/seafes
```

### Configure Syslog For Seahub

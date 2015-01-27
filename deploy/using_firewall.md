# Firewall settings

By default, you should open 4 ports (for TCP) in your firewall settings.

     |
     | Seahub
        | 8000
        |-
        | FileServer
        | 8082
        |-
        | Ccnet Daemon
        | 10001
        |-
        | Seafile Daemon
        | 12001
        |
        



If you run Seafile behind Nginx/Apache with HTTPS, you should open ports

     |
     | HTTPS
        | 443
        |-
        | Ccnet Daemon
        | 10001
        |-
        | Seafile Daemon
        | 12001
        |

If you run Seafile behind Nginx/Apache with HTTPS and only use HTTPS syncing (which is added in version 4.0 and work be make as the default syncing protocol in version 4.1), you only need to open port 443.

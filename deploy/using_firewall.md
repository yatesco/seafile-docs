# Firewall settings

By default, you should open 2 ports (for TCP) in your firewall settings.

     |
     | Seahub
        | 8000
        |-
        | FileServer
        | 8082


If you run Seafile behind Nginx/Apache with HTTPS, you only need to open ports 443.

# Configure Syncing via HTTP Protocol

Starting from version 4.0.0, Seafile supports file syncing via HTTP protocol. To use this feature, you must configure Nginx or Apache on the server.

## Nginx

Follow [this guide](deploy_with_nginx.md) to configure Nginx without HTTPS, or [this guide](https_with_nginx.md) to configure Nginx with HTTPS.

The section in Nginx config file related to HTTP sync is

```
    location /seafhttp {
        rewrite ^/seafhttp(.*)$ $1 break;
        proxy_pass http://127.0.0.1:8082;
        client_max_body_size 0;
        proxy_connect_timeout  36000s;
        proxy_read_timeout  36000s;
    }
```

there are two things to note:

* You must use the path "/seafhttp" for http syncing. This is hard coded in the client.
* You should add the "client_max_body_size" configuration. The value should be set to 0 (means no limit) or 100M (suffice for most cases).

## Apache

Follow [this guide](deploy_with_apache.md) to configure Apache without HTTPS, or [this guide](https_with_apache.md) to configure Nginx with HTTPS.

The section in Apache config file related to HTTP sync is

```
    #
    # seafile fileserver
    #
    ProxyPass /seafhttp http://127.0.0.1:8082
    ProxyPassReverse /seafhttp http://127.0.0.1:8082
    RewriteRule ^/seafhttp - [QSA,L]
```

Note that you must use the path "/seafhttp" for http syncing. This is hard coded in the client.

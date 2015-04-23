# Configure Syncing via HTTP Protocol

Starting from version 4.0.0, Seafile supports file syncing via HTTP protocol. To use this feature, you must configure Nginx or Apache on the server. (If you have already configured Nginx/Apache in version 3.x and your configuration matches the following, you don't need to do further modifications to enable HTTP/HTTPS syncing.)

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

## Notes on certificates chain
Whether or not you are using self-signed certificates or "official" ones released by well known certificate authorities (CA), be sure to include the full certificate chain in the configuration.

If you only use the server certificate in the ```cacert.pem``` file, the browser interface will work anyway but the browser will complain about unknown certificate authorities. However, the Seafile desktop client won't work unless you set the ```Do not verify server certificate in HTTP syncing``` option in the Advanced settings, which is annoying to say at least.

When creating the ```cacert.pem``` file, be sure to concatenate the certificate authorities' certificates **after** the server certificate. Detailed information can be found, for example, in the [SSL certificate chains section of the Nginx documentation site](http://nginx.org/en/docs/http/configuring_https_servers.html#chains).

## FAQ and Trouble Shooting

### Certificate Revocation List and Custom CA

When you use a custom CA to sign your certificate, you have to include certificate revocation list (CRL) in your certificate. See [this thread](https://forum.seafile-server.org/t/https-syncing-on-windows-machine-using-custom-ca/898) for more information.

### Choosing Ciphers on Nginx/Apache

You should choose strong ciphers on the server side. However some cipher list doesn't work with the SChannel TLS library on the Windows client. The following Nginx cipher list is tested to be working fine:

```
ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
```

You may fine tune the list to meet your needs.



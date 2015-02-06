## Overview

[Shibboleth](https://shibboleth.net/) is a widely used single sign on (SSO) protocol. Seafile server (Community Edition >= 4.0.6, Pro Edition >= 4.0.4) supports authentication via Shibboleth. It allows users from another organization to log in to Seafile without registering an account on the service provider.

In this documentation, we assume the reader is familiar with Shibboleth installation and configuration. For introduction to Shibboleth concepts, please refer to https://wiki.shibboleth.net/confluence/display/SHIB2/UnderstandingShibboleth .

Shibboleth Service Provider (SP) should be installed on the same server as the Seafile server. The official SP from https://shibboleth.net/ is implemented as an Apache module. The module handles all Shibboleth authentication details. Seafile server receives authentication information (username) from fastcgi. The username then can be used as login name for the user.

Assume your seafile is deployed at https://seafile.example.com/ according [this](http://manual.seafile.com/deploy/https_with_apache.html), in order to enable shibboleth integration, you need to use a different url (e.g. https://seafile-shib.example.com) which need a new Apache vhost and also modify `seahub_settings.py`.

Since Shibboleth support requires Apache, if you want to use Nginx, you need two servers, one for non-Shibboleth access, another for Shibboleth access. In a cluster environment, you can configure your load balancer to direct traffic to different server according to URL.

The configuration includes 3 steps:

1. Install and configure Shibboleth Service Provider;
2. Configure Apache;
3. Configure Seahub.

## Install and Configure Shibboleth Service Provider

Installation and configuration of Shibboleth is out of the scope of this documentation. Here are a few references:

* For RedHat and SUSE: https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPLinuxInstall
* For Ubuntu: http://bradleybeddoes.com/2011/08/12/installing-a-shibboleth-2-sp-in-ubuntu-11-04-within-virtualbox/

Please note that you don't have to follow the Apache configurations in the above links. Just use the Apache config we provide in the next section.

## Apache Configuration

You should create a new virtual host configuration for Shibboleth.

```
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerName seafile-shib.example.com
        DocumentRoot /var/www
        #Alias /seafmedia  /home/ubuntu/dev/seahub/media
        Alias /media /home/user/seafile-server-latest/seahub/media

        ErrorLog ${APACHE_LOG_DIR}/seahub.error.log
        CustomLog ${APACHE_LOG_DIR}/seahub.access.log combined

        SSLEngine on
        SSLCertificateFile  /path/to/ssl-cert.pem
        SSLCertificateKeyFile /path/to/ssl-key.pem

        <Location /Shibboleth.sso>
        SetHandler shib
        </Location>

        <Location /api2>
        AuthType None
        Require all granted
        Allow from all
        satisfy any
        </Location>

        RewriteEngine On
        <Location /media>
        Require all granted
        </Location>

        <Location />
        AuthType shibboleth
        ShibRequestSetting requireSession true
        Require valid-user
        #ShibUseHeaders On
        </Location>

        #
        # seafile fileserver
        #
        ProxyPass /seafhttp http://127.0.0.1:8082
        ProxyPassReverse /seafhttp http://127.0.0.1:8082
        RewriteRule ^/seafhttp - [QSA,L]

        #
        # seahub
        #
        RewriteRule ^/(media.*)$ /$1 [QSA,L,PT]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ /seahub.fcgi$1 [QSA,L,E=HTTP_AUTHORIZATION:%{HTTP:Authorization}]

    </VirtualHost>
</IfModule>

```

After restarting Apache, you should be able to get the Service Provider metadata by accessing https://seafile-shib.example.com/Shibboleth.sso/Metadata . This metadata should be uploaded to the Identity Provider (IdP) server.

## Configure Seahub

Now we have to tell Seahub how to do with the authentication information passed in by Shibboleth.

Add the following configuration to seahub_settings.py.

```
EXTRA_AUTHENTICATION_BACKENDS = (
    'shibboleth.backends.ShibbolethRemoteUserBackend',
)
EXTRA_MIDDLEWARE_CLASSES = (
    'shibboleth.middleware.ShibbolethRemoteUserMiddleware',
)
SHIBBOLETH_ATTRIBUTE_MAP = {
    "eppn": (True, "username"),
}
```

In the above configuration, the Shibboleth attribute `eppn` (short for Edu Person Principal Name) is mapped into Seahub's username. You can use other reasonable Shibboleth attribute returned by your IdP for username. The username should have format similar to an email address.

## Verify

After restarting Apache and Seafile services, when user visit https://seafile-shib.example.com/, he/she will be redirected to the IdP authentication page which is configured in your SP config file.

# OnlyOffice

From version 6.1.0+ on (including CE), Seafile supports [OnlyOffice](https://www.onlyoffice.com/) to view/edit office files online. In order to use OnlyOffice, you must first deploy an OnlyOffice server.

**Info for clusters**

In a cluster setup we recommend a dedicated DocumentServer host or a DocumentServer Cluster on a different subdomain. 
Technically it works also via subfolder if the loadbalancer can handle folder for loadbalancing.

**For most users we recommend to deploy the documentserver in a docker image locally and provide it via a subfolder.**

Benefits:
- no additional server required
- no additional subdomain required
- no additional SSL certificate required
- easy and quick deployment
- easy management


**Summary**
* [Deployment of DocumentServer via SUBDOMAIN](deploy/only_office.md#deployment-of-documentserver-via-subdomain)
    * [Test that DocumentServer is running](deploy/only_office.md#test-that-documentserver-is-running-via-subdomain)
    * [Configure Seafile Server](deploy/only_office.md#configure-seafile-server-for-subdomain)
* [Deployment of DocumentServer via SUBFOLDER](deploy/only_office.md#deployment-of-documentserver-via-subfolder)
    * [Install Docker](deploy/only_office.md#install-docker)
    * [Deploy OnlyOffice DocumentServer Docker image](deploy/only_office.md#deploy-onlyoffice-documentserver-docker-image)
    * [Configure Webserver](deploy/only_office.md#configure-webserver)
    * [Test that DocumentServer is running](deploy/only_office.md#test-that-documentserver-is-running-via-subfolder)
    * [Configure Seafile Server](deploy/only_office.md#configure-seafile-server-for-subfolder)
    * [Complete Nginx config EXAMPLE](deploy/only_office.md#complete-nginx-config-example)


## Deployment of DocumentServer via SUBDOMAIN
URL example: https://onlyoffice.domain.com

- Subdomain
- DNS record for subdomain
- SSL certificate (LE works also)

For a quick and easy installation, we suggest you use [ONLYOFFICE/Docker-DocumentServer](https://github.com/ONLYOFFICE/Docker-DocumentServer) for a subdomain installation. Just follow the guide in the OnlyOffice documentation.

### Test that DocumentServer is running via SUBDOMAIN
After the installation process is finished, visit this page to make sure you have deployed OnlyOffice successfully: ```http{s}://{your Seafile Server's domain or IP}/welcome```, you will get **Document Server is running** info at this page.


### Configure Seafile Server for SUBDOMAIN
Add the following config option to ```seahub_settings.py```.

```
# Enable Only Office
ENABLE_ONLYOFFICE = True
VERIFY_ONLYOFFICE_CERTIFICATE = False
ONLYOFFICE_APIJS_URL = 'http{s}://{your OnlyOffice server's domain or IP}/web-apps/apps/api/documents/api.js'
ONLYOFFICE_FILE_EXTENSION = ('doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'odt', 'fodt', 'odp', 'fodp', 'ods', 'fods')
```

Then restart the Seafile Server

```
./seafile.sh restart
./seahub.sh restart

# or
service seafile-server restart
```

When you click on a document you should see the new preview page.



## Deployment of DocumentServer via SUBFOLDER
URL example: https://seafile.domain.com/onlyofficeds

- Local proxy to subfolder on already existing Seafile Server (sub)domain.
- SSL via Seafile Server domain, no additional certificate required !

**The subfolder can NOT be ```/onlyoffice/``` as this path is used for communication between Seafile and Document Server !**

The following guide shows how to deploy the OnlyOffice Document server locally.
*It is based on the ["ONLYOFFICE/Docker-DocumentServer" documentation](https://github.com/ONLYOFFICE/Docker-DocumentServer).*

**Requirements** for OnlyOffice DocumentServer via Docker
https://github.com/ONLYOFFICE/Docker-DocumentServer#recommended-system-requirements


### Install Docker

Ubuntu
https://docs.docker.com/engine/installation/linux/ubuntu/

Debian
https://docs.docker.com/engine/installation/linux/debian/

CentOS
https://docs.docker.com/engine/installation/linux/centos/


### Deploy OnlyOffice DocumentServer Docker image
This downloads and deploys the DocumentServer on the local port 88.

Ubuntu 16.04 / Debian 8 / CentOS 7
```
docker run -i -t -d -p 88:80 onlyoffice/documentserver --restart=always --name oods
```

### Configure Webserver
#### Configure Nginx

**Variable mapping**

Add the following configuration to your seafile nginx .conf file (e.g. ```/etc/ngnix/conf.d/seafile.conf```) out of the ```server``` directive. These variables are to be defined for the DocumentServer to work in a subfolder.

```
# Required for only office document server
map $http_x_forwarded_proto $the_scheme {
        default $http_x_forwarded_proto;
        "" $scheme;
    }

map $http_x_forwarded_host $the_host {
        default $http_x_forwarded_host;
        "" $host;
    }

map $http_upgrade $proxy_connection {
        default upgrade;
        "" close;
    }
```

**Proxy server settings subfolder**

Add the following configuration to your seafile nginx .conf file (e.g. ```/etc/ngnix/conf.d/seafile.conf```) within the ```server``` directive.
```

...   
location /onlyofficeds/ {

        # THIS ONE IS IMPORTANT ! - Trailing slash !
        proxy_pass http://{your Seafile server's domain or IP}:88/;

        proxy_http_version 1.1;
        client_max_body_size 100; # Limit Document size to 100MB
        proxy_read_timeout 3600s;
        proxy_connect_timeout 3600s;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $proxy_connection;

        # THIS ONE IS IMPORTANT ! - Subfolder and NO trailing slash !
        proxy_set_header X-Forwarded-Host $the_host/onlyofficeds;

        proxy_set_header X-Forwarded-Proto $the_scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	}
...
```

#### Configure Apache
_To be written...._

### Test that DocumentServer is running via SUBFOLDER
After the installation process is finished, visit this page to make sure you have deployed OnlyOffice successfully: ```http{s}://{your Seafile Server's domain or IP}/{your subdolder}/welcome```, you will get **Document Server is running** info at this page.

### Configure Seafile Server for SUBFOLDER
Add the following config option to ```seahub_settings.py```:

```
# Enable Only Office
ENABLE_ONLYOFFICE = True
VERIFY_ONLYOFFICE_CERTIFICATE = True
ONLYOFFICE_APIJS_URL = 'http{s}://{your Seafile server's domain or IP}/{your subdolder}/web-apps/apps/api/documents/api.js'
ONLYOFFICE_FILE_EXTENSION = ('doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'odt', 'fodt', 'odp', 'fodp', 'ods', 'fods')
```

Then restart the Seafile Server

```
./seafile.sh restart
./seahub.sh restart

# or
service seafile-server restart
```

When you click on a document you should see the new preview page.


### Complete Nginx config EXAMPLE
Complete nginx config file (e.g. ```/etc/nginx/conf.d/seafile.conf```) based on Seafile Server V6.1 including OnlyOffice DocumentServer via subfolder.

```
# Required for OnlyOffice DocumentServer
map $http_x_forwarded_proto $the_scheme {
	default $http_x_forwarded_proto;
	"" $scheme;
}

map $http_x_forwarded_host $the_host {
	default $http_x_forwarded_host;
	"" $host;
}

map $http_upgrade $proxy_connection {
	default upgrade;
	"" close;
}

server {
        listen       80;
        server_name  seafile.domain.com;
        rewrite ^ https://$http_host$request_uri? permanent;    # force redirect http to https
}

server {
        listen 443 http2;
        ssl on;
        ssl_certificate /etc/ssl/cacert.pem;        # path to your cacert.pem
        ssl_certificate_key /etc/ssl/privkey.pem;    # path to your privkey.pem
        server_name seafile.domain.com;
        proxy_set_header X-Forwarded-For $remote_addr;
        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
        server_tokens off;

    location / {
        fastcgi_pass    127.0.0.1:8000;
        fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
        fastcgi_param   PATH_INFO           $fastcgi_script_name;

        fastcgi_param   SERVER_PROTOCOL        $server_protocol;
        fastcgi_param   QUERY_STRING        $query_string;
        fastcgi_param   REQUEST_METHOD      $request_method;
        fastcgi_param   CONTENT_TYPE        $content_type;
        fastcgi_param   CONTENT_LENGTH      $content_length;
        fastcgi_param   SERVER_ADDR         $server_addr;
        fastcgi_param   SERVER_PORT         $server_port;
        fastcgi_param   SERVER_NAME         $server_name;
        fastcgi_param   REMOTE_ADDR         $remote_addr;
        fastcgi_param   HTTPS               on;
        fastcgi_param   HTTP_SCHEME         https;

        access_log      /var/log/nginx/seahub.access.log;
        error_log       /var/log/nginx/seahub.error.log;
        fastcgi_read_timeout 36000;
        client_max_body_size 0;
    }

    location /seafhttp {
        rewrite ^/seafhttp(.*)$ $1 break;
        proxy_pass http://127.0.0.1:8082;
        client_max_body_size 0;
        proxy_connect_timeout  36000s;
        proxy_read_timeout  36000s;
        proxy_send_timeout  36000s;
        send_timeout  36000s;
    }

    location /media {
        root /home/user/haiwen/seafile-server-latest/seahub;
    }

    location /seafdav {
        fastcgi_pass    127.0.0.1:8080;
        fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
        fastcgi_param   PATH_INFO           $fastcgi_script_name;
        fastcgi_param   SERVER_PROTOCOL     $server_protocol;
        fastcgi_param   QUERY_STRING        $query_string;
        fastcgi_param   REQUEST_METHOD      $request_method;
        fastcgi_param   CONTENT_TYPE        $content_type;
        fastcgi_param   CONTENT_LENGTH      $content_length;
        fastcgi_param   SERVER_ADDR         $server_addr;
        fastcgi_param   SERVER_PORT         $server_port;
        fastcgi_param   SERVER_NAME         $server_name;
        fastcgi_param   HTTPS               on;
        client_max_body_size 0;
        access_log      /var/log/nginx/seafdav.access.log;
        error_log       /var/log/nginx/seafdav.error.log;
    }

    location /onlyofficeds/ {
        # IMPORTANT ! - Trailing slash !
        proxy_pass http://127.0.0.1:88/;
		
        proxy_http_version 1.1;
        client_max_body_size 100; # Limit Document size to 100MB
        proxy_read_timeout 3600s;
        proxy_connect_timeout 3600s;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $proxy_connection;

        # IMPORTANT ! - Subfolder and NO trailing slash !
        proxy_set_header X-Forwarded-Host $the_host/onlyofficeds;
		
        proxy_set_header X-Forwarded-Proto $the_scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```


# FAQ

Please check the [FAQ section](faq/README.md)

## Questions about file synchronization

#### When downloading a library, the client hangs at "connecting server"

First, you can check the Seafile client log (`~/.ccnet/logs/seafile.log` for
Linux, `C:/users/your_name/ccnet/logs/seafile.log` for Windows) to see what's wrong.

Possible reasons:

* Firewall: Ensure the firewall is configured properly. See [Firewall Settings for Seafile Server](deploy/using_firewall.md)

#### How to enable more verbose log output for the client

Set environment variable `SEAFILE_DEBUG = all` before running Seafile client. On Linux, you can open a terminal and type:

```
export SEAFILE_DEBUG=all
./seafile-applet
```

## Questions about server setup

#### Failed to upload/download file online

* Make sure your firewall for seafile fileserver is opened.
* Make sure `SERVICE_URL` in ccnet.conf and `FILE_SERVER_ROOT` in seahub_settings.py are set correctly. Furthermore check that you haven't overwritten them using the settings in the Seahub Admin section.
* Use Chrome/Firefox debug mode to find out which address is being used when clicking download button and whether it is correct.

#### Does Seafile server support Python 3?

No, You must have Python 2.7 installed on your server.

#### Can Seafile server run on FreeBSD?

There was an unconfirmed solution on the internet, which later has vanished.
(Please explain the installation routine if you successfully set up Seafile in FreeBSD.)

#### Website displays "Page unavailable", what can I do?

* You can check the back trace in Seahub log files (`installation folder/logs/seahub_django_request.log`)

* You can also turn on debug mode by adding `DEBUG = True` to `seahub_settings.py` and restarting Seahub with `./seahub.sh restart`, then refresh the page, all the debug infomations will be displayed. Make sure ./seahub.sh was started as: ./seahub.sh start-fastcgi in case you're using Nginx/Apache.

#### Files with a space in their name do not work using Apache

* See http://manual.seafile.com/deploy/deploy_with_apache.html#problems-with-paths-and-files-containing-spaces

#### Avatar pictures vanished after upgrading the server, what can I do?

* You need to check whether the "avatars" symbolic link under seahub/media/ is linking to ../../../seahub-data/avatars. If not, you need to correct the link according to the "minor upgrade" section in [Upgrading-Seafile-Server](deploy/upgrade.md).

* If your avatars link is correct, and avatars are still broken, you may need to refresh Seahub cache using `rm -rf /tmp/seahub_cache/*` or by restarting memcached if being used.

#### How to change seafile-data location after setup?

Modify file `seafile.ini` under ccnet. This file contains the location of seafile-data. Move seafile-data to another place, like `/opt/new/seafile-data` and modify `seafile.ini` accordingly.

#### Failed to send email, what can I do?

Please check logs/seahub.log.

There are some common mistakes:

1. Check whether there are typos in the config (`seahub_settings.py`, e.g. you could have forgotten to add a single quote `EMAIL_HOST_USER = XXX`, which should be `EMAIL_HOST_USER = 'XXX'` or you could habe a space at the end of a config line.
2. Your mail server is not available.

#### After upgrading Web UI is broken because CSS files can't be loaded

Please remove the cache and try again, `rm -rf /tmp/seahub_cache/*`. If you configured memecached, restart memcached, then restart Seahub.

If the problem is not fixed, check whether seafile-server-latest point to the correct folder. Then check whether `seafile-server-latest/seahub/media/CACHE` is correctly being generated (it should contain the auto-generated CSS file(s)).

## Questions about Clustering

### Page layout broken because seahub/media/CACHE is created only on first node

Please add

    COMPRESS_CACHE_BACKEND = 'django.core.cache.backends.locmem.LocMemCache'

to `seahub_settings.py` as documented at http://manual.seafile.com/deploy_pro/deploy_in_a_cluster.html

This is going to tell every node to generate the CSS CACHE in its local folder.


## Questions about server maintenance

### How to migrate libraries and groups from one account to another?

Since version 4.4.2, system admins can migrate libraries and groups from one account to another existing account using [RESTful web api](https://github.com/haiwen/seafile-docs/blob/master/develop/web_api.md#migrate-account).

### Seafile GC shows errors, FSCK can’t fix them

GC scans the history. But FSCK only scans the current version. You can ignore the error. It is a minor issue.

## Questions about LDAP and User management

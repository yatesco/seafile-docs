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


## Questions about Clustering

### Page layout broken because seahub/media/CACHE is created only on first node

Please add

    COMPRESS_CACHE_BACKEND = 'django.core.cache.backends.locmem.LocMemCache'

to `seahub_settings.py` as documented at http://manual.seafile.com/deploy_pro/deploy_in_a_cluster.html

This is going to tell every node to generate the CSS CACHE in its local folder.

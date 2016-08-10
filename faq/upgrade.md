# Upgrade

## After upgrading Web UI is broken because CSS files can't be loaded

#### Answer

Please remove the cache and try again, `rm -rf /tmp/seahub_cache/*`. If you configured memecached, restart memcached, then restart Seahub.

If the problem is not fixed, check whether seafile-server-latest point to the correct folder. Then check whether `seafile-server-latest/seahub/media/CACHE` is correctly being generated (it should contain the auto-generated CSS file(s)).


## Avatar pictures vanished after upgrading the server, what can I do?

#### Answer

* You need to check whether the "avatars" symbolic link under seahub/media/ is linking to ../../../seahub-data/avatars. If not, you need to correct the link according to the "minor upgrade" section in [Upgrading-Seafile-Server](deploy/upgrade.md).

* If your avatars link is correct, and avatars are still broken, you may need to refresh Seahub cache using `rm -rf /tmp/seahub_cache/*` or by restarting memcached if being used.

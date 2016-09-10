# FAQ

## Very common problem

#### Seafile/Seahub can't start after upgrade or any other reasons

Please check whether you use the right user to run or upgrade Seafile. Pay special attention to the following files:

* `seafile-directory/seafile-server-6.0.3/runtime/error.log`
* `seafile-directory/seafile-server-6.0.3/runtime/access.log`
* `seafile-directory/logs/*`

You can run the following command to change fix the permission for the whole directory:

```
chown -R userx:groupx seafiledirectory
```

You can also try remove the cache directory of Seahub

```
rm -rf /tmp/seahub_cache
```

## Server

* [Common problems in setup server](setup.md)
* [Libraries, users and groups management](library-mgr.md)
* [LDAP](ldap.md)
* [GC and fsck](gc-fsck.md)
* [Common problems after upgrade](upgrade.md)
* [Can't start server](data-lost.md)
* [Cluster](cluster.md)
* [Ceph](ceph.md)

## Client

* [Common problems about desktop syncing client](client.md)

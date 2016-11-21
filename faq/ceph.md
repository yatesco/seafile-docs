# Ceph


## Seafile server can't started when using Ceph

#### Description

Seafile server can't started when using Ceph as storage backend. seafile.log is empty. controller.log shows:

```
[10/20/16 12:39:29] seafile-controller.c(568): pid file /opt/seafile/pids/seaf-server.pid does not exist
[10/20/16 12:39:29] seafile-controller.c(588): seaf-server need restart...
[10/20/16 12:39:29] seafile-controller.c(198): starting seaf-server ...
```

#### Answer

This is most likely caused by Ceph library incompatible.

You can install `librados` provided by the Linux distribution, then remove bundled libraries:

```
cd seafile-server-latest/seafile/lib
rm librados.so.2 libstdc++.so.6 libnspr4.so
```

You can also run `seaf-fsck.sh`. It will print detailed message if Ceph library incompatible.



## GC error when removing blocks in Ceph

#### Description

We just did a GC run which came up with errors when deleting blocks.
This seems to happen with all blocks/libraries. Below is an example for a single library.

```
Starting seafserv-gc, please wait ...
[08/29/16 09:15:41] gc-core.c(768): Database is MySQL/Postgre, use online GC.
[08/29/16 09:15:41] gc-core.c(792): Using up to 10 threads to run GC.
[08/29/16 09:15:41] gc-core.c(738): GC version 1 repo Documents(135ca71c-da2b-4b07-86e3-c7a1d46b9b22)
[08/29/16 09:16:04] gc-core.c(510): GC started for repo 135ca71c. Total block number is 294.
[08/29/16 09:16:04] gc-core.c(68): GC index size is 1024 Byte for repo 135ca71c.
[08/29/16 09:16:04] gc-core.c(269): Populating index for repo 135ca71c.
[08/29/16 09:16:04] gc-core.c(334): Traversed 33 commits, 402 blocks for repo 135ca71c.
[08/29/16 09:16:04] gc-core.c(559): Scanning and deleting unused blocks for repo 135ca71c.
[08/29/16 09:16:04] ../../common/block-backend-ceph.c(463): [block bend] Failed to remove block 79fc986a: No such file
or directory.
[08/29/16 09:16:04] ../../common/block-backend-ceph.c(463): [block bend] Failed to remove block ae2678f8: No such file
or directory.
[08/29/16 09:16:04] ../../common/block-backend-ceph.c(463): [block bend] Failed to remove block 9fe1ca0b: No such file
or directory.
[08/29/16 09:16:04] ../../common/block-backend-ceph.c(463): [block bend] Failed to remove block 4cad277e: No such file
or directory.
[08/29/16 09:16:04] ../../common/block-backend-ceph.c(463): [block bend] Failed to remove block e9c94b16: No such file
or directory.
[08/29/16 09:16:04] gc-core.c(577): GC finished for repo 135ca71c. 294 blocks total, about 402 reachable blocks, 5
blocks are removed.

[08/29/16 09:16:04] gc-core.c(839): === GC is finished ===
seafserv-gc run done
```

#### Answer

Your "issue" looks similar to the one discussed here:
http://lists.ceph.com/pipermail/ceph-users-ceph.com/2015-November/005837.html

That should be related to the behavior of cache tier in Ceph. You could
try to use "rados rm" command to remove that object. If it returns the
same error (no such file or directory), it should be the same issue. You
should try to copy that object out before removing it, in case you still
need it later.

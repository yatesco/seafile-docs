# Seafile.conf settings

**Note**: Since Seafile Server 5.0.0, all config files are moved to the central **conf** folder. [Read More](../deploy/new_directory_layout_5_0_0.md).

## Storage Quota Setting

You may set a default quota (e.g. 2GB) for all users. To do this, just add the following lines to `seafile.conf` file

<pre>
[quota]
# default user quota in GB, integer only
default = 2
</pre>

This setting applies to all users. If you want to set quota for a specific user, you may log in to seahub website as administrator, then set it in "System Admin" page.

## Default history length limit

If you don't want to keep all file revision history, you may set a default history length limit for all libraries.

<pre>
[history]
keep_days = days of history to keep
</pre>

## System Trash
Seafile uses a system trash, where deleted libraries will be moved to. In this way, accidentally deleted libraries can be recovered by system admin.
<pre>
[library_trash]
# How often trashed libraries are scanned for removal, default 1 day.
scan_days = xx

# How many days to keep trashed libraries, default 30 days.
expire_days = xx
</pre>

## Seafile fileserver configuration

The configuration of seafile fileserver is in the <code>[fileserver]</code> section of the file `seafile.conf`

<pre>
[fileserver]
# bind address for fileserver, default to 0.0.0.0
host = 0.0.0.0
# tcp port for fileserver
port = 8082
</pre>

Change upload/download settings.

<pre>
[fileserver]
# Set maximum upload file size to 200M.
max_upload_size=200

# Set maximum download directory size to 200M.
max_download_dir_size=200
</pre>

You can download a folder as a zip archive from seahub, but some zip software
on windows doesn't support UTF-8, in which case you can use the "windows_encoding"
settings to solve it.
<pre>
[zip]
# The file name encoding of the downloaded zip file.
windows_encoding = iso-8859-1
</pre>

## Changing MySQL Connection Pool Size

When you configure seafile server to use MySQL, the default connection pool size is 100, which should be enough for most use cases. You can change this value by adding following options to seafile.conf:

```
[database]
......
# Use larger connection pool
max_connections = 200
```
**Note**: You need to restart seafile and seahub so that your changes take effect.
<pre>
./seahub.sh restart
./seafile.sh restart
</pre>

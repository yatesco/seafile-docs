# File permission management

Seafile manages files into libraries. Every library has an owner, who can share the library to other users or share it into groups. The share can be read-only or read-write.

## Read-only syncing

Read-only libraries can be synced to local desktop. The modifications at the client will not be synced back. In the further, we will add the ability to prevent users from modifying the files on the client.

## Cascading permission

In Seafile, most permission management are done at the library level. This makes syncing very efficient without needing to check permission for every file. And we think this is enough for most cases. But there are occasional cases where users want to set different permissions on sub-folders.

Suppose you share a library as read-only to a group and then want specific sub-folder to be read-write by a few users. You can share the the sub-folder as read-write to these users. From the view of the latter, they will see a library (with the name of the sub-folder) appear in the shared libraries. And they can modify that library.

This is not very intuitive. In the further, we will add tranditional cascading permission management feature. Currently, this seems not that demanding by the users. You can tell your opinion by raise issues on [Seafile project at Github](https://github.com/haiwen/seafile).

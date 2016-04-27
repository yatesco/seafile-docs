# Import Directory To Seafile

From seafile 5.1.3 pro edition, we support import local directory to seafile functionality, that is copy the entire directory to a new created repositroy of seafile.

## Usage

Assume you have installed seafile 5.1.3 pro edition and have executed related setup seafile script, or you have upgraded seafile to 5.1.3 pro edition.

1. Go to <INSTALL_PATH>/seafile-server-latest, there is a script named seaf-import.sh, execute `./seaf-import.sh -h`, it will print follow usage information:
```
usage :
seaf-import.sh
 -p <import dir path, must set>
 -n <repo name, must set>
 -u <repo owner, must set>
```

2. Execute `./seaf-import.sh -p <dir you want to import> -n <repo name> -u <repo owner>`, follow similar information will output:
```
Starting seaf-import, please wait ...
[04/26/16 03:36:23] seaf-import.c(79): Import file ./runtime/seahub.pid successfully.
[04/26/16 03:36:23] seaf-import.c(79): Import file ./runtime/error.log successfully.
[04/26/16 03:36:23] seaf-import.c(79): Import file ./runtime/seahub.conf successfully.
[04/26/16 03:36:23] seaf-import.c(79): Import file ./runtime/access.log successfully.
[04/26/16 03:36:23] seaf-import.c(183): Import dir ./runtime/ to repo 5ffb1f43 successfully.
 run done
Done.
```

3. Login in seafile server with <above repo owner>, you will find a new repositroy named <above repo name> created.

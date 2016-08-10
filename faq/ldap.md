# LDAP related issues

## Can't connect to LDAP server with ldaps

#### Description

Seafile server can't communication with my LDAP server. The ccnet.log shows:

```
[08/05/16 09:47:17] ../common/session.c(398): Accepted a local client
[08/05/16 09:47:17] user-mgr.c(335): ldap_initialize failed: Bad parameter to an ldap routine.
[08/05/16 09:47:17] user-mgr.c(773): Ldap init and bind failed using ‘cn=XXX,dc=XXX,dc=XXX': ‘XXXXXXX' on server 'ldaps://10.XX.XX.XX/'.
```

#### Answer

If you are using pro edition, you can check the LDAP configuration by running a script as described in  http://manual.seafile.com/deploy_pro/using_ldap_pro.html  (search Testing your LDAP Configuration).

If the script can correctly talk to ldap server, it is most likely caused by incompatible of bundled LDAP libraries. You can follow http://manual.seafile.com/deploy/using_ldap.html (the end of document) to remove the bundled LDAP libraries.


## How to restrict Seafile access to certain accounts in AD

#### Answer

You can use FILTER field in LDAP configuration in `ccnet.conf`. For example, the following filter restricts the access to Seafile to members of a group.

    FILTER = (memberOf=cn=group,cn=users,DC=x)

AD also supports subgroups. The following filter restricts the access to Seafile to membersand subgroups of a group.

    FILTER = (memberOf:1.2.840.113556.1.4.1941:=cn=group,cn=users,DC=x)

For more information on the Filter syntax, see http://msdn.microsoft.com/en-us/library/aa746475%28VS.85%29.aspx

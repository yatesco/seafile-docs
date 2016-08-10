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

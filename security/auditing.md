# Access log and auditing

In the Pro Edition, Seafile offers four audit logs in system admin panel:

* Login log
* File access log (including access to shared files)
* File update log
* Permission change log

![Seafile Auditing Log](../images/admin-audit-log.png)

The logging feature is turned off by default. See [config options for pro edition](../deploy_pro/configurable_options.md) for how to turn it on.

The audit log data is being saved in seahub-db.

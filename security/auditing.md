# Access log and auditing

In pro edition, Seafile offers four auditing logs in system admin panel:

* Login log
* File access log
* File update log
* Permission change log

The logging feature is turned off by default. See [config options for pro edition](../deploy_pro/configurable_options) for how to turn it on.

## file access

access.log (under directory logs/stats-logs) records the following information

* file download via Web
* file download via API or mobile clients
* file sync via desktop clients


The format is:

    user, operation type, ip/device, date, library_name, file path. 




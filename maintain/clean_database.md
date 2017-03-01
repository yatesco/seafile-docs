# Clean Database

## Seahub

### Session

Since version 5.0, we offered command to clear expired session records in Seahub database.

    cd <install-path>/seafile-server-latest
    ./seahub.sh clearsessions


### Activity

To clean the activity table, login in to MySQL/MariaDB and use the following command:

    use seahub_db;
    DELETE FROM Event WHERE to_days(now()) - to_days(timestamp) > 90;

The corresponding items in UserEvent will deleted automatically by MariaDB when the foreign keys in Event table are deleted.

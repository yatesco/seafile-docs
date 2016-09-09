# Guest Invitation

Starting from version 6.0, we added guest invitation feature to enable certain users to invite guests.

Please read [this document](http://manual.seafile.com/deploy_pro/roles_permissions.html) about roles and permissions before continue.


In order to use this feature, please add following line to `seahub_settings.py`,

```
ENABLE_GUEST_INVITATION = True
```

After restarting, users who have `can_invite_guest` permission will see "Invite People" section at sidebar of home page.

Users can invite a guest user by providing his/her email address, system will email the invite link to the user.

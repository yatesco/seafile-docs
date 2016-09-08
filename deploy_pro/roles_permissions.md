# Roles and Permissions Support

Starting from version 6.0, you can add/edit roles and permission for users. A role is just a group of users with some pre-defined permissions, you can toggle user roles in user list page at admin panel.

In version 6.0, we support 11 permissions, more permissions will be added later.

Seafile comes with two build-in roles `default` and `guest`, a default user is a normal user with permissions as followings:
```
    'default': {
        'can_add_repo': True,
        'can_add_group': True,
        'can_view_org': True,
        'can_use_global_address_book': True,
        'can_generate_share_link': True,
        'can_generate_upload_link': True,
        'can_invite_guest': False,
        'can_drag_drop_folder_to_sync': True,
        'can_connect_with_android_clients': True,
        'can_connect_with_ios_clients': True,
        'can_connect_with_desktop_clients': True,
    },
```

While a guest user can only read files/folders in the system, here are the permissions for a guest user:
```
    'guest': {
        'can_add_repo': False,
        'can_add_group': False,
        'can_view_org': False,
        'can_use_global_address_book': False,
        'can_generate_share_link': False,
        'can_generate_upload_link': False,
        'can_invite_guest': False,
        'can_drag_drop_folder_to_sync': False,
        'can_connect_with_android_clients': False,
        'can_connect_with_ios_clients': False,
        'can_connect_with_desktop_clients': False,
    },
```

## Edit build-in roles

If you want to edit the permissions of build-in roles, e.g. default users can invite guest, guest users can view repos in organization, you can add following lines to `seahub_settings.py` with corresponding permissions set to `True`.

```
ENABLED_ROLE_PERMISSIONS = {
    'default': {
        'can_add_repo': True,
        'can_add_group': True,
        'can_view_org': True,
        'can_use_global_address_book': True,
        'can_generate_share_link': True,
        'can_generate_upload_link': True,
        'can_invite_guest': True,
        'can_drag_drop_folder_to_sync': True,
        'can_connect_with_android_clients': True,
        'can_connect_with_ios_clients': True,
        'can_connect_with_desktop_clients': True,
    },
    'guest': {
        'can_add_repo': False,
        'can_add_group': False,
        'can_view_org': True,
        'can_use_global_address_book': False,
        'can_generate_share_link': False,
        'can_generate_upload_link': False,
        'can_invite_guest': False,
        'can_drag_drop_folder_to_sync': False,
        'can_connect_with_android_clients': False,
        'can_connect_with_ios_clients': False,
        'can_connect_with_desktop_clients': False,
    }
}
```

## Add custom roles

If you want to add a new role and assign some users with this role, e.g. new role `employee` can invite guest and have all other permissions a default user has, you can add following lines to `seahub_settings.py`

```
ENABLED_ROLE_PERMISSIONS = {
    'default': {
        'can_add_repo': True,
        'can_add_group': True,
        'can_view_org': True,
        'can_use_global_address_book': True,
        'can_generate_share_link': True,
        'can_generate_upload_link': True,
        'can_invite_guest': False,
        'can_drag_drop_folder_to_sync': True,
        'can_connect_with_android_clients': True,
        'can_connect_with_ios_clients': True,
        'can_connect_with_desktop_clients': True,
    },
    'guest': {
        'can_add_repo': False,
        'can_add_group': False,
        'can_view_org': False,
        'can_use_global_address_book': False,
        'can_generate_share_link': False,
        'can_generate_upload_link': False,
        'can_invite_guest': False,
        'can_drag_drop_folder_to_sync': False,
        'can_connect_with_android_clients': False,
        'can_connect_with_ios_clients': False,
        'can_connect_with_desktop_clients': False,
    },
    'employee': {
        'can_add_repo': True,
        'can_add_group': True,
        'can_view_org': True,
        'can_use_global_address_book': True,
        'can_generate_share_link': True,
        'can_generate_upload_link': True,
        'can_invite_guest': True,
        'can_drag_drop_folder_to_sync': True,
        'can_connect_with_android_clients': True,
        'can_connect_with_ios_clients': True,
        'can_connect_with_desktop_clients': True,
    },
}
```

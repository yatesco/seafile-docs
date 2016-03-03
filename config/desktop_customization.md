# Seafile Desktop customization

## Customize the logo and name displayed on seafile desktop clients (Seafile Professional Only)

Note: The feature is only available in seafile desktop client 4.4.0 and later.

By default, the text "Seafile" is displayed in the top of seafile desktop client window, along side with the seafile logo. To customize them, set `DESKTOP_CUSTOM_LOGO` and `DESKTOP_CUSTOM_BRAND` in `seahub_settings.py`.

![desktop-customization](../images/desktop-customization.png)

The size of the image must be `24x24`, and generally you should put it in the `custom` folder.

```python
DESKTOP_CUSTOM_LOGO = 'custom/desktop-custom-logo.png'
DESKTOP_CUSTOM_BRAND = 'Seafile For My Company'
```

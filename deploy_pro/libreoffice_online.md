# Integrate Seafile with Collabora Online (LibreOffice Online)

Since Seafile Professional edition 6.0.0, you can integrate Seafile with Collabora Online to preview office files.

## Setup LibreOffice Online

Prepare a Ubuntu 16.04 64bit server with [docker](http://www.docker.com/) installed, the use the following command to setup Collabora Online:

```
docker pull collabora/code
docker run -t -p 9980:9980 -e "domain=<your-dot-escaped-domain>" --cap-add MKNOD collabora/code
```

For more information about Collabora Online and how to deploy it, please refer to https://www.collaboraoffice.com/code/

## Config Seafile

NOTE: You must [enable https](../deploy/https_with_nginx.md) with Seafile to use Collabora Online.

Add following config option to seahub_settings.py:

``` python
# Enable LibreOffice Online
ENABLE_OFFICE_WEB_APP = True

# Url of LibreOffice Online's discovery page
# The discovery page tells Seafile how to interact with LibreOffice Online when view file online
# You should change `https://example.LibreOffice-online:9980/hosting/discovery` to your actual LibreOffice Online server address
OFFICE_WEB_APP_BASE_URL = 'https://example.LibreOffice-online:9980/hosting/discovery'

# Expiration of WOPI access token
# WOPI access token is a string used by Seafile to determine the file's
# identity and permissions when use LibreOffice Online view it online
# And for security reason, this token should expire after a set time period
WOPI_ACCESS_TOKEN_EXPIRATION = 30 * 60   # seconds

# List of file formats that you want to view through LibreOffice Online
# You can change this value according to your preferences
# And of course you should make sure your LibreOffice Online supports to preview
# the files with the specified extensions
OFFICE_WEB_APP_FILE_EXTENSION = ('ods', 'xls', 'xlsb', 'xlsm', 'xlsx','ppsx', 'ppt',
    'pptm', 'pptx', 'doc', 'docm', 'docx')

# Enable edit files through LibreOffice Online
ENABLE_OFFICE_WEB_APP_EDIT = True

# types of files should be editable through LibreOffice Online
OFFICE_WEB_APP_EDIT_FILE_EXTENSION = ('ods', 'xls', 'xlsb', 'xlsm', 'xlsx','ppsx', 'ppt',
    'pptm', 'pptx', 'doc', 'docm', 'docx')

```

Then restart Seafile.

Click and office file in Seafile web interface, you will see the online preview rendered by LibreOffice online. Here is an example:

![LibreOffice-online](../images/libreoffice-online.png)

## Trouble shooting

Understanding how theintegration work will help you debug the problem. When a user visits a file page:

1. (seahub->browser) Seahub will generate a page containing an iframe and send it to the browser
2. (browser->LibreOffice Online) With the iframe, the browser will try to load the file preview page from the LibreOffice Online
3. (LibreOffice Online->seahub) LibreOffice Online receives the request and sends a request to Seahub to get the file content
4. (LibreOffice Online->browser) LibreOffice Online sends the file preview page to the browser.

If you have a problem, please check the Nginx log for Seahub (for step 3) and Collabora Online to see which step is wrong.

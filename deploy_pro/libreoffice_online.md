# LibreOffice Online

In Seafile Professional Server Version 6.0.0 (or above), you can use LibreOffice Online to preview documents.

To use LibreOffice Online you should first prepare a Ubuntu 1604 64bit server with [docker](http://www.docker.com/) installed, then:

```
docker pull collabora/code
docker run -t -p 9980:9980 -e "domain=<your-dot-escaped-domain>" --cap-add MKNOD collabora/code
```

For more information about LibreOffice Online and how to deploy it, please refer to https://www.collaboraoffice.com/code/

NOTE: You must [enable https](../deploy/https_with_nginx.md) with Seafile to use LibreOffice Online.

Seafile's own Office file preview is still the default. To use LibreOffice Online for preview, please add following config option to seahub_settings.py.

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
WOPI_ACCESS_TOKEN_EXPIRATION = 30 * 60 # seconds

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

Then restart Seafile

After you click the document you specified in seahub_settings.py, you will see the new preview page.

![LibreOffice-online](../images/libreoffice-online.png)

## Trouble shooting

Understanding how the web app integration works is going to help you debugging the problem. When a user visits a file page:

1. (seahub->browser) Seahub will generate a page containing an iframe and send it to the browser
2. (browser->LibreOffice Online) With the iframe, the browser will try to load the file preview page from the LibreOffice Online
3. (LibreOffice Online->seahub) LibreOffice Online receives the request and sends a request to Seahub to get the file content
4. (LibreOffice Online->browser) LibreOffice Online sends the file preview page to the browser.

Please check the Nginx log for Seahub (for step 3) and LibreOffice Online to see which step is wrong.

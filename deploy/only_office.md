# Only Office

From 6.1.0 CE version on, Seafile will support [OnlyOffice](https://www.onlyoffice.com/) to view/edit office files online. In order to use OnlyOffice, you must deploy an OnlyOffice server first, for a quick and easy installation, we suggest you use [ONLYOFFICE/Docker-CommunityServer](https://github.com/ONLYOFFICE/Docker-CommunityServer). After the installation process finished, visit this page to make sure you have deployed OnlyOffice successfully: http{s}://{your OnlyOffice server's domain or IP}/welcome, you will get **Document Server is running** info at this page, then add the following config option to seahub_settings.py.

``` python
# Enable Only Office
ENABLE_ONLYOFFICE = True
VERIFY_ONLYOFFICE_CERTIFICATE = False
ONLYOFFICE_APIJS_URL = 'http{s}://{your OnlyOffice server's domain or IP}/web-apps/apps/api/documents/api.js'
ONLYOFFICE_FILE_EXTENSION = ('doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'odt', 'fodt', 'odp', 'fodp', 'ods', 'fods')
```

Then restart

```
./seafile.sh restart
./seahub.sh restart
```

After you click the document you specified in seahub_settings.py, you will see the new preview page.

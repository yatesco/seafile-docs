# Upgrade Notes V6.x.x
These notes just give additional information about changes within each major version.  
Please always follow the [main installation guide](https://manual.seafile.com/deploy/upgrade.html).

## Important release changes

From this version, the Wiki module is hidden by default. Users will not be able to turn it on. From our feedback, this feature is not used by most users. 

For compatibility with old version, you can turn it on by adding the following line to `seahub_settings.py`:

`ENABLE_WIKI = True`


---

## V6.1.0

#### Video Thumbnails
If you upgrade to 6.1, you need to install the FFMPEG package to activate video thumbnails:

```
# for Ubuntu 16.04
apt-get install ffmpeg
pip install pillow moviepy

# for Debian 8
apt-get install ffmpeg
pip install pillow moviepy

# for Centos 7
yum -y install epel-release
rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
yum -y install ffmpeg ffmpeg-devel
pip install pillow moviepy
```

#### OnlyOffice
The system requires some minor changes to support the OnlyOffice document server.  
Please follow the instructions [here](../deploy/only_office.md).

---

## V6.0.0 - V6.0.9

There are no other special instructions.

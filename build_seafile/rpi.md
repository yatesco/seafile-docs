# How to Build Seafile Server Release Package for Raspberry Pi

## Setup the build environment

### <a id="install-packages"></a> Install packages

```
sudo apt-get install build-essential
sudo apt-get install libevent-dev libcurl4-openssl-dev ibglib2.0-dev uuid-dev intltool libsqlite3-dev ibmysqlclient-dev libarchive-dev libtool libjansson-dev valac libfuse-dev re2c flex python-setuptools
```
### <a id="compile-dev-libs"></a> Compile development libraries

#### libevhtp

libevhtp is a http server libary on top of libevent. It's used in seafile file server.

```
git clone https://www.github.com/haiwen/libevhtp.git
cd libevhtp
cmake -DEVHTP_DISABLE_SSL=OFF -DEVHTP_BUILD_SHARED=ON .
make
sudo make install
```

#### libzdb

`libzdb` provides a consistent API to various database backends, including sqlite/mysql/pg/oracle. It's used by ccnet-server and seafile-server.

```
git clone https://www.github.com/haiwen/libzdb.git
cd libzdb
./configure
make
sudo make install
```

### <a id="install-python-libs"></a> Install python libraries


Create a new directory `/home/pi/dev/seahub_thirdpart`:

```
mkdir -p ~/dev/seahub_thirdpart
```

Download these tarballs to `/tmp/`:

- [django 1.5.12](https://www.djangoproject.com/download/1.5/tarball/)
- [djblets 0.6.14](https://github.com/djblets/djblets/tarball/release-0.6.14)
- [gunicorn 0.16.1](http://pypi.python.org/packages/source/g/gunicorn/gunicorn-0.16.1.tar.gz)
- [flup 1.0](http://pypi.python.org/packages/source/f/flup/flup-1.0.tar.gz#md5=530801fe835fd9a680457e443eb95578)
- [chardet](https://pypi.python.org/pypi/chardet)
- [python-dateutil](https://labix.org/python-dateutil#head-2f49784d6b27bae60cde1cff6a535663cf87497b)
- [six](https://pypi.python.org/pypi/six)

Install all these libaries to `/home/pi/dev/seahub_thirdpart`:

```
cd ~/dev/seahub_thirdpart
export PYTHONPATH=.
easy_install -d . /tmp/Django-1.5.12.tar.gz
easy_install -d . /tmp/djblets-0.6.14.tar.gz
easy_install -d . /tmp/gunicorn-0.16.1.tar.gz
easy_install -d . /tmp/flup-1.0.tar.gz
easy_install -d . /tmp/chardet-1.0.tar.gz
easy_install -d . /tmp/python-dateutil-1.5.tar.gz
easy_install -d . /tmp/six-<version>.tar.gz
```

## Prepare source code

To build seafile server, there are four sub projects involved:

- [libsearpc](https://github.com/haiwen/libsearpc)
- [ccnet](https://github.com/haiwen/ccnet)
- [seafile](https://github.com/haiwen/seafile)
- [seahub](https://github.com/haiwen/seahub)

The build process has two steps:

- First, fetch the tags of each projects, and make a soruce tarball for each of them.
- Then run a `build-server.py` script to build the server package from the source tarballs.

### Fetch git tags and prepare source tarballs

Seafile manages the releases in tags on github.

Assume we are packaging for seafile server 4.1.1, then the tags are:

- ccnet, seafile, and seahub would all have a `v4.1.1-sever` tag.
- libsearpc would have the `v3.0-latest` tag (libsearpc has been quite stable and basically has no further development, so the tag is always `v3.0-latest`)

First setup the `PKG_CONFIG_PATH` enviroment variable (So we don't need to make and make install libsearpc/ccnet/seafile into the system):

```
export PKG_CONFIG_PATH=/c/src/seafile/lib:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/c/src/libsearpc:$PKG_CONFIG_PATH
export PKG_CONFIG_PATH=/c/src/ccnet:$PKG_CONFIG_PATH
```


### libsearpc

```
cd ~/dev
git clone https://github.com/haiwen/libsearpc.git
cd libsearpc
git reset --hard v3.0-latest
./autogen.sh
./configure
make dist
```

### ccnet

```
cd ~/dev
git clone https://github.com/haiwen/ccnet.git
cd ccnet
git reset --hard v4.1.1-server
./autogen.sh
./configure
make dist
```

### seafile

```
cd ~/dev
git clone https://github.com/haiwen/seafile.git
cd seafile
git reset --hard v4.1.1-server
./autogen.sh
./configure
make dist
```

### seahub

```
cd ~/dev
git clone https://github.com/haiwen/seahub.git
cd seahub
git reset --hard v4.1.1-server
./tools/gen-tarball.py --version=4.1.1 --branch=HEAD
```

### Copy the source tar balls to the same folder

```
mkdir ~/seafile-sources
cp ~/dev/libsearpc/libsearpc-<version>-tar.gz ~/seafile-sources
cp ~/dev/ccnet/ccnet-<version>-tar.gz ~/seafile-sources
cp ~/dev/seafile/seafile-<version>-tar.gz ~/seafile-sources
cp ~/dev/seahub/seahub-<version>-tar.gz ~/seafile-sources
```

### Run the packaging script

Now we have all the tarballs prepared, we can run the `build-server.py` script to build the server package.

```
mkdir ~/seafile-server-pkgs
./build-server.py --libsearpc_version=<libsearpc_version> --ccnet_version=<ccnet_version> --seafile_version=<seafile_version> --seahub_version=<seahub_version> --srcdir=  --thidrpartdir=/home/pi/dev/seahub_thirdpart --srcdir=/home/pi/seafile-sources --outputdir=/home/pi/seafile-server-pkgs
```

After the script finisheds, we would get a `seafile-server_4.1.1_pi.tar.gz` in `~/seafile-server-pkgs` folder.

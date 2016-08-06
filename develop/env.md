# Setup Seafile Develop Environment

The following operation have all been tested on ubuntu-16.04.1-desktop-amd64 system.

## Install Necessary Packages

- install necessary packages by `apt`

```
sudo apt install ssh libevent-dev libcurl4-openssl-dev libglib2.0-dev uuid-dev intltool libsqlite3-dev libmysqlclient-dev libarchive-dev libtool libjansson-dev valac libfuse-dev python-dateutil cmake re2c flex sqlite3 python-pip python-simplejson git libssl-dev libldap2-dev
```

- install `libevhtp` from source

```
cd ~/Downloads/
wget https://github.com/ellzey/libevhtp/archive/1.1.6.tar.gz
tar xf 1.1.6.tar.gz
cd libevhtp-1.1.6/
cmake -DEVHTP_DISABLE_SSL=OFF -DEVHTP_BUILD_SHARED=ON .
make
sudo make install
sudo ldconfig
```

- install `libzdb` from source

```
cd ~/Downloads/
wget http://tildeslash.com/libzdb/dist/libzdb-3.1.tar.gz
tar xf libzdb-3.1.tar.gz
cd libzdb-3.1/
./configure
make
sudo make install
sudo ldconfig
```

## Download and Build Seafile

- create project root directory *dev*

```
cd
mkdir dev
```

- download and install `libsearpc`

```
cd ~/dev/
git clone https://github.com/haiwen/libsearpc.git
cd libsearpc/
./autogen.sh
./configure
make
sudo make install
sudo ldconfig
```

- download and install `ccnet`

```
cd ~/dev/
git clone https://github.com/haiwen/ccnet.git
cd ccnet/
git checkout -b v6.0.0-server v6.0.0-server
./autogen.sh
./configure --disable-client --enable-server --enable-ldap
make
sudo make install
sudo ldconfig
```

- download and install `seafile`

```
cd ~/dev/
git clone https://github.com/haiwen/seafile.git
cd seafile/
git checkout -b v6.0.0-server v6.0.0-server
./autogen.sh
./configure --disable-client --enable-server
make
sudo make install
```

- download `seahub`

```
cd ~/dev/
git clone https://github.com/haiwen/seahub.git
cd seahub/
git checkout -b v6.0.0-server v6.0.0-server
```

## Start `ccnet-server` and `seaf-server`

```
cd ~/dev/seafile/tests/basic
./seafile.sh 2
```

or you can start manually by:

```
ccnet-server -c ~/dev/seafile/tests/basic/conf2/ -D all -f -
seaf-server -c ~/dev/seafile/tests/basic/conf2/ -d ~/dev/seafile/tests/basic/conf2/seafile-data/ -f -l -
```

**NOTE**: if *error while loading shared libraries: libzdb.so.11: cannot open shared object file: No such file or directory*, you should `sudo ldconfig`

## Start `seahub`

`Seahub` is the web front end of Seafile. It is written in the Django framework, requires Python 2.7 installed on your server.

- set environment

```
cd ~/dev/seahub/

cat > setenv.sh << EOF
export CCNET_CONF_DIR=/home/plt/dev/seafile/tests/basic/conf2
export SEAFILE_CONF_DIR=/home/plt/dev/seafile/tests/basic/conf2/seafile-data
export PYTHONPATH=/usr/local/lib/python2.7/dist-packages:thirdpart:\$PYTHONPATH
EOF

sudo chmod u+x setenv.sh
```

**NOTE**: change **plt** to your linux user name

- install requirements

```
. setenv.sh
cd ~/dev/seahub/
sudo pip install -r requirements.txt
```

**NOTE**: if *locale.Error: unsupported locale setting*, you should `export LC_ALL=en_US.UTF-8`

- create database and admin account

```
. setenv.sh
python manage.py migrate
python tools/seahub-admin.py # create admin account
```

**NOTE**: currently, your *ccnet directory* is `/home/plt/dev/seafile/tests/basic/conf2`

- run `seahub`

```
python manage.py runserver 0.0.0.0:8000
```

then open browser and navigate to http://127.0.0.1:8000

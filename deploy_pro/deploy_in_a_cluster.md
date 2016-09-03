# Deploy in a cluster

**Note**: Since Seafile Server 5.0.0, all config files are moved to the central **conf** folder. [Read More](../deploy/new_directory_layout_5_0_0.md).

**Update**: Since Seafile Pro server 6.0.0, cluster deployment requires that `seafile-data/httptemp` folder be placed inside an NFS share. Otherwise sometimes folder download on the web UI can't work properly. Read the "Link `seafile-data/httptemp` to an NFS Share" section below for details.

## <a id="wiki-arch"></a> Architecture

The Seafile cluster solution employs a 3-tier architecture:

* Load balancer tier: Distribute incoming traffic to Seafile servers. HA can be achieved by deploying multiple load balancer instances.
* Seafile server cluster: a cluster of Seafile server instances. If one instance fails, the load balancer will stop handing traffic to it. So HA is achieved.
* Backend storage: Distributed storage cluster, e.g.  S3, Openstack Swift or Ceph.

This architecture scales horizontally. That means, you can handle more traffic by adding more machines. The architecture is visualized in the following picture.

![seafile-cluster](../images/seafile-cluster.png)

There are two main components on the Seafile server node: web server (Nginx/Apache) and Seafile app server. The web server passes requests from the clients to Seafile app server. The Seafile app servers work independently. They don't know about each other's state. That means each app server can fail independently without affecting other app server instances. The load balancer is responsible for detecting failure and re-routing requests.

Even though Seafile app servers work independently, they still have to share some session information. All shared session information are stored in memcached. So all Seafile app servers have to connect to the same memcached server (cluster). More details about memcached configuration is available later.

All Seafile app servers access the same set of user data. The user data has two parts: One in the MySQL database and the other one in the backend storage cluster (S3, Ceph etc.). All app servers serve the data equally to the clients.

All app servers have to connect to the same database or database cluster. We recommend to use MariaDB Galera Cluster if you need a database cluster.

There are a few steps to deploy a Seafile cluster:

1. Prepare hardware, operating systems, memcached and database
2. Setup a single Seafile server node
3. Copy the deployment to other Seafile nodes
4. Setup Nginx/Apache and firewall rules
5. Setup load balancer
6. [Setup backgroup task node](enable_search_and_background_tasks_in_a_cluster.md)

## <a id="wiki-preparation"></a>Preparation

### Hardware

At least 2 Linux server with at least 2GB RAM.

### Install Python libraries

On each mode, you need to install some python libraries.

First make sure your have installed Python 2.7, then:
```
sudo easy_install pip
sudo pip install boto
```

If you receive an error stating "Wheel installs require setuptools >= ...", run this between the pip and boto lines above
```
sudo pip install setuptools --no-use-wheel --upgrade
```

### Setup Memcached

All Seafile server instances will share the same memcached server cluster. Let's assume that the address of memcached server is 192.168.1.134, listening on port 11211 (the default).

By default, memcached only listens on 127.0.0.1. So you have to modify memcached.conf and restart memcached.

```
# Specify which IP address to listen on. The default is to listen on all IP addresses
# This parameter is one of the only security measures that memcached has, so make sure
# it's listening on a firewalled interface.
-l 0.0.0.0
```

It's also recommended to set a higher limit for memcached's memory, such as 256MB.

```
# Start with a cap of 64 megs of memory. It's reasonable, and the daemon default
# Note that the daemon will grow to this size, but does not start out holding this much
# memory
-m 256
```

Seafile servers share session information within memcached. If you set up a memcached cluster, please make sure all the seafile server nodes connects to all the memcached nodes.

When setting up a memcached cluster, you can either run one memcached instance on each Seafile server node, or set up separate machines for the memcached cluster. It usually saves you some money if you run memcached on Seafile server nodes.

### (Optional) Setup MariaDB Cluster

MariaDB cluster helps you to remove single point of failure from the cluster architecture. Every update in the database cluster is synchronously replicated to all instances.

It's recommended that you run one database instance on each Seafile server node. There are a few benefits about this approach:

* The Seafile app server always access its local database instance, which is faster.
* You don't have to set up another load balancer for the database instances.

This architecture should scale well for a few tens of database nodes, since Seafile has not many write operations to the db. For bigger deployments, you'd better use more sophiscated load balancing techniques for the databases.

Details about setting up MariaDB cluster is covered in [this document](clustering_with_mariadb_ceph.md).

## <a id="wiki-configure-single-node"></a> Configure a Single Node

You should make sure the config files on every Seafile server are consistent. **It's critical that you don't set up Seafile server on each machine separately. You should set up seafile server on one machine then copy the config directory to the other machines.**

### Get the license

Put the license you get under the top level diretory. In our wiki, we use the diretory `/data/haiwen/` as the top level directory.


### Download/Uncompress Seafile Professional Server

```
tar xf seafile-pro-server_2.1.3_x86-64.tar.gz
```

Now you have:

```
haiwen
├── seafile-license.txt
└── seafile-pro-server-2.1.3/
```
### Setup Seafile Config

The setup process of Seafile Professional Server is the same as the Seafile Community Server. See [Download and Setup Seafile Server With MySQL](../deploy/using_mysql.md) in the community wiki.

Note: **Use the load balancer's address or domain name for the server address. Don't use the local IP address of each Seafile server machine. This assures the user will always access your service via the load balancers.**

After the setup process is done, you still have to do a few manual changes to the config files.

#### seafile.conf

You have to add the following configuration to `seafile.conf`

```
[cluster]
enabled = true
memcached_options = --SERVER=192.168.1.134 --POOL-MIN=10 --POOL-MAX=100
```

If you have a memcached cluster, you need to specify all the memcached server addresses in seafile.conf. The format is

```
[cluster]
enabled = true
memcached_options = --SERVER=192.168.1.134 --SERVER=192.168.1.135 --SERVER=192.168.1.136 --POOL-MIN=10 --POOL-MAX=100
```

(Optional) The Seafile server also opens a port for the load balancers to run health checks. Seafile by default uses port 11001. You can change this by adding the following config option to `seafile.conf`

```
[cluster]
health_check_port = 12345
```

#### seahub_settings.py

Install Python memcache library.

On Debian/Ubuntu:

```
sudo apt-get install python-memcache
```

On CentOS/RedHat:

```
sudo yum install python-memcached
```

Add the following configuration to `seahub_settings.py`. These settings tell Seahub to store avatar in database and cache avatar in memcached, and store css CACHE to local memory of every node.

```
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': '192.168.1.134:11211',
    }
}

AVATAR_FILE_STORAGE = 'seahub.base.database_storage.DatabaseStorage'

COMPRESS_CACHE_BACKEND = 'django.core.cache.backends.locmem.LocMemCache'

```

If you use memcached cluster, please replace the `CACHES` variable with the following:

```
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
        'LOCATION': ['192.168.1.134:11211', '192.168.1.135:11211', '192.168.1.136:11211',],
    }
}
```

If you enable the thumbnail feature, you'd better set thumbnail storage path to a **shared folder**, so that every node will create/get thumbnail through the same **shared folder**.

```
THUMBNAIL_ROOT = 'path/to/shared/folder/'
```

#### seafevents.conf

Add following to `seafevents.conf` to disable file indexing service on the local server. The file indexing service should be started on a dedicated background server.

```
[INDEX FILES]
external_es_server = true
```

### Update Seahub Database

In cluster environment, we have to store avatars in the database instead of in a local disk.

```
CREATE TABLE `avatar_uploaded` (`filename` TEXT NOT NULL, `filename_md5` CHAR(32) NOT NULL PRIMARY KEY, `data` MEDIUMTEXT NOT NULL, `size` INTEGER NOT NULL, `mtime` datetime NOT NULL);
```

### Link `seafile-data/httptemp` to an NFS Share

In version 6.0.0, the folder download mechanism has been updated. This requires that, in a cluster deployment, `seafile-data/httptemp` folder must be in an NFS share. You can make this folder a symlink to the NFS share.

```
cd /data/haiwen/
ln -s /nfs-share/seafile-httptemp seafile-data/httptemp
```

The httptemp folder only contains temp files for downloading/uploading file on web UI. So there is no reliability requirement for the NFS share. You can export it from any node in the cluster.

### Backend Storage Settings

You also need to add the settings for backend cloud storage systems to the config files.

* For NFS: [Setup Seafile cluster with NFS](setup_seafile_cluster_with_nfs.md)
* For S3: [Setup With Amazon S3](setup_with_mazon_S3.md)
* For OpenStack Swift: [Setup With OpenStackSwift](setup_with_OpenStackSwift.md)
* For Ceph: [Setup With Ceph](setup_with_Ceph.md)


### Run and Test the Single Node

Once you have finished configuring this single node, start it to test if it runs properly:

```
cd /data/haiwen/seafile-server-latest
./seafile.sh start
./seahub.sh start
```

*Note:* The first time you start seahub, the script would prompt you to create an admin account for your Seafile server.

Open your browser, visit http://ip-address-of-this-node:8000 and login with the admin account.


## <a id="wiki-configure-other-nodes"></a> Configure other nodes

Now you have one node working fine, let's continue to configure more nodes.

### Copy the config to all Seafile servers

Supposed your Seafile installation directory is `/data/haiwen`, compress this whole directory into a tarball and copy the tarball to all other Seafile server machines. You can simply uncompress the tarball and use it.

You have to make sure, on each node, `seafile-data/httptemp` should point to the same NFS share folder.

On each node, run `./seafile.sh` and `./seahub.sh` to start Seafile server.

## Setup Nginx/Apache and Https

You'll usually want to use Nginx/Apache and https for web access. You need to set it up on each machine running Seafile server. **Make sure the certificate on all the servers are the same.**

* For Nginx:
   * [Config Seahub with Nginx](../deploy/deploy_with_nginx.md)
   * [Enabling Https with Nginx](../deploy/https_with_nginx.md)
* For Apache:
   * [Config Seahub with Apache](../deploy/deploy_with_apache.md)
   * [Enabling Https with Apache](../deploy/https_with_apache.md)

## Firewall Settings

Beside [standard ports of a seafile server](../deploy/using_firewall.md), there are 2 firewall rule changes for Seafile cluster:

* On each Seafile server machine, you should open the health check port (default 11001);
* On the memcached server, you should open the port 11211. For security resons only the Seafile servers should be allowed to access this port.


## <a id="wiki-lb-settings"></a>Load Balancer Setting

Now that your cluster is already running, fire up the load balancer and welcome your users.

### AWS Elastic Load Balancer (ELB)

In the AWS ELB management console, after you've added the Seafile server instances to the instance list, you should do two more configurations.

First you should setup TCP listeners

![elb-listeners](../images/elb-listeners.png)

Then you setup health check

![elb-health-check](../images/elb-health-check.png)

### HAProxy

This is a sample `/etc/haproxy/haproxy.cfg`:

(Assume your health check port is `11001`)

```
global
    log 127.0.0.1 local1 notice
    maxconn 4096
    user haproxy
    group haproxy

defaults
    log global
    mode http
    retries 3
    maxconn 2000
    timeout connect 10000
    timeout client 300000
    timeout server 300000

listen seahub 0.0.0.0:80
    mode http
    option httplog
    option dontlognull
    option forwardfor
    server seahubserver01 192.168.1.165:80 check port 11001
    server seahubserver02 192.168.1.200:80 check port 11001

listen seahub-https 0.0.0.0:443
    mode tcp
    option tcplog
    option dontlognull
    server seahubserver01 192.168.1.165:443 check port 11001
    server seahubserver02 192.168.1.200:443 check port 11001
```

## See how it runs

Now you should be able to test your cluster. Open https://seafile.example.com in your browser and enjoy. You can also synchronize files with Seafile clients.

If the above works, the next step would be [Enable search and background tasks in a cluster](enable_search_and_background_tasks_in_a_cluster.md).

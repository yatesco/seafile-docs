# Seafile Clustering with MariaDB and Ceph

In this document we describe the detailed solution of deploying a high scalable Seafile cluster with MariaDB and Ceph. The document is not a finished one. We will improve it continuously as our knowledge grow with several on going projects.

## Backgrounds

Seafile organizes files into libraries. Each library is a GIT repository like file system tree with each file and folder identified by a unique hash value. These unique IDs are used in the syncing algorithm and there is no need to storing syncing state for each file in the database. Tranditional database like MySQL are not scalable to tens of millions of records, while object storages like Ceph and Swift are highly scalable. So in theory, Seafile is capable to storing billions of files for syncing and sharing.

While files are saved into object storage, other information like sharing and permission has to be stored in database. MariaDB Galera can be used to provide a scalable and reliable database storage.

## Hardware and system requirement

In the minimum, we use three machines to setup the cluster. Each machine should be of

* 4 cores with 8GB or more memory.
* 1 SSD disk to storing Ceph journal.
* 1 SATA disk to storing the operating system
* 1 SATA disk to storing MariaDB database
* 4 or more SATA disk to store Ceph data

We use Ubuntu 14.04 server as the operating system. In the following, we denote the three server as node1, node2 and node3.

## Setup Ceph cluster

#### Prepare

1. Install ceph-deploy and setup ssh access.
2. In node1, create a directory "ceph-cluster"

#### Create Ceph cluster

In node1

    node1# ceph-deploy new node1 node2 node3
    node1# ceph-deploy install node1 node2 node3
    node1# ceph-deploy mon create-initia1

#### Add OSDs

In Ceph, every OSD manages one disk. Suppose the disk for SSD is `/dev/sdb` and the SATA disks are `/dev/sdc`, `/dev/sdd`, etc. Add OSDs by the following commands:

    node1# ceph-deploy osd create node1:/dev/sdc:/dev/sdb
    node1# ceph-deploy osd create node2:/dev/sdc:/dev/sdb
    node1# ceph-deploy osd create node3:/dev/sdc:/dev/sdb
    node1# ceph-deploy osd create node1:/dev/sdd:/dev/sdb
    node1# ceph-deploy osd create node2:/dev/sdd:/dev/sdb
    node1# ceph-deploy osd create node3:/dev/sdd:/dev/sdb


#### 

## Setup MariaDB cluster

#### Install MariaDB and Galera

    sudo apt-get install mariadb-galera-server galera
    sudo apt-get install rsync

#### Config MariaDB

In `/etc/mysql/conf.d/cluster.cnf`

    [mysqld]
     
    query_cache_size=0
    binlog_format=ROW
    default-storage-engine=innodb
    innodb_autoinc_lock_mode=2
    query_cache_type=0
    bind-address=0.0.0.0

    # Galera Provider Configuration
    wsrep_provider=/usr/lib/galera/libgalera_smm.so
    #wsrep_provider_options="gcache.size=32G"

    # Galera Cluster Configuration
    wsrep_cluster_name="test_cluster"
    wsrep_cluster_address="gcomm://first_ip,second_ip,third_ip

    # Galera Synchronization Congifuration
    wsrep_sst_method=rsync
    #wsrep_sst_auth=user:pass

    # Galera Node Configuration
    wsrep_node_address="this_node_ip"
    wsrep_node_name="this_node_name"

Here first_ip, second_ip and third_ip are corresponding to the IP address of node1, node2 and node3.

#### Start

In node1:

    node1# sudo service mysql start --wsrep-new-cluster

In node2 and node3:

    node2# sudo service mysql start
    node3# sudo service mysql start

## Setup Seafile cluster

Please follow http://manual.seafile.com/deploy_pro/setup_with_Ceph.html to set seafile with Ceph and follow http://manual.seafile.com/deploy_pro/deploy_in_a_cluster.html for setup Seafile cluster.







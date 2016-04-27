# Seafile Store Backend Encryption

From seafile 5.1.3 pro edition, we support store backend encryption functionality, that is all seafile related objects(commit, fs, block) will be encrypted by 32 bits key and 16 bits iv using EVP_aes_256_cbc algorithm, then store to related backend.

## Config Store Backend Encryption

Assume you have installed seafile 5.1.3 pro edition and have executed related setup seafile script, or you have upgraded seafile to 5.1.3 pro edition.

### Generate Key Iv

1. Go to <INSTALL_PATH>/seafile-server-latest, there is a script named seaf-gen-key.sh, execute `./seaf-gen-key.sh -h`, it will print follow usage information:
```
usage :
seaf-gen-key.sh
 -p <file path to write key iv, default ./seaf-key.txt>
```

2. Assume we generate key file in current dir and named seaf-key.txt, execute `./seafile-gen-key.sh` (note: you can generate other key file by set -p parameter), then a new file seaf-key.txt is created in current dir.
**Note you can not miss or corrupt the key file or seafile will not work, so advise you to backup the key file.**

### Configuration For New Installed Seafile

Add follow configuration to seafile.conf:
```
[store_crypt]
key_path = <the key file path generated in previous section>
```

### Configuration For Upgraded Seafile Or Have Runned Seafile

In order to work with previous data, we must encrypt previous data.

1. Ensure seafile server has been stopped, you can go to <INSTALL_PATH>/seafile-server-latest, execute `./seafile.sh stop` to stop seafile server.

2. Go to <INSTALL_PATH>, execute follow command:
```
cp -r conf conf-enc
mkdir seafile-data-enc

if you are using sqlite db, execute cp seafile-data/seafile.db seafile-data-enc/
```

3. If you config s3/swift/ceph backend, edit <INSTALL_PATH>/conf-enc/seafile.conf, set new bucket/container/pool in block_backend, commit_object_backend, fs_object_backend three sections to store encryted data.

4. Add follow configuration to <INSTALL_PATH>/conf-enc/seafile.conf
```
[store_crypt]
key_path = <the key file path generated in previous section>
```

5. Go to <INSTALL_PATH>/seafile-server-latest, there is a script named seaf-encrypt.sh, execute `./seaf-encrypt -h`, it will print follow usage information:
```
usage :
seaf-encrypt.sh
 -f <seafile enc central config dir, must set>
 -e <seafile enc data dir, must set>
```

6. Execute `./seaf-encrypt -f ../conf-enc -e ../seafile-data-enc`, follow similar information will output:
```
Starting seaf-encrypt, please wait ...
[04/26/16 06:59:40] seaf-encrypt.c(444): Start to encrypt 57 block among 12 repo.
[04/26/16 06:59:40] seaf-encrypt.c(444): Start to encrypt 102 fs among 12 repo.
[04/26/16 06:59:41] seaf-encrypt.c(454): Success encrypt all fs.
[04/26/16 06:59:40] seaf-encrypt.c(444): Start to encrypt 66 commit among 12 repo.
[04/26/16 06:59:41] seaf-encrypt.c(454): Success encrypt all commit.
[04/26/16 06:59:41] seaf-encrypt.c(454): Success encrypt all block.
seaf-encrypt run done
Done.
```
If there are error messages output after executing seaf-encrypt.sh, you can clean related backend storage and retry.

7. Go to <INSTALL_PATH>, execute follow command:
```
mv conf conf-bak
mv seafile-data seafile-data-bak
mv conf-enc conf
mv seafile-data-enc seafile-data
```
Restart seafile server, if verify there is not data miss or corrupted, means encrypt previous data successfully so you can remove conf-bak seafile-data-bak.

# Add memcached

Seahub caches items (avatars, profiles, etc) on the file system in /tmp/seahub_cache/ by default. You can replace it with Memcached. You need to install

* memcached
* python memcached modules: pylibmc and django-pylibmc

To install the python modules:

```
sudo pip install pylibmc
sudo pip install django-pylibmc
```

Then add the following lines to **seahub_settings.py**.

```
CACHES = {
    'default': {
        'BACKEND': 'django_pylibmc.memcached.PyLibMCCache',
        'LOCATION': '127.0.0.1:11211',
    }
}
```

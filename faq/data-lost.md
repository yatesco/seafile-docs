# Some component of Seafile can't be started

## Seahub can't be started after power failure

Please try clean the cache directory `seahub_cache`

## Seafevents can't be started

#### Description

Office files online preview can't work. There is no logs in seafevents.log. From `controller.log`, the seafevent process is being started again and again.

#### Answer

Please check the permission of `seafevent.pid` and `seafevent.log`. If seafevent can't write to these files, it will fail to start.

You can also try start seafevents manually following: https://download.seafile.com/f/423d5d6301/


## Seahub can't be started

lease check the permission of `seahub.pid`, `seahub_django_request.log` and `seahub.log`. If Seahub can't write to these files, it will fail to start.

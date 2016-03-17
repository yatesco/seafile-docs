# Web API V2.1
<p><div class="toc">
<li><a href="#share">Share</a><ul>
    <li><a href="#share-link">Share Link</a><ul>
        <li><a href="#list-share-links">List Share Links</a></li>
        <li><a href="#create-share-link">Create Share Link</a></li>
        <li><a href="#delete-share-link">Delete Share Link</a></li>
    </ul>
    </li>
    <li><a href="#upload-link">Upload Link</a><ul>
        <li><a href="#list-upload-links">List Upload Links</a></li>
        <li><a href="#create-upload-link">Create Upload Link</a></li>
        <li><a href="#delete-upload-link">Delete Upload Link</a></li>
    </ul>
    </li>
</ul>
</li>
</p>

## <a id="share"></a>Share

### <a id="share-link"></a>Share Link ###

#### <a id="list-share-links"></a>List Share Links ####

**GET** https://cloud.seafile.com/api/v2.1/share-links/

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api/v2.1/share-links/"

**Sample response**

    [{"username":"lian@lian.com","view_cnt":0,"ctime":"2016-02-26T16:20:36.894","token":"4cbd625c5e","repo_id":"62ca6cf9-dab6-47e5-badc-bab13d9220ce","link":"https://cloud.seafile.com/f/4cbd625c5e/","expire_date":null,"path":"/file.md","is_expired":false},{"username":"lian@lian.com","view_cnt":0,"ctime":"2016-03-04T03:54:58.279","token":"8dc1e04ddd","repo_id":"62ca6cf9-dab6-47e5-badc-bab13d9220ce","link":"https://cloud.seafile.com/d/8dc1e04ddd/","expire_date":null,"path":"/","is_expired":false}]

#### <a id="create-share-link"></a>Create Share Link ####

**POST** https://cloud.seafile.com/api/v2.1/share-links/

**Request parameters**

* repo-id
* path (file/folder path)
* password (not necessary)
* expire_date (not necessary)

**Sample request**

Create download link for file

    curl -d "path=/foo.md&repo_id=62ca6cf9-dab6-47e5-badc-bab13d9220ce" -H 'Authorization: Token ef12bf1e66a1aa797a1d6556fdc9ae84f1e9249f' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api/v2.1/share-links/

Create download link for directory with password and expire date

    curl -d "path=/bar/&repo_id=62ca6cf9-dab6-47e5-badc-bab13d9220ce&password=password&expire_date=6" -H 'Authorization: Token ef12bf1e66a1aa797a1d6556fdc9ae84f1e9249f' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api/v2.1/share-links/

**Sample response**

```
{
    "username": "lian@lian.com",
    "view_cnt": 0,
    "ctime": "2016-03-04T04:06:35.477",
    "token": "409f5aa54a",
    "repo_id": "62ca6cf9-dab6-47e5-badc-bab13d9220ce",
    "link": "https://cloud.seafile.com/f/409f5aa54a/",
    "expire_date": null,
    "path": "/foo.md",
    "is_expired": false
}
```

```
{
    "username": "lian@lian.com",
    "view_cnt": 0,
    "ctime": "2016-03-04T04:12:48.959",
    "token": "db1a50e686",
    "repo_id": "62ca6cf9-dab6-47e5-badc-bab13d9220ce",
    "link": "https://cloud.seafile.com/d/db1a50e686/",
    "expire_date": null,
    "path": "/bar/",
    "is_expired": false
}
```

**Errors**

* 400 path/repo_id invalid
* 403 Permission denied.
* 404 file/folder/library not found.
* 500 Internal Server Error

#### <a id="delete-share-link"></a>Delete Share Link ####

**DELETE** https://cloud.seafile.com/api/v2.1/share-links/{token}/

**Sample request**

    curl -X DELETE -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api/v2.1/share-links/0ae587a7d1/"

**Sample response**

    {"success":true}

### <a id="upload-link"></a>Upload Link ###

#### <a id="list-upload-links"></a>List Upload Links ####

**GET** https://cloud.seafile.com/api/v2.1/upload-links/

**Sample request**

    curl -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api/v2.1/upload-links/"

**Sample response**

    [{"username":"lian@lian.com","repo_id":"62ca6cf9-dab6-47e5-badc-bab13d9220ce","ctime":"2016-03-03T15:26:15.223","token":"9a5d5c8391","link":"https://cloud.seafile.com/u/d/9a5d5c8391/","path":"/"},{"username":"lian@lian.com","repo_id":"78c620ee-2989-4427-8eff-7748f4fbebc0","ctime":"2016-03-04T05:37:17.968","token":"d17d87ea4d","link":"https://cloud.seafile.com/u/d/d17d87ea4d/","path":"/yutong/"}]

#### <a id="create-upload-link"></a>Create Upload Link ####

**POST** https://cloud.seafile.com/api/v2.1/upload-links/

**Request parameters**

* repo-id
* path (file/folder path)
* password (not necessary)

**Sample request**

Create upload link for directory with password

    curl -d "path=/bar/&repo_id=afc3b694-7d4c-4b8a-86a4-89c9f3261b12&password=password" -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' -H 'Accept: application/json; indent=4' https://cloud.seafile.com/api/v2.1/upload-links/

**Sample response**

```
{
    "username": "lian@lian.com",
    "repo_id": "62ca6cf9-dab6-47e5-badc-bab13d9220ce",
    "ctime": "2016-03-04T05:51:34.022",
    "token": "dce40e8594",
    "link": "https://cloud.seafile.com/u/d/dce40e8594/",
    "path": "/bar/"
}
```
**Errors**

* 400 path/repo_id invalid
* 403 Permission denied.
* 500 Internal Server Error

#### <a id="delete-upload-link"></a>Delete Upload Link ####

**DELETE** https://cloud.seafile.com/api/v2.1/upload-links/{token}/

**Sample request**

    curl -X DELETE -H 'Authorization: Token f2210dacd9c6ccb8133606d94ff8e61d99b477fd' "https://cloud.seafile.com/api/v2.1/upload-links/0ae587a7d1/"

**Sample response**

    {"success":true}

# Details about File Search

## <a id="search-opt"></a>Search Options

Following options should be set in file **seafevents.conf**, and need to restart seafile and seahub to take affect.

```
[INDEX FILES]
...
# Seafile does not support search contents of PDF/DOC on Windows system 
index_office_pdf = false

```


## <a id="wiki-faq"></a>Common problems

### <a id="how-to-rebuild-search-index"></a>How to rebuild index if something goes wrong

You can rebuild search index by:

```
./pro/pro.py search --clear
./pro/pro.py search --update
```

If this not work, you can try the following steps:

1. Stop Seafile
2. Remove old search index `rm -rf pro-data/search`
3. Restart Seafile
4. Wait one minute then run `./pro/pro.py search --update`

### <a id="wiki-search-office-pdf"></a>I can't search Office/PDF files


Seafile does not support search contents of PDF/DOC on Windows system 


### <a id="wiki-search-no-result"></a>I get no result when I search a keyword

The search index is updated every 10 minutes by default. So before the first index update is performed, you get nothing no matter what you search.

  To be able to search immediately,

  - Make sure you have started seafile server
  - Update the search index manually:
```
      cd haiwen/seafile-pro-server-2.0.4
     ./pro/pro.py search --update
```

### <a id="wiki-cannot-search-encrypted-files"></a>Encrypted files cannot be searched

This is because the server can't index encrypted files, since, they are encrypted.






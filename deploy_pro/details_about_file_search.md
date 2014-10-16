# Details about File Search
## <a id="search-opt"></a>Search Options

Following options should be set in file **seafevents.conf**, and need to restart seafile and seahub to take affect.

```
[INDEX FILES]
...
# Seafile does not support search contents of PDF/DOC on Windows system 
index_office_pdf = false

# Set search language.
lang = german
```


## <a id="wiki-faq"></a>Common problems


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

### <a id="wiki-set-search-lang"></a>Handle your language more gracefully

**Note**: Added in seafile pro server 3.0.3.

Say your files are mainly in German, you can specify it in `seafevents.conf`:

```
[INDEX FILES]
...
lang = german
```

This way, the text of your files can be handled more gracefully when you search them.

*Anytime you change the value of `lang`, you have to delete the search index and recreate it:*

```
./pro/pro.py search --clear
./pro/pro.py search --update
```

Supported languages include: `arabic`, `armenian`, `basque`, `brazilian`, `bulgarian`, `catalan`, `chinese`, `cjk`, `czech`, `danish`, `dutch`, `english`, `finnish`, `french`, `galician`, `german`, `greek`, `hindi`, `hungarian`, `indonesian`, `italian`, `norwegian`, `persian`, `portuguese`, `romanian`, `russian`, `spanish`, `swedish`, `turkish`, `thai`





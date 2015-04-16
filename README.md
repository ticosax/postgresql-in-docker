postgresql-in-docker
====================

Dockerfile to deliver postgres9.4

Image available as [trusted build](https://index.docker.io/u/ticosax/postgresql-in-docker/)
or in quay.io https://quay.io/repository/ticosax/postgresql-in-docker

Set `$PG_PASSWORD` with hashed password for `postgres` user.

```python
>>> import hashlib
>>> 'md5' + hashlib.md5('SuperSecret' + 'postgres').hexdigest()
'md518b44022038e72b9ca9c56530ac5c8d9'
```

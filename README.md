ArchivesSpace Dashboard
=======================

This is a demo application to provide an example of using the archivesspace-client gem in a web application context.

Currently it:

- displays the ArchivesSpace version
- shows a table of defined permissions
- shows permissions by defined roles

Usage
-----

Prepare the configuration file:

```
cp config.ini.example config.ini
```

Enter values as appropriate for:

- host: full url to archivesspace
- port: port to backend, it must be reachable
- user: account for login
- pass: password for the above user account
- repo: the code of the repository to get data from

```
bundle install
bundle exec rackup config.ru
# by default go to: http://localhost:9292
```

---


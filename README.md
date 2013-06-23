gdata-backup
============
Make a local copy of Google Docs via the command line.

This program makes it easy to download your Google Docs for backup, e.g. via a cron job.

Installation
============

```
bundle
```

Configuration
=============
This gem uses the imap-backup gem's command line inetrface to configure the GMail
accounts that you want to back up. imap-backup is installed when you run bundle (above).

```shell
$ imap-backup setup
```

See the imap-backup README for fuller instructions.

Usage
=====

```
gdata-backup EMAIL DIRECTORY
```

Alternatives
============

There are various other applications available which download Google Docs:

* You can download a zipped bundle from the Google Docs web interface,
* There are some Open Source,
* There are various commercial products.

Open Source:

* http://gdocs-backup.com/source
* http://gs.fhtino.it/gdocbackup - .net/mono
* http://1st-soft.net/gdd/ - greasemonkey

Commercial:

* http://www.backupgoo.com/en/index.html
* http://www.workflow.ae/Google-Docs-Backup-Utility/
* http://www.gladinet.com/
* http://www.syncdocs.com/


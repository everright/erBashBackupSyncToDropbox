erBashBackupSyncToDropbox
=========================

Author: Everright.Chen
Email:  everright.chen@gmail.com
Web:    http://www.everright.cn

Backup site files and database, and set the number of days to retain, sync to dropbox.

How to configure and use
========================

Default working directory of this manual can be modify. 

    /home/backup/

Please visit [this page to view](http://www.everright.cn/bash-script-to-backup-website-databases-and-files-then-sync-to-dropbox.html) detailed configuration process.

Dropbox
-------

### Create new account

[Click here](http://db.tt/cyQy5qPp) to open the Dropbox registration page, enter a name, password, email to complete the registration.

### Setup Dropbox client

After registration is complete, you will jump to the Dropbox download page to download the the Dropbox client installation program to install.

### Apply developers API

Open the developers page [https://www.dropbox.com/developers](https://www.dropbox.com/developers), Click "My Apps" on the left to enter the apps list, create a new app, then get the App key and the App secret. 

Dropbox Uploader
----------------

[Dropbox Uploader](https://github.com/andreafabrizi/Dropbox-Uploader) is a BASH script which can be used to upload, download, delete or list files from Dropbox, an online file sharing, synchronization and backup service.

### Download

    curl -o dropbox_uploader.tar.gz https://nodeload.github.com/andreafabrizi/Dropbox-Uploader/tar.gz/master
    tar xvzf dropbox_uploader.tar.gz
    mv Dropbox-Uploader-master/dropbox_uploader.sh ./
    rm -rf Dropbox-Uploader-master dropbox_uploader.tar.gz

### Initial configuration

    chmod a+x dropbox_uploader.sh

    ./dropbox_uploader.sh

    # App key:
    # App secret:
    # Access level you have chosen, App folder or Full Dropbox [a/f]:
    > Access token
    Setup completed!

Dropbox Uploader configuration file will be save in "~/.dropbox_uploader"

erBashBackupSyncToDropbox
-------------------------

### Download

    curl -o erBackup.tar.gz https://github.com/everright/erBashBackupSyncToDropbox/archive/master.tar.gz
    tar xvzf erBackup.tar.gz
    mv erBashBackupSyncToDropbox/erBackup.sh ./
    rm -rf erBashBackupSyncToDropbox erBackup.tar.gz

### Configuration

    chmod a+x erBackup.sh

Edit the bash file, and replace these settings

    EMAIL_TO="everright.chen@gmail.com" #Your e-mail address, multiple separated by commas
    DROPBOX_DIR="" #Dropbox storage folder, left blank is /
    DROPBOX_UPLOADER="/test/dropbox/dropbox_uploader.sh" #Dropbox Uploader bash script
    BACKUP_SRC="/test/dropbox/files /test/dropbox/test.sh" #Backup files and folders, multiple separated by a space
    BACKUP_DST="/test/dropbox/backup" #Local storage backup folder
    MYSQL_SERVER="localhost" #MySQL Host
    MYSQL_USER="mysqluser" #MySQL Username
    MYSQL_PASS="userpassword" #MySQL Password
    MYSQL_DUMP="/usr/local/mysql5.5.10/bin/mysqldump" #mysqldump command
    DATABASES="wp_everright wp_everright_cn" #Backup databases, multiple separated by a space
    LIMIT_DAYS=7 #The number of days to retain the backup files

### Crontab

    crontab -e 
    0 0 * * * /bin/bash /home/backup/erBackup.sh&
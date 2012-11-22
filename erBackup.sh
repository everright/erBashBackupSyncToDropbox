#!/usr/bin/env bash

EMAIL_TO="everright.chen@gmail.com" #Your e-mail address, multiple separated by commas
DROPBOX_DIR="" #Dropbox storage folder, left blank is /
DROPBOX_UPLOADER="/test/dropbox/dropbox_uploader.sh" #Dropbox Uploader bash script
BACKUP_SRC="/test/dropbox/files /test/dropbox/dropbox_uploader.sh" #Backup files and folders, multiple separated by a space
BACKUP_DST="/test/dropbox/backup" #Local storage backup folder
MYSQL_SERVER="localhost" #MySQL Host
MYSQL_USER="mysqluser" #MySQL Username
MYSQL_PASS="userpassword"  #MySQL Password
MYSQL_DUMP="/usr/local/mysql5.5.10/bin/mysqldump" #mysqldump command
DATABASES="wp_everright wp_everright_cn" #Backup databases, multiple separated by a space
LIMIT_DAYS=7 #The number of days to retain the backup files
NOW=`date "+%F-%H-%M"`
BACKUP_FILE="backup_$NOW.tar.gz" #Backup file name
DATABASE_FILE="database_$NOW.sql" #Database export file name
LOG_FILE="/tmp/site_backup.log" #Log file

# Current time
function now() {
    date "+%F %T.%N"  
}

# Backup files
function do_backup() {
    echo "[$(now)] Dumping databases..." > $LOG_FILE
    cd $BACKUP_DST
    $MYSQL_DUMP -h$MYSQL_SERVER -u$MYSQL_USER -p$MYSQL_PASS --add-drop-table --databases $DATABASES > $DATABASE_FILE
    echo "[$(now)] Packing files..." >> $LOG_FILE
    tar -czf $BACKUP_FILE $BACKUP_SRC $DATABASE_FILE
    echo "[$(now)] Upload files..." >> $LOG_FILE
    $DROPBOX_UPLOADER upload "$BACKUP_FILE" "$DROPBOX_DIR/$BACKUP_FILE" >> $LOG_FILE
    echo "[$(now)] Cleaning the backups..." >> $LOG_FILE
    rm -rf "$DATABASE_FILE"
}

# Delete local and remote file expired
function do_rsync() {
    files=$(find $BACKUP_DST -maxdepth 1 -mtime +$LIMIT_DAYS -type f)
    for filename in $files
    do
        name=$(basename $filename)
        echo "[$(now)] Delete local file $name" >> $LOG_FILE
        rm -rf "$BACKUP_DST/$name"
        echo "[$(now)] Delete remote file $name on dropbox" >> $LOG_FILE
        $DROPBOX_UPLOADER delete "$DROPBOX_DIR/$name" >> $LOG_FILE
    done
}

# Send the backup log mail
function do_mail() {
    mail -s "Website files and database backup log" $EMAIL_TO < $LOG_FILE
}

# Run backup, rsync, send email
do_backup && do_rsync && do_mail
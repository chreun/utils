#!/bin/sh
db_user="root"
db_passwd="root"
db_name="store_db"
name="$(date +"%m%d%H%M")"
mysqldump -u$db_user -p$db_passwd $db_name > /data/backup/$name.sql

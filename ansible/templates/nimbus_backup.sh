#!/bin/sh
set -e

#pgdump the database
docker exec nimbus_pgnimbus_1 /usr/bin/pg_dump -U postgres > {{ nimbus_data_dir }}/pg_medifor_dump

#get all the folder and files and zip them all with the current date
TIME=`date +%b-%d-%y`                      # This Command will read the date.
FILENAME=backup-nimbus-$TIME.tar.gz        # The filename including the date.
SRCDIR={{ nimbus_data_dir }}/              # Source backup folder.
DESDIR={{ nimbus_backup_data_dir }}        # Destination of backup file.
tar -cpzf $DESDIR/$FILENAME $SRCDIR        # tar it all up and put in backup folder

#cleanup older backups and make sure to keep at least 5
FILECOUNT=$(ls -l {{ nimbus_backup__data_dir }} | wc -l)
echo "File count for {{ medifor_backup_dir }} is $FILECOUNT"
if [ $FILECOUNT -gt 5 ]; then
    find {{ nimbus_backup_data_dir }}  -mindepth 1 -mtime +15 -delete
else
    echo "Not enough files to clear out"
fi
#!/usr/bin/env bash

# Rclone Backups
# Author: Akash Mehta Website: http://akash.windhigh.com

CURRENTDATETIME=$(date +%d-%h-%Y_%H-%M);
LOGFILE='backup-logs.txt'

echo "RCLONE TO SPACES BACKUP STARTED AT $(date +'%d-%m-%Y %H:%M:%S')" >> $LOGFILE

echo "Now performing backup ..."
 
time rclone sync "/" "rclone-remote-name:the-spaces-name-goes-here/backups/${HOSTNAME}/files/$(date +%d-%h-%Y)" \
    --delete-excluded \
    --skip-links \
    --stats 60s \
    --stats-log-level NOTICE \
    --transfers=32 \
    --checkers=128 \
    --retries 1 \  #Default value is 3. This value overrides the default rclone retries.
    # Use include flags to include the directories you want to backup. 
    --include "/root/**" \
    --include "/home/**" \
    --include "/var/www/**" \
#    --no-check-dest \
#    --no-traverse \
#    --dry-run \
#    -v
 
echo "... performing backup done!"

echo "BackupToSpaces finished at $(date +'%d-%m-%Y %H:%M:%S')" >> $LOGFILE

# # If lifecycle policy is not expiring old objects enable below script:
# # This script deletes 5th old backup
# echo "Purge started at $(date +'%d-%m-%Y %H:%M:%S')" >> $LOGFILE
# rclone purge rclone-remote-name:the-spaces-name-goes-here/backups/${HOSTNAME}/files/$(date -d '-5 day' '+%d-%h-%Y')/
# echo "Purge completed at $(date +'%d-%m-%Y %H:%M:%S')" >> $LOGFILE
# echo "##################################################" >> $LOGFILE

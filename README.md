
# Backups to cloud using Rclone utility

## Author: Akash Mehta Website: http://akash.windhigh.com

Rclone utility can be used to setup backups from a linux server to any rclone remote that we configure for example AWS S3, Google Drive, Dropbox, S3 compatible storage such as Digital Ocean Spaces, etc. 

### Installing RClone

Guide to install Rclone
https://rclone.org/install/ 

You can use this command to install Rclone:
curl https://rclone.org/install.sh | sudo bash -s beta


For Linux Server to Digital Ocean Spaces, I followed these two guides to configure the rclone remote “spaces”::

https://rclone.org/s3/#digitalocean-spaces

https://www.digitalocean.com/community/tutorials/how-to-migrate-from-amazon-s3-to-digitalocean-spaces-with-rclone

### Configuring the script as per your requirement.

Configure the backup script (backup.sh) as you need.

### Setup cron

Next step is to setup a cron to run this backup script to backup the data daily, weekly, monthly or as required.

First make the script executable:

`chmod +x backup.sh`

Then open the crontab for the user using:

`crontab -e`

And make the required entry as per requirement

For example:

`24 2 * * * /root/files/cron/backup.sh 2>&1 | /usr/bin/logger -t BackupToSpaces`

This makes the script run and take backup at 2:24AM.

### To check the backup logs

To check the backup logs:

`grep "BackupToSpaces" /var/log/syslog`

`tail backup-logs.txt`

### Configure lifecycle policies to expire objects

We will need lifecycle policies to expire objects after a spscific period of time. This is also called retention policy.

This policy is in .xml format for use in DigitalOcean Spaces:
We will set expiration for 14 days in this policy.

````
<LifecycleConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
  <Rule>
    <ID>Expire old logs</ID>
    <Prefix>logs/</Prefix>
    <Status>Enabled</Status>
    <Expiration>
      <Days>14</Days>
    </Expiration>
  </Rule>
````

This policy is JSON format:

````
{
    "Rules": [
        {
            "Filter": {
                "Prefix": "documents/"
            },
            "Status": "Enabled",
            "Expiration": {
                "Days": 14
            },
            "ID": "ExampleRule"
        }
    ]
        }

````

If the expiration policy is not working then add this code to the script:

````
rclone purge rclone-remote-name:the-spaces-name-goes-here/backups/${HOSTNAME}/files/$(date -d '-5 day' '+%d-%h-%Y')/

````
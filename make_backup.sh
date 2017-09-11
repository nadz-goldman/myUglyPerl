#!/bin/bash

site=domain.com

remoteSite=domain.com

mysqlUser=user
mysqlPass=pass

rsyncPassFile=passFile
rsyncExcludes=excludeFile
rsyncHost=host
rsyncPort=port
rsyncUser=user

now=$(date +"%d-%m-%Y")

logger "BACKUP PROCESS: dumping db"
/usr/bin/touch /var/mysql_db
/bin/chmod 600 /var/mysql_db
/usr/bin/mysqldump --all-databases -u $mysqlUser --password=$mysqlPass --events > /var/mysql_db

logger "TARing dirs and DB for sending tar to NAS"
tar -czf /myTemp/$site-$now.tar.gz /usr/local/etc/ /etc/ /usr/local/www/ /var/log/ /home/ /etc/bind/ /var/mysql_db

logger "BACKUP PROCESS: trying send db dump"
/usr/bin/rsync -rtpEog4WL --exclude-from=$rsyncExcludes  --rsh=ssh --delete-after   /var/mysql_db     $remoteSite:/storage/bak/ng/mysql_db
/bin/rm /var/mysql_db

logger "Trying to send tar to NAS"
/usr/bin/rsync -a --password-file=$rsyncPassFile /myTemp/$site-$now.tar.gz rsync://$rsyncUser@$rsyncHost:$rsyncPort/$site/

logger "BACKUP PROCESS: db dump transfered and removed"
logger "BACKUP PROCESS: starting syncing directories with NVC"

/usr/bin/rsync -rtpEog4WL  --copy-unsafe-links --exclude-from=$rsyncExcludes  --rsh=ssh --delete-after   /path1  $rsyncHost:/storage/$site/path1
/usr/bin/rsync -rtpEog4WL  --copy-unsafe-links --exclude-from=$rsyncExcludes  --rsh=ssh --delete-after   /path2  $rsyncHost:/storage/$site/path2
/usr/bin/rsync -rtpEog4WL  --copy-unsafe-links --exclude-from=$rsyncExcludes  --rsh=ssh --delete-after   /path3  $rsyncHost:/storage/$site/path3
/usr/bin/rsync -rtpEog4WL  --copy-unsafe-links --exclude-from=$rsyncExcludes  --rsh=ssh --delete-after   /path4  $rsyncHost:/storage/$site/path4
/usr/bin/rsync -rtpEog4WL  --copy-unsafe-links --exclude-from=$rsyncExcludes  --rsh=ssh --delete-after   /path5  $rsyncHost:/storage/$site/path5
/usr/bin/rsync -rtpEog4WL  --copy-unsafe-links --exclude-from=$rsyncExcludes  --rsh=ssh --delete-after   /path6  $rsyncHost:/storage/$site/path6

touch /tmp/rsync.done
/usr/bin/rsync -rtpEog4WL --rsh=ssh --delete-after   /tmp/rsync.done      $rsyncHost:/storage/bak/path1

/bin/rm /myTemp/$site-$now.tar.gz

logger "BACKUP PROCESS: all done!"



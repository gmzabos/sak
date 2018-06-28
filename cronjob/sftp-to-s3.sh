#!/usr/bin/bash
#
# gzabos        28.06.2018
#
# Get data from SFTP, sync data to S3 bucket
#
# Prerequisites: aws cli
#

#########################################
# Set Variables
#########################################
export SSHPASS=<your password>'
export SFTPUSER='<your sftp user>'
export SFTPHOST='<your sftp host>'
export TEMPDIR='your temp dir'
export S3BUCKET='s3://<your S3 bucket/path/'

cd $TEMPDIR
########################################
# Get data via sftp into $TEMPDIR
########################################
sshpass -e sftp -oBatchMode=no -b - $SFTPUSER@$SFTPHOST << !
   get *
   bye
!
########################################
# Upload data to S3 Bucket
########################################
/usr/local/bin/aws s3 sync . $S3BUCKET

########################################
# Remove data from $TEMPDIR
########################################
rm -f *


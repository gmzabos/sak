Register-ScheduledJob -Name "System State Backup & Upload to S3" -Trigger @{Frequency = "Weekly"; At = "02:00"; DaysOfWeek = "Sunday"} -ScriptBlock {

###################################
#	Create System State Backup
#	on Windows AD Server
#	onto dummy D:\ or other
#	additional VolumePath
###################################

# Create new Backup policy
$policy = New-WBPolicy

# Create new Backup of the system state
Add-WBSystemstate -Policy $policy

# Backup location
$backupLocation = New-WBBackupTarget -VolumePath D:

# Add WBBackupTarget object for Backup location
Add-WBBackupTarget -Policy $policy -Target $backupLocation

# Start Backup
Start-WBBackup -Policy $policy -Force

###################################
#	Upload backup to S3 bucket
#	(check S3 bucket name)
###################################

# Change to working directory
cd d:

# Create a backup-<timestamp>.zip
7z.exe a -tzip backup-$(get-date -f yyyy-MM-dd).zip D:\WindowsImageBackup\*

# Upload local .zip to S3 bucket
aws s3 cp backup-$(get-date -f yyyy-MM-dd).zip s3://adbackup/ --sse

###################################
#	Clean Up for next run
###################################

# Delete local .zip after upload
rm backup-$(get-date -f yyyy-MM-dd).zip

# Delete \WindowsImageBackup\
rm -r .\WindowsImageBackup\

}


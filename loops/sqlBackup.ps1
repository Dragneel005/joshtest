Install-Module -Name SqlServer -Scope CurrentUser

# Load SQL Server module
Import-Module SqlServer -ErrorAction Stop

# Ask user for SQL Server instance
$serverInstance = Read-Host "Enter SQL Server instance name (e.g. localhost\SQLEXPRESS)"

# Ask user for credentials (username + password prompt)
$credential = Get-Credential -Message "Enter SQL Server admin credentials"

# Create backup directory if not exists
$backupRoot = "C:\SQLBackup"
if (-not (Test-Path $backupRoot)) {
    New-Item -ItemType Directory -Path $backupRoot | Out-Null
    Write-Host "Created backup directory at $backupRoot"
}

# Timestamp for naming
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# === Backup Databases ===
$databases = Get-SqlDatabase -ServerInstance $serverInstance -Credential $credential | Where-Object { $_.Name -ne "tempdb" }

foreach ($db in $databases) {
    $backupFile = "$backupRoot\$($db.Name)_$timestamp.bak"
    Write-Host "Backing up database $($db.Name) to $backupFile"
    Backup-SqlDatabase -ServerInstance $serverInstance -Database $db.Name -BackupFile $backupFile -Initialize -Credential $credential
}

# === Script Logins ===
$loginsFile = "$backupRoot\Logins_$timestamp.sql"
Write-Host "Scripting logins to $loginsFile"
Invoke-Sqlcmd -ServerInstance $serverInstance -Database master -Credential $credential -Query "
IF OBJECT_ID('sp_help_revlogin') IS NULL
    PRINT '⚠️ sp_help_revlogin not installed. Please load Microsoft''s script first.'
ELSE
    EXEC sp_help_revlogin
" | Out-File -FilePath $loginsFile -Encoding UTF8

# === Script SQL Agent Jobs ===
$jobsFile = "$backupRoot\Jobs_$timestamp.sql"
Write-Host "Scripting jobs to $jobsFile"
$sqlJobs = @"
DECLARE @jobId UNIQUEIDENTIFIER
DECLARE job_cursor CURSOR FOR
SELECT job_id FROM msdb.dbo.sysjobs
OPEN job_cursor
FETCH NEXT FROM job_cursor INTO @jobId
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC msdb.dbo.sp_help_job @job_id=@jobId
    EXEC msdb.dbo.sp_help_jobhistory @job_id=@jobId
    EXEC msdb.dbo.sp_help_jobstep @job_id=@jobId
    FETCH NEXT FROM job_cursor INTO @jobId
END
CLOSE job_cursor
DEALLOCATE job_cursor
"@
Invoke-Sqlcmd -ServerInstance $serverInstance -Database msdb -Credential $credential -Query $sqlJobs | Out-File -FilePath $jobsFile -Encoding UTF8

# === Script Linked Servers ===
$linkedFile = "$backupRoot\LinkedServers_$timestamp.sql"
Write-Host "Scripting linked servers to $linkedFile"
Invoke-Sqlcmd -ServerInstance $serverInstance -Database master -Credential $credential -Query "EXEC sp_linkedservers" | Out-File -FilePath $linkedFile -Encoding UTF8

Write-Host "✅ Backup and scripting complete. Files stored in $backupRoot"

# Run on a new VM deployed using Six Degrees SQL Server on Azure VM templates to prepare the Data and Log disks and configure
# the default locations on SQL Server

# Make sure the CD Drive is on Z: so it's out the way
Get-WmiObject -Class Win32_volume -Filter 'DriveType=5' |
  Select-Object -First 1 |
  Set-WmiInstance -Arguments @{DriveLetter='Z:'}

# Find the RAW disks (should be the SQL Data and SQL Log files)
$disks = Get-Disk | Where partitionstyle -eq 'raw' | sort number
$letters = 69..89 | ForEach-Object { [char]$_ }
$count = 0

# Initialise and format the disks
foreach ($disk in $disks) {
    $driveLetter = $letters[$count].ToString()
    $partition = $disk | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -UseMaximumSize -DriveLetter $driveLetter

    Switch ($count) {
        0{ $volumelabel = "SQLData" }
        1{ $volumelabel = "SQLLogs" }
        Default { $volumelabel = ("DataDisk$($count)") }
    }
        
    $partition | Format-Volume -FileSystem NTFS -NewFileSystemLabel $volumelabel  -AllocationUnitSize 65536 -Confirm:$false -Force
    $count++
} 

# Get references to the new volumes
$dataVolume = Get-Volume | Where {$_.FileSystemLabel -eq "SQLData"} 
$logVolume = Get-Volume | Where {$_.FileSystemLabel -eq "SQLLogs"} 

# Create SQLData and SQLLog folders
New-Item -Path ($($dataVolume.DriveLetter) + ':\SQLData') -ItemType Directory
New-Item -Path ($($logVolume.DriveLetter) + ':\SQLLogs') -ItemType Directory

# Find the account that SQL Server is set to run as (likely to be NTSERVICE\MSSQLServer)
$service = Get-WmiObject -Class Win32_Service | Where {$_.Name -eq "MSSQLSERVER"}

# Give the Service Account Full Control from to the SQLData folder on the data drive
$acl = Get-Acl -Path ($($dataVolume.DriveLetter) + ':\SQLData')
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($service.StartName,"FullControl","ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl -Path ($($dataVolume.DriveLetter) + ':\SQLData')

# Give the Service Account Full Control from to the SQLLogs folder on the logs drive
$acl = Get-Acl -Path ($($logVolume.DriveLetter) + ':\SQLLogs')
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($service.StartName,"FullControl","ContainerInherit,ObjectInherit", "None", "Allow")
$acl.SetAccessRule($AccessRule)
$acl | Set-Acl -Path ($($logVolume.DriveLetter) + ':\SQLLogs')


# Create the DefaultLog and DefaultData entry entries.  Doing this inside the SQL Server instance as it seems to redirect the registry entry
# to the correct key based on the instance name, so we don't need to figure that out in PowerShell.
cmd.exe /c "osql.exe -E -d master -Q ""EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultData', REG_SZ, N'$($dataVolume.DriveLetter):\SQLData'"""
cmd.exe /c "osql -E -d master -Q ""EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'DefaultLog', REG_SZ, N'$($logVolume.DriveLetter):\SQLLogs'"""

# Restart SQL Server
Get-Service -Name "MSSQLSERVER" | Restart-Service

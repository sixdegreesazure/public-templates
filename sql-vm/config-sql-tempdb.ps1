# The script that will be configured as a start-up Scheduled Tasks
$startScript = {
    if(!(Test-Path -path 'D:\SQLTemp'))  
    {  
        # Create SQLData and SQLLog folders
        New-Item -Path 'D:\SQLTemp\Data' -ItemType Directory
        New-Item -Path 'D:\SQLTemp\Log' -ItemType Directory
    
        # Find the account that SQL Server is set to run as (likely to be NTSERVICE\MSSQLServer)
        $service = Get-WmiObject -Class Win32_Service | Where {$_.Name -eq 'MSSQLSERVER'}
    
        # Give the Service Account Full Control from to the SQLData folder on the data drive
        $acl = Get-Acl -Path 'D:\SQLTemp'
        $AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($service.StartName,'FullControl','ContainerInherit,ObjectInherit','None','Allow')
        $acl.SetAccessRule($AccessRule)
        $acl | Set-Acl -Path 'D:\SQLTemp'
    }
    # Start Services
    Start-Service MSSQLServer
    Start-Service SQLSERVERAGENT 
    }
    
    $path = "C:\6dginstall"
    If(!(test-path $path))
    {
          New-Item -ItemType Directory -Force -Path $path
    }
    
    $startScript | Out-File -FilePath "C:\6dginstall\prepare-sql-temp-location.ps1"
    
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument ' -file "C:\6dginstall\prepare-sql-temp-location.ps1"'
    
    $trigger =  New-ScheduledTaskTrigger -AtStartup
    
    Register-ScheduledTask `
        -Action $action `
        -Trigger $trigger `
        -TaskName "Check and Fix SQL TempDB Location" `
        -Description "Ensures folders are present for TempDB on VM temporary storage and that SQL Server account has rights." `
        -User "SYSTEM" `
        -RunLevel Highest
    
    # Run the script to make sure we have the SQL Temp
    Invoke-Command -ScriptBlock $startScript
    
    $tempDbFiles = (Invoke-SqlCmd -Query "select * FROM sys.master_files where database_id = (select database_id from sys.databases where name = 'tempdb');")
    
    Foreach ($file in $tempDbFiles) {
    
        $FileName = $file.physical_name.Substring($file.physical_name.LastIndexOf('\') + 1);
    
        if ($file.type -eq 0) {
            $path = "D:\SQLTemp\Data"
        } elseif ($file.type -eq 1) {
            $path = "D:\SQLTemp\Log"
        }        
      
        # this is a data file so it belongs in D:\SQLTemp\Data
            
        $sqlQuery = "ALTER DATABASE tempdb MODIFY FILE (NAME = [$($file.name)], FILENAME = '$($path)\$($FileName)');"
        Invoke-SqlCmd -Query $sqlQuery
    }
    
    # Set the SQL Server services to uo
    sc.exe config MSSQLServer start=delayed-auto 
    sc.exe config SQLSERVERAGENT start=delayed-auto  
    
    # Restart the 
    Stop-Service SQLSERVERAGENT 
    Restart-Service MSSQLServer
    Start-Service SQLSERVERAGENT
    

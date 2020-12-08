param (
    [string]$sqlAdminUser,
    [string]$targetCollation,
    [string]$sqlInstanceName = "MSSQLSERVER"
)

# Make sure the "SQL Server (InstanceName)" Service is running before we carry on.  Check it every 10 seconds 
# until it is started or we have run through the loop 30 times (which would be 5 minutes)

$loopCount = 0
DO
{
    Sleep -s 10
    $serviceStatus = (Get-Service | Where {$_.DisplayName -like "SQL Server ($($sqlInstanceName))*"})
    Write-Output $serviceStatus.Status
    $loopCount++

} While (($serviceStatus.Status -ne "Running") -And $loopCount -lt 30)

# Check the service is started (in case we exited the loop because we looped too many times (i.e. we waited 5 minutes)
if ($serviceStatus.Status -eq "Running") {

    # Now carry on and attempt the collation change
    if ((Invoke-sqlCmd -Query "select count(name) as DbCount from sys.databases WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');").dbCount -ne 0) {
        Write-Error "Server is hosting user databases so collation change will not be attempted"
    } else {

        if ($targetCollation) {

            $currentCollation = (Invoke-sqlCmd -Query "SELECT CONVERT (varchar, SERVERPROPERTY('collation')) AS 'ServerCollation';").ServerCollation

            if ($currentCollation -eq $targetCollation) {
                Write-Output "SQL Server is already using collection $($currentCollation).  Nothing to do..."
            } else {
                Write-Output "SQL Server is using collection $($currentCollation) but the target collection is $($targetCollation)"
                Write-Output "Attempting to change the collation (by invoking setup.exe to rebuild the system databases)"

                if (Test-Path -Path "C:\SQLServerFull") {
    
                    $cmdToRun = "c:\SQLServerFull\setup.exe /QUIET /ACTION=REBUILDDATABASE /INSTANCENAME=$($sqlInstanceName) /SQLSYSADMINACCOUNTS=$($sqlAdminUser) /SQLCOLLATION=$($targetCollation)"
                    Start-Process -FilePath "C:\Windows\System32\cmd.exe" -Wait -ArgumentList "/c $($cmdtoRun) > c:\sqlserverfull\collationChange.log"

                    # Read in the output of the command
                    $result = Get-Content -Path "C:\SQLServerFull\collationChange.log"
     
                    # See if "The following error occured:" is contained in the file and return the error message (which will be on the next line)
                    $isError = [array]::IndexOf($result, 'The following error occurred:')
                    If ($isError -gt -1) {
                        $errorMessage = $result[$isError +1]
                    }
    
                    if ($errorMessage) {
                        throw "Error changing the collation:  $($errorMessage)"
                    } else {
                        Write-Output "Checking collation has been successfully changed"
                        $currentCollation = (Invoke-sqlCmd -Query "SELECT CONVERT (varchar, SERVERPROPERTY('collation')) AS 'ServerCollation';").ServerCollation
                        if ($currentCollation -ne $targetCollation) {
                            throw "Collation was not changed.  Check C:\SQLServerFull\collationChange.log on the target server for more information"
                        } else {
                            Write-Output "The Server Collation is now set to $($targetCollation)"
                        }
                    }
                }
                else {
                        throw "Did not find SQL Server install files at C:\SQLServerFull.  Not an Azure Marketplace SQL VM image?"
                }

            }
        } else {
            Write-Output "No SQL collation provided so no changes made."
        } 
    }   


} else {
    Write-Error "Waited 5 minutes and SQL Server $($sqlinstance) Service was not started"
}


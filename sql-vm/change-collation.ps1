param (
    [string]$sqlAdminUser,
    [string]$targetCollation
)

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

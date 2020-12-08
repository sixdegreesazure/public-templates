# this is destructive - it rebuilds the SQL system databases from scratch so must be the first thing you do
# after deploying a SQL Server instance

Setup /QUIET /ACTION=REBUILDDATABASE /INSTANCENAME=InstanceName
/SQLSYSADMINACCOUNTS=accounts /[ SAPWD= StrongPassword ]
/SQLCOLLATION=CollationName  
@{
    # Version number of this module.
    moduleVersion      = '15.0.0'

    # ID used to uniquely identify this module
    GUID               = '693ee082-ed36-45a7-b490-88b07c86b42f'

    # Author of this module
    Author             = 'DSC Community'

    # Company or vendor of this module
    CompanyName        = 'DSC Community'

    # Copyright statement for this module
    Copyright          = 'Copyright the DSC Community contributors. All rights reserved.'

    # Description of the functionality provided by this module
    Description        = 'Module with DSC resources for deployment and configuration of Microsoft SQL Server.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion  = '5.0'

    # Minimum version of the common language runtime (CLR) required by this module
    CLRVersion         = '4.0'

    # Functions to export from this module
    FunctionsToExport  = @()

    # Cmdlets to export from this module
    CmdletsToExport    = @()

    # Variables to export from this module
    VariablesToExport  = @()

    # Aliases to export from this module
    AliasesToExport    = @()

    DscResourcesToExport = @('SqlAG','SqlAGDatabase','SqlAgentAlert','SqlAgentFailsafe','SqlAgentOperator','SqlAGListener','SqlAGReplica','SqlAlias','SqlAlwaysOnService','SqlDatabase','SqlDatabaseDefaultLocation','SqlDatabaseOwner','SqlDatabaseObjectPermission','SqlDatabasePermission','SqlDatabaseRecoveryModel','SqlDatabaseRole','SqlDatabaseUser','SqlRS','SqlRSSetup','SqlScript','SqlScriptQuery','SqlConfiguration','SqlDatabaseMail','SqlEndpoint','SqlEndpointPermission','SqlServerEndpointState','SqlLogin','SqlMaxDop','SqlMemory','SqlServerNetwork','SqlPermission','SqlProtocol','SqlProtocolTcpIp','SqlReplication','SqlRole','SqlSecureConnection','SqlServiceAccount','SqlSetup','SqlTraceFlag','SqlWaitForAG','SqlWindowsFirewall','DSC_SqlAG','DSC_SqlAGDatabase','DSC_SqlAgentAlert','DSC_SqlAgentFailsafe','DSC_SqlAgentOperator','DSC_SqlAGListener','DSC_SqlAGReplica','DSC_SqlAlias','DSC_SqlAlwaysOnService','DSC_SqlConfiguration','DSC_SqlDatabase','DSC_SqlDatabaseDefaultLocation','DSC_SqlDatabaseMail','DSC_SqlDatabaseObjectPermission','DSC_SqlDatabasePermission','DSC_SqlDatabaseRole','DSC_SqlDatabaseUser','DSC_SqlEndpoint','DSC_SqlEndpointPermission','DSC_SqlLogin','DSC_SqlMaxDop','DSC_SqlMemory','DSC_SqlPermission','DSC_SqlProtocol','DSC_SqlProtocolTcpIp','DSC_SqlReplication','DSC_SqlRole','DSC_SqlRS','DSC_SqlRSSetup','DSC_SqlScript','DSC_SqlScriptQuery','DSC_SqlSecureConnection','DSC_SqlServiceAccount','DSC_SqlSetup','DSC_SqlTraceFlag','DSC_SqlWaitForAG','DSC_SqlWindowsFirewall','MSFT_SqlDatabaseOwner','MSFT_SqlDatabaseRecoveryModel','MSFT_SqlServerEndpointState','MSFT_SqlServerNetwork')

    RequiredAssemblies = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData        = @{

        PSData = @{
            # Set to a prerelease string value if the release should be a prerelease.
            Prerelease   = ''

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/dsccommunity/SqlServerDsc/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/dsccommunity/SqlServerDsc'

            # A URL to an icon representing this module.
            IconUri      = 'https://dsccommunity.org/images/DSC_Logo_300p.png'

            # ReleaseNotes of this module
            ReleaseNotes = '## [15.0.0] - 2020-12-06

### Added

- SqlServerDsc
  - Added new resource SqlTraceFlag to set or changes TraceFlags on SQL Server.
    This resource is based on @Zuldans code but with SqlServerDsc integrated SMO.
    Credits: https://github.com/Zuldan/cSQLServerTraceFlag
  - Added a lot of test scripts to validated the code.
- SqlEndpoint
  - Added support for the Service Broker Endpoint ([issue #498](https://github.com/dsccommunity/SqlServerDsc/issues/498)).
- SqlDatabaseRole
  - Added test to ensure Add-SqlDscDatabaseRoleMember throws the expected error
    ([issue #1620](https://github.com/dsccommunity/SqlServerDsc/issues/1620)).

### Changed

- SqlServerDsc
  - Updated code formatting using latest release of PSScriptAnalyzer.
  - The URLs in the CHANGELOG.md that was pointing to issues is now
    referencing the new repository name and URL.
- SqlServerDsc.Common
  - The helper function `Get-SqlInstanceMajorVersion` no longer have a default
    value for parameter **InstanceName** since the parameter is mandatory
    and it was never used.
- SqlReplication
  - The resource are now using the helper function `Get-SqlInstanceMajorVersion`
    ([issue #1408](https://github.com/dsccommunity/SqlServerDsc/issues/1408)).
- SqlRole
  - Major overhaul of resource.
  - BREAKING CHANGE: Removed decision making from get-TargetResource; this
    prevented a simple solution for issue #550. it now just tels if a role
    exists or not. And what members are in that role. MembersToInclude and
    MembersToExclude now always return $null.
  - Added sanitize function (`Get-CorrectedMemberParameters`) to make it
    so for the sysadmin role SA does not get altered ([issue #550](https://github.com/dsccommunity/SqlServerDsc/issues/550)).
  - Added lots of tests.
- SqlWaitForAG
  - BREAKING CHANGE: Fix for issue ([issue #1569](https://github.com/dsccommunity/SqlServerDsc/issues/1569))
    The resource now waits for the Availability Group to become Available.
  - Two parameters where added to test get and set resource at instance level.
- SqlSetup
  - Minor change to the evaluation of the parameter `BrowserSvcStartupType`,
    if it has an assigned a value or not.

### Fixed

- SqlDatabaseRole
  - Fixed check to see if the role and user existed in the database. The
    previous logic would always indicate the role or user was not found unless
    the role had the same name as the user. Also updated the
    DesiredMembersNotPresent string to be more accurate when an extra user is
    in the role ([issue #1487](https://github.com/dsccommunity/SqlServerDsc/issues/1487)).
- SqlAlwaysOnService
  - Updated Get-TargetResource to return all defined schema properties
    ([issue #150](https://github.com/dsccommunity/SqlServerDsc/issues/1501)).
- SqlSetup
  - Added a note to the documentation that the parameter `BrowserSvcStartupType`
    cannot be used for configurations that utilize the `''InstallFailoverCluster''`
    action ([issue #1627](https://github.com/dsccommunity/SqlServerDsc/issues/1627)).

'

        } # End of PSData hashtable

    } # End of PrivateData hashtable
}





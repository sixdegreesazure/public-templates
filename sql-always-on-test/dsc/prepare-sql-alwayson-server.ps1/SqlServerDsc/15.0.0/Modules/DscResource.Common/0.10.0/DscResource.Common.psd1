@{
    # Script module or binary module file associated with this manifest.
    RootModule        = 'DscResource.Common.psm1'

    # Version number of this module.
    ModuleVersion     = '0.10.0'

    # ID used to uniquely identify this module
    GUID              = '9c9daa5b-5c00-472d-a588-c96e8e498450'

    # Author of this module
    Author            = 'DSC Community'

    # Company or vendor of this module
    CompanyName       = 'DSC Community'

    # Copyright statement for this module
    Copyright         = 'Copyright the DSC Community contributors. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Common functions used in DSC Resources'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '4.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Assert-BoundParameter','Assert-IPAddress','Assert-Module','Compare-DscParameterState','Compare-ResourcePropertyState','ConvertTo-CimInstance','ConvertTo-HashTable','Get-LocalizedData','Get-TemporaryFolder','New-InvalidArgumentException','New-InvalidDataException','New-InvalidOperationException','New-InvalidResultException','New-NotImplementedException','New-ObjectNotFoundException','Remove-CommonParameter','Set-DscMachineRebootRequired','Set-PSModulePath','Test-DscParameterState','Test-IsNanoServer')

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('DSC', 'Localization')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/dsccommunity/DscResource.Common/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/dsccommunity/DscResource.Common'

            # A URL to an icon representing this module.
            IconUri      = 'https://dsccommunity.org/images/DSC_Logo_300p.png'

            # ReleaseNotes of this module
            ReleaseNotes = '## [0.10.0] - 2020-11-18

### Added

- Added cmdlet `Compare-DscParameterState` - Could be used in
  Get-TargetResource function or Get() method in Class based Resources.
  It is based on the code of Test-DscParameterState function to get compliance
  between current and desired state of resources.
  The OutPut of Compare-DscParameterState is a collection psobject.
  The properties of psobject are Property,InDesiredState,ExpectedType,ActualType,
  ExpectedValue and ActualValue. The IncludeInDesiredState parameter must be use to
  add ExeptedValue and ActualValue.
- Added pester test to test the pscredential object with `Compare-DscParameterState`.

### Changed

- Cmdlet Test-DscResourceState is now calling Compare-DscParameterState. Possible breaking change.
- IncludeInDesiredState and IncludeValue parameters of Compare-DscParameterState
  are removed in splatting when Test-DscCompareState is called.

### Fix

- Fix git diff command in QA tests on Linux and MacOS.

'

            Prerelease   = ''
        } # End of PSData hashtable

    } # End of PrivateData hashtable
}





function Set-InfobloxDHCPRangeOptions {
    <#
    .SYNOPSIS
    Sets DHCP range options on an Infoblox server.

    .DESCRIPTION
    This function modifies the DHCP range options on an Infoblox server. It allows setting options and Microsoft-specific options for a given network or reference ID.

    .PARAMETER Type
    Specifies the type of options to set. Valid values are 'Options' and 'MsOptions'.

    .PARAMETER Network
    The network for which to set DHCP options.

    .PARAMETER ReferenceID
    The unique identifier for the DHCP range to be modified.

    .PARAMETER Name
    The name of the DHCP option.

    .PARAMETER Number
    The number of the DHCP option.

    .PARAMETER Value
    The value of the DHCP option.

    .PARAMETER VendorClass
    The vendor class of the DHCP option.

    .PARAMETER UseOption
    Indicates whether to use the option.

    .EXAMPLE
    Set-InfobloxDHCPRangeOptions -Type 'Options' -Network '192.168.1.0/24' -Name 'domain-name-servers' -Number 6 -Value '192.168.0.15' -VendorClass 'DHCP' -UseOption

    .EXAMPLE
    Set-InfobloxDHCPRangeOptions -Type 'MsOptions' -ReferenceID 'DHCPRange-1' -Name 'time-servers' -Number 4 -Value '11' -VendorClass 'DHCP'

    .NOTES
    Ensure you are connected to an Infoblox server using Connect-Infoblox before running this function.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory)]
        [ValidateSet('Options', 'MsOptions')]
        [string] $Type,

        [parameter(ParameterSetName = 'NetworkOption', Mandatory)]
        [string] $Network,

        [parameter(ParameterSetName = 'ReferenceOption', Mandatory)]
        [string] $ReferenceID,

        [parameter(ParameterSetName = 'NetworkOption', Mandatory)]
        [parameter(ParameterSetName = 'ReferenceOption', Mandatory)]
        [string] $Name,

        [parameter(ParameterSetName = 'NetworkOption')]
        [parameter(ParameterSetName = 'ReferenceOption')]
        [alias('Num')][System.Nullable[int]] $Number,

        [parameter(ParameterSetName = 'NetworkOption')]
        [parameter(ParameterSetName = 'ReferenceOption')]
        [string] $Value,


        [parameter(ParameterSetName = 'NetworkOption')]
        [parameter(ParameterSetName = 'ReferenceOption')]
        [string] $VendorClass,


        [parameter(ParameterSetName = 'NetworkOption')]
        [parameter(ParameterSetName = 'ReferenceOption')]
        [switch] $UseOption

    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Set-InfobloxDHCPRangeOptions - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }


    $Object = [ordered] @{
        "name"         = $Name
        "num"          = $Number
        "use_option"   = if ($PSBoundParameters.ContainsKey('UseOption')) { $UseOption.IsPresent } else { $null }
        "value"        = $Value
        "vendor_class" = $VendorClass
    }

    if ($Type -eq 'options') {

    } else {
        if ($UseOption.IsPresent) {
            Write-Warning -Message 'Set-InfobloxDHCPRangeOptions - use_option is not a valid parameter for MSOptions'
            $Object.Remove('use_option')
        }
    }

    Remove-EmptyValue -Hashtable $Object

    if ($Network) {
        $DHCPRange = Get-InfobloxDHCPRange -Network $Network -ReturnFields 'options', 'ms_options'
    } elseif ($ReferenceID) {
        $DHCPRange = Get-InfobloxDHCPRange -ReferenceID $ReferenceID -ReturnFields 'options', 'ms_options'
    } else {
        Write-Warning -Message 'You must specify either a Network or a ReferenceID'
        return
    }
    if (-not $DHCPRange -or $null -eq $DHCPRange._ref) {
        Write-Warning -Message 'Set-InfobloxDHCPRangeOptions - No DHCP Range found'
        return
    }

    $ChangeRequired = $false
    $OptionFound = $false
    [Array] $NewOptions = @(
        if ($Type -eq 'options') {
            $Options = $DHCPRange.options | Select-Object -Property name, num, use_option, value, vendor_class
            foreach ($Option in $Options) {
                if ($Option.name -eq $Name) {
                    $OptionFound = $true
                    foreach ($Key in $Object.Keys) {
                        if ($Object.$Key -ne $Option.$Key) {
                            Write-Verbose -Message "Set-InfobloxDHCPRangeOptions - Preparing overwrite $Name for $Key to $($Object.$Key)"
                            $Option.$Key = $Object.$Key
                            $ChangeRequired = $true
                        } else {
                            Write-Verbose -Message "Set-InfobloxDHCPRangeOptions - No changes required $Name for $Key, as it already exists with the same values"
                        }
                    }
                    if ($ChangeRequired) {
                        $Option
                    }
                } else {
                    $Option
                }
            }
            if (-not $OptionFound) {
                Write-Verbose -Message "Set-InfobloxDHCPRangeOptions - Changes required for $Name. Does not exist yet!"
                $Object
                $ChangeRequired = $true
            }
        } else {
            $MSOptions = $DHCPRange.ms_options | Select-Object -Property name, num, value, vendor_class
            foreach ($MSOption in $MSOptions) {
                if ($MSOption.name -eq $Name) {
                    $OptionFound = $true
                    foreach ($Key in $Object.Keys) {
                        if ($Object.$Key -ne $MSOption.$Key) {
                            Write-Verbose -Message "Set-InfobloxDHCPRangeOptions - Preparing overwrite $Name for $Key to $($Object.$Key)"
                            $MSOption.$Key = $Object.$Key
                            $ChangeRequired = $true
                        } else {
                            Write-Verbose -Message "Set-InfobloxDHCPRangeOptions - No changes required $Name for $Key, as it already exists with the same values"
                        }
                    }
                    if ($ChangeRequired) {
                        $MSOption
                    }
                } else {
                    $MSOption
                }
            }
            if (-not $OptionFound) {
                Write-Verbose -Message "Set-InfobloxDHCPRangeOptions - Changes required for $Name. Does not exist yet!"
                $Object
                $ChangeRequired = $true
            }
        }
    )
    if ($ChangeRequired) {
        if ($Type -eq 'options') {
            Set-InfobloxDHCPRange -ReferenceID $DHCPRange._ref -Options $NewOptions
        } else {
            Set-InfobloxDHCPRange -ReferenceID $DHCPRange._ref -MSOptions $NewOptions
        }
    } else {
        Write-Warning -Message 'Set-InfobloxDHCPRangeOptions - No changes required'
    }
}
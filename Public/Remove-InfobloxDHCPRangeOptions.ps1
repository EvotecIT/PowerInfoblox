function Remove-InfobloxDHCPRangeOptions {
    <#
    .SYNOPSIS
    Removes DHCP range options from an Infoblox server.

    .DESCRIPTION
    This function removes specified DHCP range options from an Infoblox server. It allows removing options and Microsoft-specific options for a given network or reference ID.

    .PARAMETER Type
    Specifies the type of options to remove. Valid values are 'Options' and 'MsOptions'.

    .PARAMETER Network
    The network for which to remove DHCP options.

    .PARAMETER ReferenceID
    The unique identifier for the DHCP range to be modified.

    .PARAMETER Name
    The name of the DHCP option to be removed.

    .EXAMPLE
    Remove-InfobloxDHCPRangeOptions -Type 'Options' -Network '192.168.1.0/24' -Name 'domain-name-servers'

    .EXAMPLE
    Remove-InfobloxDHCPRangeOptions -Type 'MsOptions' -ReferenceID 'DHCPRange-1' -Name 'time-servers'

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
        [string] $Name
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Remove-InfobloxDHCPRangeOptions - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($Network) {
        $DHCPRange = Get-InfobloxDHCPRange -Network $Network -ReturnFields 'options', 'ms_options'
    } elseif ($ReferenceID) {
        $DHCPRange = Get-InfobloxDHCPRange -ReferenceID $ReferenceID -ReturnFields 'options', 'ms_options'
    } else {
        Write-Warning -Message 'You must specify either a Network or a ReferenceID'
        return
    }
    if (-not $DHCPRange -or $null -eq $DHCPRange._ref) {
        Write-Warning -Message 'Remove-InfobloxDHCPRangeOptions - No DHCP Range found'
        return
    }

    $OptionFound = $false
    [Array] $NewOptions = @(
        if ($Type -eq 'options') {
            $Options = $DHCPRange.options | Select-Object -Property name, num, use_option, value, vendor_class
            foreach ($Option in $Options) {
                if ($Option.name -eq $Name) {
                    Write-Verbose -Message "Remove-InfobloxDHCPRangeOptions - Changes required for $Name. Removal required!"
                    $OptionFound = $true
                } else {
                    $Option
                }
            }
        } else {
            $MSOptions = $DHCPRange.ms_options | Select-Object -Property name, num, value, vendor_class
            foreach ($MSOption in $MSOptions) {
                if ($MSOption.name -eq $Name) {
                    Write-Verbose -Message "Remove-InfobloxDHCPRangeOptions - Changes required for $Name. Removal required!"
                    $OptionFound = $true
                } else {
                    $MSOption
                }
            }
        }
    )
    if (-not $OptionFound) {
        Write-Verbose -Message "Remove-InfobloxDHCPRangeOptions - Change not required. Option $Name not found"
    } else {
        if ($Type -eq 'options') {
            Set-InfobloxDHCPRange -ReferenceID $DHCPRange._ref -Options $NewOptions
        } else {
            Set-InfobloxDHCPRange -ReferenceID $DHCPRange._ref -MSOptions $NewOptions
        }
    }
}
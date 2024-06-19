function New-InfobloxOption {
    <#
    .SYNOPSIS
    Creates a dummy Infoblox option to use within other cmdlets

    .DESCRIPTION
    This function creates a new Infoblox option. It's just syntactic sugar to make it easier to create options to use within other cmdlets.

    .PARAMETER Name
    The name of the Infoblox option. This parameter is mandatory.

    .PARAMETER Number
    The number of the Infoblox option. This parameter is mandatory.

    .PARAMETER UseOption
    A switch indicating whether to use the option. This parameter is mandatory.

    .PARAMETER Value
    The value of the Infoblox option. This parameter is mandatory.

    .PARAMETER VendorClass
    The vendor class of the Infoblox option. This parameter is mandatory.

    .EXAMPLE
    $addInfobloxDHCPRangeSplat = @{
        StartAddress = '10.10.12.5'
        EndAddress   = '10.10.12.10'
        Options      = @(
            New-InfobloxOption -Name "dhcp-lease-time" -Number 51 -UseOption -Value '86400' -VendorClass 'DHCP'
            New-InfobloxOption -Name "domain-name-servers" -Number 6 -UseOption -Value '192.168.0.15' -VendorClass 'DHCP'
            New-InfobloxOption -Name 'routers' -Number 3 -UseOption -Value '192.168.11.12' -VendorClass 'DHCP'
            New-InfobloxOption -Name 'time-servers' -Number 4 -UseOption -Value '11' -VendorClass 'DHCP'
        )
        Verbose      = $true
    }

    Add-InfobloxDHCPRange @addInfobloxDHCPRangeSplat

    .NOTES
    This function is used to create a dummy Infoblox option to use within other cmdlets.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Name,
        [Parameter(Mandatory)][alias('Num')][int] $Number,
        [string] $Type,
        [string] $UserClass,
        [Parameter()][switch] $UseOption,
        [Parameter(Mandatory)][string] $Value,
        [Parameter(Mandatory)][string] $VendorClass
    )

    $Object = [ordered] @{
        "name"         = $Name
        "num"          = $Number
        "type"         = $Type
        "user_class"   = $UserClass
        "use_option"   = if ($PSBoundParameters.ContainsKey('UseOption')) { $UseOption.IsPresent } else { $null }
        "value"        = $Value
        "vendor_class" = $VendorClass
    }
    Remove-EmptyValue -Hashtable $Object
    $Object
}
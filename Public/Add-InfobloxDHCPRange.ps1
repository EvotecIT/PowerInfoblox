function Add-InfobloxDHCPRange {
    <#
    .SYNOPSIS
    Adds a DHCP range to Infoblox.

    .DESCRIPTION
    This function adds a DHCP range to Infoblox. It requires an established connection to an Infoblox server, which can be done using the Connect-Infoblox function.

    .PARAMETER StartAddress
    The starting IP address of the DHCP range. This parameter is mandatory.

    .PARAMETER EndAddress
    The ending IP address of the DHCP range. This parameter is mandatory.

    .PARAMETER Name
    The name of the DHCP range.

    .PARAMETER Comment
    A comment for the DHCP range.

    .PARAMETER NetworkView
    The network view in which the DHCP range will be added. The default is 'default'.

    .PARAMETER MSServer
    The Microsoft server to which the DHCP range will be added.

    .PARAMETER ReturnOutput
    If this switch is present, the function will return the output of the operation.

    .PARAMETER ExtensibleAttribute
    An extensible attribute to be added to the DHCP range.

    .PARAMETER FailoverAssociation
    The failover association for the DHCP range.

    .PARAMETER Options
    An array of options to be added to the DHCP range.

    .PARAMETER MSOptions
    An array of Microsoft options to be added to the DHCP range.

    .PARAMETER ServerAssociationType
    The server association type for the DHCP range. The possible values are 'MEMBER', 'MS_FAILOVER', 'NONE', 'MS_SERVER', 'FAILOVER'.

    .PARAMETER Exclude
    An array of IP addresses or IP address ranges to be excluded from the DHCP range.

    .PARAMETER AlwaysUpdateDns
    If this switch is present, DNS will always be updated for the DHCP range.

    .PARAMETER Disable
    If this switch is present, the DHCP range will be disabled.

    .EXAMPLE
    Add-InfobloxDHCPRange -StartAddress '192.168.1.100' -EndAddress '192.168.1.200' -Name 'DHCP Range 1' -Comment 'This is a DHCP range.'
    Adds a DHCP range from 192.168.1.100 to 192.168.1.200 with the name 'DHCP Range 1' and a comment 'This is a DHCP range.'.

    .EXAMPLE
    Add-InfobloxDHCPRange -StartAddress '10.22.41.15' -EndAddress '10.22.41.30'
    Adds a reserved range from 10.22.41.15 to 10.22.41.30

    .EXAMPLE
    $addInfobloxDHCPRangeSplat = @{
        StartAddress = '10.22.41.51'
        EndAddress = '10.22.41.60'
        Verbose = $true
        MSServer = 'dhcp2016.evotec.pl'
        Name = 'DHCP Range Me?'
        ServerAssociationType = 'MS_SERVER'
    }

    Add-InfobloxDHCPRange @addInfobloxDHCPRangeSplat

    .EXAMPLE
    $addInfobloxDHCPRangeSplat = @{
        StartAddress          = '10.22.41.70'
        EndAddress            = '10.22.41.90'
        Verbose               = $true
        MSServer              = 'dhcp2019.evotec.pl'
        Name                  = 'DHCP Range Me2?'
        ServerAssociationType = 'MS_SERVER'
        Exclude               = '10.22.41.75-10.22.41.79'
    }

    Add-InfobloxDHCPRange @addInfobloxDHCPRangeSplat

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
    You must first connect to an Infoblox server using Connect-Infoblox before running this function.
    Please note that when using MSServer parameter you need to provide a valid server name that is already added to Infoblox,
    and it also needs to be part of Members in Add-InfobloxNetwork.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $StartAddress,
        [Parameter(Mandatory)][string] $EndAddress,
        [string] $Name,
        [string] $Comment,
        [string] $NetworkView = 'default',
        [string] $MSServer,
        [switch] $ReturnOutput,
        [System.Collections.IDictionary] $ExtensinbleAttribute,
        [Array] $Options,
        [Alias('ms_options')][Array] $MSOptions,
        [alias('failover_association')][string] $FailoverAssociation,
        [ValidateSet('MEMBER', 'MS_FAILOVER', 'NONE', 'MS_SERVER', 'FAILOVER')] [string] $ServerAssociationType,
        [Array] $Exclude,
        [switch] $AlwaysUpdateDns,
        [switch] $Disable
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Add-InfobloxDHCPRange - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $Body = [ordered] @{
        "start_addr"   = $StartAddress
        "end_addr"     = $EndAddress
        "comment"      = $Comment
        "network_view" = $NetworkView
    }
    if ($Name) {
        $Body["name"] = $Name
    }
    if ($ServerAssociationType) {
        $Body["server_association_type"] = $ServerAssociationType
    }
    if ($MSServer) {
        $Body["ms_server"] = [PSCustomObject] @{
            "_struct"  = "msdhcpserver"
            "ipv4addr" = $MSServer
        }
    }
    if ($ExtensinbleAttribute) {
        $Body["extattrs"] = [ordered] @{}
        foreach ($Key in $ExtensinbleAttribute.Keys) {
            if ($ExtensinbleAttribute[$Key] -is [System.Collections.IDictionary]) {
                $Body["extattrs"][$Key] = $ExtensinbleAttribute[$Key]
            } else {
                $Body["extattrs"][$Key] = @{
                    value = $ExtensinbleAttribute[$Key]
                }
            }
        }
    }
    if ($Options) {
        $Body["options"] = @(
            foreach ($Option in $Options) {
                $Option
            }
        )
    }

    if ($MSOptions) {
        $Body["ms_options"] = @(
            foreach ($MSOption in $MSOptions) {
                $MSOption
            }
        )
    }

    if ($FailoverAssociation) {
        $Body["failover_association"] = $FailoverAssociation
    }
    if ($Exclude) {
        $Body["exclude"] = @(
            foreach ($ExcludeItem in $Exclude) {
                if ($ExcludeItem -is [string]) {
                    if ($ExcludeItem -like "*-*") {
                        $ExcludeItem = $ExcludeItem -split '-'
                        $ExcludeItem = @{
                            StartAddress = $ExcludeItem[0]
                            EndAddress   = $ExcludeItem[1]
                        }
                    } else {
                        $ExcludeItem = @{
                            StartAddress = $ExcludeItem
                            EndAddress   = $ExcludeItem
                        }
                    }
                }
                [ordered] @{
                    "start_address" = $ExcludeItem.StartAddress
                    "end_address"   = $ExcludeItem.EndAddress
                }
            }
        )
    }

    if ($PSBoundParameters.ContainsKey('AlwaysUpdateDns')) {
        $Body["always_update_dns"] = $AlwaysUpdateDns.IsPresent
    }
    if ($PSBoundParameters.ContainsKey('Disable')) {
        $Body["disable"] = $Disable.IsPresent
    }

    Remove-EmptyValue -Hashtable $Body

    $invokeInfobloxQuerySplat = @{
        RelativeUri = "range"
        Method      = 'POST'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Add-InfobloxDHCPRange - $Output"
        if ($ReturnOutput) {
            $Output
        }
    }
}
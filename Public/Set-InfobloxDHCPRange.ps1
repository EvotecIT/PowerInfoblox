function Set-InfobloxDHCPRange {
    <#
    .SYNOPSIS
    Sets the DHCP range configuration on an Infoblox server.

    .DESCRIPTION
    This function modifies the DHCP range configuration on an Infoblox server. It allows setting comments, Microsoft options, and other DHCP options.

    .PARAMETER ReferenceID
    The unique identifier for the DHCP range to be modified.

    .PARAMETER Comment
    A comment to associate with the DHCP range.

    .PARAMETER MSServer
    The Microsoft DHCP server associated with the range.

    .PARAMETER ExtensinbleAttribute
    A hashtable of extensible attributes to associate with the DHCP range.

    .PARAMETER Options
    An array of general DHCP options.

    .PARAMETER MSOptions
    An array of Microsoft-specific DHCP options.

    .PARAMETER FailoverAssociation
    The failover association for the DHCP range.

    .PARAMETER ServerAssociationType
    The type of server association. Valid values are 'MEMBER', 'MS_FAILOVER', 'NONE', 'MS_SERVER', 'FAILOVER'.

    .PARAMETER Exclude
    An array of IP addresses or address ranges to exclude from the DHCP range.

    .PARAMETER AlwaysUpdateDns
    Indicates whether to always update DNS.

    .PARAMETER Disable
    Indicates whether to disable the DHCP range.

    .EXAMPLE
    Set-InfobloxDHCPRange -ReferenceID 'DHCPRange-1' -Comment 'This is a DHCP range.'

    .EXAMPLE
    Set-InfobloxDHCPRange -ReferenceID 'DHCPRange-1' -Options @(
        New-InfobloxOption -Name "dhcp-lease-time" -Number 51 -UseOption -Value '86400' -VendorClass 'DHCP'
        New-InfobloxOption -Name "domain-name-servers" -Number 6 -UseOption -Value '192.168.0.15' -VendorClass 'DHCP'
        New-InfobloxOption -Name 'routers' -Number 3 -UseOption -Value '192.168.11.12' -VendorClass 'DHCP'
        New-InfobloxOption -Name 'time-servers' -Number 4 -UseOption -Value '11' -VendorClass 'DHCP'
    )

    .NOTES
    Ensure you are connected to an Infoblox server using Connect-Infoblox before running this function.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(ParameterSetName = 'ReferenceID', Mandatory)][string] $ReferenceID,
        [string] $Comment,
        [string] $MSServer,
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
        Write-Warning -Message 'Set-InfobloxDHCPRange - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $Body = [ordered] @{}
    if ($Comment) {
        $Body["comment"] = $Comment
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
                $Option | Select-Object -Property name, num, use_option, value, vendor_class
            }
        )
    }
    if ($MSOptions) {
        $Body["ms_options"] = @(
            foreach ($MSOption in $MSOptions) {
                $MSOption | Select-Object -Property name, num, value, vendor_class
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

    if ($Body.Count -eq 0) {
        Write-Warning -Message 'Set-InfobloxDHCPRange - No changes requested'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri = $ReferenceID
        Method      = 'PUT'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Output) {
        Write-Verbose -Message "Set-InfobloxDHCPRange - Modified $Output"
    }
}
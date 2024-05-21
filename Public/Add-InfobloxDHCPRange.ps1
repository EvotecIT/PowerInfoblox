function Add-InfobloxDHCPRange {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $StartAddress,
        [Parameter(Mandatory)][string] $EndAddress,
        [string] $Name,
        [string] $Comment,
        [string] $NetworkView = 'default',
        [string[]] $Members,
        [string[]] $MSServers,
        [switch] $ReturnOutput,
        [System.Collections.IDictionary] $ExtensinbleAttribute,
        [string] $FailoverAssociation,
        [ValidateSet('MEMBER', 'MS_FAILOVER','NONE','MS_SERVER','FAILOVER')] [string] $ServerAssociationType,
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
    if ($Members) {
        $Body["members"] = @(
            foreach ($DHCPMember in $Members) {
                [ordered] @{
                    "_struct"  = "msdhcpserver"
                    "ipv4addr" = $DHCPMember
                }
            }
        )
        #"_struct": "dhcpmember",
        #"name": "ddi.example.com"
    }
    if ($MSServers) {
        $Body["ms_servers"] = @(
            foreach ($DHCPMember in $MSServers) {
                [ordered] @{
                    "_struct"  = "msdhcpserver"
                    "ipv4addr" = $DHCPMember
                }
            }
        )
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
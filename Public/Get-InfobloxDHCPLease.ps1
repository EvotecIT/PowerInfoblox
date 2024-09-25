function Get-InfobloxDHCPLease {
    [alias('Get-InfobloxDHCPLeases')]
    [CmdletBinding()]
    param(
        [string] $Network,
        [string] $IPv4Address,
        [string] $Hostname,
        [switch] $PartialMatch,
        [switch] $FetchFromSchema,
        [int] $MaxResults = 1000000
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDHCPLease - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Get-InfobloxDHCPLease - Requesting DHCP leases for Network [$Network] / IPv4Address [$IPv4Address] / Hostname [$Hostname] / PartialMatch [$($PartialMatch.IsPresent)]"

    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "lease"
    } elseif ($ReturnFields) {
        $ReturnFields = ($ReturnFields | Sort-Object -Unique) -join ','
    } else {
        $ReturnFields = 'binding_state,hardware,client_hostname,fingerprint,address,network_view'
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'lease'
        Method         = 'GET'
        QueryParameter = @{
            _return_fields = $ReturnFields
            _max_results   = $MaxResults
        }
    }
    if ($Network) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."network~" = $Network.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.network = $Network.ToLower()
        }
    }
    if ($IPv4Address) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."ipv4addr~" = $IPv4Address.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.ipv4addr = $IPv4Address.ToLower()
        }
    }
    if ($Hostname) {
        if ($PartialMatch) {
            $invokeInfobloxQuerySplat.QueryParameter."name~" = $Hostname.ToLower()
        } else {
            $invokeInfobloxQuerySplat.QueryParameter.name = $Hostname.ToLower()
        }
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
}
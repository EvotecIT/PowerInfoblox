function Get-InfobloxDHCPLease {
    <#
    .SYNOPSIS
    Retrieves DHCP leases from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI lease objects. Results can be filtered by network,
    IPv4 address, or host name. Specify PartialMatch to use WAPI regular-expression
    matching for every supplied filter.

    .PARAMETER Network
    Filters leases by network in CIDR notation, such as 192.0.2.0/24.

    .PARAMETER IPv4Address
    Filters leases by IPv4 address.

    .PARAMETER Hostname
    Filters leases by client host name.

    .PARAMETER PartialMatch
    Uses partial matching instead of exact matching for the supplied filters.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the lease object by the connected WAPI schema.

    .PARAMETER ReturnFields
    Specifies the lease fields to return. Duplicate field names are removed.

    .PARAMETER MaxResults
    Specifies the maximum number of leases returned. The default is 1000000.

    .EXAMPLE
    Get-InfobloxDHCPLease -Network '192.0.2.0/24'

    Returns leases for the specified network.

    .EXAMPLE
    Get-InfobloxDHCPLease -Hostname 'client-01' -PartialMatch -ReturnFields address,client_hostname,binding_state

    Returns leases whose host name partially matches client-01 and limits the returned fields.
    #>
    [alias('Get-InfobloxDHCPLeases')]
    [CmdletBinding()]
    param(
        [string] $Network,
        [string] $IPv4Address,
        [string] $Hostname,
        [switch] $PartialMatch,
        [switch] $FetchFromSchema,
        [string[]] $ReturnFields,
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
        $ReturnFields = Get-FieldsFromSchema -SchemaObject 'lease' -RequestedFields ('binding_state,hardware,client_hostname,fingerprint,address,network_view' -split ',')
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

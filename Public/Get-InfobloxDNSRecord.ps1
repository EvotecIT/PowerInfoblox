function Get-InfobloxDNSRecord {
    <#
    .SYNOPSIS
    Gets Infoblox DNS records of one WAPI record type.

    .DESCRIPTION
    Queries a record:<type> WAPI endpoint. Common record types use schema-filtered preferred fields.
    Other current or future record types can be queried by name without waiting for a new ValidateSet.

    .PARAMETER Name
    The DNS record name to match.

    .PARAMETER ReferenceID
    The exact DNS record WAPI object reference to retrieve. The record type is inferred from it.

    .PARAMETER Zone
    The DNS zone to match.

    .PARAMETER View
    The DNS view to match.

    .PARAMETER PartialMatch
    Uses WAPI regular-expression matching for Name, Zone, and View.

    .PARAMETER Type
    The WAPI DNS record type. Host is the default. The legacy LBDN name is normalized to DTCLBDN.

    .PARAMETER FetchFromSchema
    Requests every field reported as readable by the connected Grid schema.

    .PARAMETER ReturnFields
    Requests the specified fields without changing the caller's explicit selection.

    .PARAMETER MaxResults
    The maximum result count requested from WAPI.

    .EXAMPLE
    Get-InfobloxDNSRecord -Type A -Name 'host.example.com'

    .EXAMPLE
    Get-InfobloxDNSRecord -Type MX -Zone 'example.com' -ReturnFields name,mail_exchanger,preference

    .EXAMPLE
    Get-InfobloxDNSRecord -ReferenceID 'record:a/example-reference:host.example.com/default'
    #>
    [Alias('Get-InfobloxDNSRecords')]
    [CmdletBinding(DefaultParameterSetName = 'ByFilter')]
    param(
        [Parameter(ParameterSetName = 'ByFilter')]
        [string] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $ReferenceID,

        [Parameter(ParameterSetName = 'ByFilter')]
        [string] $Zone,

        [Parameter(ParameterSetName = 'ByFilter')]
        [string] $View,

        [Parameter(ParameterSetName = 'ByFilter')]
        [switch] $PartialMatch,

        [Parameter(ParameterSetName = 'ByFilter')]
        [ValidateNotNullOrEmpty()]
        [string] $Type = 'Host',

        [switch] $FetchFromSchema,
        [string[]] $ReturnFields,

        [Parameter(ParameterSetName = 'ByFilter')]
        [ValidateRange(1, 2147483647)]
        [int] $MaxResults = 1000000
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDNSRecord - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
        if ($ReferenceID -notmatch '^record:(?<RecordType>[^/]+)/') {
            throw "Get-InfobloxDNSRecord - ReferenceID '$ReferenceID' is not a DNS record WAPI object reference."
        }
        $NormalizedType = Resolve-InfobloxDNSRecordType -Type $Matches.RecordType
        $RelativeUri = $ReferenceID
    } else {
        $NormalizedType = Resolve-InfobloxDNSRecordType -Type $Type
        $RelativeUri = "record:$NormalizedType"
    }
    if ($FetchFromSchema) {
        $ResolvedReturnFields = Get-FieldsFromSchema -SchemaObject "record:$NormalizedType"
    } elseif ($ReturnFields) {
        $ResolvedReturnFields = ($ReturnFields | Sort-Object -Unique) -join ','
    } else {
        $PreferredFields = Get-InfobloxDNSRecordPreferredField -Type $NormalizedType
        if ($PreferredFields) {
            $ResolvedReturnFields = Get-FieldsFromSchema -SchemaObject "record:$NormalizedType" -RequestedFields $PreferredFields
        }
    }

    $QueryParameter = @{}
    if ($PSCmdlet.ParameterSetName -eq 'ByFilter') {
        $QueryParameter._max_results = $MaxResults
    }
    if ($ResolvedReturnFields) {
        $QueryParameter._return_fields = $ResolvedReturnFields
    }
    if ($PSCmdlet.ParameterSetName -eq 'ByFilter') {
        foreach ($Filter in @(
                @{ Name = 'zone'; Value = $Zone },
                @{ Name = 'view'; Value = $View },
                @{ Name = 'name'; Value = $Name }
            )) {
            if (-not $Filter.Value) {
                continue
            }
            $FilterName = if ($PartialMatch) { "$($Filter.Name)~" } else { $Filter.Name }
            $QueryParameter[$FilterName] = $Filter.Value.ToLowerInvariant()
        }
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = $RelativeUri
        Method         = 'GET'
        QueryParameter = $QueryParameter
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false

    $FirstProperties = switch ($NormalizedType) {
        'a' { 'name', 'ipv4addr', 'view', 'zone' }
        'aaaa' { 'name', 'ipv6addr', 'view', 'zone' }
        'cname' { 'name', 'canonical', 'view', 'zone' }
        'host' { 'name', 'ipv4addrs', 'ipv6addrs', 'view', 'zone' }
        'mx' { 'name', 'mail_exchanger', 'preference', 'view', 'zone' }
        'ns' { 'name', 'nameserver', 'addresses', 'view', 'zone' }
        'ptr' { 'name', 'ptrdname', 'ipv4addr', 'ipv6addr', 'view', 'zone' }
        'txt' { 'name', 'text', 'view', 'zone' }
    }
    $Output | Select-ObjectByProperty -FirstProperty $FirstProperties -LastProperty '_ref'
}

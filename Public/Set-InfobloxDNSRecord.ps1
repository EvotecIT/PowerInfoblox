function Set-InfobloxDNSRecord {
    <#
    .SYNOPSIS
    Updates the value of an existing Infoblox DNS record.

    .DESCRIPTION
    Updates an existing DNS record by using its Infoblox WAPI object reference. Value maps to the
    primary data field for A, AAAA, CNAME, HOST, MX, NS, PTR, and TXT records. Properties supports
    structured HOST changes and other record types or multi-field updates without guessing at nested WAPI fields.
    Type is optional and, when supplied, must match the type encoded in ReferenceID.

    .PARAMETER ReferenceID
    The WAPI object reference of the DNS record to update, for example record:cname/... or record:a/....

    .PARAMETER Value
    The new record value. The WAPI field depends on the record type: ipv4addr for A, ipv6addr for AAAA,
    canonical for CNAME, name for HOST, ptrdname for PTR, mail_exchanger for MX, nameserver for NS,
    and text for TXT.

    .PARAMETER Properties
    A field dictionary for HOST records, complex record types, or updates that affect multiple fields.

    .PARAMETER Preference
    An optional MX preference from 0 through 65535, updated together with Value.

    .PARAMETER Address
    Optional NS glue addresses, updated together with Value. Supply an empty array
    to clear existing glue addresses.

    .PARAMETER Type
    The optional expected record type. When supplied, it must match the type encoded in ReferenceID.

    .EXAMPLE
    Set-InfobloxDNSRecord -ReferenceID 'record:cname/ZG5zLmJpbmRfY25h:test01.example.com/default' -Value 'target.example.com'

    Updates the canonical target of a CNAME record.

    .EXAMPLE
    Set-InfobloxDNSRecord -ReferenceID 'record:a/ZG5zLmhvc3Q:192.0.2.10/test01.example.com/default' -Type A -Value '192.0.2.20'

    Updates an A record and verifies that the reference identifies an A record.

    .EXAMPLE
    Set-InfobloxDNSRecord -ReferenceID 'record:txt/ZG5zLmJpbmRfdHh0:test01.example.com/default' -Value 'Verification=AbC123' -WhatIf

    Previews a TXT record update without sending the PUT request.

    .EXAMPLE
    Set-InfobloxDNSRecord -ReferenceID 'record:host/example-reference:host.example.com/default' -Properties @{ ipv4addrs = @(@{ ipv4addr = '192.0.2.20' }) }

    Replaces the IPv4 address collection of a HOST record with an explicitly structured WAPI value.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Value')]
    param(
        [Parameter(Mandatory)]
        [string] $ReferenceID,

        [Parameter(Mandatory, ParameterSetName = 'Value')]
        [Alias('Object', 'Name', 'PtrName', 'PTR', 'NameServer', 'Text', 'CanonicalName', 'IPAddress', 'MailExchanger')]
        [ValidateNotNullOrEmpty()]
        [string] $Value,

        [Parameter(Mandatory, ParameterSetName = 'Properties')]
        [ValidateNotNull()]
        [System.Collections.IDictionary] $Properties,

        [ValidateNotNullOrEmpty()]
        [string] $Type,

        [Parameter(ParameterSetName = 'Value')]
        [ValidateRange(0, 65535)]
        [int] $Preference,

        [Alias('Addresses')]
        [Parameter(ParameterSetName = 'Value')]
        [string[]] $Address
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Set-InfobloxDNSRecord - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($ReferenceID -notmatch '^record:(?<RecordType>[^/]+)/') {
        throw "Set-InfobloxDNSRecord - ReferenceID '$ReferenceID' is not a DNS record WAPI object reference."
    }

    $ReferenceRecordType = Resolve-InfobloxDNSRecordType -Type $Matches.RecordType

    if ($PSBoundParameters.ContainsKey('Type')) {
        $ExpectedRecordType = Resolve-InfobloxDNSRecordType -Type $Type
        if ($ExpectedRecordType -ne $ReferenceRecordType) {
            throw "Set-InfobloxDNSRecord - Type '$Type' does not match record type '$($ReferenceRecordType.ToUpperInvariant())' in ReferenceID."
        }
    }

    $bodySplat = @{
        Type = $ReferenceRecordType
    }
    if ($PSCmdlet.ParameterSetName -eq 'Properties') {
        $bodySplat.Properties = $Properties
    } else {
        $bodySplat.Value = $Value
        if ($PSBoundParameters.ContainsKey('Preference')) {
            $bodySplat.Preference = $Preference
            $bodySplat.PreferenceSpecified = $true
        }
        if ($PSBoundParameters.ContainsKey('Address')) {
            $bodySplat.Address = $Address
            $bodySplat.AddressSpecified = $true
        }
    }
    $Body = ConvertTo-InfobloxDNSRecordUpdateBody @bodySplat

    $FieldNames = @($Body.Keys) -join ', '
    if (-not $PSCmdlet.ShouldProcess($ReferenceID, "Set $($ReferenceRecordType.ToUpperInvariant()) record field(s): $FieldNames")) {
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri = $ReferenceID
        Method      = 'PUT'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -Confirm:$false
    if ($Output) {
        Write-Verbose -Message "Set-InfobloxDNSRecord - Modified $($ReferenceRecordType.ToUpperInvariant()) / $Output"
    }
}

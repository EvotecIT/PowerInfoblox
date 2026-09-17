function Set-InfobloxDNSRecord {
    <#
    .SYNOPSIS
    Updates the value of an existing Infoblox DNS record.

    .DESCRIPTION
    Updates one value field on an existing DNS record by using its Infoblox WAPI object reference.
    The record type is read from ReferenceID and mapped to the corresponding WAPI field. Type can
    be supplied as an additional safety check and must match the type encoded in ReferenceID.

    .PARAMETER ReferenceID
    The WAPI object reference of the DNS record to update, for example record:cname/... or record:a/....

    .PARAMETER Value
    The new record value. The WAPI field depends on the record type: ipv4addr for A, ipv6addr for AAAA,
    canonical for CNAME, name for HOST, ptrdname for PTR, mail_exchanger for MX, nameserver for NS, and
    text for TXT.

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
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string] $ReferenceID,

        [Parameter(Mandatory)]
        [Alias('Object', 'Name', 'PtrName', 'PTR', 'NameServer', 'Text', 'CanonicalName', 'IPAddress', 'MailExchanger')]
        [ValidateNotNullOrEmpty()]
        [string] $Value,

        [ValidateSet(
            'A',
            'AAAA',
            'CNAME',
            'HOST',
            'PTR',
            'MX',
            'NS',
            'TXT'
        )]
        [string] $Type
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

    $ReferenceRecordType = $Matches.RecordType.ToUpperInvariant()
    $FieldByRecordType = @{
        A     = 'ipv4addr'
        AAAA  = 'ipv6addr'
        CNAME = 'canonical'
        HOST  = 'name'
        PTR   = 'ptrdname'
        MX    = 'mail_exchanger'
        NS    = 'nameserver'
        TXT   = 'text'
    }

    if (-not $FieldByRecordType.ContainsKey($ReferenceRecordType)) {
        throw "Set-InfobloxDNSRecord - Record type '$ReferenceRecordType' is not supported."
    }

    if ($PSBoundParameters.ContainsKey('Type') -and $Type.ToUpperInvariant() -ne $ReferenceRecordType) {
        throw "Set-InfobloxDNSRecord - Type '$Type' does not match record type '$ReferenceRecordType' in ReferenceID."
    }

    $FieldName = $FieldByRecordType[$ReferenceRecordType]
    $Body = @{}
    $Body[$FieldName] = $Value

    if (-not $PSCmdlet.ShouldProcess($ReferenceID, "Set $ReferenceRecordType record field '$FieldName'")) {
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri = $ReferenceID
        Method      = 'PUT'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -Confirm:$false
    if ($Output) {
        Write-Verbose -Message "Set-InfobloxDNSRecord - Modified $ReferenceRecordType / $Output"
    }
}

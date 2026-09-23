function Set-InfobloxDNSRecord {
    <#
    .SYNOPSIS
    Updates the value of an existing Infoblox DNS record.

    .DESCRIPTION
    Updates an existing DNS record by exact WAPI reference or by an unambiguous record name,
    type, view, and optional current value. An ambiguous or mismatched name lookup lists candidates
    and skips the update. Value maps to the
    primary data field for A, AAAA, CNAME, HOST, MX, NS, PTR, and TXT records. Properties supports
    structured HOST changes and other record types or multi-field updates without guessing at nested WAPI fields.
    Type is optional and, when supplied, must match the type encoded in ReferenceID.

    .PARAMETER ReferenceID
    The WAPI object reference of the DNS record to update, for example record:cname/... or record:a/....

    .PARAMETER RecordName
    The existing DNS record name to update. Type is required. Use CurrentValue when the name
    identifies several records in a view. The -Name alias of Value remains the new value.

    .PARAMETER CurrentValue
    The expected existing value for an A, AAAA, CNAME, MX, NS, PTR, or TXT record. With
    RecordName it selects the existing record; with ReferenceID it guards the update.

    .PARAMETER View
    Limits a RecordName lookup to one DNS view.

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
    Required with RecordName. With ReferenceID, optionally checks the type encoded in the reference.

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

    .EXAMPLE
    Set-InfobloxDNSRecord -RecordName '10.2.0.192.in-addr.arpa' -Type PTR -View Internal -CurrentValue 'old.example.com' -Value 'new.example.com' -WhatIf

    Previews changing only the PTR record whose current target matches old.example.com.
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByReferenceValue')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByReferenceValue')]
        [Parameter(Mandatory, ParameterSetName = 'ByReferenceProperties')]
        [string] $ReferenceID,

        [Parameter(Mandatory, ParameterSetName = 'ByNameValue')]
        [Parameter(Mandatory, ParameterSetName = 'ByNameProperties')]
        [ValidateNotNullOrEmpty()]
        [string] $RecordName,

        [Parameter(Mandatory, ParameterSetName = 'ByReferenceValue')]
        [Parameter(Mandatory, ParameterSetName = 'ByNameValue')]
        [Alias('Object', 'Name', 'PtrName', 'PTR', 'NameServer', 'Text', 'CanonicalName', 'IPAddress', 'MailExchanger')]
        [ValidateNotNullOrEmpty()]
        [string] $Value,

        [Parameter(Mandatory, ParameterSetName = 'ByReferenceProperties')]
        [Parameter(Mandatory, ParameterSetName = 'ByNameProperties')]
        [ValidateNotNull()]
        [System.Collections.IDictionary] $Properties,

        [Parameter(ParameterSetName = 'ByReferenceValue')]
        [Parameter(ParameterSetName = 'ByReferenceProperties')]
        [Parameter(Mandatory, ParameterSetName = 'ByNameValue')]
        [Parameter(Mandatory, ParameterSetName = 'ByNameProperties')]
        [ValidateNotNullOrEmpty()]
        [string] $Type,

        [Parameter(ParameterSetName = 'ByNameValue')]
        [Parameter(ParameterSetName = 'ByNameProperties')]
        [string] $View,

        [ValidateNotNullOrEmpty()]
        [string] $CurrentValue,

        [Parameter(ParameterSetName = 'ByReferenceValue')]
        [Parameter(ParameterSetName = 'ByNameValue')]
        [ValidateRange(0, 65535)]
        [int] $Preference,

        [Alias('Addresses')]
        [Parameter(ParameterSetName = 'ByReferenceValue')]
        [Parameter(ParameterSetName = 'ByNameValue')]
        [string[]] $Address
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Set-InfobloxDNSRecord - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($PSCmdlet.ParameterSetName -like 'ByReference*') {
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
        if ($PSBoundParameters.ContainsKey('CurrentValue')) {
            $ValueField = Get-InfobloxDNSRecordValueField -Type $ReferenceRecordType
            if (-not $ValueField) {
                throw "Set-InfobloxDNSRecord - CurrentValue is not supported for record type '$($ReferenceRecordType.ToUpperInvariant())'."
            }
            [Array] $Current = @(Get-InfobloxDNSRecord -ReferenceID $ReferenceID -ReturnFields @('name', 'view', $ValueField) -Verbose:$false)
            if ($Current.Count -ne 1 -or ($Current[0]._ref -and $Current[0]._ref -cne $ReferenceID)) {
                Write-Warning -Message "Set-InfobloxDNSRecord - ReferenceID '$ReferenceID' did not resolve to exactly one matching record. Skipping."
                return
            }
            if (-not (Test-InfobloxDNSRecordValue -Type $ReferenceRecordType -ActualValue $Current[0].$ValueField -ExpectedValue $CurrentValue)) {
                Write-Warning -Message "Set-InfobloxDNSRecord - CurrentValue '$CurrentValue' does not match $ValueField='$($Current[0].$ValueField)' for '$ReferenceID'. Skipping."
                return
            }
        }
    } else {
        $ReferenceRecordType = Resolve-InfobloxDNSRecordType -Type $Type
        $findSplat = @{ Name = $RecordName; Type = $ReferenceRecordType }
        if ($View) { $findSplat.View = $View }
        if ($PSBoundParameters.ContainsKey('CurrentValue')) { $findSplat.MatchValue = $CurrentValue }
        $Selection = Find-InfobloxDNSRecordCandidate @findSplat
        [Array] $Candidates = $Selection.Candidates
        [Array] $Selected = $Selection.Selected
        if ($Selected.Count -ne 1) {
            [Array] $ShownRecords = @(if ($Selected.Count -gt 0) { $Selected } else { $Candidates })
            $Details = if ($ShownRecords.Count -gt 0) {
                Format-InfobloxDNSRecordCandidate -Records $ShownRecords -Name $RecordName -Type $ReferenceRecordType.ToUpperInvariant() -ValueField $Selection.ValueField
            } else { '  No records found.' }
            $Reason = if ($Selected.Count -eq 0 -and $Candidates.Count -gt 0) {
                $Criteria = @(
                    if ($View) { "View '$View'" }
                    if ($PSBoundParameters.ContainsKey('CurrentValue')) { "CurrentValue '$CurrentValue'" }
                ) -join ' and '
                "No record matches $Criteria."
            } else { "Found $($Selected.Count) matching records." }
            Write-Warning -Message "Set-InfobloxDNSRecord - $Reason Specify View or CurrentValue, or use ReferenceID. Available records:`n$Details`nSkipping."
            return
        }
        $ReferenceID = $Selected[0]._ref
        if (-not $ReferenceID -or $ReferenceID -notmatch '^record:(?<RecordType>[^/]+)/' -or
            (Resolve-InfobloxDNSRecordType -Type $Matches.RecordType) -ne $ReferenceRecordType) {
            Write-Warning -Message "Set-InfobloxDNSRecord - The selected $($ReferenceRecordType.ToUpperInvariant()) record has no matching WAPI reference. Skipping."
            return
        }
    }

    $bodySplat = @{
        Type = $ReferenceRecordType
    }
    if ($PSCmdlet.ParameterSetName -like '*Properties') {
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

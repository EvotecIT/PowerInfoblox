function Remove-InfobloxDnsRecord {
    <#
    .SYNOPSIS
    Removes Infoblox DNS records.

    .DESCRIPTION
    Removes one DNS record selected by ReferenceID or records found by Name and Type. Value can
    select a specific A, AAAA, CNAME, MX, NS, PTR, or TXT record with that name. Name-based
    removal stops when the selected records are ambiguous unless RemoveAllMatching is supplied.
    Associated PTR cleanup for A and AAAA records is limited to the same view and matching ptrdname.

    .PARAMETER Name
    One or more exact DNS record names to find and remove.

    .PARAMETER ReferenceID
    The exact DNS record WAPI object reference to remove.

    .PARAMETER Type
    The WAPI record type. It is required with Name and optional as a safety check with ReferenceID.

    .PARAMETER Value
    The existing record value to match when removing by Name: address for A/AAAA, canonical
    target for CNAME, mail exchanger for MX, nameserver for NS, target FQDN for PTR, or text
    for TXT. With ReferenceID, Value guards against deleting an object whose value has changed.
    DNS names are compared without regard to case or a final dot; TXT is exact.

    .PARAMETER View
    Limits a name-based lookup to one DNS view.

    .PARAMETER RemoveAllMatching
    Explicitly allows every record returned for a Name, Type, and optional View to be removed.
    Without this switch, an ambiguous lookup is skipped.

    .PARAMETER SkipPTR
    Skips associated PTR record removal when removing A or AAAA records.

    .PARAMETER LogPath
    The path to a log file that receives discovery, removal attempt, preview,
    success, and failure messages.

    .EXAMPLE
    Remove-InfobloxDnsRecord -ReferenceID 'record:mx/example-reference:example.com/default' -WhatIf

    .EXAMPLE
    Remove-InfobloxDnsRecord -Name 'host.example.com' -Type A -View Internal -WhatIf

    .EXAMPLE
    Remove-InfobloxDnsRecord -Name '5.10.2.10.in-addr.arpa' -Type PTR -Value 'host.example.com' -View Internal -WhatIf

    .EXAMPLE
    Remove-InfobloxDnsRecord -Name 'example.com' -Type MX -View default -RemoveAllMatching -WhatIf
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string[]] $Name,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $ReferenceID,

        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [Parameter(ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $Type,

        [Parameter(ParameterSetName = 'ByName')]
        [string] $View,

        [Parameter(ParameterSetName = 'ByName')]
        [Parameter(ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $Value,

        [switch] $RemoveAllMatching,
        [switch] $SkipPTR,
        [string] $LogPath
    )

    if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
        if ($ReferenceID -notmatch '^record:(?<RecordType>[^/]+)/') {
            throw "Remove-InfobloxDnsRecord - ReferenceID '$ReferenceID' is not a DNS record WAPI object reference."
        }
        $NormalizedType = Resolve-InfobloxDNSRecordType -Type $Matches.RecordType
        if ($PSBoundParameters.ContainsKey('Type')) {
            $ExpectedType = Resolve-InfobloxDNSRecordType -Type $Type
            if ($ExpectedType -ne $NormalizedType) {
                throw "Remove-InfobloxDnsRecord - Type '$Type' does not match record type '$($NormalizedType.ToUpperInvariant())' in ReferenceID."
            }
        }
    } else {
        $NormalizedType = Resolve-InfobloxDNSRecordType -Type $Type
    }

    if ($NormalizedType -in @('host_ipv4addr', 'host_ipv6addr')) {
        throw "Remove-InfobloxDnsRecord - Record type '$NormalizedType' cannot be deleted directly. Remove or update its parent HOST record."
    }
    $DisplayType = $NormalizedType.ToUpperInvariant()

    $ValueField = Get-InfobloxDNSRecordValueField -Type $NormalizedType
    if ($PSBoundParameters.ContainsKey('Value') -and -not $ValueField) {
        throw "Remove-InfobloxDnsRecord - Value selection is not supported for record type '$DisplayType'. Use ReferenceID."
    }

    [Array] $ToBeDeleted = @(
        if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
            $getReferenceSplat = @{ ReferenceID = $ReferenceID; Verbose = $false }
            if ($PSBoundParameters.ContainsKey('Value')) {
                $getReferenceSplat.ReturnFields = @('name', 'view', $ValueField)
            }
            [Array] $FoundByReference = @(Get-InfobloxDNSRecord @getReferenceSplat)
            if ($FoundByReference.Count -gt 1) {
                throw "Remove-InfobloxDnsRecord - Exact ReferenceID lookup returned $($FoundByReference.Count) records. Refusing to remove any record."
            }
            if ($FoundByReference.Count -eq 1) {
                $FoundRecord = $FoundByReference[0]
                if ($FoundRecord._ref -and $FoundRecord._ref -cne $ReferenceID) {
                    throw "Remove-InfobloxDnsRecord - Exact ReferenceID lookup returned a different object reference. Refusing to remove any record."
                }
                if (-not $FoundRecord._ref) {
                    $FoundRecord | Add-Member -NotePropertyName '_ref' -NotePropertyValue $ReferenceID
                }
                if ($PSBoundParameters.ContainsKey('Value') -and
                    -not (Test-InfobloxDNSRecordValue -Type $NormalizedType -ActualValue $FoundRecord.$ValueField -ExpectedValue $Value)) {
                    Write-Warning -Message "Remove-InfobloxDnsRecord - Value '$Value' does not match $ValueField='$($FoundRecord.$ValueField)' for '$ReferenceID'. Skipping."
                } else {
                    $FoundRecord
                }
            } else {
                Write-Warning -Message "Remove-InfobloxDnsRecord - ReferenceID '$ReferenceID' was not found. Skipping."
            }
        } else {
            foreach ($RecordName in $Name) {
                $findSplat = @{
                    Name = $RecordName
                    Type = $NormalizedType
                }
                if ($View) {
                    $findSplat.View = $View
                }
                if ($PSBoundParameters.ContainsKey('Value')) {
                    $findSplat.MatchValue = $Value
                }
                $Selection = Find-InfobloxDNSRecordCandidate @findSplat
                [Array] $MatchesForName = $Selection.Candidates
                if ($MatchesForName.Count -eq 0) {
                    Write-Warning -Message "Remove-InfobloxDnsRecord - No $DisplayType record for '$RecordName' was found$(if ($View) { " in view '$View'" }). Skipping."
                    continue
                }
                [Array] $SelectedRecords = $Selection.Selected
                if ($SelectedRecords.Count -eq 0 -or ($SelectedRecords.Count -gt 1 -and -not $RemoveAllMatching)) {
                    $WarningRecords = if ($SelectedRecords.Count -eq 0) { $MatchesForName } else { $SelectedRecords }
                    $Candidates = Format-InfobloxDNSRecordCandidate -Records $WarningRecords -Name $RecordName -Type $DisplayType -ValueField $ValueField
                    if ($SelectedRecords.Count -eq 0) {
                        $Criteria = @(
                            if ($View) { "View '$View'" }
                            if ($PSBoundParameters.ContainsKey('Value')) { "Value '$Value'" }
                        ) -join ' and '
                        Write-Warning -Message "Remove-InfobloxDnsRecord - No $DisplayType record for '$RecordName' matches $Criteria. Available records:`n$Candidates`nSkipping."
                    } else {
                        $SelectionHint = if ($ValueField) { 'View or Value' } else { 'View' }
                        Write-Warning -Message "Remove-InfobloxDnsRecord - Found $($SelectedRecords.Count) $DisplayType records for '$RecordName'. Specify $SelectionHint, use ReferenceID, or explicitly use RemoveAllMatching. Matching records:`n$Candidates`nSkipping."
                    }
                    continue
                }
                $SelectedRecords
            }
        }
    )

    $SeenReference = [System.Collections.Generic.Dictionary[string, bool]]::new([System.StringComparer]::Ordinal)
    [Array] $ToBeDeleted = @($ToBeDeleted | Where-Object {
            if (-not $_._ref) {
                return $true
            }
            if ($SeenReference.ContainsKey($_._ref)) {
                return $false
            }
            $SeenReference[$_._ref] = $true
            $true
        })

    foreach ($Record in $ToBeDeleted) {
        if ($LogPath) {
            Write-Color -Text "Found $($Record.name) with type $DisplayType to be removed" -LogFile $LogPath -NoConsoleOutput
        }
    }
    Write-Verbose -Message "Remove-InfobloxDnsRecord - Found $($ToBeDeleted.Count) $DisplayType records to delete"

    $AssociatedPTRBySource = [System.Collections.Generic.Dictionary[string, object]]::new([System.StringComparer]::Ordinal)
    if (($NormalizedType -in @('a', 'aaaa')) -and -not $SkipPTR) {
        foreach ($Record in $ToBeDeleted) {
            if (-not $Record._ref) {
                continue
            }
            $AddressValue = if ($NormalizedType -eq 'a') { $Record.ipv4addr } else { $Record.ipv6addr }
            if (-not $AddressValue -or -not $Record.name) {
                continue
            }
            try {
                $PTRAddress = Convert-IpAddressToPtrString -IPAddress $AddressValue -ErrorAction Stop
            } catch {
                Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to convert $AddressValue to a PTR name."
                if ($LogPath) {
                    Write-Color -Text "Failed to convert $AddressValue to a PTR name" -NoConsoleOutput -LogFile $LogPath
                }
                continue
            }

            $getPTRSplat = @{
                Type = 'PTR'
                Name = $PTRAddress
                ReturnFields = @('name', 'ptrdname', 'view')
                Verbose = $false
            }
            if ($Record.view) {
                $PTRView = $Record.view
            } elseif ($View) {
                $PTRView = $View
            } else {
                Write-Warning -Message "Remove-InfobloxDnsRecord - Cannot safely find the PTR associated with '$($Record.name)' because its DNS view is unknown. Skipping PTR removal."
                continue
            }
            $getPTRSplat.View = $PTRView
            [Array] $PTRCandidates = @(Get-InfobloxDNSRecord @getPTRSplat)
            $ExpectedPTRTarget = ([string] $Record.name).TrimEnd('.')
            [Array] $AssociatedPTR = @($PTRCandidates | Where-Object {
                    $_.ptrdname -and
                    $_.view -and
                    ([string] $_.ptrdname).TrimEnd('.') -ieq $ExpectedPTRTarget -and
                    ([string] $_.view) -ieq ([string] $PTRView)
                })

            if ($AssociatedPTR.Count -gt 1 -and -not $RemoveAllMatching) {
                Write-Warning -Message "Remove-InfobloxDnsRecord - Found $($AssociatedPTR.Count) associated PTR records for '$($Record.name)'. Use ReferenceID or explicitly use RemoveAllMatching. Skipping PTR removal."
                continue
            }
            if ($AssociatedPTR.Count -eq 0) {
                Write-Verbose -Message "Remove-InfobloxDnsRecord - No PTR record associated with '$($Record.name)' was found. Skipping PTR removal."
                continue
            }
            $AssociatedPTRBySource[$Record._ref] = @($AssociatedPTR)
        }
    }

    $ProcessedPTRReference = [System.Collections.Generic.Dictionary[string, bool]]::new([System.StringComparer]::Ordinal)
    foreach ($Record in $ToBeDeleted) {
        if (-not $Record._ref) {
            Write-Warning -Message 'Remove-InfobloxDnsRecord - Record does not have a reference ID. Skipping.'
            if ($LogPath) {
                Write-Color -Text 'Record does not have a reference ID. Skipping.' -NoConsoleOutput -LogFile $LogPath
            }
            continue
        }
        Write-Verbose -Message "Remove-InfobloxDnsRecord - Removing $($Record.name) with type $DisplayType / WhatIf:$WhatIfPreference"
        if ($LogPath) {
            Write-Color -Text "Removing $($Record.name) with type $DisplayType" -NoConsoleOutput -LogFile $LogPath
        }
        $ForwardRemoved = $false
        try {
            $Success = Remove-InfobloxObject -ReferenceID $Record._ref -WhatIf:$WhatIfPreference -ErrorAction Stop -ReturnSuccess -Verbose:$false
            if ($Success -eq $true -or $WhatIfPreference) {
                $ForwardRemoved = $true
                Write-Verbose -Message "Remove-InfobloxDnsRecord - Removed $($Record.name) with type $DisplayType / WhatIf:$WhatIfPreference"
                if ($LogPath) {
                    if ($WhatIfPreference) {
                        Write-Color -Text "WhatIf: Would remove $($Record.name) with type $DisplayType" -NoConsoleOutput -LogFile $LogPath
                    } else {
                        Write-Color -Text "Removed $($Record.name) with type $DisplayType" -NoConsoleOutput -LogFile $LogPath
                    }
                }
            } else {
                Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to remove $($Record.name) with type $DisplayType."
                if ($LogPath) {
                    Write-Color -Text "Failed to remove $($Record.name) with type $DisplayType" -NoConsoleOutput -LogFile $LogPath
                }
            }
        } catch {
            Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to remove $($Record.name) with type $DisplayType, error: $($_.Exception.Message)"
            if ($LogPath) {
                Write-Color -Text "Failed to remove $($Record.name) with type $DisplayType, error: $($_.Exception.Message)" -NoConsoleOutput -LogFile $LogPath
            }
        }
        if (-not $ForwardRemoved) {
            continue
        }
        if (-not $AssociatedPTRBySource.ContainsKey($Record._ref)) {
            continue
        }

        foreach ($PTRRecord in @($AssociatedPTRBySource[$Record._ref])) {
            if (-not $PTRRecord._ref) {
                Write-Warning -Message 'Remove-InfobloxDnsRecord - PTR record does not have a reference ID. Skipping.'
                if ($LogPath) {
                    Write-Color -Text 'PTR record does not have a reference ID. Skipping.' -NoConsoleOutput -LogFile $LogPath
                }
                continue
            }
            if ($ProcessedPTRReference.ContainsKey($PTRRecord._ref)) {
                continue
            }
            $ProcessedPTRReference[$PTRRecord._ref] = $true

            Write-Verbose -Message "Remove-InfobloxDnsRecord - Removing $($PTRRecord.name) with type PTR / WhatIf:$WhatIfPreference"
            if ($LogPath) {
                Write-Color -Text "Removing $($PTRRecord.name) with type PTR" -NoConsoleOutput -LogFile $LogPath
            }
            try {
                $Success = Remove-InfobloxObject -ReferenceID $PTRRecord._ref -WhatIf:$WhatIfPreference -ErrorAction Stop -ReturnSuccess -Verbose:$false
                if ($Success -eq $true -or $WhatIfPreference) {
                    Write-Verbose -Message "Remove-InfobloxDnsRecord - Removed $($PTRRecord.name) with type PTR / WhatIf:$WhatIfPreference"
                    if ($LogPath) {
                        if ($WhatIfPreference) {
                            Write-Color -Text "WhatIf: Would remove $($PTRRecord.name) with type PTR" -NoConsoleOutput -LogFile $LogPath
                        } else {
                            Write-Color -Text "Removed $($PTRRecord.name) with type PTR" -NoConsoleOutput -LogFile $LogPath
                        }
                    }
                } else {
                    Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to remove $($PTRRecord.name) with type PTR."
                    if ($LogPath) {
                        Write-Color -Text "Failed to remove $($PTRRecord.name) with type PTR" -NoConsoleOutput -LogFile $LogPath
                    }
                }
            } catch {
                Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to remove $($PTRRecord.name) with type PTR, error: $($_.Exception.Message)"
                if ($LogPath) {
                    Write-Color -Text "Failed to remove $($PTRRecord.name) with type PTR, error: $($_.Exception.Message)" -NoConsoleOutput -LogFile $LogPath
                }
            }
        }
    }
}

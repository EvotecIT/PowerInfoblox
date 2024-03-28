function Remove-InfobloxDnsRecord {
    <#
    .SYNOPSIS
    Remove Infoblox DNS records

    .DESCRIPTION
    Remove Infoblox DNS records

    .PARAMETER Name
    Name of the record to remove

    .PARAMETER Type
    Type of the record to remove

    .PARAMETER SkipPTR
    Skip PTR record removal, when removing A record

    .PARAMETER LogPath
    Path to log file. Changes are logged to this file

    .EXAMPLE
    Remove-InfobloxDnsRecord -Name 'test.example.com' -Type 'A' -WhatIf

    .EXAMPLE
    Remove-InfobloxDnsRecord -Name 'test.example.com' -Type 'A' -SkipPTR -WhatIf

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string[]] $Name,
        [ValidateSet(
            'A', 'CNAME', 'AAAA', 'PTR'
        )]
        [Parameter(Mandatory)][string] $Type,
        [switch] $SkipPTR,
        [string] $LogPath
    )
    [Array] $ToBeDeleted = foreach ($Record in $Name) {
        $FoundRecord = Get-InfobloxDNSRecord -Name $Record -Type $Type -Verbose:$false
        if ($FoundRecord) {
            $FoundRecord
            if ($LogPath) {
                Write-Color -Text "Found $($FoundRecord.name) with type $Type to be removed" -LogFile $LogPath -NoConsoleOutput
            }
        } else {
            Write-Verbose -Message "Remove-InfobloxDnsRecord - No record for $Record were found. Skipping"
            if ($LogPath) {
                Write-Color -Text "No record for $Record were found. Skipping" -LogFile $LogPath -NoConsoleOutput
            }
        }
    }

    Write-Verbose -Message "Remove-InfobloxDnsRecord - Found $($ToBeDeleted.Count) records to delete"

    [Array] $ToBeDeletedPTR = @(
        if ($Type -eq 'A' -and -not $SkipPTR) {
            foreach ($Record in $ToBeDeleted) {
                if ($null -eq $Record.ipv4addr) {
                    continue
                }
                try {
                    $PTRAddress = Convert-IpAddressToPtrString -IPAddress $Record.ipv4addr -ErrorAction Stop
                } catch {
                    Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to convert $($Record.ipv4addr) to PTR"
                    if ($LogPath) {
                        Write-Color -Text "Failed to convert $($Record.ipv4addr) to PTR" -NoConsoleOutput -LogFile $LogPath
                    }
                }
                if ($PTRAddress) {
                    $PTRRecord = Get-InfobloxDNSRecord -Type PTR -Name $PTRAddress -Verbose:$false
                    if ($PTRRecord) {
                        $PTRRecord
                        if ($LogPath) {
                            Write-Color -Text "Found $($PTRRecord.name) with type PTR to be removed" -NoConsoleOutput -LogFile $LogPath
                        }
                    } else {
                        Write-Verbose -Message "Remove-InfobloxDnsRecord - No PTR record for $($Record.name) were found. Skipping"
                        if ($LogPath) {
                            Write-Color -Text "No PTR record for $($Record.name) were found. Skipping" -NoConsoleOutput -LogFile $LogPath
                        }
                    }
                }
            }
        }
    )

    if ($ToBeDeletedPTR.Count -gt 0) {
        Write-Verbose -Message "Remove-InfobloxDnsRecord - Found $($ToBeDeletedPTR.Count) PTR records to delete"
    }

    foreach ($Record in $ToBeDeleted) {
        if (-not $Record._ref) {
            Write-Warning -Message "Remove-InfobloxDnsRecord - Record does not have a reference ID, skipping"
            if ($LogPath) {
                Write-Color -Text "Record does not have a reference ID, skipping" -NoConsoleOutput -LogFile $LogPath
            }
            continue
        }
        Write-Verbose -Message "Remove-InfobloxDnsRecord - Removing $($Record.name) with type $Type / WhatIf:$WhatIfPreference"
        if ($LogPath) {
            Write-Color -Text "Removing $($Record.name) with type $Type" -NoConsoleOutput -LogFile $LogPath
        }
        try {
            $Success = Remove-InfobloxObject -ReferenceID $Record._ref -WhatIf:$WhatIfPreference -ErrorAction Stop -ReturnSuccess -Verbose:$false
            if ($Success -eq $true -or $WhatIfPreference) {
                Write-Verbose -Message "Remove-InfobloxDnsRecord - Removed $($Record.name) with type $Type / WhatIf: $WhatIfPreference"
                if ($LogPath) {
                    Write-Color -Text "Removed $($Record.name) with type $Type" -NoConsoleOutput -LogFile $LogPath
                }
            } else {
                # this shouldn't really happen as the error action is set to stop
                Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to remove $($Record.name) with type $Type / WhatIf: $WhatIfPreference"
                if ($LogPath) {
                    Write-Color -Text "Failed to remove $($Record.name) with type $Type / WhatIf: $WhatIfPreference" -NoConsoleOutput -LogFile $LogPath
                }
            }
        } catch {
            Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to remove $($Record.name) with type $Type, error: $($_.Exception.Message)"
            if ($LogPath) {
                Write-Color -Text "Failed to remove $($Record.name) with type $Type, error: $($_.Exception.Message)" -NoConsoleOutput -LogFile $LogPath
            }
        }
    }
    foreach ($Record in $ToBeDeletedPTR) {
        if (-not $Record._ref) {
            Write-Warning -Message "Remove-InfobloxDnsRecord - PTR record does not have a reference ID, skipping"
            if ($LogPath) {
                Write-Color -Text "PTR record does not have a reference ID, skipping" -NoConsoleOutput -LogFile $LogPath
            }
            continue
        }
        Write-Verbose -Message "Remove-InfobloxDnsRecord - Removing $($Record.name) with type PTR / WhatIf:$WhatIfPreference"
        if ($LogPath) {
            Write-Color -Text "Removing $($Record.name) with type PTR / WhatIf: $WhatIfPreference" -NoConsoleOutput -LogFile $LogPath
        }
        try {
            $Success = Remove-InfobloxObject -ReferenceID $Record._ref -WhatIf:$WhatIfPreference -ErrorAction Stop -ReturnSuccess -Verbose:$false
            if ($Success -eq $true -or $WhatIfPreference) {
                Write-Verbose -Message "Remove-InfobloxDnsRecord - Removed $($Record.name) with type PTR / WhatIf: $WhatIfPreference"
                if ($LogPath) {
                    Write-Color -Text "Removed $($Record.name) with type PTR / WhatIf: $WhatIfPreference" -NoConsoleOutput -LogFile $LogPath
                }
            } else {
                # this shouldn't really happen as the error action is set to stop
                Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to remove $($Record.name) with type PTR / WhatIf: $WhatIfPreference"
                if ($LogPath) {
                    Write-Color -Text "Failed to remove $($Record.name) with type PTR / WhatIf: $WhatIfPreference" -NoConsoleOutput -LogFile $LogPath
                }
            }
        } catch {
            Write-Warning -Message "Remove-InfobloxDnsRecord - Failed to remove $($Record.name) with type PTR, error: $($_.Exception.Message)"
            if ($LogPath) {
                Write-Color -Text "Failed to remove $($Record.name) with type PTR, error: $($_.Exception.Message)" -NoConsoleOutput -LogFile $LogPath
            }
        }
    }
}
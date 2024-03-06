function Add-InfoBloxDNSRecord {
    <#
    .SYNOPSIS
    Short description

    .DESCRIPTION
    Long description

    .PARAMETER Name
    Parameter description

    .PARAMETER IPAddress
    Parameter description

    .PARAMETER CanonicalName
    Parameter description

    .PARAMETER PtrName
    Parameter description

    .PARAMETER Type
    Parameter description

    .EXAMPLE
    Add-InfoBloxDNSRecord -Name 'Test' -IPv4Address '10.10.10.10' -Type 'A'

    .EXAMPLE
    Add-InfoBloxDNSRecord -Name 'Test' -IPv4Address '10.10.10.10' -Type 'HOST'

    .EXAMPLE
    Add-InfoBloxDNSRecord -Name 'Test' -CanonicalName 'test2.mcdonalds.com' -Type 'CNAME'

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string] $Name,
        [Alias('IPv4Address','IPv6Address')][string] $IPAddress,
        [string] $CanonicalName,
        [string] $PtrName,
        [string] $Text,
        [parameter(Mandatory)][ValidateSet(
            'A',
            #'AAAA',
            'CNAME',
            'HOST',
            'PTR'
            #'DName',
            #'DNSKEY', 'DS', 'Host', 'host_ipv4addr', 'host_ipv6addr',
            #'LBDN', 'MX', 'NAPTR', 'NS', 'NSEC',
            #'NSEC3', 'NSEC3PARAM', 'PTR', 'RRSIG', 'SRV', 'TXT'
        )]
        [string] $Type
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Add-InfoBloxDNSRecord - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    # Lets convert it to lowercase, since Infoblox is case sensitive
    $Type = $Type.ToLower()
    if ($Type -eq 'A') {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with IPAddress: '$IPAddress'"
        if ($Name -and $IPAddress) {
            $Body = [ordered] @{
                name     = $Name.ToLower()
                ipv4addr = $IPAddress
            }
        } else {
            if ($ErrorActionPreference -eq 'Stop') {
                throw "Add-InfoBloxDNSRecord - 'Name' and 'IPAddress' are required for $Type record"
            }
            Write-Warning -Message "'Name' and 'IPAddress' are required for $Type record"
            return
        }
    } elseif ($Type -eq 'CNAME') {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with IPAddress: '$IPAddress'"
        if ($Name -and $CanonicalName) {
            $Body = [ordered] @{
                name      = $Name.ToLower()
                canonical = $CanonicalName.ToLower()
            }
        } else {
            if ($ErrorActionPreference -eq 'Stop') {
                throw "'Name' and 'CanonicalName' are required for $Type record"
            }
            Write-Warning -Message "Add-InfoBloxDNSRecord - 'Name' and 'CanonicalName' are required for $Type record"
            return
        }
    } elseif ($Type -eq 'AAAA') {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with IPAddress: '$IPAddress'"
        if ($Name -and $IPAddress) {
            $Body = [ordered] @{
                name     = $Name.ToLower()
                ipv6addr = $IPAddress
            }
        } else {
            if ($ErrorActionPreference -eq 'Stop') {
                throw "'Name' and 'IPAddress' are required for $Type record"
            }
            Write-Warning -Message "Add-InfoBloxDNSRecord - 'Name' and 'IPAddress' are required for $Type record"
            return
        }
    } elseif ($Type -eq 'HOST') {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with IPAddress: '$IPAddress'"
        if ($Name -and $IPAddress) {
            $Body = [ordered] @{
                name      = $Name.ToLower()
                ipv4addrs = @(
                    @{
                        ipv4addr = $IPAddress
                    }
                )
            }
        } else {
            if ($ErrorActionPreference -eq 'Stop') {
                throw "'Name' and 'IPAddress' are required for '$Type' record"
            }
            Write-Warning -Message "Add-InfoBloxDNSRecord - 'Name' and 'IPAddress' are required for '$Type' record"
            return
        }
    } elseif ($Type -eq 'PTR') {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with IPAddress: '$IPAddress'"
        if ($Name -and $IPAddress -and $PtrName) {
            $Body = [ordered] @{
                name     = $Name.ToLower()
                ptrdname = $PtrName.ToLower()
                ipv4addr = $IPAddress
            }
        } else {
            if ($ErrorActionPreference -eq 'Stop') {
                throw "'Name' and 'IPAddress' and 'PtrName' are required for '$Type' record"
            }
            Write-Warning -Message "Add-InfoBloxDNSRecord - 'Name' and 'IPAddress' and 'PtrName' are required for '$Type' record"
            return
        }
    } elseif ($Type -eq 'TXT') {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with TEXT: '$Text'"
        if ($Name -and $IPAddress) {
            $Body = [ordered] @{
                name = $Name.ToLower()
                text = $Text.ToLower()
            }
        } else {
            if ($ErrorActionPreference -eq 'Stop') {
                throw "'Name' and 'Text' are required for '$Type' record"
            }
            Write-Warning -Message "Add-InfoBloxDNSRecord - 'Name' and 'Text' are required for '$Type' record"
            return
        }
    } else {
        # won't trigger, but lets leave it like that
        if ($ErrorActionPreference -eq 'Stop') {
            throw "Add-InfoBloxDNSRecord - Type $Type not supported"
        }
        Write-Warning -Message "Add-InfoBloxDNSRecord - Type $Type not supported"
        return
    }
    $invokeInfobloxQuerySplat = @{
        RelativeUri = "record:$Type"
        Method      = 'POST'
        Body        = $Body
    }

    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WarningAction SilentlyContinue -WarningVariable varWarning
    if ($Output) {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Added $Type / $Output"
    } else {
        if (-not $WhatIfPreference) {
            Write-Warning -Message "Add-InfoBloxDNSRecord - Failed to add $Type, error: $varWarning"
        }
    }
}
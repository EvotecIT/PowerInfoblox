function Add-InfoBloxDNSRecord {
    [CmdletBinding()]
    param(
        [string] $Name,
        [string] $IPv4Address,
        [string] $CanonicalName,
        [parameter(Mandatory)][ValidateSet(
            'A',
            #'AAAA',
            'CNAME',
            'HOST'
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
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with IPv4Address: '$IPv4Address'"
        if ($Name -and $IPv4Address) {
            $Body = [ordered] @{
                name     = $Name.ToLower()
                ipv4addr = $IPv4Address
            }
        } else {
            Write-Warning -Message "Add-InfoBloxDNSRecord - Name and IPv4Address are required for $Type record"
            return
        }
    } elseif ($Type -eq 'CNAME') {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with IPv4Address: '$IPv4Address'"
        if ($Name -and $CanonicalName) {
            $Body = [ordered] @{
                name      = $Name.ToLower()
                canonical = $CanonicalName.ToLower()
            }
        } else {
            Write-Warning -Message "Add-InfoBloxDNSRecord - Name and CanonicalName are required for $Type record"
            return
        }
    } elseif ($Type -eq 'HOST') {
        Write-Verbose -Message "Add-InfoBloxDNSRecord - Adding $Type record $Name with IPv4Address: '$IPv4Address'"
        if ($Name -and $IPv4Address) {
            $Body = [ordered] @{
                name      = $Name.ToLower()
                ipv4addrs = @(
                    @{
                        ipv4addr = $IPv4Address
                    }
                )
            }
        } else {
            Write-Warning -Message "Add-InfoBloxDNSRecord - Name and IPv4Address are required for $Type record"
            return
        }
    } else {
        # won't trigger, but lets leave it like that
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
        Write-Warning -Message "Add-InfoBloxDNSRecord - Failed to add $Type, error: $varWarning"
    }
}
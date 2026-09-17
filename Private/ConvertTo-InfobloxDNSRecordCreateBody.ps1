function ConvertTo-InfobloxDNSRecordCreateBody {
    [CmdletBinding(DefaultParameterSetName = 'Typed')]
    param(
        [Parameter(Mandatory)]
        [string] $Type,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $Name,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $IPAddress,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $CanonicalName,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $PtrName,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $Text,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $MailExchanger,

        [Parameter(ParameterSetName = 'Typed')]
        [int] $Preference,

        [Parameter(ParameterSetName = 'Typed')]
        [switch] $PreferenceSpecified,

        [Parameter(ParameterSetName = 'Typed')]
        [string] $NameServer,

        [Parameter(ParameterSetName = 'Typed')]
        [string[]] $Address,

        [Parameter(Mandatory, ParameterSetName = 'Properties')]
        [System.Collections.IDictionary] $Properties
    )

    if ($PSCmdlet.ParameterSetName -eq 'Properties') {
        if ($Properties.Count -eq 0) {
            throw 'ConvertTo-InfobloxDNSRecordCreateBody - Properties cannot be empty.'
        }
        $Body = [ordered]@{}
        foreach ($Entry in $Properties.GetEnumerator()) {
            $Body[$Entry.Key] = $Entry.Value
        }
        return $Body
    }

    $NormalizedType = Resolve-InfobloxDNSRecordType -Type $Type
    $ParsedAddress = $null

    switch ($NormalizedType) {
        'a' {
            if (-not $Name -or -not $IPAddress -or
                -not [System.Net.IPAddress]::TryParse($IPAddress, [ref] $ParsedAddress) -or
                $ParsedAddress.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
                throw "Add-InfoBloxDNSRecord - Name and a valid IPv4 address are required for an A record."
            }
            [ordered]@{ name = $Name; ipv4addr = $IPAddress }
        }
        'aaaa' {
            if (-not $Name -or -not $IPAddress -or
                -not [System.Net.IPAddress]::TryParse($IPAddress, [ref] $ParsedAddress) -or
                $ParsedAddress.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetworkV6) {
                throw "Add-InfoBloxDNSRecord - Name and a valid IPv6 address are required for an AAAA record."
            }
            [ordered]@{ name = $Name; ipv6addr = $IPAddress }
        }
        'cname' {
            if (-not $Name -or -not $CanonicalName) {
                throw 'Add-InfoBloxDNSRecord - Name and CanonicalName are required for a CNAME record.'
            }
            [ordered]@{ name = $Name; canonical = $CanonicalName }
        }
        'host' {
            if (-not $Name -or -not $IPAddress -or
                -not [System.Net.IPAddress]::TryParse($IPAddress, [ref] $ParsedAddress)) {
                throw 'Add-InfoBloxDNSRecord - Name and a valid IPAddress are required for a HOST record.'
            }
            if ($ParsedAddress.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork) {
                [ordered]@{ name = $Name; ipv4addrs = @(@{ ipv4addr = $IPAddress }) }
            } else {
                [ordered]@{ name = $Name; ipv6addrs = @(@{ ipv6addr = $IPAddress }) }
            }
        }
        'ptr' {
            if (-not $PtrName) {
                throw 'Add-InfoBloxDNSRecord - PtrName is required for a PTR record.'
            }
            $Body = [ordered]@{ ptrdname = $PtrName }
            if ($IPAddress) {
                if (-not [System.Net.IPAddress]::TryParse($IPAddress, [ref] $ParsedAddress)) {
                    throw 'Add-InfoBloxDNSRecord - IPAddress must be a valid IPv4 or IPv6 address for a PTR record.'
                }
                if ($ParsedAddress.AddressFamily -eq [System.Net.Sockets.AddressFamily]::InterNetwork) {
                    $Body.ipv4addr = $IPAddress
                } else {
                    $Body.ipv6addr = $IPAddress
                }
            } elseif ($Name) {
                $Body.name = $Name
            } else {
                throw 'Add-InfoBloxDNSRecord - IPAddress or Name is required for a PTR record.'
            }
            $Body
        }
        'mx' {
            if (-not $Name -or -not $MailExchanger -or -not $PreferenceSpecified) {
                throw 'Add-InfoBloxDNSRecord - Name, MailExchanger, and Preference are required for an MX record.'
            }
            [ordered]@{ name = $Name; mail_exchanger = $MailExchanger; preference = $Preference }
        }
        'ns' {
            if (-not $Name -or -not $NameServer) {
                throw 'Add-InfoBloxDNSRecord - Name and NameServer are required for an NS record.'
            }
            $Body = [ordered]@{
                name       = $Name
                nameserver = $NameServer
            }
            if ($Address) {
                $Body.addresses = @($Address | ForEach-Object { @{ address = $_ } })
            }
            $Body
        }
        'txt' {
            if (-not $Name -or [string]::IsNullOrEmpty($Text)) {
                throw 'Add-InfoBloxDNSRecord - Name and Text are required for a TXT record.'
            }
            [ordered]@{ name = $Name; text = $Text }
        }
        default {
            throw "Add-InfoBloxDNSRecord - Type '$Type' requires the Properties parameter set."
        }
    }
}

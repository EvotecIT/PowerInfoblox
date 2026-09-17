function ConvertTo-InfobloxDNSRecordUpdateBody {
    [CmdletBinding(DefaultParameterSetName = 'Value')]
    param(
        [Parameter(Mandatory)]
        [string] $Type,

        [Parameter(Mandatory, ParameterSetName = 'Value')]
        [string] $Value,

        [Parameter(Mandatory, ParameterSetName = 'Properties')]
        [System.Collections.IDictionary] $Properties,

        [Parameter(ParameterSetName = 'Value')]
        [int] $Preference,

        [Parameter(ParameterSetName = 'Value')]
        [switch] $PreferenceSpecified,

        [Parameter(ParameterSetName = 'Value')]
        [string[]] $Address,

        [Parameter(ParameterSetName = 'Value')]
        [switch] $AddressSpecified
    )

    if ($PSCmdlet.ParameterSetName -eq 'Properties') {
        if ($Properties.Count -eq 0) {
            throw 'ConvertTo-InfobloxDNSRecordUpdateBody - Properties cannot be empty.'
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
            if (-not [System.Net.IPAddress]::TryParse($Value, [ref] $ParsedAddress) -or
                $ParsedAddress.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetwork) {
                throw "Set-InfobloxDNSRecord - Value '$Value' is not a valid IPv4 address."
            }
            [ordered]@{ ipv4addr = $Value }
        }
        'aaaa' {
            if (-not [System.Net.IPAddress]::TryParse($Value, [ref] $ParsedAddress) -or
                $ParsedAddress.AddressFamily -ne [System.Net.Sockets.AddressFamily]::InterNetworkV6) {
                throw "Set-InfobloxDNSRecord - Value '$Value' is not a valid IPv6 address."
            }
            [ordered]@{ ipv6addr = $Value }
        }
        'cname' {
            [ordered]@{ canonical = $Value }
        }
        'host' {
            [ordered]@{ name = $Value }
        }
        'mx' {
            $Body = [ordered]@{ mail_exchanger = $Value }
            if ($PreferenceSpecified) {
                $Body.preference = $Preference
            }
            $Body
        }
        'ns' {
            $Body = [ordered]@{ nameserver = $Value }
            if ($AddressSpecified) {
                $Body.addresses = @($Address | ForEach-Object { @{ address = $_ } })
            }
            $Body
        }
        'ptr' {
            [ordered]@{ ptrdname = $Value }
        }
        'txt' {
            [ordered]@{ text = $Value }
        }
        default {
            throw "Set-InfobloxDNSRecord - Record type '$Type' requires the Properties parameter set."
        }
    }
}

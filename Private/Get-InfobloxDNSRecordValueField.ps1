function Get-InfobloxDNSRecordValueField {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Type
    )

    switch (Resolve-InfobloxDNSRecordType -Type $Type) {
        'a' { 'ipv4addr' }
        'aaaa' { 'ipv6addr' }
        'cname' { 'canonical' }
        'mx' { 'mail_exchanger' }
        'ns' { 'nameserver' }
        'ptr' { 'ptrdname' }
        'txt' { 'text' }
    }
}

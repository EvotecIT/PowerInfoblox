function Get-InfobloxDNSRecordPreferredField {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Type
    )

    switch (Resolve-InfobloxDNSRecordType -Type $Type) {
        'a' {
            'name,ipv4addr,view,zone,comment,disable,ttl,use_ttl' -split ','
        }
        'aaaa' {
            'name,ipv6addr,view,zone,comment,disable,ttl,use_ttl' -split ','
        }
        'cname' {
            'name,canonical,view,zone,comment,disable,ttl,use_ttl' -split ','
        }
        'host' {
            'name,dns_name,aliases,dns_aliases,ipv4addrs,ipv6addrs,configure_for_dns,configure_for_dhcp,view,zone,comment,disable,ttl,use_ttl' -split ','
        }
        'mx' {
            'name,mail_exchanger,preference,view,zone,comment,disable,ttl,use_ttl' -split ','
        }
        'ns' {
            'name,nameserver,addresses,view,zone,extattrs' -split ','
        }
        'ptr' {
            'name,ptrdname,ipv4addr,ipv6addr,view,zone,comment,disable,ttl,use_ttl' -split ','
        }
        'txt' {
            'name,text,view,zone,comment,disable,ttl,use_ttl' -split ','
        }
    }
}

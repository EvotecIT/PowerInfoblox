function Get-InfobloxDNSRecordPreferredField {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Type
    )

    switch (Resolve-InfobloxDNSRecordType -Type $Type) {
        'a' {
            'ipv4addr,name,view,zone,cloud_info,comment,creation_time,creator,ddns_principal,ddns_protected,disable,discovered_data,dns_name,last_queried,ms_ad_user_data,reclaimable,shared_record_group,ttl,use_ttl' -split ','
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
            'aws_rte53_record_info,cloud_info,comment,creation_time,creator,ddns_principal,ddns_protected,disable,discovered_data,dns_name,dns_ptrdname,extattrs,forbid_reclamation,ipv4addr,ipv6addr,last_queried,ms_ad_user_data,name,ptrdname,reclaimable,shared_record_group,ttl,use_ttl,view,zone' -split ','
        }
        'txt' {
            'name,text,view,zone,comment,disable,ttl,use_ttl' -split ','
        }
    }
}

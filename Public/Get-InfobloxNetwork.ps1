function Get-InfobloxNetwork {
    [OutputType([system.object[]])]
    [cmdletbinding()]
    param(
        [string] $Network,
        [string[]]$ReturnFields,
        [switch] $Partial,
        [switch] $All,
        [int] $MaxResults = 1000000,
        [switch] $FetchFromSchema,
        [switch] $Native
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxNetwork - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "network"
    } elseif ($ReturnFields) {
        $ReturnFields = ($ReturnFields | Sort-Object -Unique) -join ','
    } else {
        if ($Native) {
            $ReturnFields = $Null
        } else {
            $ReturnFields = @(
                "authority", "bootfile", "bootserver", "cloud_info", "comment", "conflict_count", "ddns_domainname", "ddns_generate_hostname", "ddns_server_always_updates", "ddns_ttl", "ddns_update_fixed_addresses", "ddns_use_option81", "deny_bootp", "dhcp_utilization", "dhcp_utilization_status", "disable", "discover_now_status", "discovered_bgp_as", "discovered_bridge_domain", "discovered_tenant", "discovered_vlan_id", "discovered_vlan_name", "discovered_vrf_description", "discovered_vrf_name", "discovered_vrf_rd", "discovery_basic_poll_settings", "discovery_blackout_setting", "discovery_engine_type", "discovery_member", "dynamic_hosts", "email_list", "enable_ddns", "enable_dhcp_thresholds", "enable_discovery", "enable_email_warnings", "enable_ifmap_publishing", "enable_pxe_lease_time", "enable_snmp_warnings", "endpoint_sources", "extattrs", "high_water_mark", "high_water_mark_reset", "ignore_dhcp_option_list_request", "ignore_id", "ignore_mac_addresses", "ipam_email_addresses", "ipam_threshold_settings", "ipam_trap_settings", "ipv4addr", "last_rir_registration_update_sent", "last_rir_registration_update_status", "lease_scavenge_time", "logic_filter_rules", "low_water_mark", "low_water_mark_reset", "members", "mgm_private", "mgm_private_overridable", "ms_ad_user_data", "netmask", "network", "network_container", "network_view", "nextserver", "options", "port_control_blackout_setting", "pxe_lease_time", "recycle_leases", "rir", "rir_organization", "rir_registration_status", "same_port_control_discovery_blackout", "static_hosts", "subscribe_settings", "total_hosts", "unmanaged", "unmanaged_count", "update_dns_on_lease_renewal", "use_authority", "use_blackout_setting", "use_bootfile", "use_bootserver", "use_ddns_domainname", "use_ddns_generate_hostname", "use_ddns_ttl", "use_ddns_update_fixed_addresses", "use_ddns_use_option81", "use_deny_bootp", "use_discovery_basic_polling_settings", "use_email_list", "use_enable_ddns", "use_enable_dhcp_thresholds", "use_enable_discovery", "use_enable_ifmap_publishing", "use_ignore_dhcp_option_list_request", "use_ignore_id", "use_ipam_email_addresses", "use_ipam_threshold_settings", "use_ipam_trap_settings", "use_lease_scavenge_time", "use_logic_filter_rules", "use_mgm_private", "use_nextserver", "use_options", "use_pxe_lease_time", "use_recycle_leases", "use_subscribe_settings", "use_update_dns_on_lease_renewal", "use_zone_associations", "utilization", "utilization_update", "vlans", "zone_associations"
            ) -join ','
        }
    }

    $QueryParameter = [ordered]@{
        _return_fields = $ReturnFields
    }
    if ($All) {
        $QueryParameter["_max_results"] = $MaxResults
    } elseif ($Network -and $Partial.IsPresent) {
        $QueryParameter["_max_results"] = $MaxResults
        $QueryParameter."network~" = $Network
    } elseif ($Network) {
        $QueryParameter.network = $Network
    } else {
        Write-Warning -Message "Get-InfobloxNetwork - You must provide either -Network or -All switch"
        return
    }
    $ListNetworks = Invoke-InfobloxQuery -RelativeUri "network" -Method Get -QueryParameter $QueryParameter -WhatIf:$false
    foreach ($FoundNetwork in $ListNetworks) {
        if ($Native) {
            $FoundNetwork
        } else {
            $FullInformation = Get-IPAddressRangeInformation -Network $FoundNetwork.network
            $OutputData = [ordered] @{
                Network                              = $FoundNetwork.network
                NetworkRef                           = $FoundNetwork._ref
                IP                                   = $FullInformation.IP                   # : 10.2.10.0
                NetworkLength                        = $FullInformation.NetworkLength        # : 24
                SubnetMask                           = $FullInformation.SubnetMask           # : 255.255.255.0
                NetworkAddress                       = $FullInformation.NetworkAddress       # : 10.2.10.0
                HostMin                              = $FullInformation.HostMin              # : 10.2.10.1
                HostMax                              = $FullInformation.HostMax              # : 10.2.10.254
                TotalHosts                           = $FullInformation.TotalHosts           # : 256
                UsableHosts                          = $FullInformation.UsableHosts          # : 254
                Broadcast                            = $FullInformation.Broadcast            # : 10.2.10.255

                authority                            = $FoundNetwork.authority                            #: False
                cloud_info                           = $FoundNetwork.cloud_info                           #: @{authority_type=GM; delegated_scope=NONE; mgmt_platform=; owned_by_adaptor=False}
                comment                              = $FoundNetwork.comment                              #: found in CMDB
                conflict_count                       = $FoundNetwork.conflict_count                       #: 0
                ddns_generate_hostname               = $FoundNetwork.ddns_generate_hostname               #: False
                ddns_server_always_updates           = $FoundNetwork.ddns_server_always_updates           #: True
                ddns_ttl                             = $FoundNetwork.ddns_ttl                             #: 0
                ddns_update_fixed_addresses          = $FoundNetwork.ddns_update_fixed_addresses          #: False
                ddns_use_option81                    = $FoundNetwork.ddns_use_option81                    #: False
                deny_bootp                           = $FoundNetwork.deny_bootp                           #: False
                dhcp_utilization                     = $FoundNetwork.dhcp_utilization                     #: 0
                dhcp_utilization_status              = $FoundNetwork.dhcp_utilization_status              #: LOW
                disable                              = $FoundNetwork.disable                              #: False
                discover_now_status                  = $FoundNetwork.discover_now_status                  #: NONE
                discovered_bgp_as                    = $FoundNetwork.discovered_bgp_as                    #:
                discovered_bridge_domain             = $FoundNetwork.discovered_bridge_domain             #:
                discovered_tenant                    = $FoundNetwork.discovered_tenant                    #:
                discovered_vlan_id                   = $FoundNetwork.discovered_vlan_id                   #:
                discovered_vlan_name                 = $FoundNetwork.discovered_vlan_name                 #:
                discovered_vrf_description           = $FoundNetwork.discovered_vrf_description           #:
                discovered_vrf_name                  = $FoundNetwork.discovered_vrf_name                  #:
                discovered_vrf_rd                    = $FoundNetwork.discovered_vrf_rd                    #:
                discovery_basic_poll_settings        = $FoundNetwork.discovery_basic_poll_settings        #: @{auto_arp_refresh_before_switch_port_polling=True; cli_collection=True; complete_ping_sweep=False;
                #                                    = $FoundNetwork.                                     #  credential_group=default; device_profile=False; netbios_scanning=False; port_scanning=False;
                #                                    = $FoundNetwork.                                     #  smart_subnet_ping_sweep=False; snmp_collection=True; switch_port_data_collection_polling=PERIODIC;
                #                                    = $FoundNetwork.                                     #  switch_port_data_collection_polling_interval=3600}
                discovery_blackout_setting           = $FoundNetwork.discovery_blackout_setting           #: @{enable_blackout=False}
                discovery_engine_type                = $FoundNetwork.discovery_engine_type                #: NONE
                dynamic_hosts                        = $FoundNetwork.dynamic_hosts                        #: 0
                email_list                           = $FoundNetwork.email_list                           #: {}
                enable_ddns                          = $FoundNetwork.enable_ddns                          #: False
                enable_dhcp_thresholds               = $FoundNetwork.enable_dhcp_thresholds               #: False
                enable_discovery                     = $FoundNetwork.enable_discovery                     #: False
                enable_email_warnings                = $FoundNetwork.enable_email_warnings                #: False
                enable_ifmap_publishing              = $FoundNetwork.enable_ifmap_publishing              #: False
                enable_pxe_lease_time                = $FoundNetwork.enable_pxe_lease_time                #: False
                enable_snmp_warnings                 = $FoundNetwork.enable_snmp_warnings                 #: False
                #extattrs                             = $FoundNetwork.extattrs                             #: @{Country=; Name=; Region=}
                high_water_mark                      = $FoundNetwork.high_water_mark                      #: 95
                high_water_mark_reset                = $FoundNetwork.high_water_mark_reset                #: 85
                ignore_dhcp_option_list_request      = $FoundNetwork.ignore_dhcp_option_list_request      #: False
                ignore_id                            = $FoundNetwork.ignore_id                            #: NONE
                ignore_mac_addresses                 = $FoundNetwork.ignore_mac_addresses                 #: {}
                ipam_email_addresses                 = $FoundNetwork.ipam_email_addresses                 #: {}
                ipam_threshold_settings              = $FoundNetwork.ipam_threshold_settings              #: @{reset_value=85; trigger_value=95}
                ipam_trap_settings                   = $FoundNetwork.ipam_trap_settings                   #: @{enable_email_warnings=False; enable_snmp_warnings=True}
                ipv4addr                             = $FoundNetwork.ipv4addr                             #: 172.23.0.0
                lease_scavenge_time                  = $FoundNetwork.lease_scavenge_time                  #: -1
                logic_filter_rules                   = $FoundNetwork.logic_filter_rules                   #: {}
                low_water_mark                       = $FoundNetwork.low_water_mark                       #: 0
                low_water_mark_reset                 = $FoundNetwork.low_water_mark_reset                 #: 10
                members                              = $FoundNetwork.members                              #: {}
                mgm_private                          = $FoundNetwork.mgm_private                          #: False
                mgm_private_overridable              = $FoundNetwork.mgm_private_overridable              #: True
                netmask                              = $FoundNetwork.netmask                              #: 27
                network_container                    = $FoundNetwork.network_container                    #: 172.23.0.0/16
                network_view                         = $FoundNetwork.network_view                         #: default
                options                              = $FoundNetwork.options                              #: {@{name=dhcp-lease-time; num=51; use_option=False; value=43200; vendor_class=DHCP}}
                port_control_blackout_setting        = $FoundNetwork.port_control_blackout_setting        #: @{enable_blackout=False}
                recycle_leases                       = $FoundNetwork.recycle_leases                       #: True
                rir                                  = $FoundNetwork.rir                                  #: NONE
                rir_registration_status              = $FoundNetwork.rir_registration_status              #: NOT_REGISTERED
                same_port_control_discovery_blackout = $FoundNetwork.same_port_control_discovery_blackout #: False
                static_hosts                         = $FoundNetwork.static_hosts                         #: 0
                subscribe_settings                   = $FoundNetwork.subscribe_settings                   #:
                total_hosts                          = $FoundNetwork.total_hosts                          #: 0
                unmanaged                            = $FoundNetwork.unmanaged                            #: False
                unmanaged_count                      = $FoundNetwork.unmanaged_count                      #: 0
                update_dns_on_lease_renewal          = $FoundNetwork.update_dns_on_lease_renewal          #: False
                use_authority                        = $FoundNetwork.use_authority                        #: False
                use_blackout_setting                 = $FoundNetwork.use_blackout_setting                 #: False
                use_bootfile                         = $FoundNetwork.use_bootfile                         #: False
                use_bootserver                       = $FoundNetwork.use_bootserver                       #: False
                use_ddns_domainname                  = $FoundNetwork.use_ddns_domainname                  #: False
                use_ddns_generate_hostname           = $FoundNetwork.use_ddns_generate_hostname           #: False
                use_ddns_ttl                         = $FoundNetwork.use_ddns_ttl                         #: False
                use_ddns_update_fixed_addresses      = $FoundNetwork.use_ddns_update_fixed_addresses      #: False
                use_ddns_use_option81                = $FoundNetwork.use_ddns_use_option81                #: False
                use_deny_bootp                       = $FoundNetwork.use_deny_bootp                       #: False
                use_discovery_basic_polling_settings = $FoundNetwork.use_discovery_basic_polling_settings #: False
                use_email_list                       = $FoundNetwork.use_email_list                       #: False
                use_enable_ddns                      = $FoundNetwork.use_enable_ddns                      #: False
                use_enable_dhcp_thresholds           = $FoundNetwork.use_enable_dhcp_thresholds           #: False
                use_enable_discovery                 = $FoundNetwork.use_enable_discovery                 #: False
                use_enable_ifmap_publishing          = $FoundNetwork.use_enable_ifmap_publishing          #: False
                use_ignore_dhcp_option_list_request  = $FoundNetwork.use_ignore_dhcp_option_list_request  #: False
                use_ignore_id                        = $FoundNetwork.use_ignore_id                        #: False
                use_ipam_email_addresses             = $FoundNetwork.use_ipam_email_addresses             #: False
                use_ipam_threshold_settings          = $FoundNetwork.use_ipam_threshold_settings          #: False
                use_ipam_trap_settings               = $FoundNetwork.use_ipam_trap_settings               #: False
                use_lease_scavenge_time              = $FoundNetwork.use_lease_scavenge_time              #: False
                use_logic_filter_rules               = $FoundNetwork.use_logic_filter_rules               #: False
                use_mgm_private                      = $FoundNetwork.use_mgm_private                      #: False
                use_nextserver                       = $FoundNetwork.use_nextserver                       #: False
                use_options                          = $FoundNetwork.use_options                          #: False
                use_pxe_lease_time                   = $FoundNetwork.use_pxe_lease_time                   #: False
                use_recycle_leases                   = $FoundNetwork.use_recycle_leases                   #: False
                use_subscribe_settings               = $FoundNetwork.use_subscribe_settings               #: False
                use_update_dns_on_lease_renewal      = $FoundNetwork.use_update_dns_on_lease_renewal      #: False
                use_zone_associations                = $FoundNetwork.use_zone_associations                #: False
                utilization                          = $FoundNetwork.utilization                          #: 0
                utilization_update                   = $FoundNetwork.utilization_update                   #: 1707318915
                vlans                                = $FoundNetwork.vlans                                #: {}
                zone_associations                    = $FoundNetwork.zone_associations                    #: {}
                _ref                                 = $FoundNetwork._ref                                 #: network/ZG
            }
            foreach ($Extra in $FoundNetwork.extattrs.psobject.properties) {
                $OutputData[$Extra.Name] = $Extra.Value.value
            }
            [PSCustomObject]$OutputData
        }
    }
}
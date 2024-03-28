﻿function Get-InfobloxDNSAuthZone {
    [alias('Get-InfobloxDNSAuthZones')]
    [cmdletbinding()]
    param(
        [string] $FQDN,
        [string] $View
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDNSAuthZones - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'zone_auth'
        Method         = 'GET'
        QueryParameter = @{
            _max_results   = 1000000
            _return_fields = @(
                'address'
                'allow_active_dir'
                'allow_fixed_rrset_order'
                'allow_gss_tsig_for_underscore_zone'
                'allow_gss_tsig_zone_updates'
                'allow_query'
                'allow_transfer'
                'allow_update'
                'allow_update_forwarding'
                'aws_rte53_zone_info'
                'cloud_info'
                'comment'
                'copy_xfer_to_notify'
                'create_underscore_zones'
                'ddns_force_creation_timestamp_update'
                'ddns_principal_group'
                'ddns_principal_tracking'
                'ddns_restrict_patterns'
                'ddns_restrict_patterns_list'
                'ddns_restrict_protected'
                'ddns_restrict_secure'
                'ddns_restrict_static'
                'disable'
                'disable_forwarding'
                'display_domain'
                'dns_fqdn'
                'dns_integrity_enable'
                'dns_integrity_frequency'
                'dns_integrity_member'
                'dns_integrity_verbose_logging'
                'dns_soa_email'
                'dnssec_key_params'
                'dnssec_keys'
                'dnssec_ksk_rollover_date'
                'dnssec_zsk_rollover_date'
                'effective_check_names_policy'
                'effective_record_name_policy'
                'extattrs'
                'external_primaries'
                'external_secondaries'
                'fqdn'
                'grid_primary'
                'grid_primary_shared_with_ms_parent_delegation'
                'grid_secondaries'
                'is_dnssec_enabled'
                'is_dnssec_signed'
                'is_multimaster'
                'last_queried'
                'locked'
                'locked_by'
                'mask_prefix'
                'member_soa_mnames'
                'member_soa_serials'
                'ms_ad_integrated'
                'ms_allow_transfer'
                'ms_allow_transfer_mode'
                'ms_dc_ns_record_creation'
                'ms_ddns_mode'
                'ms_managed'
                'ms_primaries'
                'ms_read_only'
                'ms_secondaries'
                'ms_sync_disabled'
                'ms_sync_master_name'
                'network_associations'
                'network_view'
                'notify_delay'
                'ns_group'
                'parent'
                'prefix'
                'primary_type'
                'record_name_policy'
                'records_monitored'
                'rr_not_queried_enabled_time'
                'scavenging_settings'
                'soa_default_ttl'
                'soa_email'
                'soa_expire'
                'soa_negative_ttl'
                'soa_refresh'
                'soa_retry'
                'soa_serial_number'
                'srgs'
                'update_forwarding'
                'use_allow_active_dir'
                'use_allow_query'
                'use_allow_transfer'
                'use_allow_update'
                'use_allow_update_forwarding'
                'use_check_names_policy'
                'use_copy_xfer_to_notify'
                'use_ddns_force_creation_timestamp_update'
                'use_ddns_patterns_restriction'
                'use_ddns_principal_security'
                'use_ddns_restrict_protected'
                'use_ddns_restrict_static'
                'use_dnssec_key_params'
                'use_external_primary'
                'use_grid_zone_timer'
                'use_import_from'
                'use_notify_delay'
                'use_record_name_policy'
                'use_scavenging_settings'
                'use_soa_email'
                'using_srg_associations'
                'view'
                'zone_format'
                'zone_not_queried_enabled_time'
            ) -join ','
        }
    }
    if ($View) {
        $invokeInfobloxQuerySplat.QueryParameter.view = $View.ToLower()
    }
    if ($FQDN) {
        $invokeInfobloxQuerySplat.QueryParameter.fqdn = $FQDN.ToLower()
    }
    Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false | Select-ObjectByProperty -LastProperty '_ref'
}
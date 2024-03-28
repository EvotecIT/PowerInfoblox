function Get-InfobloxGrid {
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxGrid - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    # defalt return fields
    $ReturnFields = 'allow_recursive_deletion,audit_log_format,audit_to_syslog_enable,automated_traffic_capture_setting,consent_banner_setting,csp_api_config,csp_grid_setting,deny_mgm_snapshots,descendants_action,dns_resolver_setting,dscp,email_setting,enable_gui_api_for_lan_vip,enable_lom,enable_member_redirect,enable_recycle_bin,enable_rir_swip,external_syslog_backup_servers,external_syslog_server_enable,http_proxy_server_setting,informational_banner_setting,is_grid_visualization_visible,lockout_setting,lom_users,mgm_strict_delegate_mode,ms_setting,name,nat_groups,ntp_setting,objects_changes_tracking_setting,password_setting,restart_banner_setting,restart_status,rpz_hit_rate_interval,rpz_hit_rate_max_query,rpz_hit_rate_min_query,scheduled_backup,security_banner_setting,security_setting,service_status,snmp_setting,support_bundle_download_timeout,syslog_facility,syslog_servers,syslog_size,threshold_traps,time_zone,token_usage_delay,traffic_capture_auth_dns_setting,traffic_capture_chr_setting,traffic_capture_qps_setting,traffic_capture_rec_dns_setting,traffic_capture_rec_queries_setting,trap_notifications,updates_download_member_config,vpn_port'
    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "grid"
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'grid'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            _return_fields = $ReturnFields
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}
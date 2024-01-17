function Get-InfobloxMember {
    [cmdletbinding()]
    param(

    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxMember - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'member'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            _return_fields = 'config_addr_type,host_name,platform,service_type_configuration,vip_setting,node_info,service_status'
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}
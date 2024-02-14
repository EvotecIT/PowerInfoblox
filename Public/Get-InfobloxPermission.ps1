function Get-InfobloxPermission {
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        Write-Warning -Message 'Get-InfobloxPermissions - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    # defalt return fields
    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "permission"
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'permission'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            _return_fields = $ReturnFields
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}
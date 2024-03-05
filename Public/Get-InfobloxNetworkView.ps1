function Get-InfobloxNetworkView {
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxNetworkView - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    Write-Verbose -Message "Get-InfobloxNetworkView - Requesting Network View"

    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "networkview"
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'networkview'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            _return_fields = $ReturnFields
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}
function Get-InfobloxNetworkView {
    <#
    .SYNOPSIS
    Retrieves network views from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI networkview objects and returns the network views available
    to the current connection.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the networkview object by the connected WAPI schema.

    .EXAMPLE
    Get-InfobloxNetworkView

    Returns network views using the default WAPI fields.

    .EXAMPLE
    Get-InfobloxNetworkView -FetchFromSchema

    Returns network views with all fields advertised by the connected WAPI schema.
    #>
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
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}

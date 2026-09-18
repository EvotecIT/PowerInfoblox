function Get-InfobloxDiscoveryTask {
    <#
    .SYNOPSIS
    Retrieves discovery tasks from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI discoverytask objects and returns their properties with
    the object reference placed last.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the discoverytask object by the connected WAPI schema.

    .EXAMPLE
    Get-InfobloxDiscoveryTask

    Returns discovery tasks using the default WAPI fields.

    .EXAMPLE
    Get-InfobloxDiscoveryTask -FetchFromSchema

    Returns discovery tasks with all fields advertised by the connected WAPI schema.
    #>
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxDiscoveryTask - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    # defalt return fields
    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "discoverytask"
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'discoverytask'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            _return_fields = $ReturnFields
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}

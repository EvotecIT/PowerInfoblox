function Get-InfobloxVDiscoveryTask {
    <#
    .SYNOPSIS
    Retrieves virtual discovery tasks from an Infoblox server.

    .DESCRIPTION
    Queries Infoblox WAPI vdiscoverytask objects and returns their properties with
    the object reference placed last.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the vdiscoverytask object by the connected WAPI schema.

    .EXAMPLE
    Get-InfobloxVDiscoveryTask

    Returns virtual discovery tasks using the default WAPI fields.

    .EXAMPLE
    Get-InfobloxVDiscoveryTask -FetchFromSchema

    Returns virtual discovery tasks with all fields advertised by the connected WAPI schema.
    #>
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxVDiscoveryTask - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    # defalt return fields
    if ($FetchFromSchema) {
        $ReturnFields = Get-FieldsFromSchema -SchemaObject "vdiscoverytask"
    }

    $invokeInfobloxQuerySplat = @{
        RelativeUri    = 'vdiscoverytask'
        Method         = 'GET'
        QueryParameter = @{
            _max_results = 1000000
            _return_fields = $ReturnFields
        }
    }
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}

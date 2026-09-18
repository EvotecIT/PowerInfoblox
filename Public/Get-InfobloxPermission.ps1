function Get-InfobloxPermission {
    <#
    .SYNOPSIS
    Retrieves Infoblox permissions.

    .DESCRIPTION
    Queries Infoblox WAPI permission objects available to the connected account.

    .PARAMETER FetchFromSchema
    Requests every field advertised for the permission object by the connected WAPI schema.

    .EXAMPLE
    Get-InfobloxPermission

    Returns permissions using the default WAPI fields.

    .EXAMPLE
    Get-InfobloxPermission -FetchFromSchema

    Returns permissions with all fields advertised by the connected WAPI schema.
    #>
    [cmdletbinding()]
    param(
        [switch] $FetchFromSchema
    )

    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
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
    $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    $Output | Select-ObjectByProperty -LastProperty '_ref'
}

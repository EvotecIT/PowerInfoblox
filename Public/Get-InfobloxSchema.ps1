function Get-InfobloxSchema {
    <#
    .SYNOPSIS
    Get the schema for Infoblox as a whole or a specific object

    .DESCRIPTION
    Get the schema for Infoblox as a whole or a specific object

    .PARAMETER Object
    The object to get the schema for

    .PARAMETER ReturnReadOnlyFields
    Return only read-only fields in format suitable for use with Invoke-InfobloxQuery

    .PARAMETER ReturnWriteFields
    Return only write fields in format suitable for use with Invoke-InfobloxQuery

    .PARAMETER ReturnFields
    Return all fields in full objects

    .EXAMPLE
    Get-InfobloxSchema

    .EXAMPLE
    Get-InfobloxSchema -Object 'record:host'

    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [string] $Object,
        [switch] $ReturnReadOnlyFields,
        [switch] $ReturnWriteFields,
        [switch] $ReturnFields
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Get-InfobloxSchema - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }
    if ($Object) {
        $invokeInfobloxQuerySplat = @{
            RelativeUri = "$($Object.ToLower())?_schema"
            Method      = 'Get'
        }
    } else {
        $invokeInfobloxQuerySplat = @{
            RelativeUri = "?_schema"
            Method      = 'Get'
        }
    }
    $Query = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WhatIf:$false
    if ($Query) {
        if ($ReturnReadOnlyFields) {
            Get-FieldsFromSchema -Schema $Query -SchemaObject $Object
        } elseif ($ReturnWriteFields) {
            Get-FieldsFromSchema -Schema $Query -SchemaObject $Object -Supports 'w'
        } elseif ($ReturnFields) {
            $Query.Fields
        } else {
            $Query
        }
    } else {
        Write-Warning -Message 'Get-InfobloxSchema - No schema returned'
    }
}

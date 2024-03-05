function Get-InfobloxSchema {
    <#
    .SYNOPSIS
    Get the schema for Infoblox as a whole or a specific object

    .DESCRIPTION
    Get the schema for Infoblox as a whole or a specific object

    .PARAMETER Object
    The object to get the schema for

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
        [switch] $ReturnReadOnlyFields
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
            RelativeUri = "$($Object.ToLower())"
            Method      = 'Get'
            Query       = @{
                _schema = $true
            }
        }
    } else {
        $invokeInfobloxQuerySplat = @{
            RelativeUri = "?_schema"
            Method      = 'Get'
        }
    }
    $Query = Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    if ($Query) {
        if ($ReturnReadOnlyFields) {
            Get-FieldsFromSchema -Schema $Query -SchemaObject $Object
        } else {
            $Query
        }
    } else {
        Write-Warning -Message 'Get-InfobloxSchema - No schema returned'
    }
}
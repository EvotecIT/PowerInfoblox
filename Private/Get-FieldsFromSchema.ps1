function Get-FieldsFromSchema {
    [CmdletBinding()]
    param(
        [PSCustomobject] $Schema,
        [string] $SchemaObject
    )
    if (-not $Script:InfobloxSchemaFields) {
        $Script:InfobloxSchemaFields = [ordered] @{}
    }
    if ($Script:InfobloxSchemaFields[$SchemaObject]) {
        $Script:InfobloxSchemaFields[$SchemaObject]
    } else {
        if (-not $Schema) {
            $Schema = Get-InfobloxSchema -Object $SchemaObject
        }
        if ($Schema -and $Schema.fields.name) {
            $FilteredFields = foreach ($Field in $Schema.fields) {
                if ($Field.supports -like "*r*") {
                    $Field.Name
                }
            }
            $Script:InfobloxSchemaFields[$SchemaObject] = ($FilteredFields -join ',')
            $Script:InfobloxSchemaFields[$SchemaObject]
        } else {
            Write-Warning -Message "Get-FieldsFromSchema - Failed to fetch schema for record type 'allrecords'. Using defaults"
        }
    }
}
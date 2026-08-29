function Get-FieldsFromSchema {
    [CmdletBinding()]
    param(
        [PSCustomobject] $Schema,
        [string] $SchemaObject,
        [string[]] $RequestedFields
    )

    if (-not $Script:InfobloxSchemaFields) {
        $Script:InfobloxSchemaFields = [ordered] @{}
    }

    if ($SchemaObject) {
        $NormalizedSchemaObject = $SchemaObject.ToLowerInvariant()
        $SchemaDescription = $SchemaObject
    } else {
        $NormalizedSchemaObject = '__root__'
        $SchemaDescription = 'root'
    }
    $BaseUri = $Script:InfobloxConfiguration.BaseUri
    if ($BaseUri) {
        $CacheKey = '{0}|{1}' -f $BaseUri.ToString().TrimEnd([char] '/').ToLowerInvariant(), $NormalizedSchemaObject
    } else {
        $CacheKey = $NormalizedSchemaObject
    }

    if ($Script:InfobloxSchemaFields.Contains($CacheKey)) {
        $ReadableFields = @($Script:InfobloxSchemaFields[$CacheKey])
    } else {
        if (-not $Schema) {
            try {
                if ($SchemaObject) {
                    $Schema = Get-InfobloxSchema -Object $SchemaObject -WarningAction SilentlyContinue -ErrorAction Stop
                } else {
                    $Schema = Get-InfobloxSchema -WarningAction SilentlyContinue -ErrorAction Stop
                }
            } catch {
                $Schema = $null
            }
        }

        if ($Schema -and $Schema.fields.name) {
            $ReadableFields = @(
                foreach ($Field in $Schema.fields) {
                    if ($Field.supports -like '*r*') {
                        $Field.Name
                    }
                }
            )
            $Script:InfobloxSchemaFields[$CacheKey] = $ReadableFields
        } else {
            Write-Warning -Message "Get-FieldsFromSchema - Failed to fetch schema for record type '$SchemaDescription'. Using server default fields"
            return
        }
    }

    if ($RequestedFields) {
        $ReadableFieldLookup = @{}
        foreach ($FieldName in $ReadableFields) {
            $ReadableFieldLookup[$FieldName] = $true
        }
        $ReadableFields = @(
            foreach ($FieldName in $RequestedFields) {
                if ($ReadableFieldLookup.ContainsKey($FieldName)) {
                    $FieldName
                }
            }
        )
    }

    $ReadableFields -join ','
}

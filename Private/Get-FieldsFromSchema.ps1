function Get-FieldsFromSchema {
    [CmdletBinding()]
    param(
        [PSCustomobject] $Schema,
        [string] $SchemaObject,
        [string[]] $RequestedFields,
        [ValidateSet('r', 'w', 'u', 's')]
        [string] $Supports = 'r'
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
        $CacheKey = '{0}|{1}|{2}' -f $BaseUri.ToString().TrimEnd([char] '/').ToLowerInvariant(), $NormalizedSchemaObject, $Supports
    } else {
        $CacheKey = '{0}|{1}' -f $NormalizedSchemaObject, $Supports
    }

    if ($Script:InfobloxSchemaFields.Contains($CacheKey)) {
        $SupportedFields = @($Script:InfobloxSchemaFields[$CacheKey])
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
            $SupportedFields = @(
                foreach ($Field in $Schema.fields) {
                    if ($Field.supports -like "*$Supports*") {
                        $Field.Name
                    }
                }
            )
            $Script:InfobloxSchemaFields[$CacheKey] = $SupportedFields
        } else {
            Write-Warning -Message "Get-FieldsFromSchema - Failed to fetch schema for record type '$SchemaDescription'. Using server default fields"
            return
        }
    }

    if ($RequestedFields) {
        $SupportedFieldLookup = @{}
        foreach ($FieldName in $SupportedFields) {
            $SupportedFieldLookup[$FieldName] = $true
        }
        $SupportedFields = @(
            foreach ($FieldName in $RequestedFields) {
                if ($SupportedFieldLookup.ContainsKey($FieldName)) {
                    $FieldName
                }
            }
        )
    }

    $SupportedFields -join ','
}

function ConvertTo-InfobloxExtattrs {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][System.Collections.IDictionary] $Attributes
    )

    $Extattrs = [ordered] @{}
    foreach ($Key in $Attributes.Keys) {
        $RawValue = $Attributes[$Key]
        if ($null -eq $RawValue) {
            continue
        }

        if ($RawValue -is [System.Collections.IDictionary]) {
            $ResolvedDictionary = [ordered] @{}
            foreach ($DictionaryKey in $RawValue.Keys) {
                $ResolvedDictionary[$DictionaryKey] = $RawValue[$DictionaryKey]
            }
            if ($ResolvedDictionary.Contains('value')) {
                $ResolvedDictionary['value'] = Resolve-InfobloxExtensibleAttributeValue -Name $Key -Value $ResolvedDictionary['value']
            } elseif ($ResolvedDictionary.Contains('values')) {
                $ResolvedDictionary['values'] = Resolve-InfobloxExtensibleAttributeValue -Name $Key -Value $ResolvedDictionary['values']
            }
            $Extattrs[$Key] = $ResolvedDictionary
        } else {
            $ResolvedValue = Resolve-InfobloxExtensibleAttributeValue -Name $Key -Value $RawValue
            $Extattrs[$Key] = @{
                value = $ResolvedValue
            }
        }
    }

    $Extattrs
}

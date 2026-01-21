function Resolve-InfobloxExtensibleAttributeValueSingle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Name,
        [Parameter(Mandatory)] $Value,
        [Parameter(Mandatory)][hashtable] $MapByValue,
        [Parameter(Mandatory)][hashtable] $Ids
    )

    if ($null -eq $Value) {
        return $null
    }

    $Candidate = if ($Value -is [string]) { $Value } else { [string] $Value }

    if ($Ids.ContainsKey($Candidate)) {
        return $Candidate
    }
    if ($MapByValue.ContainsKey($Candidate)) {
        return $MapByValue[$Candidate]
    }

    $Available = $MapByValue.Keys -join ', '
    $Message = "Resolve-InfobloxExtensibleAttributeValue - Extensible attribute '$Name' value '$Candidate' not found in list. Available values: $Available"
    if ($ErrorActionPreference -eq 'Stop') {
        throw $Message
    }
    Write-Warning -Message $Message
    return $Candidate
}

function Resolve-InfobloxExtensibleAttributeValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string] $Name,
        [Parameter(Mandatory)] $Value
    )

    $Definition = Get-InfobloxExtensibleAttributeDefinition -Name $Name
    if (-not $Definition) {
        $Message = "Resolve-InfobloxExtensibleAttributeValue - Extensible attribute '$Name' definition not found."
        if ($ErrorActionPreference -eq 'Stop') {
            throw $Message
        }
        Write-Warning -Message $Message
        return $Value
    }

    $ListValues = $Definition.list_values
    if (-not $ListValues) {
        return $Value
    }

    $ListValues = @($ListValues)
    $MapByValue = @{}
    $Ids = @{}
    foreach ($Item in $ListValues) {
        if ($null -ne $Item.value) {
            $IdValue = if ($null -ne $Item.id -and $Item.id -ne '') { $Item.id } else { $Item.value }
            if (-not $MapByValue.ContainsKey($Item.value)) {
                $MapByValue[$Item.value] = $IdValue
            }
        }
        if ($null -ne $Item.id -and $Item.id -ne '') {
            if (-not $Ids.ContainsKey($Item.id)) {
                $Ids[$Item.id] = $true
            }
        }
    }

    if ($Value -is [System.Collections.IEnumerable] -and -not ($Value -is [string])) {
        $Resolved = foreach ($Item in $Value) {
            Resolve-InfobloxExtensibleAttributeValueSingle -Name $Name -Value $Item -MapByValue $MapByValue -Ids $Ids
        }
        return ,$Resolved
    }

    Resolve-InfobloxExtensibleAttributeValueSingle -Name $Name -Value $Value -MapByValue $MapByValue -Ids $Ids
}

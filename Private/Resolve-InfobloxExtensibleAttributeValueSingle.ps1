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

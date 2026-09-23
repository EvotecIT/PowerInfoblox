function Find-InfobloxDNSManagedObject {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('view', 'zone_auth', 'zone_forward', 'zone_delegated', 'zone_rp', 'zone_stub')]
        [string] $ObjectType,

        [Parameter(Mandatory, ParameterSetName = 'ByName')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(ParameterSetName = 'ByName')]
        [string] $View,

        [Parameter(Mandatory, ParameterSetName = 'ByReference')]
        [ValidateNotNullOrEmpty()]
        [string] $ReferenceID
    )

    $NameField = if ($ObjectType -eq 'view') { 'name' } else { 'fqdn' }
    if ($PSCmdlet.ParameterSetName -eq 'ByName') {
        $NormalizedName = if ($ObjectType -eq 'view') { $Name } else { Normalize-InfobloxDNSZoneName -Name $Name }
    }
    if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
        if (-not $ReferenceID.StartsWith("$ObjectType/", [System.StringComparison]::OrdinalIgnoreCase)) {
            throw "ReferenceID '$ReferenceID' does not identify a $ObjectType object."
        }
        $RelativeUri = $ReferenceID
        $QueryParameter = @{}
    } else {
        $RelativeUri = $ObjectType
        $QueryParameter = @{ _max_results = 1000000 }
        $QueryParameter[$NameField] = $NormalizedName
    }

    $PreferredFields = if ($ObjectType -eq 'view') {
        @('name', 'is_default', 'network_view', 'comment')
    } else {
        @('fqdn', 'view', 'comment', 'disable')
    }
    $ReturnFields = Get-FieldsFromSchema -SchemaObject $ObjectType -RequestedFields $PreferredFields
    if ($ReturnFields) {
        $QueryParameter._return_fields = $ReturnFields
    }
    [Array] $Candidates = @(Invoke-InfobloxQuery -RelativeUri $RelativeUri -Method GET -QueryParameter $QueryParameter -WhatIf:$false)
    [Array] $Selected = @(
        if ($PSCmdlet.ParameterSetName -eq 'ByReference') {
            $Candidates | Where-Object { -not $_._ref -or $_._ref -ceq $ReferenceID }
        } else {
            $Candidates | Where-Object {
                $_.$NameField -and
                $(if ($ObjectType -eq 'view') { [string] $_.$NameField } else { Normalize-InfobloxDNSZoneName -Name ([string] $_.$NameField) }) -ieq $NormalizedName -and
                (-not $View -or ($_.view -and ([string] $_.view) -ieq $View))
            }
        }
    )
    if ($PSCmdlet.ParameterSetName -eq 'ByReference' -and $Selected.Count -eq 1 -and -not $Selected[0]._ref) {
        $Selected[0] | Add-Member -NotePropertyName '_ref' -NotePropertyValue $ReferenceID
    }

    [pscustomobject]@{
        Candidates = $Candidates
        Selected   = $Selected
    }
}

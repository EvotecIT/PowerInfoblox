function Select-ObjectByProperty {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline)][Array] $Object,
        [System.Collections.IDictionary] $AddObject,
        [alias('FirstProperty')][Parameter()][string[]] $FirstProperties,
        [alias('LastProperty')][Parameter()][string[]] $LastProperties,
        [string[]] $AllProperties
    )
    process {
        foreach ($O in $Object) {
            # If we have an object, we can get the properties from it
            # we assume user can provide AllProperties instead of current object properties
            $Properties = if ($AllProperties) { $AllProperties } else { $O.PSObject.Properties.Name }

            $ReturnObject = [ordered] @{}
            foreach ($Property in $FirstProperties) {
                if ($Properties -contains $Property) {
                    $ReturnObject[$Property] = $O.$Property
                }
            }
            if ($AddObject) {
                foreach ($Property in $AddObject.Keys) {
                    $ReturnObject[$Property] = $AddObject[$Property]
                }
            }
            foreach ($Property in $Properties) {
                if ($Property -notin $LastProperties -and $Property -notin $FirstProperties) {
                    $ReturnObject[$Property] = $O.$Property
                }
            }
            foreach ($Property in $LastProperties) {
                if ($Properties -contains $Property) {
                    $ReturnObject[$Property] = $O.$Property
                }
            }
            [pscustomobject]$ReturnObject
        }
    }
}
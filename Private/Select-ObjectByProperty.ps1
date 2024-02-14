function Select-ObjectByProperty {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline)][Array] $Object,
        [System.Collections.IDictionary] $AddObject,
        [alias('FirstProperty')][Parameter()][string[]] $FirstProperties,
        [alias('LastProperty')][Parameter()][string[]] $LastProperties
    )
    process {
        foreach ($O in $Object) {
            $ReturnObject = [ordered] @{}
            foreach ($Property in $FirstProperties) {
                if ($O.PSObject.Properties.Name -contains $Property) {
                    $ReturnObject[$Property] = $O.$Property
                }
            }
            if ($AddObject) {
                foreach ($Property in $AddObject.Keys) {
                    $ReturnObject[$Property] = $AddObject[$Property]
                }
            }
            foreach ($Property in $O.PSObject.Properties.Name) {
                if ($Property -notin $LastProperties -and $Property -notin $FirstProperties) {
                    $ReturnObject[$Property] = $O.$Property
                }
            }
            foreach ($Property in $LastProperties) {
                if ($O.PSObject.Properties.Name -contains $Property) {
                    $ReturnObject[$Property] = $O.$Property
                }
            }
            [pscustomobject]$ReturnObject
        }
    }
}
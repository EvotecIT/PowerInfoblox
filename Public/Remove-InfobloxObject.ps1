function Remove-InfobloxObject {
    <#
    .SYNOPSIS
    Remove an Infoblox object by reference ID

    .DESCRIPTION
    Remove an Infoblox object by reference ID
    It can be used to remove any object type, but it is recommended to use the more specific cmdlets

    .PARAMETER Objects
    An array of objects to remove

    .PARAMETER ReferenceID
    The reference ID of the object to remove

    .EXAMPLE
    Remove-InfobloxObject -ReferenceID 'record:host/ZG5zLmhvc3QkLl9kZWZhdWx0LmNvbS5pbmZvLmhvc3Q6MTcyLjI2LjEuMjAu:'

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'ReferenceID')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Array')][Array] $Objects,
        [parameter(Mandatory, ParameterSetName = 'ReferenceID')][string] $ReferenceID
    )
    if (-not $Script:InfobloxConfiguration) {
        if ($ErrorActionPreference -eq 'Stop') {
            throw 'You must first connect to an Infoblox server using Connect-Infoblox'
        }
        Write-Warning -Message 'Remove-InfobloxObject - You must first connect to an Infoblox server using Connect-Infoblox'
        return
    }

    if ($Objects) {
        $Objects | ForEach-Object {
            if ($_._ref) {
                $ReferenceID = $_._ref
                Remove-InfobloxObject -ReferenceID $ReferenceID
            } else {
                Write-Warning -Message "Remove-InfobloxObject - Object does not have a reference ID: $_"
            }
        }
    } else {
        $invokeInfobloxQuerySplat = @{
            RelativeUri = $ReferenceID
            Method      = 'DELETE'
        }
        $Output = Invoke-InfobloxQuery @invokeInfobloxQuerySplat -WarningAction SilentlyContinue -WarningVariable varWarning
        if ($Output) {
            Write-Verbose -Message "Remove-InfobloxObject - Removed $($ReferenceID) / $Output"
        } else {
            Write-Warning -Message "Remove-InfobloxObject - Failed to remove $ReferenceID, error: $varWarning"
        }
    }
}
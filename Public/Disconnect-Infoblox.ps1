function Disconnect-Infoblox {
    <#
    .SYNOPSIS
    Disconnects from an InfoBlox server

    .DESCRIPTION
    Disconnects from an InfoBlox server
    As this is a REST API it doesn't really disconnect, but it does clear the script variable to clear the credentials from memory

    .EXAMPLE
    Disconnect-Infoblox

    .NOTES
    General notes
    #>
    [cmdletbinding(SupportsShouldProcess)]
    param(
        [switch] $ForceLogOut
    )

    if ($ForceLogOut) {
        $invokeInfobloxQuerySplat = @{
            RelativeUri = "logout"
            Method      = 'POST'
        }
        Invoke-InfobloxQuery @invokeInfobloxQuerySplat
    }
    # lets remove the default parameters so that user has to connect again
    $Script:InfobloxConfiguration = $null
    $PSDefaultParameterValues.Remove('Invoke-InfobloxQuery:Credential')
    $PSDefaultParameterValues.Remove('Invoke-InfobloxQuery:Server')
    $PSDefaultParameterValues.Remove('Invoke-InfobloxQuery:BaseUri')
    $PSDefaultParameterValues.Remove('Invoke-InfobloxQuery:WebSession')
}
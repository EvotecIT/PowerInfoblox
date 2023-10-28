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
    [cmdletbinding()]
    param()
    $Script:InfobloxConfiguration = $null
}
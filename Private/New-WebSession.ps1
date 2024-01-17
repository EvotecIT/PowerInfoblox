function New-WebSession {
    [cmdletbinding()]
    param(
        [System.Collections.IDictionary]$Cookies,
        [Uri]$For
    )

    $newSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()

    foreach ($entry in $Cookies.GetEnumerator()) {
        $cookie = [System.Net.Cookie]::new($entry.Name, $entry.Value)
        if ($For) {
            $newSession.Cookies.Add([uri]::new($For, '/'), $cookie)
        } else {
            $newSession.Cookies.Add($cookie)
        }
    }

    $newSession
}
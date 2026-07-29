function ConvertTo-InfobloxComment {
    [CmdletBinding()]
    param(
        [AllowNull()]
        [object] $Comment
    )

    if ($null -eq $Comment) {
        return ''
    }
    if (($Comment -is [bool] -or $Comment -is [System.Management.Automation.SwitchParameter]) -and -not [bool] $Comment) {
        return ''
    }
    $CommentText = [string] $Comment
    if ([string]::IsNullOrWhiteSpace($CommentText)) {
        return ''
    }
    $CommentText
}

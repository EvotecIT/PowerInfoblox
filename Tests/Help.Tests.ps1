$manifestPath = Join-Path (Split-Path $PSScriptRoot -Parent) 'PowerInfoblox.psd1'
$manifest = Import-PowerShellDataFile -Path $manifestPath
$exportedFunctions = @($manifest.FunctionsToExport | Sort-Object)
$exportedAliases = @($manifest.AliasesToExport | Sort-Object)

Describe 'Exported command help' {
    It '<_> has useful comment-based help' -ForEach $exportedFunctions {
        $command = Get-Command -Name $_ -Module PowerInfoblox -CommandType Function -ErrorAction Stop
        $help = Get-Help -Name $command.Name -Full

        ([string] $help.Synopsis) | Should -Not -BeNullOrEmpty
        ([string] $help.Description.Text) | Should -Not -BeNullOrEmpty
        @($help.Examples.Example).Count | Should -BeGreaterThan 0
        ($help | Out-String) | Should -Not -Match 'Short description|Long description|Parameter description|General notes'
    }

    It '<_> documents every command-specific parameter' -ForEach $exportedFunctions {
        $command = Get-Command -Name $_ -Module PowerInfoblox -CommandType Function -ErrorAction Stop
        $help = Get-Help -Name $command.Name -Full
        $helpParameters = @($help.Parameters.Parameter)
        $commonParameterNames = @(
            'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
            'ProgressAction', 'ErrorVariable', 'WarningVariable', 'InformationVariable',
            'OutVariable', 'OutBuffer', 'PipelineVariable', 'WhatIf', 'Confirm'
        )
        $commandParameterNames = @(
            $command.Parameters.Keys | Where-Object { $_ -notin $commonParameterNames }
        )

        foreach ($parameterName in $commandParameterNames) {
            $parameterHelp = @($helpParameters | Where-Object Name -EQ $parameterName)
            $parameterHelp.Count | Should -Be 1 -Because "$($command.Name) -$parameterName needs one .PARAMETER section"
            ([string] $parameterHelp[0].Description.Text) | Should -Not -BeNullOrEmpty
        }
    }

    It '<_> resolves to an exported PowerInfoblox function' -ForEach $exportedAliases {
        $alias = Get-Command -Name $_ -Module PowerInfoblox -CommandType Alias -ErrorAction Stop

        $alias.ResolvedCommand.CommandType | Should -Be 'Function'
        $alias.ResolvedCommand.ModuleName | Should -Be 'PowerInfoblox'
    }
}

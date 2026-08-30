Describe 'Set-InfobloxNetworkMembers' {
    InModuleScope PowerInfoblox {
        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.12' }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = 'https://example.test/wapi/v2.12'
            $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = [pscredential]::new('user', (ConvertTo-SecureString 'pass' -AsPlainText -Force))
        }

        It 'returns warning when no members inputs are provided' {
            Mock Write-Warning {}
            Set-InfobloxNetworkMembers -Network '10.46.5.128/25'
            Should -Invoke -CommandName Write-Warning -Times 1
        }

        It 'builds members payload from Network with defaults' {
            $result = [pscustomobject]@{
                _ref          = 'network/ref'
                members       = @(
                    @{ _struct = 'msdhcpserver'; ipv4addr = 'a' },
                    @{ _struct = 'msdhcpserver'; ipv4addr = 'b' }
                )
                network       = '10.46.5.128/25'
                network_view  = 'default'
            }
            $script:putBody = $null
            $script:getQueryParameter = $null
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $BaseUri)
                if ($Method -eq 'GET') {
                    $script:getQueryParameter = $QueryParameter
                    return $result
                }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -Members @('b', 'c') | Out-Null

            Should -Invoke -CommandName Invoke-InfobloxQuery -ParameterFilter { $Method -eq 'PUT' } -Times 1
            $script:getQueryParameter.Contains('_return_fields') | Should -BeFalse
            $script:putBody.members | Should -HaveCount 2
            $script:putBody.members[0]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[0].ipv4addr | Should -Be 'b'
            $script:putBody.members[1]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[1].ipv4addr | Should -Be 'c'
        }

        It 'does not update an arbitrary network when lookup returns multiple matches' {
            $result = @(
                [pscustomobject]@{ _ref = 'network/one' }
                [pscustomobject]@{ _ref = 'network/two' }
            )
            Mock Invoke-InfobloxQuery -MockWith {
                if ($Method -eq 'GET') { return $result }
                return @{ ok = $true }
            }
            Mock Write-Error

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -Members 'a'

            Should -Invoke -CommandName Write-Error -Times 1 -ParameterFilter {
                $Category -eq 'InvalidData' -and $Message -like '*Multiple networks were returned*'
            }
            Should -Invoke -CommandName Invoke-InfobloxQuery -ParameterFilter { $Method -eq 'PUT' } -Times 0 -Exactly
        }

        It 'adds members without duplicates' {
            $result = [pscustomobject]@{
                _ref    = 'network/ref'
                members = @(
                    @{ _struct = 'msdhcpserver'; ipv4addr = 'a' }
                )
            }
            $script:putBody = $null
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $BaseUri)
                if ($Method -eq 'GET') { return $result }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -AddMembers @('a', 'b') | Out-Null

            $script:putBody.members | Should -HaveCount 2
            $script:putBody.members[0]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[0].ipv4addr | Should -Be 'a'
            $script:putBody.members[1]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[1].ipv4addr | Should -Be 'b'
        }

        It 'removes members from current list' {
            $result = [pscustomobject]@{
                _ref    = 'network/ref'
                members = @(
                    @{ _struct = 'msdhcpserver'; ipv4addr = 'a' },
                    @{ _struct = 'msdhcpserver'; ipv4addr = 'b' }
                )
            }
            $script:putBody = $null
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $BaseUri)
                if ($Method -eq 'GET') { return $result }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -RemoveMembers @('a') | Out-Null

            $script:putBody.members | Should -HaveCount 1
            $script:putBody.members[0]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[0].ipv4addr | Should -Be 'b'
        }

        It 'preserves heterogeneous member structures and metadata when adding a member' {
            $result = [pscustomobject]@{
                _ref    = 'network/ref'
                members = @(
                    [pscustomobject]@{ _struct = 'dhcpmember'; name = 'dhcp-a'; metadata = 'keep-name' }
                    [pscustomobject]@{ _struct = 'msdhcpserver'; ipv4addr = 'a'; metadata = 'keep-address' }
                )
            }
            $script:putBody = $null
            Mock Invoke-InfobloxQuery -MockWith {
                if ($Method -eq 'GET') { return $result }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -AddMembers 'b' | Out-Null

            $script:putBody.members | Should -HaveCount 3
            $script:putBody.members[0]._struct | Should -Be 'dhcpmember'
            $script:putBody.members[0].name | Should -Be 'dhcp-a'
            $script:putBody.members[0].metadata | Should -Be 'keep-name'
            $script:putBody.members[1]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[1].metadata | Should -Be 'keep-address'
            $script:putBody.members[2]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[2].ipv4addr | Should -Be 'b'
        }

        It 'removes matching members without rewriting unrelated member structures' {
            $result = [pscustomobject]@{
                _ref    = 'network/ref'
                members = @(
                    [pscustomobject]@{ _struct = 'dhcpmember'; name = 'dhcp-a'; metadata = 'keep-name' }
                    [pscustomobject]@{ _struct = 'msdhcpserver'; ipv4addr = 'a'; metadata = 'remove-address' }
                    [pscustomobject]@{ _struct = 'msdhcpserver'; ipv4addr = 'b'; metadata = 'keep-address' }
                )
            }
            $script:putBody = $null
            Mock Invoke-InfobloxQuery -MockWith {
                if ($Method -eq 'GET') { return $result }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -RemoveMembers 'a' | Out-Null

            $script:putBody.members | Should -HaveCount 2
            $script:putBody.members[0]._struct | Should -Be 'dhcpmember'
            $script:putBody.members[0].name | Should -Be 'dhcp-a'
            $script:putBody.members[0].metadata | Should -Be 'keep-name'
            $script:putBody.members[1].ipv4addr | Should -Be 'b'
            $script:putBody.members[1].metadata | Should -Be 'keep-address'
        }

        It 'does not overwrite members when the Grid cannot return the current list' {
            $result = [pscustomobject]@{
                _ref         = 'network/ref'
                network      = '10.46.5.128/25'
                network_view = 'default'
            }
            Mock Get-FieldsFromSchema
            Mock Invoke-InfobloxQuery -MockWith {
                if ($Method -eq 'GET') { return $result }
                return @{ ok = $true }
            }
            Mock Write-Error

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -AddMembers 'b'

            Should -Invoke -CommandName Write-Error -Times 1 -ParameterFilter {
                $Category -eq 'InvalidData' -and $Message -like '*cannot safely calculate an update*'
            }
            Should -Invoke -CommandName Invoke-InfobloxQuery -ParameterFilter { $Method -eq 'PUT' } -Times 0 -Exactly
        }

        It 'fetches members by reference without requiring schema access' {
            $result = [pscustomobject]@{
                _ref         = 'network/ref'
                network      = '10.46.5.128/25'
                network_view = 'default'
            }
            $memberResult = [pscustomobject]@{
                _ref    = 'network/ref'
                members = @(
                    @{ _struct = 'msdhcpserver'; ipv4addr = 'a' }
                )
            }
            $script:memberQueryParameter = $null
            $script:putBody = $null
            Mock Get-FieldsFromSchema -MockWith { throw 'Schema access denied' }
            Mock Invoke-InfobloxQuery -MockWith {
                if ($Method -eq 'GET' -and $RelativeUri -eq 'network') { return $result }
                if ($Method -eq 'GET' -and $RelativeUri -eq 'network/ref') {
                    $script:memberQueryParameter = $QueryParameter
                    return $memberResult
                }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -AddMembers 'b' | Out-Null

            $script:memberQueryParameter._return_fields | Should -Be 'members'
            $script:putBody.members.ipv4addr | Should -Be @('a', 'b')
            Should -Invoke -CommandName Get-FieldsFromSchema -Times 0 -Exactly
        }

        It 'supports custom member struct and property' {
            $result = [pscustomobject]@{
                _ref    = 'network/ref'
                members = @()
            }
            $script:putBody = $null
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $BaseUri)
                if ($Method -eq 'GET') { return $result }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -MemberStruct 'dhcpmember' -MemberProperty 'name' -Members @('dhcp01') | Out-Null

            $script:putBody.members | Should -HaveCount 1
            $script:putBody.members[0]._struct | Should -Be 'dhcpmember'
            $script:putBody.members[0].name | Should -Be 'dhcp01'
        }

        It 'allows clearing members with empty list' {
            $result = [pscustomobject]@{
                _ref    = 'network/ref'
                members = @(
                    @{ _struct = 'msdhcpserver'; ipv4addr = 'a' }
                )
            }
            $script:putBody = $null
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $BaseUri)
                if ($Method -eq 'GET') { return $result }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -Members @() | Out-Null

            $script:putBody.members | Should -Be @()
        }
    }
}

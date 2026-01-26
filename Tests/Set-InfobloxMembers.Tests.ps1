Describe 'Set-InfobloxMembers' {
    InModuleScope PowerInfoblox {
        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.12' }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = 'https://example.test/wapi/v2.12'
            $PSDefaultParameterValues['Invoke-InfobloxQuery:Credential'] = [pscredential]::new('user', (ConvertTo-SecureString 'pass' -AsPlainText -Force))
        }

        It 'returns warning when no members inputs are provided' {
            Mock Write-Warning {}
            Set-InfobloxMembers -Network '10.46.5.128/25'
            Assert-MockCalled Write-Warning -Times 1
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
            Mock Invoke-InfobloxQuery -MockWith {
                param($RelativeUri, $Method, $BaseUri)
                if ($Method -eq 'GET') { return $result }
                $script:putBody = $Body
                return @{ ok = $true }
            }

            Set-InfobloxMembers -Network '10.46.5.128/25' -Members @('b', 'c') | Out-Null

            Assert-MockCalled Invoke-InfobloxQuery -ParameterFilter { $Method -eq 'PUT' } -Times 1
            $script:putBody.members | Should -HaveCount 2
            $script:putBody.members[0]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[0].ipv4addr | Should -Be 'b'
            $script:putBody.members[1]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[1].ipv4addr | Should -Be 'c'
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

            Set-InfobloxMembers -Network '10.46.5.128/25' -AddMembers @('a', 'b') | Out-Null

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

            Set-InfobloxMembers -Network '10.46.5.128/25' -RemoveMembers @('a') | Out-Null

            $script:putBody.members | Should -HaveCount 1
            $script:putBody.members[0]._struct | Should -Be 'msdhcpserver'
            $script:putBody.members[0].ipv4addr | Should -Be 'b'
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

            Set-InfobloxMembers -Network '10.46.5.128/25' -MemberStruct 'dhcpmember' -MemberProperty 'name' -Members @('dhcp01') | Out-Null

            $script:putBody.members | Should -HaveCount 1
            $script:putBody.members[0]._struct | Should -Be 'dhcpmember'
            $script:putBody.members[0].name | Should -Be 'dhcp01'
        }
    }
}

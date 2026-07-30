Describe 'DHCP range mutations' {
    InModuleScope PowerInfoblox {
        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.13.8' }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = 'https://example.test/wapi/v2.13.8'
            $script:requestBody = $null
            $script:requestMethod = $null
            $script:requestUri = $null
            Mock Invoke-InfobloxQuery -MockWith {
                $script:requestBody = $Body
                $script:requestMethod = $Method
                $script:requestUri = $RelativeUri
                'range/reference'
            }
        }

        AfterAll {
            $Script:InfobloxConfiguration = $null
            $PSDefaultParameterValues.Remove('Invoke-InfobloxQuery:BaseUri')
        }

        It 'clears a range comment instead of serializing Boolean false as text' {
            Set-InfobloxDHCPRange -ReferenceID 'range/reference' -Comment $false

            $script:requestMethod | Should -Be 'PUT'
            $script:requestUri | Should -Be 'range/reference'
            $script:requestBody.Contains('comment') | Should -BeTrue
            $script:requestBody.comment | Should -Be ''
        }

        It 'omits a Boolean false comment when creating a range' {
            Add-InfobloxDHCPRange -StartAddress '10.0.0.10' -EndAddress '10.0.0.20' -Comment $false

            $script:requestMethod | Should -Be 'POST'
            $script:requestUri | Should -Be 'range'
            $script:requestBody.Contains('comment') | Should -BeFalse
        }

        It 'preserves PowerShell string coercion for other comment values' {
            Set-InfobloxDHCPRange -ReferenceID 'range/reference' -Comment 12345

            $script:requestBody.comment | Should -Be '12345'
        }

        It 'maps override and disabled DDNS settings to the WAPI fields' {
            Set-InfobloxDHCPRange -ReferenceID 'range/reference' -DDNSUpdateMode Override -DDNSEnabled $false

            $script:requestBody.use_enable_ddns | Should -BeTrue
            $script:requestBody.enable_ddns | Should -BeFalse
        }

        It 'maps inheritance to the DDNS use flag without changing the stored local value' {
            Set-InfobloxDHCPRange -ReferenceID 'range/reference' -DDNSUpdateMode Inherit

            $script:requestBody.use_enable_ddns | Should -BeFalse
            $script:requestBody.Contains('enable_ddns') | Should -BeFalse
        }

        It 'selects override mode when DDNS enablement is supplied directly' {
            Add-InfobloxDHCPRange -StartAddress '10.0.0.10' -EndAddress '10.0.0.20' -DDNSEnabled $true

            $script:requestBody.use_enable_ddns | Should -BeTrue
            $script:requestBody.enable_ddns | Should -BeTrue
        }

        It 'rejects a local DDNS value while inheritance is selected' {
            {
                Set-InfobloxDHCPRange -ReferenceID 'range/reference' -DDNSUpdateMode Inherit -DDNSEnabled $false
            } | Should -Throw '*DDNSEnabled cannot be set*'

            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 0
        }

        It 'keeps AlwaysUpdateDns separate from DDNS enablement' {
            Set-InfobloxDHCPRange -ReferenceID 'range/reference' -AlwaysUpdateDns

            $script:requestBody.always_update_dns | Should -BeTrue
            $script:requestBody.Contains('enable_ddns') | Should -BeFalse
            $script:requestBody.Contains('use_enable_ddns') | Should -BeFalse
        }

        It 'warns when no range changes are requested' {
            Mock Write-Warning

            Set-InfobloxDHCPRange -ReferenceID 'range/reference'

            Should -Invoke -CommandName Write-Warning -Times 1 -ParameterFilter {
                $Message -eq 'Set-InfobloxDHCPRange - No changes requested'
            }
            Should -Invoke -CommandName Invoke-InfobloxQuery -Times 0
        }
    }
}

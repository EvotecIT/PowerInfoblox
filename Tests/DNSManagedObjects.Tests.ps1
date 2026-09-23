Describe 'DNS zone and view management' {
    InModuleScope PowerInfoblox {
        BeforeEach {
            $Script:InfobloxConfiguration = @{ BaseUri = 'https://example.test/wapi/v2.13.6' }
            $PSDefaultParameterValues['Invoke-InfobloxQuery:BaseUri'] = 'https://example.test/wapi/v2.13.6'
            $script:Calls = [System.Collections.ArrayList]::new()
            $script:Objects = @()
            Mock Get-FieldsFromSchema { 'fqdn,view,comment,disable,name,is_default,network_view' }
            Mock Invoke-InfobloxQuery {
                [void] $script:Calls.Add([pscustomobject]@{ Method = $Method; Uri = $RelativeUri; Body = $Body; Query = $QueryParameter })
                if ($Method -eq 'GET') { return $script:Objects }
                'object/reference'
            }
        }

        AfterAll {
            $Script:InfobloxConfiguration = $null
            $PSDefaultParameterValues.Remove('Invoke-InfobloxQuery:BaseUri')
        }

        It 'creates the selected zone kind with view and supplied WAPI fields' {
            Add-InfobloxDNSZone -Type Forward -Name example.test -View Internal -Properties @{ forward_to = @(@{ address = '192.0.2.53' }) } -Confirm:$false
            $script:Calls.Count | Should -Be 1
            $script:Calls[0].Uri | Should -Be 'zone_forward'
            $script:Calls[0].Body.fqdn | Should -Be 'example.test'
            $script:Calls[0].Body.view | Should -Be 'Internal'
            $script:Calls[0].Body.forward_to[0].address | Should -Be '192.0.2.53'
        }

        It 'creates <Type> using the <Endpoint> WAPI object' -TestCases @(
            @{ Type = 'ResponsePolicy'; Endpoint = 'zone_rp'; Field = 'substitute_name'; Value = 'blocked.example.test' }
            @{ Type = 'Stub'; Endpoint = 'zone_stub'; Field = 'stub_from'; Value = @(@{ address = '192.0.2.53' }) }
        ) {
            param($Type, $Endpoint, $Field, $Value)
            Add-InfobloxDNSZone -Type $Type -Name example.test -Properties @{ $Field = $Value } -Confirm:$false
            $script:Calls.Count | Should -Be 1
            $script:Calls[0].Uri | Should -Be $Endpoint
            $script:Calls[0].Body[$Field] | Should -Be $Value
        }

        It 'rejects conflicting zone identity before POST' {
            { Add-InfobloxDNSZone -Type Authoritative -Name example.test -View Internal -Properties @{ view = 'External' } -Confirm:$false } |
                Should -Throw '*does not match View*'
            $script:Calls.Count | Should -Be 0
        }

        It 'creates a view with its network view' {
            Add-InfobloxDNSView -Name Internal -NetworkView default -Confirm:$false
            $script:Calls.Count | Should -Be 1
            $script:Calls[0].Uri | Should -Be 'view'
            $script:Calls[0].Body.name | Should -Be 'Internal'
            $script:Calls[0].Body.network_view | Should -Be 'default'
        }

        It 'shows zone candidates when the requested view does not match and does not update' {
            $script:Objects = @([pscustomobject]@{ _ref = 'zone_auth/one:example.test/Internal'; fqdn = 'example.test'; view = 'Internal' })
            $Warnings = @(Set-InfobloxDNSZone -Type Authoritative -Name example.test -View External -Properties @{ comment = 'changed' } -WarningVariable Captured -WarningAction Continue)
            $script:Calls.Count | Should -Be 1
            $script:Calls[0].Method | Should -Be 'GET'
            ($Captured -join ' ') | Should -Match 'zone_auth/one:example.test/Internal'
            ($Captured -join ' ') | Should -Match 'view=Internal'
        }

        It 'refuses ambiguous zones and lists both references' {
            $script:Objects = @(
                [pscustomobject]@{ _ref = 'zone_auth/one:example.test/Internal'; fqdn = 'example.test'; view = 'Internal' }
                [pscustomobject]@{ _ref = 'zone_auth/two:example.test/External'; fqdn = 'example.test'; view = 'External' }
            )
            Remove-InfobloxDNSZone -Type Authoritative -Name example.test -WarningVariable Captured -WarningAction Continue -Confirm:$false
            $script:Calls.Count | Should -Be 1
            ($Captured -join ' ') | Should -Match 'zone_auth/one'
            ($Captured -join ' ') | Should -Match 'zone_auth/two'
        }

        It 'updates exactly the zone selected by ReferenceID' {
            $Reference = 'zone_delegated/one:example.test/Internal'
            $script:Objects = @([pscustomobject]@{ _ref = $Reference; fqdn = 'example.test'; view = 'Internal' })
            Set-InfobloxDNSZone -ReferenceID $Reference -Type Delegated -Properties @{ comment = 'changed' } -Confirm:$false
            $script:Calls.Count | Should -Be 2
            $script:Calls[1].Method | Should -Be 'PUT'
            $script:Calls[1].Uri | Should -Be $Reference
        }

        It 'uses an exact response policy zone reference for removal' {
            $Reference = 'zone_rp/one:example.test/Internal'
            $script:Objects = @([pscustomobject]@{ _ref = $Reference; fqdn = 'example.test'; view = 'Internal' })
            Remove-InfobloxDNSZone -ReferenceID $Reference -Type ResponsePolicy -Confirm:$false
            $script:Calls.Count | Should -Be 2
            $script:Calls[1].Method | Should -Be 'DELETE'
            $script:Calls[1].Uri | Should -Be $Reference
        }

        It 'filters response policy zones by FQDN and view' {
            Get-InfobloxResponsePolicyZones -FQDN example.test -View Internal | Out-Null
            $script:Calls[0].Uri | Should -Be 'zone_rp'
            $script:Calls[0].Query.fqdn | Should -Be 'example.test'
            $script:Calls[0].Query.view | Should -Be 'Internal'
        }

        It 'filters stub zones by FQDN and view' {
            Get-InfobloxDNSStubZone -FQDN example.test -View Internal | Out-Null
            $script:Calls[0].Uri | Should -Be 'zone_stub'
            $script:Calls[0].Query.fqdn | Should -Be 'example.test'
            $script:Calls[0].Query.view | Should -Be 'Internal'
        }

        It 'refuses to remove a default DNS view' {
            $script:Objects = @([pscustomobject]@{ _ref = 'view/default'; name = 'default'; is_default = $true; network_view = 'default' })
            Remove-InfobloxDNSView -Name default -WarningVariable Captured -WarningAction Continue -Confirm:$false
            $script:Calls.Count | Should -Be 1
            ($Captured -join ' ') | Should -Match 'default DNS view'
        }

        It 'removes exactly the nondefault view selected by ReferenceID' {
            $Reference = 'view/one:Internal/false'
            $script:Objects = @([pscustomobject]@{ _ref = $Reference; name = 'Internal'; is_default = $false; network_view = 'default' })
            Remove-InfobloxDNSView -ReferenceID $Reference -Confirm:$false
            $script:Calls.Count | Should -Be 2
            $script:Calls[1].Method | Should -Be 'DELETE'
            $script:Calls[1].Uri | Should -Be $Reference
        }

        It 'updates exactly one view selected by Name' {
            $script:Objects = @([pscustomobject]@{ _ref = 'view/one:Internal/false'; name = 'Internal'; is_default = $false })
            Set-InfobloxDNSView -Name Internal -Properties @{ comment = 'updated' } -Confirm:$false
            $script:Calls.Count | Should -Be 2
            $script:Calls[1].Method | Should -Be 'PUT'
            $script:Calls[1].Uri | Should -Be 'view/one:Internal/false'
        }

        It 'gets one view by name with the WAPI name query' {
            $script:Objects = @([pscustomobject]@{ _ref = 'view/one:Internal/false'; name = 'Internal'; is_default = $false })
            Get-InfobloxDNSView -Name Internal | Out-Null
            $script:Calls[0].Uri | Should -Be 'view'
            $script:Calls[0].Query.name | Should -Be 'Internal'
        }
    }
}

---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Set-InfobloxNetworkMembers
## SYNOPSIS
Sets or modifies members for an Infoblox object.

## SYNTAX
### __AllParameterSets
```powershell
Set-InfobloxNetworkMembers [-Network] <string> [[-NetworkView] <string>] [[-Members] <string[]>] [[-AddMembers] <string[]>] [[-RemoveMembers] <string[]>] [[-MemberStruct] <string>] [[-MemberProperty] <string>] [-ReturnOutput] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the members list for an object by reference ID, or resolves a network by CIDR.
Supports replacing the full list or adding/removing members.

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -Members @(
    'dhcp01.example.com', 'dhcp02.example.com'
)
```


### EXAMPLE 2
```powershell
PS > Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -AddMembers 'dhcp02.example.com'
```


### EXAMPLE 3
```powershell
PS > Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -RemoveMembers 'dhcp01.example.com'
```


### EXAMPLE 4
```powershell
PS > Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -MemberStruct 'dhcpmember' -MemberProperty 'name' -Members @(
    'dhcp01.example.com', 'dhcp02.example.com'
)
```


### EXAMPLE 5
```powershell
PS > $customMembersSplat = @{
    Network        = '10.46.5.128/25'
    MemberStruct   = 'dhcpmember'
    MemberProperty = 'name'
    AddMembers     = 'dhcp03.example.com'
}
Set-InfobloxNetworkMembers @customMembersSplat
```


### EXAMPLE 6
```powershell
PS > Set-InfobloxNetworkMembers -Network '10.46.5.128/25' -Members @()
```


## PARAMETERS

### -AddMembers
Members to add to the existing list.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberProperty
The member property name holding the address/name. Defaults to 'ipv4addr'.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 6
Default value: ipv4addr
Accept pipeline input: False
Accept wildcard characters: False
```

### -Members
Full list of members to set on the object.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MemberStruct
The Infoblox member struct name. Defaults to 'msdhcpserver'.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 5
Default value: msdhcpserver
Accept pipeline input: False
Accept wildcard characters: False
```

### -Network
The IPv4 network in CIDR notation (e.g. 10.46.5.128/25).

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetworkView
The network view. Defaults to 'default'.

```yaml
Type: String
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 1
Default value: default
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveMembers
Members to remove from the existing list.

```yaml
Type: String[]
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnOutput
If provided, returns the API response.

```yaml
Type: SwitchParameter
Parameter Sets: __AllParameterSets
Aliases: None
Possible values:

Required: False
Position: named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

- `None`

## OUTPUTS

- `None`

## RELATED LINKS

- None

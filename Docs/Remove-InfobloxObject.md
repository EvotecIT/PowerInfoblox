---
external help file: PowerInfoblox-help.xml
Module Name: PowerInfoblox
online version: https://github.com/EvotecIT/PowerInfoblox
schema: 2.0.0
---
# Remove-InfobloxObject
## SYNOPSIS
Remove an Infoblox object by reference ID

## SYNTAX
### ReferenceID (Default)
```powershell
Remove-InfobloxObject -ReferenceID <string> [-ReturnSuccess] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Array
```powershell
Remove-InfobloxObject -Objects <array> [-ReturnSuccess] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Remove an Infoblox object by reference ID
It can be used to remove any object type, but it is recommended to use the more specific cmdlets

## EXAMPLES

### EXAMPLE 1
```powershell
PS > Remove-InfobloxObject -ReferenceID 'record:host/ZG5zLmhvc3QkLl9kZWZhdWx0LmNvbS5pbmZvLmhvc3Q6MTcyLjI2LjEuMjAu:'
```


## PARAMETERS

### -Objects
An array of objects to remove

```yaml
Type: Array
Parameter Sets: Array
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReferenceID
The reference ID of the object to remove

```yaml
Type: String
Parameter Sets: ReferenceID
Aliases: None
Possible values:

Required: True
Position: named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReturnSuccess
Returns True when the delete request produces output and False when it does not.

```yaml
Type: SwitchParameter
Parameter Sets: ReferenceID, Array
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

$Parameters = @{
    ResourceGroupName = "noki-resource-group"
    name = "ConditionAndLoops$(get-date -format 'MMddHHmm')"
    TemplateFile = "vnet.bicep"
}
New-AzResourceGroupDeployment @Parameters -TemplateParameterFile main.parameters.json -verbose -whatif
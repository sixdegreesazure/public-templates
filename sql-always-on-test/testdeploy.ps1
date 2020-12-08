New-AzResourceGroupDeployment `
    -Name ("deploy-sqlcluster") `
    -resourcegroup "rg-neu-uat-db" `
    -templatefile "azuredeploy.json" `
    -templateparameterfile "azuredeploy.parameters.json"
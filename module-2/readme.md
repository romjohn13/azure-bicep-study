this module is focus on the bicep learn https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-files-parameters/

creating this files for module


how to create KeyVault

$keyVaultName = 'noki-kv'
$login = Read-Host "Enter the login name" -AsSecureString
$password = Read-Host "Enter the password" -AsSecureString

New-AzKeyVault -VaultName $keyVaultName -Location southeastasia -resourcegroup "noki-resource-group" -EnabledForTemplateDeployment
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $login
Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $password

sqlServerAdministratorLogin = nokibicep
sqlServerAdministratorPassword = nokibicep13$$TAE


how to get the created resource id of keyvault
(Get-AzKeyVault -Name $keyVaultName).ResourceId
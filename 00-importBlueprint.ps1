param(
    [string]$subscriptionId = $env:SUBSCRIPTIONID,
    [string]$blueprintPath = $env:BLUEPRINTPATH,
    [string]$blueprintName = $env:BLUEPRINTNAME,
    [string]$spnId = $env:SPNID,
    [string]$spnPass = $env:SPNPASS,
    [string]$tenantId = $env:TENANTID
)

Install-Module -Name Az.Blueprint -AllowClobber -Force

write-output "Subscription : $subscriptionId"
$securePass = ConvertTo-SecureString $spnPass -AsPlainText -Force
$credential = New-Object -TypeName pscredential -ArgumentList $spnId, $securePass
Login-AzAccount -Credential $credential -ServicePrincipal -TenantId $tenantId
Write-output "$PSScriptRoot"
Import-AzBlueprintWithArtifact -Name $blueprintName -SubscriptionId $subscriptionId -InputPath "$PSScriptRoot/$blueprintPath/" -Force
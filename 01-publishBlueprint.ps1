param(
    [string]$subscriptionId = $env:SUBSCRIPTIONID,
    [string]$blueprintPath = $env:BLUEPRINTPATH,
    [string]$blueprintName = $env:BLUEPRINTNAME,
    [string]$spnId = $env:SPNID,
    [string]$spnPass = $env:SPNPASS,
    [string]$tenantId = $env:TENANTID
)

write-output "Subscription : $subscriptionId"
$securePass = ConvertTo-SecureString $spnPass -AsPlainText -Force
$credential = New-Object -TypeName pscredential -ArgumentList $spnId, $securePass
Login-AzAccount -Credential $credential -ServicePrincipal -TenantId $tenantId

$createdBlueprint = Get-AzBlueprint -SubscriptionId $subscriptionId -Name $blueprintName -errorAction SilentlyContinue

if($createdBlueprint)
{
    Publish-AzBlueprint -Blueprint $createdBlueprint -Version "2.0.0"
}else
{
    throw "Could not get Blueprint"
    exit 1
}
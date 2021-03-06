param(
    [string]$subscriptionId = $env:SUBSCRIPTIONID,
    [string]$mgId = $env:MGID,
    [string]$blueprintPath = $env:BLUEPRINTPATH,
    [string]$blueprintName = $env:BLUEPRINTNAME,
    [string]$spnId = $env:SPNID,
    [string]$spnPass = $env:SPNPASS,
    [string]$tenantId = $env:TENANTID
)

Install-Module -Name Az.Blueprint -AllowClobber -Force

if (!(Get-Module -ListAvailable -Name Az.Blueprint)) {
    throw "Module does not exist"
    exit 1 
} 

write-output "Subscription : $subscriptionId"
$securePass = ConvertTo-SecureString $spnPass -AsPlainText -Force
$credential = New-Object -TypeName pscredential -ArgumentList $spnId, $securePass
Login-AzAccount -Credential $credential -ServicePrincipal -TenantId $tenantId

$text = [System.Threading.Thread]::CurrentThread.CurrentCulture.TextInfo
gci "$blueprintPath/blueprint.json" | Rename-Item -NewName {"$($text.ToTitleCase($_.BaseName.ToLower()))$($_.Extension)"}

## Rename artifact to Artifcat /i\
cd $blueprintPath
Rename-Item -Path "artifacts" -NewName "temporary" -force
Rename-Item -Path "temporary" -NewName "Artifacts" -force
cd ..
## :'( 

Import-AzBlueprintWithArtifact -Name $blueprintName -ManagementGroupId $mgId -InputPath $blueprintPath -Force
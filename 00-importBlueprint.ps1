param(
    [string]$subscriptionId = $env:SUBSCRIPTIONID,
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

$text = [System.Threading.Thread]::CurrentThread.CurrentCulture.TextInfo
gci "$blueprintPath/blueprint.json" | Rename-Item -NewName {"$($text.ToTitleCase($_.BaseName.ToLower()))$($_.Extension)"}

## Rename artifact to Artifcat /i\
cd $blueprintPath
Rename-Item -Path "artifacts" -NewName "temporary" -force
Rename-Item -Path "temporary" -NewName "Artifacts" -force
cd ..
## :'( 

Import-AzBlueprintWithArtifact -Name $blueprintName -SubscriptionId $subscriptionId -InputPath $blueprintPath -Force
# 登入 Azure
# Connect-AzAccount

# 定義 ACR 名稱和資源組名稱
$registryName = "kTCDockRegistry"
$resourceGroupName = "KTCFE.DevOps"


az acr show --name $registryName --resource-group $resourceGroupName --query loginServer --output tsv

# 獲取 ACR 中的所有 repository
$repositories = (az acr repository list --name $registryName --output tsv)

#$repository = "debug/ind4/l-ind4portalapi"

foreach ($repository in $repositories)
{
    Write-Host "Processing image: $repository"
    # 獲取 repository 的所有 manifest
    $manifests = az acr repository show-manifests --name $registryName --repository $repository --orderby time_desc --output json | ConvertFrom-Json

    foreach ($manifest in $manifests)
    {
        # 獲取與當前 manifest 關聯的所有 tags
        $tags = az acr repository show-tags --name $registryName --repository $repository --detail --output json | ConvertFrom-Json | Where-Object {$_.digest -eq $manifest.digest}
    
        # 如果 manifest 沒有與任何 tag 關聯，則刪除它
        if ($tags.Count -eq 0)
        {
            $digest = $manifest.digest
            Write-Host "Deleted manifest: $repository@$digest"
            az acr repository delete --name $registryName --image "$repository@$digest" --yes
        }
    }
}
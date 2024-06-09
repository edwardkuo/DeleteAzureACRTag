# DeleteAzureACRTag
透過PS移除ACR不需要的Image
## Remove Unuse image file
在Azure ACR中，開啟進階模式，可以去定義多久沒有用到的Image會自動刪除。但如果不想啟用該功能，又或是說還沒有時間到時候，想要刪除ACR Image又要怎樣處裡呢?

### DeleteAzureACRTag
可以先執行DeleteAzureACRTag.ps1，將我們不需要保留的Tag先做刪除，保留出我們想要的留下的Tag

### DeleteManifest
當我們把Tag移除後，在ACR還是會殘留Manifest，這時候只要執行DeleteManifest.ps1，將Manifest跟Tag沒有匹配的刪除，這樣就可以，這樣也會大幅降低ACR的儲存空間

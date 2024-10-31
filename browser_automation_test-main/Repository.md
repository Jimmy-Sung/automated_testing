### Repository 說明

| 檔案與資料夾名稱   | 用途              |
| ----------------- | ----------------- |
| *【基本檔案】* | *【Robot Framework 讀取這些 .txt 來執行測試】* |
| 檔案 OCAIP_RF_Test.txt | 用來撰寫測試案例，約 200 多個 |
| 資料夾 Keywords | 內為 .txt 檔案，用來撰寫測試案例 Keywords |
| 資料夾 Variables | 內為 .txt 檔案，用來撰寫測試案例 Variables |
| 檔案 OCAIP_API_RF_Text.txt | 直接打 API 的測試案例 |
| *【自訂檔案】* | *【此專案的測試案例使用的檔案】* |
| **［文件］檔案 TestCase.json** | **撰寫測試案例文件** |
| 資料夾 Scripts | 測試案例用來「新增議題」、「結束議題」等等 .py 檔及其所需 .ini、.csv 檔案。OCAIP_Topic_Info_\*SOME-NAME\*.txt 則為引入 Variables 的範本|
| 檔案 Scripts/change_data.py | 更改議題：讓議題結束並秀成績、結束報名、大量新增留言等 |
| 檔案 Scripts/enclosed_register_user.py | （封閉式議題專用）為使用者報名議題 |
| 檔案 Scripts/exam_score.py | 驗證成績分數是否正確 |
| 檔案 Scripts/close.sh | 關閉　chromium　開啟的瀏覽視窗 |
| 檔案 Scripts/Image_diff.py | 比對兩張瀏覽器視窗截圖的相似度 |
| 檔案 Scripts/auto_create_topic.py | 新增並上架議題，內容衍生自 Repository ocaip-batch-script 的 onestep_create.py  |
| 檔案 Scripts/create_issue.sh | 測試程式在自動排程執行後，會在 Jira Board 上新增測試報告並節錄說明測試案例 failed 的內容 |
| 檔案 Scripts/ip_unblock.py | 解鎖當前IP |
| 資料夾 Test_Data | 「上傳」系列測試案例所需檔案，各種議題的正確格式檔案及錯誤格式檔案。「UI」系列測試案例所需檔案，為正常網頁版面的截圖 |
| 資料夾 Temp | 執行測試時產生的不重要的檔案。一般為清空狀態 |
| *【For Windows】* |  |
| 資料夾 Tool | Windows 環境使用的檔案 |
| 檔案 requirements.txt | 於 Windows 環境建置時，用來安裝必備 Python 套件清單 |
| 檔案 run_test.bat | 可使用此 script 於 Windows 跑測試 |
| *【For Ubuntu】* |  |
| 資料夾 bin | 存放 Dockerfile 使用的檔案 |
| 檔案 Dockerfile | 用來 build docker |
| 檔案 run_test_docker.sh | 使用 Docker 跑測試的 script |
| 資料夾 Log | Docker 跑完測試後，測試報告輸出的目的地 |
| 檔案 clear_container.sh | 方便停止並清除 docker container 的 script |
| 檔案 chromedriverlog | 記錄一些 log，方便 Debug |
| *【Jenkins】* |  |
| 檔案 Jenkinsfile | Jenkins pipeline 使用 |
| *【其他】* |  |
| 檔案 README.md | 你正在看的此份文件 |
| 檔案 json_to_xlsx.py | 將文件 TestCase.json 轉成 TextCase.xlsx |
| 檔案 TestCase.xlsx | 由 TestCase.json 產生的文件 |
| 檔案 TestCases.xlsx | （封存）舊版測試案例文件 |
| 資料夾 ubuntu_docker | Ubuntu Container實驗中 |

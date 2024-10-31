### API 說明
| 名稱 | 用途 | 狀態 |
| ----------------- | ----------------- | ----------------- |
| *【TESTCASES】* |
| Get All Topics List By API | 請求API以獲取所有主題列表 | PASS
| Get Topic Information By API | 通過API獲取主題資訊，並以主題名稱作為輸入，成功則通過並返回主題資訊 | PASS
| Get Topic Id By API | 通過API獲取主題ID，主題名稱作為其他API進一步使用的輸入 | PASS
| Get All Users List By API | 請求API以獲取所有用戶列表 | PASS
| Get User Information By API | 請求API以獲取特定用戶資訊 | PASS
| Check If User Email Exists In System By API | 請求API以檢查系統中是否存在電子郵件地址，如果電子郵件存在則通過，否則失敗 | PASS
| Get All Teams Information From Topic By API | 通過API獲取主題資訊，並以主題名稱作為輸入 | PASS
| Check If User Attends a Topic By API | 請求API以檢查用戶是否參加特定主題，如果用戶是主題的參與者，則通過，否則失敗。 | PASS
| Get Remaining Time Of Topic By API | 請求API以獲取主題的剩餘時間 | PASS
| Get Team Information From Topic By API | 請求API以從主題獲取團隊資訊 | PASS
| Get Notification Messages Of A User By API | 請求API以獲取用戶的所有通知消息 | PASS
| Get Join Condition For A Topic By API | 在簽署協議時請求API以獲取加入條件 | PASS
| Check If Team Can Be Invited Into Topic By API | 檢查是否可以通過API被邀請加入此主題 | PASS
| Clear IP Block By API | 重置被阻止的IP位址 | PASS
| Change Eval Stage By API | 更改議題評估階段，重新計算分數與排名 | PASS
| *【OTHERS】* |  |
|  change_data.py | 更改議題：讓議題結束並秀成績、結束報名、大量新增留言等 |
|  enclosed_register_user.py |（封閉式議題專用）為使用者報名議題 |
|  exam_score.py | 驗證成績分數是否正確
|  Image_diff.py | 比對兩張瀏覽器視窗截圖的相似度 |
|  auto_create_topic.py | 新增並上架議題，內容衍生自 Repository ocaip-batch-script 的 onestep_create.py |
|  json_to_xlsx.py | 將文件 TestCase.json 轉成 TextCase.xlsx |
|  ip_unblock.py | 解鎖當前IP |


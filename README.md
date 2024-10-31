# 藉由selinium完成自動化測試系統
以下的圖像需經過IRB等醫療程序才可使用，未經允許請勿複製、散播！

## For Windows 10
環境建置
Install Python 2.7：https://www.python.org/downloads/windows/

安裝時點選 "Add python.exe to Path"，或是安裝完成後手動將 C:\Python27 和 C:\Python27\Scripts 手動加進 PATH

控制台->系統安全性->系統。或是在本機點右鍵選取內容

點選進入進階系統設定，點選進入環境變數

在系統變數視窗內，點取 Path，點選進入編輯

點選新增，以新增以下變數：C:\Python27，C:\Python27\Scripts

Install SeleniumLibrary

指令：pip install robotframework-seleniumlibrary

安裝後確認

指令：C:\>python -m robot.libdoc SeleniumLibrary version

結果：3.1.1

Install Python 3

本專案執行時需用到 python 3 (make sure install python 3.6 or later)
下載 Python 3 版本

安裝時點選 "Add python.exe to Path"，或是安裝完成後手動將 C:\Python37 和 C:\Python37\Scripts 手動加進 PATH

控制台->系統安全性->系統。或是在本機點右鍵選取內容

點選進入進階系統設定，點選進入環境變數

在系統變數視窗內，點取 Path，點選進入編輯

點選新增，以新增以下變數：C:\Python37，C:\Python37\Scripts

請確認 path 中的順序 python 2 必須在 python 3 之前，在 cmd 中執行 python 及 pip 預設必須為 python 2 的環境

將 C:\python37 中的 python.exe 複製並重新命名為 python3.exe，C:\python37\Scripts 中的 pip.exe 複製並重新命名為 pip3.exe，若你的 Python 3 是使用 Anaconda 安裝，你的環境可能沒有 python3、 pip3 指令，可將 Anaconda 的 python.exe 及 pip.exe 以上面的步驟修改放在同一資料夾。

下載此 repository 後，請先在 root directory 執行 : pip3 install -r requirements.txt

此步驟安裝的 packages，供測試案例執行 Scripts 資料夾內的 *.py 使用
（供參考）Install chrome driver

測試程式會自動進行下列的操作
下載符合 Chrome 版本的 ChromeDriver

把 chromedriver.exe 放進 C:\Python27，或是將 chromedriver.exe 所在位置加進 PATH

（供參考）使用 Virtualenv Robot Framework On Windows 10 and Python 3(virtualenv)

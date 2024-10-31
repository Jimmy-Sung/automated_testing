*** Settings ***
Suite Setup       Suite Setup
Suite Teardown    Suite Teardown
Test Setup        Login To OCAIP
Test Teardown     Compatibility Teardown
Library           SeleniumLibrary    30    3    run_on_failure=None
Resource          ./Keywords/OCAIP_Keywords.txt
Resource          ./Keywords/OCAIP_API_Keywords.txt
Resource          ./Variables/OCAIP_Variables.txt
Library           OperatingSystem
Library           Process
Library           DateTime
Library           Dialogs

*** Test Cases ***
--- UploadAOI ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- UploadAOI ---
    [Teardown]    No Operation

Upload Correct Result To AOI Issue
    [Documentation]    Upload normal result to topic AOI.
    [Tags]    UploadAOI    UploadAOI_1
    ${File name}=    Set Variable    AOI
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    ${Upload file}=    Set Variable    pri_0.1_pub_0.1.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file}    Input type=id    # Normal file
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Correct Result To AOI Issue And Check Score Accuracy
    [Documentation]    Check score accuracy of different upload files of AOI issue.
    [Tags]    UploadAOI    UploadAOI_2
    ${File name}=    Set Variable    AOI2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${Upload file}=    Set Variable    pri_0.1_pub_0.1.csv
    ${Upload file2}=    Set Variable    pri_0.5_pub_0.7.csv
    ${Upload file3}=    Set Variable    pri_0.7_pub_0.5.csv
    ${Upload file4}=    Set Variable    pri_0.8_pub_0.8.csv
    ${Upload file5}=    Set Variable    pri_0.9_pub_0.9.csv
    ${Upload file6}=    Set Variable    pri_0_pub_0.csv
    ${Upload file7}=    Set Variable    pri_0_pub_1.csv
    ${Upload file8}=    Set Variable    pri_1_pub_0.csv
    ${Upload file9}=    Set Variable    pri_1_pub_1.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file}    Expect score=0.1    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file2}    Expect score=0.7    Input type=id
    Upload Result For Topic And Expect Error   ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file3}    Expect score=0.5    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.5    Expect score2=0.7    Expect score3=0.1
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file4}    Expect score=0.8    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.8    Expect score2=0.5    Expect score3=0.7
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file5}    Expect score=0.9    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.9    Expect score2=0.8    Expect score3=0.5
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file6}    Expect score=0.0    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.0    Expect score2=0.9    Expect score3=0.8
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file7}    Expect score=1.0    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=1.0    Expect score2=0.0    Expect score3=0.9
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file8}    Expect score=0.0    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.0    Expect score2=1.0    Expect score3=0.0
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file9}    Expect score=1.0    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=1.0    Expect score2=0.0    Expect score3=1.0
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=1.0
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload ID Error Content Result To AOI Issue
    [Documentation]    Upload result with ID error content to AOI issue and expected error.
    [Tags]    UploadAOI    UploadAOI_3
    ${File name}=    Set Variable    AOI3
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    ID_error.csv
    Copy File    ${gTest data path AOI}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
    ${File name length}=    Get Length    ${Time prefix}_${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload ID Loss Content Result To AOI Issue
    [Documentation]    Upload result with ID loss content to AOI issue and expected error.
    [Tags]    UploadAOI    UploadAOI_4
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    ID_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Value Loss Content Result To AOI Issue
    [Documentation]    Upload result with value loss content to AOI issue and expected error.
    [Tags]    UploadAOI    UploadAOI_5
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    value_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案有包含空值不合規則！    ${error file}：上傳檔案有包含空值不合規則！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload ID And Value Loss Content Result To AOI Issue
    [Documentation]    Upload result with ID and value loss content to AOI issue and expected error.
    [Tags]    UploadAOI    UploadAOI_6
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    ID_value_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Jpg Error Content Result To AOI Issue
    [Documentation]    Upload result with error jpg content to AOI issue and expected error.
    [Tags]    UploadAOI    UploadAOI_7
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    jpg_csv.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Executable Program Result To AOI Issue
    [Documentation]    Upload executable program content result to AOI issue and expected error.
    [Tags]    UploadAOI    UploadAOI_8
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    error_badprogram.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Format Error Result To AOI Issue
    [Documentation]    Upload error format result to AOI issue and expected error.
    [Tags]    UploadAOI    UploadAOI_9
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    error_format.zip
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${error file}    Msg from where=button    Expected msg=此議題僅接受 csv 格式的檔案    Input type=id
    # Error content file

Upload Extreme Value Content Result To AOI Issue
    [Documentation]    Upload extreme value content result to AOI issue and expected error.
    ...
    ...    - extreme_value_over309.csv : if the value is over 309 digits, even though there are invalid strings after the 309 digits, upload will still succeed and expect score = 0.0
    ...    - extreme_value_float_over323.csv : for float values, if there are over 323 zeros after the decimal point, even though there are more non-zero digits after the 323 digits, upload will still succeed and expect score = \ the score that is expected without the decimal digits.
    ...    - extreme_value_string.csv : if any of the value is over 309 digits, or any of the float value is over 323 digits, invalid strings can be type after any other values, and upload will succeed, with expect score = 0.0.
    ...
    ...    Explanations :
    ...
    ...    | value = 999...999 (with more than 309 digits) will show expect score = 0.0 |
    ...    | value = 999...999alert("hehehe") (with more than 309 digits) will show expect score = 0.0 |
    ...    | value = 5 and value = 5.000...000123 (with 323 or more zeros) will show the same expect score |
    ...    | value = 5.000...000123eval(console.log("hahaha")) (with 323 or more zeros) will show expect score = 0.0 |
    [Tags]    UploadAOI    UploadAOI_10
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${Extreme file}=    Set Variable    extreme_value_over309.csv
    ${Extreme file2}=    Set Variable    extreme_value_float_over323.csv
    ${Extreme file3}=    Set Variable    extreme_value_string.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${Extreme file}    Expect score=0.0    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${Extreme file2}    Expect score=1.0    Input type=id    # Except for the extreme value, other values are the same as solution.csv, so the expect score should be the same as solution.csv(1.0).
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${Extreme file3}    Expect score=0.0    Input type=id

Multiple User Upload Different Data To AOI Issue And Rank Show Correct
    [Documentation]    Multiple user upload different score data and the rank should show correct with the actual rank
    [Tags]    UploadAOI    UploadAOI_11
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    # multiple user upload different data
    ${Upload file1}=    Set Variable    pri_0.1_pub_0.1.csv
    ${Upload file2}=    Set Variable    pri_0.8_pub_0.8.csv
    ${Upload file3}=    Set Variable    pri_0.9_pub_0.9.csv
    # t1
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file1}    Expect score=0.1    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file2}    Expect score=0.8    Input type=id
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file3}    Expect score=0.9    Input type=id
    # check if the rank is true
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id

Multiple User Upload Same Data At Different Time To AOI Issue And Rank Show Correct
    [Documentation]    Multiple user upload same score data with different time and the rank should show correct with the actual rank
    [Tags]    UploadAOI    UploadAOI_12    # create and init topic
    ${File name}=    Set Variable    AOI3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    # multiple user upload same data
    ${upload file}=    Set Variable    pri_0.9_pub_0.9.csv
    # t1
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${upload file}    Expect score=0.9    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path AOI}${/}Correct_File${/}${upload file}    Expect score=0.9    Input type=id
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path AOI}${/}Correct_File${/}${upload file}    Expect score=0.9    Input type=id
    # check if the rank is true
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Create Future AOI Topic And Check Functions Show Correctly
    [Documentation]    Create future AOI topic and check functions show correctly
    [Tags]    UploadAOI    UploadAOI_13    # create and init topic
    ${File name}=    Set Variable    AOI4
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Date type=future    Operation=nosign
    Go To Topic List
    Element Should Contain    //a[contains(@href,"${gTopic ID Future}")]//h7[@class="issue_coming"]    即將開始
    Go To Topic    ${gTopic ID Future}    Input type=id
    Element Should Be Disabled    //strong[text()="非報名時間"]/parent::button
    Element Attribute Value Should Be    //a[@href="#topic-data"]/parent::li    class    disabled
    Element Attribute Value Should Be    //a[@href="#topic-upload"]/parent::li    class    disabled
    Element Attribute Value Should Be    //a[@href="#topic-discuss"]/parent::li    class    disabled
    Click Element    //a[contains(text(),'規則')]
    Page Should Contain Element    //div[@id='topic-rule']/section/div/div/div/h4
    [Teardown]    Compatibility Teardown    ${gTopic ID Future}

Business Account Can Not Sign Up An Academic Issue
    [Documentation]    Business account can not sign up an academic issue.
    [Tags]    UploadAOI    UploadAOI_14
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    AOI5
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    Go To Topic List
    # Check if the topic is student only
    Element Should Contain    //a[@href="/topic/${gTopic ID Now}"]//div[@class="for_school"]/h6    學界限定
    Go To Topic    ${gTopic ID Now}    Input type=id
    # Check if the sign button is disable
    Page Should Contain Element    //div[@id="countdown"]//button[text()="僅限學界報名"]
    Element Should Be Disabled    //div[@id="countdown"]//button[text()="僅限學界報名"]
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Error JSON Format Result To AOI Issue
    [Documentation]    Upload error json format result to topic AOI.
    [Tags]    UploadAOI    UploadAOI_15
    ${File name}=    Set Variable    AOI6
    Create Topic With Argument    ${File name}    pri_single_reg_AOI_json
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    Modify Topic Settings    upload_file_extension    Content=json
    Switch Browser    1
    ${error file}=    Set Variable    key_error.json
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...json：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload JSON Format Result To AOI Issue
    [Documentation]    Upload json format result to topic AOI.
    [Tags]    UploadAOI    UploadAOI_16
    ${File name}=    Set Variable    AOI6
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Upload file}=    Set Variable    pri_0.5_pub_0.5.json
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${upload file}    Expect score=0.5394019    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.5389730
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Upload_Hydraulic ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Upload_Hydraulic ---
    [Teardown]    No Operation

Upload Correct Result To Hydraulic Issue
    [Documentation]    Upload normal result to hydraulic issues.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_1
    ${File name}=    Set Variable    hydraulic
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic
    ${Upload file}=    Set Variable    pri_0.39270610065496897_pub_0.4150585585621457.csv
    ${Upload file2}=    Set Variable    pri_0.4017261818252584_pub_0.40297299334606446.csv
    ${Upload file3}=    Set Variable    pri_0.4056847292694436_pub_0.4114990038078839.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file}    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file2}    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file3}    Input type=id    # Normal file
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Correct Result To Hydraulic Issue And Check Score Accuracy
    [Documentation]    Upload normal result to hydraulic issues and check score accuracy.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_2
    ${File name}=    Set Variable    hydraulic2
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${Upload file}=    Set Variable    pri_0.39270610065496897_pub_0.4150585585621457.csv
    ${Upload file2}=    Set Variable    pri_0.4017261818252584_pub_0.40297299334606446.csv
    ${Upload file3}=    Set Variable    pri_0.4056847292694436_pub_0.4114990038078839.csv
    ${Upload file4}=    Set Variable    pri_0.4078499273305147_pub_0.40372403234865817.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file}    Expect score=0.4150585    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file2}    Expect score=0.4029729    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file3}    Expect score=0.4114990    Input type=id    # Normal file
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.4114990    Expect score2=0.4029729    Expect score3=0.4150585
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file4}    Expect score=0.4037240    Input type=id    # Normal file
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.4037240    Expect score2=0.4114990    Expect score3=0.4029729
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.4078499
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload ID Error Content Result To Hydraulic Issue
    [Documentation]    Upload result with ID error content to hydraulic issue and expected error.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_3
    ${File name}=    Set Variable    hydraulic3
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    ID_error.csv
    Copy File    ${gTest data path hydraulic}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
    ${File name length}=    Get Length    ${Time prefix}_${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload ID Loss Content To Hydraulic Issue
    [Documentation]    Upload ID loss content result to hydraulic issues and expected error.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_4
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    ID_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Value Loss Content Result To Hydraulic Issue
    [Documentation]    Upload value loss result to hydraulic issues and expected error.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_5
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    value_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload ID And Value Loss Content Result To Hydraulic Issue
    [Documentation]    Upload ID and value loss content result to hydraulic issues and expected error.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_6
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    ID_value_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Not Float Content Result To Hydraulic Issue
    [Documentation]    Upload not float content result to hydraulic issues and expected error.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_7
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    not_float.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Executable Program Result To Hydraulic Issue
    [Documentation]    Upload executable program content result to hydraulic issue and expected error.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_8
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    error_badprogram.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Format Error Result To Hydraulic Issue
    [Documentation]    Upload error format result to hydraulic issue and expected error.
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_9
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${error file}=    Set Variable    error_format.zip
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${error file}    Msg from where=button    Expected msg=此議題僅接受 csv 格式的檔案    Input type=id
    # Error content file

Upload Extreme Value Content Result To Hydraulic Issue
    [Documentation]    Upload extreme value content result to hydraulic issue and expected error.
    ...
    ...    - extreme_value_over309.csv : if any value is over 309 digits (include 309 digits), upload failed.
    ...    - extreme_value_negative_over309.csv : if any negative value is over 309 digits (include 309 digits), upload failed.
    ...    - extreme_value_over155.csv : if any value is over 155 digits but less than 309 digits ( 155<=digit<309), upload succeed and expect score = inf.
    ...    - extreme_value_negative_over155.csv : if any negative value is over 155 digits but less than 309 digits (155<=digit<309), upload succeed and expect score = inf.
    ...
    ...    Explanations :
    ...
    ...    | value >= 1E+309 upload failed and show error message |
    ...    | value <= -1E+309 upload failed and show error message |
    ...    | 1E+155 <= value < 1E+309 upload succeed and show expect score = inf |
    ...    | -1E+155 >= value > -1E+309 upload succeed and show expect score = inf |
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_10
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${Extreme file}=    Set Variable    extreme_value_over309.csv
    ${Extreme file2}=    Set Variable    extreme_value_negative_over309.csv
    ${Extreme file3}=    Set Variable    extreme_value_over155.csv
    ${Extreme file4}=    Set Variable    extreme_value_negative_over155.csv
    ${First 16 chars file name}=    Get Substring    ${Extreme file}    0    16
    ${First 16 chars file name2}=    Get Substring    ${Extreme file2}    0    16
    ${File name length}=    Get Length    ${Extreme file}
    ${File name length2}=    Get Length    ${Extreme file2}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${Extreme file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    ${Expected msg2}=    Set Variable If    ${File name length2}>20    ${First 16 chars file name2}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${Extreme file2}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${Extreme file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${Extreme file2}    Msg from where=result    Expected msg=${Expected msg2}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${Extreme file3}    Expect score=Infinity    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Error_File${/}${Extreme file4}    Expect score=Infinity    Input type=id

Multiple User Upload Different Data To Hydraulic Issue And Rank Show Correct
    [Documentation]    Multiple user upload different score data and the rank should show correct with the actual rank
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_11
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    # multiple user upload different data
    ${Upload file1}=    Set Variable    pri_0.39270610065496897_pub_0.4150585585621457.csv
    ${Upload file2}=    Set Variable    pri_0.4056847292694436_pub_0.4114990038078839.csv
    ${Upload file3}=    Set Variable    pri_0.4017261818252584_pub_0.40297299334606446.csv
    # t1
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file1}    Expect score=0.4150585    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file2}    Expect score=0.4114990    Input type=id
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file3}    Expect score=0.4029729    Input type=id
    # check if the rank is true
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id

Multiple User Upload Same Data At Different Time To Hydraulic Issue And Rank Show Correct
    [Documentation]    Multiple user upload same score data with different time and the rank should show correct with the actual rank
    [Tags]    Upload_Hydraulic    Upload_Hydraulic_12    # create and init topic
    ${File name}=    Set Variable    hydraulic3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    # multiple user upload same data
    ${upload file}=    Set Variable    pri_0.4078499273305147_pub_0.40372403234865817.csv
    # t1
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${upload file}    Expect score=0.4037240    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${upload file}    Expect score=0.4037240    Input type=id
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${upload file}    Expect score=0.4037240    Input type=id
    # check if the rank is true
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Upload_Taxi ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Upload_Taxi ---
    [Teardown]    No Operation

Upload Correct Result To Taxi Issue
    [Documentation]    Upload normal result to taxi issue.
    [Tags]    Upload_Taxi    Upload_Taxi_1
    ${File name}=    Set Variable    taxi
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Join=No
    ${Upload file}=    Set Variable    pri_0.0_pub_0.0.csv
    ${Upload file2}=    Set Variable    pri_51.70106381884226_pub_68.09307355867165.csv
    ${Upload file3}=    Set Variable    pri_54.954526656136345_pub_55.82711408148075.csv
    ${Upload file4}=    Set Variable    pri_58.52349955359813_pub_51.881274720911264.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file}    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file2}    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file3}    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file4}    Input type=id    # Normal file
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Correct Result To Taxi Issue And Check Score Accuracy
    [Documentation]    Upload normal result to taxi issue and check score accuracy.
    [Tags]    Upload_Taxi    Upload_Taxi_2
    ${File name}=    Set Variable    taxi2
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Join=No
    ${Upload file}=    Set Variable    pri_0.0_pub_0.0.csv
    ${Upload file2}=    Set Variable    pri_51.70106381884226_pub_68.09307355867165.csv
    ${Upload file3}=    Set Variable    pri_54.954526656136345_pub_55.82711408148075.csv
    ${Upload file4}=    Set Variable    pri_58.52349955359813_pub_51.881274720911264.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file}    Expect score=0.0    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file2}    Expect score=68.093073    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file3}    Expect score=55.827114    Input type=id    # Normal file
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=55.827114    Expect score2=68.093073    Expect score3=0.0
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file4}    Expect score=51.881274    Input type=id    # Normal file
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=51.881274    Expect score2=55.827114    Expect score3=68.093073
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=58.523499
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload ID Error Content Result To Taxi Issue
    [Documentation]    Upload ID error content result to taxi issue and expected error.
    [Tags]    Upload_Taxi    Upload_Taxi_3
    ${File name}=    Set Variable    taxi3
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Join=No
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    ${error file}=    Set Variable    ID_error.csv
    Copy File    ${gTest data path taxi}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
    ${File name length}=    Get Length    ${Time prefix}_${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload ID Loss Content Result To Taxi Issue
    [Documentation]    Upload ID loss content result to taxi issues and expected error.
    [Tags]    Upload_Taxi    Upload_Taxi_4
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    ${error file}=    Set Variable    ID_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Value Loss Content Result To Taxi Issue
    [Documentation]    Upload value loss content result to taxi issue and expected error.
    [Tags]    Upload_Taxi    Upload_Taxi_5
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    ${error file}=    Set Variable    value_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案有包含空值不合規則！    ${error file}：上傳檔案有包含空值不合規則！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload ID And Value Loss Content Result To Taxi Issue
    [Documentation]    Upload ID and value loss content result to taxi issue and expected error.
    [Tags]    Upload_Taxi    Upload_Taxi_6
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    ${error file}=    Set Variable    ID_value_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Jpg Error Content Result To Taxi Issue
    [Documentation]    Upload jpg error content result to taxi issue and expected error.
    [Tags]    Upload_Taxi    Upload_Taxi_7
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    ${error file}=    Set Variable    jpg_csv.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Executable Program Result To Taxi Issue
    [Documentation]    Upload executable program to taxi issue and expected error.
    [Tags]    Upload_Taxi    Upload_Taxi_8
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    ${error file}=    Set Variable    error_badprogram.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    # Error content file

Upload Format Error Result To Taxi Issue
    [Documentation]    Upload error format result to taxi issue and expected error.
    [Tags]    Upload_Taxi    Upload_Taxi_9
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    ${error file}=    Set Variable    error_format.zip
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${error file}    Msg from where=button    Expected msg=此議題僅接受 csv 格式的檔案    Input type=id
    # Error format file

Upload Extreme Value Content Result To Taxi Issue
    [Documentation]    Upload extreme value content result to taxi issue and expected error.
    ...
    ...    - extreme_value_over309.csv : if any value is over 309 digits (include 309 digits), upload failed.
    ...    - extreme_value_negative_over309.csv : if any negative value is over 309 digits (include 309 digits), upload failed.
    ...    - extreme_value_over155.csv : if any value is over 155 digits but less than 309 digits ( 155<=digit<309), upload succeed and expect score = inf.
    ...    - extreme_value_negative_over155.csv : if any negative value is over 155 digits but less than 309 digits (155<=digit<309), upload succeed and expect score = inf.
    ...    - extreme_value_negative.csv : negative value is available, upload succeed. (but it should be positive integer)
    ...    - extreme_value_float.csv : float value is available, upload succeed. (but it should be positive integer)
    ...
    ...    Explanations :
    ...
    ...    | value >= 1E+309 upload failed and show error message |
    ...    | value <= -1E+309 upload failed and show error message |
    ...    | 1E+155 <= value < 1E+309 upload succeed and show expect score = inf |
    ...    | -1E+155 >= value > -1E+309 upload succeed and show expect score = inf |
    [Tags]    Upload_Taxi    Upload_Taxi_10
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    ${Extreme file}=    Set Variable    extreme_value_over309.csv
    ${Extreme file2}=    Set Variable    extreme_value_negative_over309.csv
    ${Extreme file3}=    Set Variable    extreme_value_over155.csv
    ${Extreme file4}=    Set Variable    extreme_value_negative_over155.csv
    ${Extreme file5}=    Set Variable    extreme_value_negative.csv
    ${Extreme file6}=    Set Variable    extreme_value_float.csv
    ${First 16 chars file name}=    Get Substring    ${Extreme file}    0    16
    ${First 16 chars file name2}=    Get Substring    ${Extreme file2}    0    16
    ${File name length}=    Get Length    ${Extreme file}
    ${File name length2}=    Get Length    ${Extreme file2}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${Extreme file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    ${Expected msg2}=    Set Variable If    ${File name length2}>20    ${First 16 chars file name2}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${Extreme file2}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${Extreme file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${Extreme file2}    Msg from where=result    Expected msg=${Expected msg2}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${Extreme file3}    Expect score=Infinity    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${Extreme file4}    Expect score=Infinity    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${Extreme file5}    Expect score=16.329931    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Error_File${/}${Extreme file6}    Expect score=0.4113026    Input type=id

Multiple User Upload Different Data To Taxi Issue And Rank Show Correct
    [Documentation]    Multiple user upload different score data and the rank should show correct with the actual rank
    [Tags]    Upload_Taxi    Upload_Taxi_11
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    # multiple user upload different data
    ${Upload file1}=    Set Variable    pri_51.70106381884226_pub_68.09307355867165.csv
    ${Upload file2}=    Set Variable    pri_54.954526656136345_pub_55.82711408148075.csv
    ${Upload file3}=    Set Variable    pri_0.0_pub_0.0.csv
    # t1
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file1}    Expect score=68.093073    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file2}    Expect score=55.827114    Input type=id
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file3}    Expect score=0.0    Input type=id
    # check if the rank is true
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id

Multiple User Upload Same Data At Different Time To Taxi Issue And Rank Show Correct
    [Documentation]    Multiple user upload same score data with different time and the rank should show correct with the actual rank
    [Tags]    Upload_Taxi    Upload_Taxi_12    # create and init topic
    ${File name}=    Set Variable    taxi3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    # multiple user upload same data
    ${upload file}=    Set Variable    pri_58.52349955359813_pub_51.881274720911264.csv
    # t1
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${upload file}    Expect score=51.881274    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path taxi}${/}Correct_File${/}${upload file}    Expect score=51.881274    Input type=id
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path taxi}${/}Correct_File${/}${upload file}    Expect score=51.881274    Input type=id
    # check if the rank is true
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Upload_SinglePublic---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Upload Single Public Version ---
    [Teardown]    No Operation

#Upload Correct Result To Single Public Issue
#    [Documentation]    Upload normal result to single public version issues.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_1
#    ${File name}=    Set Variable    SinglePublic
#    Create Topic With Argument    ${File name}    pub_single_reg_hydraulic
#    ${Upload file}=    Set Variable    pub_0.4022249.csv
#    ${Upload file2}=    Set Variable    pub_0.4080104.csv
#    ${Upload file3}=    Set Variable    pub_0.4061995.csv
#    ${Upload file4}=    Set Variable    pub_0.4016470.csv
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file}    ${gTemp folder path}${/}${Time prefix}_${Upload file}    # Normal file
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file2}    ${gTemp folder path}${/}${Time prefix}_${Upload file2}    # Normal file
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file3}    ${gTemp folder path}${/}${Time prefix}_${Upload file3}    # Normal file
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file4}    ${gTemp folder path}${/}${Time prefix}_${Upload file 4}    #Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file}    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file2}    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file3}    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file4}    Input type=id    #Normal file
#
#Upload Correct Result To Single Public Issue And Check Score Accuracy
#    [Documentation]    Upload normal result to single public version issues and check score accuracy.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_2
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${Upload file}=    Set Variable    pub_0.4022249.csv
#    ${Upload file2}=    Set Variable    pub_0.4080104.csv
#    ${Upload file3}=    Set Variable    pub_0.4061995.csv
#    ${Upload file4}=    Set Variable    pub_0.4016470.csv
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file}    ${gTemp folder path}${/}${Time prefix}_${Upload file}    # Normal file
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file2}    ${gTemp folder path}${/}${Time prefix}_${Upload file2}    # Normal file
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file3}    ${gTemp folder path}${/}${Time prefix}_${Upload file3}    # Normal file
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file4}    ${gTemp folder path}${/}${Time prefix}_${Upload file4}    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file}    Expect score=0.4022249    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file2}    Expect score=0.4080104    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file3}    Expect score=0.4061995    Input type=id    # Normal file
#    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.4061995    Expect score2=0.4080104    Expect score3=0.4022249
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file4}    Expect score=0.4016470    Input type=id    # Normal file
#    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.4016470    Expect score2=0.4061995    Expect score3=0.4080104
#
#Upload ID Error Content Result To Single Public Issue
#    [Documentation]    Upload ID error content result to single public version issue and expected error.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_3
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${error file}=    Set Variable    ID_error.csv
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload ID Loss Content Result To Single Public Issue
#    [Documentation]    Upload private and public nan content result to single public version issues and expected error.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_4
#    [Setup]    Login To OCAIP    Block Image=True
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${error file}=    Set Variable    ID_loss.csv
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload Value Loss Content Result To Single Public Issue
#    [Documentation]    Upload less value result to single public version issues and expected error.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_5
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${error file}=    Set Variable    value_loss.csv
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案有包含空值不合規則！    ${Time prefix}_${error file}：上傳檔案有包含空值不合規則！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload ID And Value Loss Content Result To Single Public Issue
#    [Documentation]    Upload one nan content result to single public version issues and expected error.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_6
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${error file}=    Set Variable    ID_value_loss.csv
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload Not Float Content Result To Single Public Issue
#    [Documentation]    Upload not float content result to single public version issues and expected error.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_7
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${error file}=    Set Variable    not_float.csv
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload Executable Program Result To Single Public Issue
#    [Documentation]    Upload executable program to single public version issues and expected error.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_8
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${error file}=    Set Variable    error_badprogram.csv
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload Format Error Result To Single Public Issue
#    [Documentation]    Upload error format result to single public version issue and expected error.
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_9
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${error file}=    Set Variable    error_format.zip
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=button    Expected msg=此議題僅接受 csv 格式的檔案    Input type=id
#    # Error content file
#
#Upload Extreme Value Content Result To Single Public Issue
#    [Documentation]    Upload extreme value content result to single public version issue and expected error.
#    ...
#    ...    - extreme_value_over309.csv : if any value is over 309 digits (include 309 digits), upload failed.
#    ...    - extreme_value_negative_over309.csv : if any negative value is over 309 digits (include 309 digits), upload failed.
#    ...    - extreme_value_over155.csv : if any value is over 155 digits but less than 309 digits ( 155<=digit<309), upload succeed and expect score = inf.
#    ...    - extreme_value_negative_over155.csv : if any negative value is over 155 digits but less than 309 digits (155<=digit<309), upload succeed and expect score = inf.
#    ...
#    ...    Explanations :
#    ...
#    ...    | value >= 1E+309 upload failed and show error message |
#    ...    | value <= -1E+309 upload failed and show error message |
#    ...    | 1E+155 <= value < 1E+309 upload succeed and show expect score = inf |
#    ...    | -1E+155 >= value > -1E+309 upload succeed and show expect score = inf |
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_10
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${Extreme file}=    Set Variable    extreme_value_over309.csv
#    ${Extreme file2}=    Set Variable    extreme_value_negative_over309.csv
#    ${Extreme file3}=    Set Variable    extreme_value_over155.csv
#    ${Extreme file4}=    Set Variable    extreme_value_negative_over155.csv
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${Extreme file}    ${gTemp folder path}${/}${Time prefix}_${Extreme file}
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${Extreme file2}    ${gTemp folder path}${/}${Time prefix}_${Extreme file2}
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${Extreme file3}    ${gTemp folder path}${/}${Time prefix}_${Extreme file3}
#    Copy File    ${gTest data path SinglePublic}${/}Error_File${/}${Extreme file4}    ${gTemp folder path}${/}${Time prefix}_${Extreme file4}
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${Extreme file}    0    16
#    ${First 16 chars file name2}=    Get Substring    ${Time prefix}_${Extreme file2}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${Extreme file}
#    ${File name length2}=    Get Length    ${Time prefix}_${Extreme file2}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${Time prefix}_${Extreme file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
#    ${Expected msg2}=    Set Variable If    ${File name length2}>20    ${First 16 chars file name2}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${Time prefix}_${Extreme file2}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Extreme file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Extreme file2}    Msg from where=result    Expected msg=${Expected msg2}    Input type=id
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Extreme file3}    Expect score=Infinity    Input type=id
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Extreme file4}    Expect score=Infinity    Input type=id
#
#Multiple User Upload Different Data To SinglePublic Issue And Rank Show Correct
#    [Documentation]    Multiple user upload different score data and the rank should show correct with the actual rank
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_11
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    # multiple user upload different data
#    ${Upload file1}=    Set Variable    pub_0.4080104.csv
#    ${Upload file2}=    Set Variable    pub_0.4061995.csv
#    ${Upload file3}=    Set Variable    pub_0.4022249.csv
#    # t1
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file1}    ${gTemp folder path}${/}${Time prefix}_${Upload file1}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file1}    Expect score=0.4080104    Input type=id
#    Logout OCAIP
#    # t2
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file2}    ${gTemp folder path}${/}${Time prefix}_${Upload file2}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file2}    Expect score=0.4061995    Input type=id
#    Logout OCAIP
#    # t3
#    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${Upload file3}    ${gTemp folder path}${/}${Time prefix}_${Upload file3}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file3}    Expect score=0.4022249    Input type=id
#    # check if the rank is true
#    # t3
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id
#    Logout OCAIP
#    # t2
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
#    Logout OCAIP
#    # t1
#    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id
#
#Multiple User Upload Same Data At Different Time To SinglePublic Issue And Rank Show Correct
#    [Documentation]    Multiple user upload same score data with different time and the rank should show correct with the actual rank
#    [Tags]    Upload_SinglePublic    Upload_SinglePublic_12    # create and init topic
#    ${File name}=    Set Variable    SinglePublic
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    # multiple user upload same data
#    ${upload file}=    Set Variable    pub_0.4016470.csv
#    # t1
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${upload file}    ${gTemp folder path}${/}${Time prefix}_${upload file}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${upload file}    Expect score=0.4016470    Input type=id
#    Remove File    ${gTemp folder path}${/}${Time prefix}_${upload file}
#    Logout OCAIP
#    # t2
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${upload file}    ${gTemp folder path}${/}${Time prefix}_${upload file}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTemp folder path}${/}${Time prefix}_${upload file}    Expect score=0.4016470    Input type=id
#    Remove File    ${gTemp folder path}${/}${Time prefix}_${upload file}
#    Logout OCAIP
#    # t3
#    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    Copy File    ${gTest data path SinglePublic}${/}Correct_File${/}${upload file}    ${gTemp folder path}${/}${Time prefix}_${upload file}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTemp folder path}${/}${Time prefix}_${upload file}    Expect score=0.4016470    Input type=id
#    Remove File    ${gTemp folder path}${/}${Time prefix}_${upload file}
#    # check if the rank is true
#    # t3
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id
#    Logout OCAIP
#    # t2
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
#    Logout OCAIP
#    # t1
#    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id

--- Upload ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Upload ---
    [Teardown]    No Operation

#Upload Correct Result
#    [Documentation]    Upload normal result to topic_3_4 issue (eval_type = single public && web_status_flow_type = simple).
#    [Tags]    Upload    Upload_1
#    ${File name}=    Set Variable    topic_3_4
#    Create Topic With Argument    ${File name}    pub_single_simple_topic_3_4    Flow type=simple    Join=No
#    ${Upload file}=    Set Variable    pub_57.34356189590154.csv
#    ${Upload file2}=    Set Variable    pub_32.776273291957565.csv
#    ${Upload file3}=    Set Variable    pub_57.13391366700772.csv
#    ${Upload file4}=    Set Variable    pub_86.36119406833772.csv
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file}    ${gTemp folder path}${/}${Time prefix}_${Upload file}    # Normal file
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file2}    ${gTemp folder path}${/}${Time prefix}_${Upload file2}    # Normal file
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file3}    ${gTemp folder path}${/}${Time prefix}_${Upload file3}
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file4}    ${gTemp folder path}${/}${Time prefix}_${Upload file4}
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file}    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file2}    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file3}    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file4}    Input type=id    #Normal file
#
#Upload Correct Result And Check Score Accuracy
#    [Documentation]    Upload normal result to topic_3_4 issue (eval_type = single public && web_status_flow_type = simple) and check score accuracy.
#    [Tags]    Upload    Upload_2
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    ${Upload file}=    Set Variable    pub_57.34356189590154.csv
#    ${Upload file2}=    Set Variable    pub_32.776273291957565.csv
#    ${Upload file3}=    Set Variable    pub_57.13391366700772.csv
#    ${Upload file4}=    Set Variable    pub_86.36119406833772.csv
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file}    ${gTemp folder path}${/}${Time prefix}_${Upload file}    # Normal file
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file2}    ${gTemp folder path}${/}${Time prefix}_${Upload file2}    # Normal file
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file3}    ${gTemp folder path}${/}${Time prefix}_${Upload file3}    # Normal file
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file4}    ${gTemp folder path}${/}${Time prefix}_${Upload file4}    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file}    Expect score=57.343561    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file2}    Expect score=32.776273    Input type=id    # Normal file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file3}    Expect score=57.133913    Input type=id    # Normal file
#    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=57.133913    Expect score2=32.776273    Expect score3=57.343561
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file4}    Expect score=86.361194    Input type=id    # Normal file
#    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=86.361194    Expect score2=57.133913    Expect score3=32.776273
#
#Upload ID Error Content Result
#    [Documentation]    Upload result with error id number to topic_3_4 issue (eval_type = single public && web_status_flow_type = simple) and expected error.
#    [Tags]    Upload    Upload_3
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    ${error file}=    Set Variable    ID_error.csv
#    Copy File    ${gTest data path}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error content file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload ID Loss Content Result
#    [Documentation]    Upload result with ID loss content to topic_3_4 issue (eval_type = single public && web_status_flow_type = simple) and expected error.
#    [Tags]    Upload    Upload_4
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    ${error file}=    Set Variable    ID_loss.csv
#    Copy File    ${gTest data path}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error content file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload Value Loss Content Result
#    [Documentation]    Upload result with value loss content to topic_3_4 issue (eval_type = single public && web_status_flow_type = simple) and expected error.
#    [Tags]    Upload    Upload_5
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    ${error file}=    Set Variable    value_loss.csv
#    Copy File    ${gTest data path}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error content file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案有包含空值不合規則！    ${Time prefix}_${error file}：上傳檔案有包含空值不合規則！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload ID And Value Loss Content Resullt
#    [Documentation]    Upload one nan content result to \ topic_3_4 (eval_type = single public && web_status_flow_type = simple) issues and expected error.
#    [Tags]    Upload    Upload_6
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    ${error file}=    Set Variable    ID_value_loss.csv
#    Copy File    ${gTest data path}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error content file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${error file}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload Jpg Error Content Result
#    [Documentation]    Upload result with error jpg content to topic_3_4 issue (eval_type = single public && web_status_flow_type = simple) and expected error.
#    [Tags]    Upload    Upload_7
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    ${error file}=    Set Variable    jpg_csv.csv
#    Copy File    ${gTest data path}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error content file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${Time prefix}_${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload Executable Program Result
#    [Documentation]    Upload executable program content result to topic_3_4 issue (eval_type = single public && web_status_flow_type = simple) and expected error.
#    [Tags]    Upload    Upload_8
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    ${error file}=    Set Variable    error_badprogram.csv
#    Copy File    ${gTest data path}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error content file
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${error file}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${error file}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${Time prefix}_${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    # Error content file
#
#Upload Format Error Result
#    [Documentation]    Upload error format result to topic_3_4 issue (eval_type = single public && web_status_flow_type = simple) \ and expected error.
#    [Tags]    Upload    Upload_9
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    ${error file}=    Set Variable    error_format.zip
#    Copy File    ${gTest data path}${/}Error_File${/}${error file}    ${gTemp folder path}${/}${Time prefix}_${error file}    # Error format file
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${error file}    Msg from where=button    Expected msg=此議題僅接受 csv 格式的檔案    Input type=id
#    # Error content file
#
#Upload Extreme Content Result
#    [Documentation]    Upload extreme value content result to topic_3_4 issue and expected error.
#    ...
#    ...    - extreme_value_over309.csv : if any value is over 309 digits (include 309 digits), upload failed.
#    ...    - extreme_value_negative_over309.csv : if any negative value is over 309 digits (include 309 digits), upload failed.
#    ...    - extreme_value_over155.csv : if any value is over 155 digits but less than 309 digits ( 155<=digit<309), upload succeed and expect score = inf.
#    ...    - extreme_value_negative_over155.csv : if any negative value is over 155 digits but less than 309 digits (155<=digit<309), upload succeed and expect score = inf.
#    ...
#    ...    Explanations :
#    ...
#    ...    | value >= 1E+309 upload failed and show error message |
#    ...    | value <= -1E+309 upload failed and show error message |
#    ...    | 1E+155 <= value < 1E+309 upload succeed and show expect score = inf |
#    ...    | -1E+155 >= value > -1E+309 upload succeed and show expect score = inf |
#    [Tags]    Upload    Upload_10
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
#    ${Extreme file}=    Set Variable    extreme_value_over309.csv
#    ${Extreme file2}=    Set Variable    extreme_value_negative_over309.csv
#    ${Extreme file3}=    Set Variable    extreme_value_over155.csv
#    ${Extreme file4}=    Set Variable    extreme_value_negative_over155.csv
#    Copy File    ${gTest data path}${/}Error_File${/}${Extreme file}    ${gTemp folder path}${/}${Time prefix}_${Extreme file}
#    Copy File    ${gTest data path}${/}Error_File${/}${Extreme file2}    ${gTemp folder path}${/}${Time prefix}_${Extreme file2}
#    Copy File    ${gTest data path}${/}Error_File${/}${Extreme file3}    ${gTemp folder path}${/}${Time prefix}_${Extreme file3}
#    Copy File    ${gTest data path}${/}Error_File${/}${Extreme file4}    ${gTemp folder path}${/}${Time prefix}_${Extreme file4}
#    ${First 16 chars file name}=    Get Substring    ${Time prefix}_${Extreme file}    0    16
#    ${First 16 chars file name2}=    Get Substring    ${Time prefix}_${Extreme file2}    0    16
#    ${File name length}=    Get Length    ${Time prefix}_${Extreme file}
#    ${File name length2}=    Get Length    ${Time prefix}_${Extreme file2}
#    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${Extreme file}：上傳檔案預測目標數量不合！
#    ${Expected msg2}=    Set Variable If    ${File name length2}>20    ${First 16 chars file name2}...csv：上傳檔案預測目標數量不合！    ${Time prefix}_${Extreme file2}：上傳檔案預測目標數量不合！
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Extreme file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Extreme file2}    Msg from where=result    Expected msg=${Expected msg2}    Input type=id
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Extreme file3}    Expect score=Infinity    Input type=id
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Extreme file4}    Expect score=Infinity    Input type=id
#
#Multiple User Upload Different Data And Rank Show Correct
#    [Documentation]    Multiple user upload different score data and the rank should show correct with the actual rank
#    [Tags]    Upload    Upload_11
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    # multiple user upload different data
#    ${Upload file1}=    Set Variable    pub_57.34356189590154.csv
#    ${Upload file2}=    Set Variable    pub_57.13391366700772.csv
#    ${Upload file3}=    Set Variable    pub_32.776273291957565.csv
#    # t1
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file1}    ${gTemp folder path}${/}${Time prefix}_${Upload file1}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file1}    Expect score=57.343561    Input type=id
#    Logout OCAIP
#    # t2
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file2}    ${gTemp folder path}${/}${Time prefix}_${Upload file2}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file2}    Expect score=57.133913    Input type=id
#    Logout OCAIP
#    # t3
#    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    Copy File    ${gTest data path}${/}Correct_File${/}${Upload file3}    ${gTemp folder path}${/}${Time prefix}_${Upload file3}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTemp folder path}${/}${Time prefix}_${Upload file3}    Expect score=32.776273    Input type=id
#    # check if the rank is true
#    # t3
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id
#    Logout OCAIP
#    # t2
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
#    Logout OCAIP
#    # t1
#    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id
#
#Multiple User Upload Same Data At Different Time And Rank Show Correct
#    [Documentation]    Multiple user upload same score data with different time and the rank should show correct with the actual rank
#    [Tags]    Upload    Upload_12    # create and init topic
#    ${File name}=    Set Variable    topic_3_4
#    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    # multiple user upload same data
#    ${upload file}=    Set Variable    pub_86.36119406833772.csv
#    # t1
#    Copy File    ${gTest data path}${/}Correct_File${/}${upload file}    ${gTemp folder path}${/}${Time prefix}_${upload file}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTemp folder path}${/}${Time prefix}_${upload file}    Expect score=86.361194    Input type=id
#    Remove File    ${gTemp folder path}${/}${Time prefix}_${upload file}
#    Logout OCAIP
#    # t2
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    Copy File    ${gTest data path}${/}Correct_File${/}${upload file}    ${gTemp folder path}${/}${Time prefix}_${upload file}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTemp folder path}${/}${Time prefix}_${upload file}    Expect score=86.361194    Input type=id
#    Remove File    ${gTemp folder path}${/}${Time prefix}_${upload file}
#    Logout OCAIP
#    # t3
#    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
#    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
#    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Flow type=simple    Join=No
#    Copy File    ${gTest data path}${/}Correct_File${/}${upload file}    ${gTemp folder path}${/}${Time prefix}_${upload file}    # Normal file
#    Sleep    1s
#    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTemp folder path}${/}${Time prefix}_${upload file}    Expect score=86.361194    Input type=id
#    Remove File    ${gTemp folder path}${/}${Time prefix}_${upload file}
#    # check if the rank is true
#    # t3
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id
#    Logout OCAIP
#    # t2
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id
#    Logout OCAIP
#    # t1
#    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
#    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id

--- Upload_News_Honor ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Upload_News_Honor ---
    [Teardown]    No Operation

Upload Correct Result To News_Honor Issue
    [Documentation]    Upload normal result to News_Honor issue.
    [Tags]    Upload_News_Honor    Upload_News_Honor_1    Enclosed_Topic
    ${File name}=    Set Variable    honor-1
    Create Topic With Argument    ${File name}    news_honor-ntu-test    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${Upload file}=    Set Variable    pri_0_pub_0.0333333.csv
    ${Upload file2}=    Set Variable    pri_0_pub_0.2.csv
    ${Upload file3}=    Set Variable    pri_0_pub_0.5.csv
    ${Upload file4}=    Set Variable    pri_0_pub_0.8.csv
    ${Upload file5}=    Set Variable    pri_0_pub_0.9.csv
    ${Upload file6}=    Set Variable    pri_0_pub_1.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file}    Input type=id    Topic type=course    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file2}    Input type=id    Topic type=course    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file3}    Input type=id    Topic type=course    # Normal file
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    ${File name2}=    Set Variable    honor-2
    Create Topic With Argument    ${File name2}    news_honor-ntu-test    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file4}    Input type=id    Topic type=course    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file5}    Input type=id    Topic type=course    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file6}    Input type=id    Topic type=course    # Normal file
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC

Upload Correct Result To News_Honor Issue And Check Score Accuracy
    [Documentation]    Upload normal result to News_Honor issue and check score accuracy.
    [Tags]    Upload_News_Honor    Upload_News_Honor_2    Enclosed_Topic
    ${File name}=    Set Variable    honor2-1
    Create Topic With Argument    ${File name}    news_honor-ntu-test    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${Upload file}=    Set Variable    pri_0_pub_0.0333333.csv
    ${Upload file2}=    Set Variable    pri_0_pub_0.2.csv
    ${Upload file3}=    Set Variable    pri_0_pub_0.5.csv
    ${Upload file4}=    Set Variable    pri_0_pub_0.8.csv
    ${Upload file5}=    Set Variable    pri_0_pub_0.9.csv
    ${Upload file6}=    Set Variable    pri_0_pub_1.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file}    Expect score=0.0333333    Input type=id    Topic type=course    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file2}    Expect score=0.2    Input type=id    Topic type=course    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file3}    Expect score=0.5    Input type=id    Topic type=course    # Normal file
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.5    Expect score2=0.2    Expect score3=0.0333333    Topic type=course
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.0    Topic type=course    #Temp pri score=0
    ${File name2}=    Set Variable    honor2-2
    Create Topic With Argument    ${File name2}    news_honor-ntu-test    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file4}    Expect score=0.8    Input type=id    Topic type=course    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file5}    Expect score=0.9    Input type=id    Topic type=course    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file6}    Expect score=1.0    Input type=id    Topic type=course    # Normal file
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=1.0    Expect score2=0.9    Expect score3=0.8    Topic type=course
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.0    Topic type=course    #Temp pri score=0

Upload ID Error Content Result To News_Honor Issue
    [Documentation]    Upload ID error content result to News_Honor issue and expected error.
    [Tags]    Upload_News_Honor    Upload_News_Honor_3    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Create Topic With Argument    ${File name}    news_honor-ntu-test    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${error file}=    Set Variable    ID_error.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案預測目標數量不合！    ${error file}：上傳檔案預測目標數量不合！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload ID Loss Content Result To News_Honor Issue
    [Documentation]    Upload ID loss content result to News_Honor issues and expected error.
    [Tags]    Upload_News_Honor    Upload_News_Honor_4    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${error file}=    Set Variable    ID_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload Value Loss Content Result To News_Honor Issue
    [Documentation]    Upload value loss content result to News_Honor issue and expected error.
    [Tags]    Upload_News_Honor    Upload_News_Honor_5    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${error file}=    Set Variable    value_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload ID And Value Loss Content Result To News_Honor Issue
    [Documentation]    Upload ID and value loss content result to News_Honor issue and expected error.
    [Tags]    Upload_News_Honor    Upload_News_Honor_6    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${error file}=    Set Variable    ID_value_loss.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload Jpg Error Content Result To News_Honor Issue
    [Documentation]    Upload jpg error content result to News_Honor issue and expected error.
    [Tags]    Upload_News_Honor    Upload_News_Honor_7    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${error file}=    Set Variable    jpg_csv.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload Executable Program Result To News_Honor Issue
    [Documentation]    Upload executable program to News_Honor issue and expected error.
    [Tags]    Upload_News_Honor    Upload_News_Honor_8    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${error file}=    Set Variable    error_badprogram.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload Format Error Result To News_Honor Issue
    [Documentation]    Upload error format result to News_Honor issue and expected error.
    [Tags]    Upload_News_Honor    Upload_News_Honor_9    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${error file}=    Set Variable    error_format.zip
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Error_File${/}${error file}    Msg from where=button    Expected msg=此議題僅接受 csv 格式的檔案    Input type=id

Upload 2 Columns Shifted Data To News_Honor Issue
    [Documentation]    Upload 2 columns shifted data to News_Honor issue and expected error.
    [Tags]    Upload_News_Honor    Upload_News_Honor_10    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    ${error file}=    Set Variable    shift_2columns.csv
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...csv：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Multiple User Upload Different Data To News_Honor Issue And Rank Show Correct
    [Documentation]    Multiple user upload different score data and the rank should show correct with the actual rank
    [Tags]    Upload_News_Honor    Upload_News_Honor_11    Enclosed_Topic
    ${File name}=    Set Variable    honor3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest first account} ${gTest normal account}    Expect=0
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    # multiple user upload different data
    ${Upload file}=    Set Variable    pri_0_pub_0.0333333.csv
    ${Upload file2}=    Set Variable    pri_0_pub_0.2.csv
    ${Upload file3}=    Set Variable    pri_0_pub_0.5.csv
    # t1
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file}    Expect score=0.0333333    Input type=id    Topic type=course    # Normal file
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file2}    Expect score=0.2    Input type=id    Topic type=course    # Normal file
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file3}    Expect score=0.5    Input type=id    Topic type=course    # Normal file
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id    Topic type=course
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id    Topic type=course
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id    Topic type=course
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Multiple User Upload Same Data At Different Time To News_Honor Issue And Rank Show Correct
    [Documentation]    Multiple user upload same score data with different time and the rank should show correct with the actual rank
    [Tags]    Upload_News_Honor    Upload_News_Honor_12    Enclosed_Topic
    ${File name}=    Set Variable    honor4
    Create Topic With Argument    ${File name}    news_honor-ntu-test    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account} ${gTest first account} ${gTest normal account}    Expect=0
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    # multiple user upload same data
    ${Upload file}=    Set Variable    pri_0_pub_0.0333333.csv
    # t1
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file}    Expect score=0.0333333    Input type=id    Topic type=course    # Normal file
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file}    Expect score=0.0333333    Input type=id    Topic type=course    # Normal file
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id    Topic type=course
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}${Upload file}    Expect score=0.0333333    Input type=id    Topic type=course    # Normal file
    # check if the rank is true
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=3/3    Input type=id    Topic type=course
    Logout OCAIP
    # t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/3    Input type=id    Topic type=course
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/3    Input type=id    Topic type=course
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Change Eval Stage For NTU_News Issue
    [Documentation]    change eval stage for NTU_News issue, recalculate scores, and rerank.
    [Tags]    Upload_News_Honor    Upload_News_Honor_13
    ${File name}=    Set Variable    2stage
    Create Topic With Argument    ${File name}    news_ntu_2stages    Join=No
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}pri_0.99_pub_0.981_2stage.csv    Expect score=0.9817870    Input type=id
    #t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}
    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}pri_0.99_pub_0.986_2stage.csv    Expect score=0.9862158    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.9966332
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/2    Input type=id    Board type=private
    Switch Browser    1
    #t1
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.9966332
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/2    Input type=id    Board type=private
    Change Eval Stage By API    ${gTopic ID Now}    2
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.9821552
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/2    Input type=id    Board type=private
    Switch Browser    2
    #t2
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.9842631
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/2    Input type=id    Board type=private

Check Public And Private Leaderboard To News_Honor Issue And Show Correctly
    [Documentation]    Check public and private leaderboard and show correctly
    [Tags]    Upload_News_Honor    Upload_News_Honor_14
    ${File name}=    Set Variable    2stage
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${ranks}=    Create List    2    2
    Check Leaderboard Is Correct    ${gTopic ID Now}    Expect user=t1    Expect ranks=${ranks}    Expect score=0.9817870    Input type=id    Board type=public
    Check Leaderboard Is Correct    ${gTopic ID Now}    Expect user=t1    Expect ranks=${ranks}    Expect score=0.9821552    Input type=id    Board type=private
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Upload_Marathon ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Upload_Marathon ---
    [Teardown]    No Operation

Upload Correct Result To Marathon Issue
    [Documentation]    Upload normal result to marathon issue.
    [Tags]    Upload_Marathon    Upload_Marathon_1
    ${File name}=    Set Variable    marathon1
    Create Topic With Argument    ${File name}    pri_team_reg_marathon    Join=No
    ${Upload file}=    Set Variable    main0.33_0.1.zip
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path marathon}${/}Correct_File${/}${Upload file}    Input type=id    Job=True    # Normal file
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.3333333

Upload Results To Marathon Issue Simultaneously And Be Blocked
    [Documentation]    Uploading results to marathon issue simultaneously should be blocked
    [Tags]    Upload_Marathon    Upload_Marathon_2
    ${File name}=    Set Variable    marathon1
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Upload file}=    Set Variable    main0.33_0.1.zip
    #2
    Login To OCAIP    ${gTest account}    ${gTest password}
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    ${Upload file}    Normalize Path    ${gTest data path marathon}${/}Correct_File${/}${Upload file}
    Choose File    //input[@id='result_data'][@type='file']    ${Upload file}
    #1
    Switch Browser    1
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Choose File    //input[@id='result_data'][@type='file']    ${Upload file}
    Click Element    id=submit
    #2
    Switch Browser    2
    Click Element    id=submit
    Wait Until Element Contains    //div[@id="flash_block"]/div[contains(@class,"alert")]     您現在有正在執行的 job, 此次上傳失敗！
    #1
    Switch Browser    1
    Wait Until Element Contains    //div[@id="data_upload"]//div[@class="file_select_name"]    未選擇任何檔案    timeout=600
    ${count}=    Get Element Count    //div[@id="evaluation_result"]//tr[contains(@class,"upload_inf")]
    Should Be Equal    ${count}    ${2}
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Team Upload Results To Marathon Issue
    [Documentation]    Team upload results to marathon issue.
    [Tags]    Upload_Marathon    Upload_Marathon_3
    ${File name}=    Set Variable    marathon2
    Create Topic With Argument    ${File name}    pri_team_reg_marathon    Join=No
    Logout OCAIP
    # t3 sign up issue
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t1    Contain team=yes    Input type=id
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t3    Request leader=t3    Operation=accept    Input type=id
    ${Upload file}=    Set Variable    main0.33_0.1.zip
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path marathon}${/}Correct_File${/}${Upload file}    Input type=id    Job=True    # Normal file
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path marathon}${/}Correct_File${/}${Upload file}    Input type=id    Job=True    # Normal file
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.3333333    Expect score2=0.3333333
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.1
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Results Until Reaching Job Limitation
    [Documentation]    Upload results until reaching job limitation and queue following jobs
    [Tags]    Upload_Marathon    Upload_Marathon_4
    [Setup]    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    ${File name}=    Set Variable    marathon3
    Create Topic With Argument    ${File name}    pri_team_reg_marathon    Join=No    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account} ${gTest normal account} ${gTest account4}    Expect=3
    ${Upload file}=    Set Variable    main0.33_0.1.zip
    ${Upload file}    Normalize Path    ${gTest data path marathon}${/}Correct_File${/}${Upload file}
    FOR     ${Account}    IN    ${gTest account}    ${gTest normal account}    ${gTest account4}
        Login To OCAIP    ${Account}    ${gTest password}    Open browser=true
        Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
        Choose File    //input[@id='result_data'][@type='file']    ${Upload file}
        Click Element    id=submit
    END
    Wait Until Element Contains    //h6[@id="upload_animation"]    等待獲得資源中
    # Switch to Admin and check status
    Switch Browser    1
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest account}    Sequence=3    Status=running
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest normal account}    Sequence=2    Status=running
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest account4}    Sequence=1    Status=queued
    # Switch to t1 and cancel job
    Switch Browser    2
    Click Element    //div[@id="job_cancel"]
    Alert Should Be Present    確認取消工作，請點 OK
    # Switch to Admin and check status
    Switch Browser    1
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest account}    Sequence=3    Status=cancelled
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest account4}    Sequence=1    Status=running    attempt=2
    Cancel Running Jobs

Upload Results To Marathon Issue And Cancel Queued Job
    [Documentation]    Upload results, cancel queued job ,and check job status
    [Tags]    Upload_Marathon    Upload_Marathon_5
    [Setup]    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    ${File name}=    Set Variable    marathon3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Upload file}=    Set Variable    main0.33_0.1.zip
    ${Upload file}    Normalize Path    ${gTest data path marathon}${/}Correct_File${/}${Upload file}
    FOR     ${Account}    IN    ${gTest account}    ${gTest normal account}    ${gTest account4}
        Login To OCAIP    ${Account}    ${gTest password}    Open browser=true
        Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
        Choose File    //input[@id='result_data'][@type='file']    ${Upload file}
        Click Element    id=submit
        # When t4 queued break loop
        Exit For Loop If    "${Account}"=="${gTest account4}"
        Wait Until Element Contains    //h6[@id="upload_animation"]    程式環境準備中
        Switch Browser    1
        Check Jobs Monitor Status    ${gTopic Name Now}    ${Account}    Sequence=1    Status=preparing
    END
    Wait Until Element Contains    //h6[@id="upload_animation"]    等待獲得資源中
    # Switch to Admin and check status
    Switch Browser    1
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest account}    Sequence=3    Status=running
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest normal account}    Sequence=2    Status=running
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest account4}    Sequence=1    Status=queued
    # Switch to t4 and cancel job
    Switch Browser    4
    Click Element    //div[@id="job_cancel"]
    Alert Should Be Present    確認取消工作，請點 OK
    # Switch to Admin and check status
    Switch Browser    1
    Check Jobs Monitor Status    ${gTopic Name Now}    ${gTest account4}    Sequence=1    Status=cancelled
    Cancel Running Jobs
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Empty/Non-zip/Oversize Results To Marathon Issue
    [Documentation]    Upload empty/non-zip/oversize results to marathon issue.
    [Tags]    Upload_Marathon    Upload_Marathon_6
    ${File name}=    Set Variable    marathon4
    Create Topic With Argument    ${File name}    pri_team_reg_marathon    Join=No
    ${Upload file}=    Set Variable    empty.zip
    ${Upload file2}=    Set Variable    error_format.csv
    ${Upload file3}=    Set Variable    oversize.zip
    # Empty without main.py
    ${Expected msg}=    Set Variable    ：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path marathon}${/}Error_File${/}${Upload file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id    Job=True
    # Not ZIP
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path marathon}${/}Error_File${/}${Upload file2}    Msg from where=button    Expected msg=此議題僅接受 zip格式且包含 main.py 之英文檔名的檔案    Input type=id    Job=True
    # Oversize
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    ${Upload file}    Normalize Path    ${gTest data path marathon}${/}Error_File${/}${Upload file3}
    Choose File    //input[@id='result_data'][@type='file']    ${Upload file}
    Click Element    id=submit
    Wait Until Element Contains    //div[@id="flash_block"]/div[contains(@class,"alert")]    上傳的程式超過大小限制

Upload Overtime Result To Marathon Issue
    [Documentation]    Upload overtime result to marathon issue.
    [Tags]    Upload_Marathon    Upload_Marathon_7
    ${File name}=    Set Variable    marathon4
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Upload file}=    Set Variable    overtime.zip
    ${Expected msg}=    Set Variable    ：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    # Timeout
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path marathon}${/}Error_File${/}${Upload file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id    Job=True
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Upload_Braints ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Upload_Braints ---
    [Teardown]    No Operation

Upload Correct Result To Braints Issue
    [Documentation]    Upload normal result to braints issue and miss 0.
    [Tags]    Upload_Braints    Upload_Braints_1
    [Setup]    Login To OCAIP    ${gTest first account}    ${gTest first password}
    ${File name}=    Set Variable    braints1
    Create Topic With Argument    ${File name}    pri_team_reg_braints    Join=No
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    Modify Topic Settings    upload_file_extension    Content=zip
    Switch Browser    1
    ${Upload file}=    Set Variable    pri_0.685_pub_0.685.zip
    ${Score}=    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path braints}${/}Correct_File${/}${Upload file}    Expect score=0.6852257    Input type=id    Detail=True
    @{Score}=    Split String    ${Score}    ${Space}
    Should Be Equal    ${Score[6]}    0
    ${Upload file}=    Set Variable    pri_0.439_pub_0.439_miss2.zip
    ${Score}=    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path braints}${/}Correct_File${/}${Upload file}    Expect score=0.4399426    Input type=id    Detail=True
    @{Score}=    Split String    ${Score}    ${Space}
    Should Be Equal    ${Score[6]}    2
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.4399426    Expect score2=0.6852257
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.4399426
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Empty Zip To Braints Issue
    [Documentation]    Upload empty zip result to braints issue and miss 5.
    [Tags]    Upload_Braints    Upload_Braints_2
    [Setup]    Login To OCAIP    ${gTest first account}    ${gTest first password}
    ${File name}=    Set Variable    braints2
    Create Topic With Argument    ${File name}    pri_team_reg_braints    Join=No
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    Modify Topic Settings    upload_file_extension    Content=zip
    Switch Browser    1
    ${error file}=    Set Variable    empty_miss5.zip
    ${Score}=    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path braints}${/}Error_File${/}${error file}    Expect score=0.0    Input type=id    Detail=True
    @{Score}=    Split String    ${Score}    ${Space}
    Should Be Equal    ${Score[6]}    5

Upload Jpg Error Content Result To Braints Issue
    [Documentation]    Upload result with error jpg content to braints issue and expected error.
    [Tags]    Upload_Braints    Upload_Braints_3
    [Setup]    Login To OCAIP    ${gTest first account}    ${gTest first password}
    ${File name}=    Set Variable    braints2
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${error file}=    Set Variable    jpg.zip
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...zip：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path braints}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload Executable Program Result To Braints Issue
    [Documentation]    Upload executable program content result to braints issue and expected error.
    [Tags]    Upload_Braints    Upload_Braints_4
    [Setup]    Login To OCAIP    ${gTest first account}    ${gTest first password}
    ${File name}=    Set Variable    braints2
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${error file}=    Set Variable    error_badprogram.zip
    ${First 16 chars file name}=    Get Substring    ${error file}    0    16
    ${File name length}=    Get Length    ${error file}
    ${Expected msg}=    Set Variable If    ${File name length}>20    ${First 16 chars file name}...zip：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！    ${error file}：上傳檔案不合規則，請再次檢查你的上傳檔案，若還有問題請洽 AIdea 管理人員！
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path braints}${/}Error_File${/}${error file}    Msg from where=result    Expected msg=${Expected msg}    Input type=id

Upload Format Error Result To Braints Issue
    [Documentation]    Upload error format result to braints issue and expected error.
    [Tags]    Upload_Braints    Upload_Braints_5
    [Setup]    Login To OCAIP    ${gTest first account}    ${gTest first password}
    ${File name}=    Set Variable    braints2
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${error file}=    Set Variable    error_format.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path braints}${/}Error_File${/}${error file}    Msg from where=button    Expected msg=此議題僅接受 zip 格式的檔案    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Upload_Team ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Upload_Team ---
    [Teardown]    No Operation

Public Board Should Show The Highest Score Of A Team
    [Documentation]    Public board should show the highest score of a team.
    ...    - ex: t1, t2, t3 are in a team, and public board should show the highest score among the three users.
    [Tags]    Upload_Team    Upload_Team_1
    ${File name}=    Set Variable    upload_teamup
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t3 sign up issue
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t1 invites t2 and t3 to team up
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 and t3 accepts t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    # t1, t2, t3 upload different files
    ${Upload file1}=    Set Variable    pri_0.7_pub_0.5.csv
    ${Upload file2}=    Set Variable    pri_0.9_pub_0.9.csv
    ${Upload file3}=    Set Variable    pri_0.8_pub_0.8.csv
    ${Upload file4}=    Set Variable    pri_0.5_pub_0.7.csv
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file1}    Expect score=0.5    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file2}    Expect score=0.9    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account3}    ${gTest semiadmin password3}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest semiadmin account3}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file4}    Expect score=0.7    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file3}    Expect score=0.8    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.8    Expect score2=0.9    Expect score3=0.5
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.8
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/2    Input type=id    Board type=public
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/2    Input type=id    Board type=private
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Enclosed Board Should Show The Highest Score Of A Team
    [Documentation]    Public board should show the highest score of a team. (enclosed version)
    ...    - ex: t1, t2, t3 are in a team, and public board should show the highest score among the three users.
    [Tags]    Upload_Team    Upload_Team_2    Enclosed_Topic
    ${File name}=    Set Variable    upload_teamup2
    Create Topic With Argument    ${File name}    enclosed_pri_team_reg_AOI    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account} ${gTest first account} ${gTest normal account} ${gTest semiadmin account3}    Expect=0
    # t1 invites t2 and t3 to team up
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 and t3 accepts t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    # t1, t2, t3 upload different files
    ${Upload file1}=    Set Variable    pri_0.7_pub_0.5.csv
    ${Upload file2}=    Set Variable    pri_0.9_pub_0.9.csv
    ${Upload file3}=    Set Variable    pri_0.8_pub_0.8.csv
    ${Upload file4}=    Set Variable    pri_0.5_pub_0.7.csv
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file1}    Expect score=0.5    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file2}    Expect score=0.9    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account3}    ${gTest semiadmin password3}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest semiadmin account3}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file4}    Expect score=0.7    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file3}    Expect score=0.8    Input type=id
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.8    Expect score2=0.9    Expect score3=0.5
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.8
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/2    Input type=id    Board type=public
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/2    Input type=id    Board type=private
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Select Multistage Scores And Check Tag
    [Documentation]    Select multistage scores and check tag
    [Tags]    Upload_Team    Upload_Team_3    Select_Score
    ${File name}=    Set Variable    select-score1
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=t1 t2 t3    Expect=3
    # t1 invites t2 and t3 to team up
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 and t3 accepts t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    # t1, t2, t3 upload different files
    ${Upload file1}=    Set Variable    pri_51.70106381884226_pub_68.09307355867165.csv
    ${Upload file2}=    Set Variable    pri_54.954526656136345_pub_55.82711408148075.csv
    ${Upload file3}=    Set Variable    pri_58.52349955359813_pub_51.881274720911264.csv
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file1}    Expect score=68.093073    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file2}    Expect score=55.827114    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file2}    Expect score=55.827114    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file3}    Expect score=51.881274    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file3}    Expect score=51.881274    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file1}    Expect score=68.093073    Input type=id
    Page Should Not Contain Element    //li[@data-tab="u_pick"]//i[contains(@class,"done")]
    #Stage 2
    Click Element    //a[text()="挑選成果"]
    Wait Until Element Contains    //div[@id="u_pick"]    開放挑選
    Change Topic Date    ${gTopic ID Now}    Operation=START_SEL    Success msg=Successfully changed topic eval date    Error msg=Failed to change topic eval date
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Select Uploaded Score
    Page Should Contain Element    //li[@data-tab="u_pick"]//i[contains(@class,"done")]

Select Multiple Scores And Expect Error
    [Documentation]    Select multiple scores, expect error ,and unselect
    [Tags]    Upload_Team    Upload_Team_4    Select_Score
    ${File name}=    Set Variable    select-score1
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Click Element    //a[text()="挑選成果"]
    Wait Until Page Contains Element    //table[@id="pickscore"]
    #Select 4 scores fast and expect error
    ${speed}=    Get Selenium Speed
    Set Selenium Speed    0s
    Click Element    //table[@id="pickscore"]//tr[2]//input
    Click Element    //table[@id="pickscore"]//tr[3]//input
    Click Element    //table[@id="pickscore"]//tr[4]//input
    Set Selenium Speed    ${speed}
    Wait Until Element Is Visible    //div[@id="private_select_alert"]
    Click Element    //div[@id="private_select_alert"]//button[@id="to_assign"]
    Checkbox Should Be Selected    //table[@id="pickscore"]//tr[1]//input
    Checkbox Should Be Selected    //table[@id="pickscore"]//tr[2]//input
    Checkbox Should Be Selected    //table[@id="pickscore"]//tr[3]//input
    Checkbox Should Not Be Selected    //table[@id="pickscore"]//tr[4]//input
    #Unselect Scores
    Select Uploaded Score
    Select Uploaded Score    Sequence=2

Select The Same Score Simultaneously
    [Documentation]    Select the same score simultaneously and check checkbox disabled
    [Tags]    Upload_Team    Upload_Team_5    Select_Score
    ${File name}=    Set Variable    select-score1
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Click Element    //a[text()="挑選成果"]
    Login To OCAIP    ${gTest account}    ${gTest password}
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Click Element    //a[text()="挑選成果"]
    Sleep    3s    #BUG? element is not attached to the page document
    Switch Browser    1
    Click Element    //table[@id="pickscore"]//tr[4]//input
    Switch Browser    2
    Customized Mouse Over    //table[@id="pickscore"]//tr[4]//input
    Click Element    //table[@id="pickscore"]//tr[4]//input
    Wait Until Element Is Visible    //div[@id="private_select_alert"]
    Click Element    //div[@id="private_select_alert"]//button[@id="to_assign"]
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Click Element    //a[text()="挑選成果"]
    Sleep    3s    #BUG? element is not attached to the page document
    Checkbox Should Not Be Selected    //table[@id="pickscore"]//tr[4]//input
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Run Keyword And Expect Error    STARTS: Checkbox '//table[@id="pickscore"]//tr[2]//input' should have been selected but was not.    Select Uploaded Score    Sequence=2
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=51.701063
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Leaderboard Rank Arrow Showing Correctly
    [Documentation]    Check leaderboard rank rising or falling arrow showing correctly
    [Tags]    Upload_Team    Upload_Team_6
    ${File name}=    Set Variable    leaderboard1
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=t1 t2    Expect=2
    ${Upload file1}=    Set Variable    pri_54.954526656136345_pub_55.82711408148075.csv
    ${Upload file2}=    Set Variable    pri_58.52349955359813_pub_51.881274720911264.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file1}    Expect score=55.827114    Input type=id
    #t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest first account}    File location=${gTest data path taxi}${/}Correct_File${/}${Upload file2}    Expect score=51.881274    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    ${ranks}=    Create List    1    2
    Check Leaderboard Is Correct    ${gTopic ID Now}    Expect user=t2    Expect ranks=${ranks}    Expect score=51.881274    Input type=id    Board type=public
    Check Leaderboard Is Correct    ${gTopic ID Now}    Expect user=t2    Expect ranks=${ranks}    Expect score=58.523499    Input type=id    Board type=private
    #t1
    Switch Browser    1
    ${ranks}=    Create List    2    1
    Check Leaderboard Is Correct    ${gTopic ID Now}    Expect user=t1    Expect ranks=${ranks}    Expect score=55.827114    Input type=id    Board type=public
    Check Leaderboard Is Correct    ${gTopic ID Now}    Expect user=t1    Expect ranks=${ranks}    Expect score=54.954526    Input type=id    Board type=private
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

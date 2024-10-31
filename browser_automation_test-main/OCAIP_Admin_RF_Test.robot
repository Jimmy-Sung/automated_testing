*** Settings ***
Suite Setup       Suite Setup
Suite Teardown    Suite Teardown
Test Setup        Login To OCAIP
Test Teardown     Compatibility Teardown
Library           SeleniumLibrary    30    3    run_on_failure=None
Resource          ./Keywords/OCAIP_Keywords.txt
Resource          ./Variables/OCAIP_Variables.txt
Library           OperatingSystem
Library           Process
Library           DateTime
Library           Dialogs

*** Test Cases ***
--- Statistics ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Statistics ---
    [Teardown]    No Operation

Check Assign Account New Roles
    [Documentation]    Login with admin account and check role exist or assign a new role to specific account
    [Tags]    Statistics    Statistics_1
    [Setup]    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Assign A Role To A User    ${gTest semiadmin account}    議題管理人員
    Assign A Role To A User    ${gTest semiadmin account2}    議題管理人員

#Initial Administration Page Should Show Correct
#    [Documentation]    Check initial status of administration page.
#    [Tags]    Statistics    Statistics_2
#    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
#    ${File name}=    Set Variable    stats
#    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
#    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=上傳紀錄

Search For Specific Strings (Upload Record)
    [Documentation]    Check the search function of upload record page shows correctly or not. (No Refresh Page)
    [Tags]    Statistics    Statistics_3
    [Setup]    Login To OCAIP    ${gTest account}    ${gTest password}
    ${File name}=    Set Variable    stats2_AOI
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    ${Upload file}=    Set Variable    pri_0.1_pub_0.1.csv
    ${Upload file2}=    Set Variable    pri_0.5_pub_0.7.csv
    ${Upload file3}=    Set Variable    pri_0.7_pub_0.5.csv
    ${Upload file4}=    Set Variable    pri_0.8_pub_0.8.csv
    ${Upload file5}=    Set Variable    pri_0.9_pub_0.9.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file}    Expect score=0.1    Input type=id    # Normal file
    Upload Result For Topic And Expect Error   ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file2}    Expect score=0.7    Input type=id    Refresh=False
    Upload Result For Topic And Expect Error   ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file3}    Expect score=0.5    Input type=id    Refresh=False
    Upload Result For Topic And Expect Error   ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file4}    Expect score=0.8    Input type=id    Refresh=False
    Upload Result For Topic And Expect Error   ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file5}    Expect score=0.9    Input type=id    Refresh=False
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}    Open browser=true
    ${Exist string}=    Set Variable    adviser1
    ${Not Exist string}    Set Variable    adviser5
    ${Executable code}=    Set Variable    alert("hahaha")
    ${Executable code2}=    Set Variable    return -1
    Search Specific Strings In Statistics    ${Exist string}    ${gTopic Name Now}    Input type=name
    Search Specific Strings In Statistics    ${Not Exist string}    ${gTopic Name Now}    Input type=name
    Search Specific Strings In Statistics    ${Executable code}    ${gTopic Name Now}    Input type=name
    Switch Browser    1
    ${File name2}=    Set Variable    stats2_hydraulic
    Create Topic With Argument    ${File name2}    pri_single_reg_hydraulic
    ${Upload file}=    Set Variable    pri_0.39270610065496897_pub_0.4150585585621457.csv
    ${Upload file2}=    Set Variable    pri_0.4017261818252584_pub_0.40297299334606446.csv
    ${Upload file3}=    Set Variable    pri_0.4056847292694436_pub_0.4114990038078839.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file}    Expect score=0.4150585    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file2}    Expect score=0.4029729    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path hydraulic}${/}Correct_File${/}${Upload file3}    Expect score=0.4114990    Input type=id
    Switch Browser    2
    Search Specific Strings In Statistics    ${Exist string}    ${gTopic Name Now}    Input type=name
    Search Specific Strings In Statistics    ${Not Exist string}    ${gTopic Name Now}    Input type=name
    Search Specific Strings In Statistics    ${Executable code2}    ${gTopic Name Now}    Input type=name

Search For Specific Date Interval (Upload Record)
    [Documentation]    Check the searching date interval function of upload record page shows correctly or not.
    [Tags]    Statistics    Statistics_4
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats2_AOI
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Search Specific Date Intervals In Statistics    ${gTopic Name Now}    Begin date=2018-08-16    End date=2018-08-20    Input type=name
    Search Specific Date Intervals In Statistics    ${gTopic Name Now}    Begin date=2018-08-17    End date=2018-08-17    Input type=name
    Search Specific Date Intervals In Statistics    ${gTopic Name Now}    Begin date=2018-08-20    End date=2018-07-20    Input type=name
    ${File name2}=    Set Variable    stats2_hydraulic
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name2}.txt
    Search Specific Date Intervals In Statistics    ${gTopic Name Now}    Begin date=2018-08-16    End date=2018-08-20    Input type=name
    Search Specific Date Intervals In Statistics    ${gTopic Name Now}    Begin date=2018-08-17    End date=2018-08-17    Input type=name
    Search Specific Date Intervals In Statistics    ${gTopic Name Now}    Begin date=2018-08-20    End date=2018-07-20    Input type=name

Check If Highest Score Of Statistics Analysis And Upload Record Are The Same
    [Documentation]    Check if the highest score from the two subpages of statistics are the same.
    [Tags]    Statistics    Statistics_5
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats2_AOI
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Compare Highest Score Of Statistics Analysis And Upload Record    ${gTopic Name Now}    Input type=name
    ${File name2}=    Set Variable    stats2_hydraulic
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name2}.txt
    Compare Highest Score Of Statistics Analysis And Upload Record    ${gTopic Name Now}    Input type=name

Select Different Data Displayed Numbers (Upload Record)
    [Documentation]    Select different data displayed numbers and check if data displayed correctly.
    [Tags]    Statistics    Statistics_6
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats2_AOI
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Select Data Displayed Numbers Of Statistics    ${gTopic Name Now}    Input type=name
    ${File name2}=    Set Variable    stats2_hydraulic
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name2}.txt
    Select Data Displayed Numbers Of Statistics    ${gTopic Name Now}    Input type=name

Check Previous And Next Page Function (Upload Record)
    [Documentation]    Check if previous page and next page function are showing correct data (the same data with pressing the page number).
    [Tags]    Statistics    Statistics_7
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats2_AOI
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Previous And Next Page Of Statistics    ${gTopic Name Now}    Input type=name
    ${File name2}=    Set Variable    stats2_hydraulic
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name2}.txt
    Check Previous And Next Page Of Statistics    ${gTopic Name Now}    Input type=name

Check Sorting Function Of Statistics (Upload Record)
    [Documentation]    Check if upload records are sorted correctly according to user action (click on different columns).
    [Tags]    Statistics    Statistics_8
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats2_AOI
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Check Sorting Function Of Statistics    ${gTopic Name Now}    Input type=name
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    ${File name2}=    Set Variable    stats2_hydraulic
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name2}.txt
    Check Sorting Function Of Statistics    ${gTopic Name Now}    Input type=name
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC

Check Statistics Overview (Statistics Analysis)
    [Documentation]    Check if the overview block shows correctly in Statistics.
    [Tags]    Statistics    Statistics_9
    [Setup]    Login To OCAIP    ${gTest account}    ${gTest password}
    ${File name}=    Set Variable    stats2_AOI2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    ${Upload file}=    Set Variable    pri_0.1_pub_0.1.csv
    Check Overview Of Statistics Analysis    ${gTopic Name Now}    ${gTest account}    ${gTest data path AOI}${/}Correct_File${/}${Upload file}    Input type=name
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check TeamUp In Statistics Overview (Statistics Analysis)
    [Documentation]    Check if the number of team in the overview block shows correctly.
    [Tags]    Statistics    Statistics_10
    [Setup]    Login To OCAIP    ${gTest account}    ${gTest password}
    ${File name}=    Set Variable    stats3
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    Check TeamUp Of Statistics Analysis    ${gTopic ID Now}    Input type=id

Check Highest Score Ranking (Statistics Analysis)
    [Documentation]    Upload several correct files to issue and check if the statistics analysis page show correct top 5 scores.
    [Tags]    Statistics    Statistics_11
    ${File name}=    Set Variable    stats4
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    ${Upload file}=    Set Variable    pri_0.1_pub_0.1.csv
    ${Upload file2}=    Set Variable    pri_0.5_pub_0.7.csv
    ${Upload file3}=    Set Variable    pri_0.7_pub_0.5.csv
    ${Upload file4}=    Set Variable    pri_0.8_pub_0.8.csv
    ${Upload file5}=    Set Variable    pri_0.9_pub_0.9.csv
    ${Upload file6}=    Set Variable    pri_0_pub_0.csv
    ${Upload file7}=    Set Variable    pri_0_pub_1.csv
    ${Upload file8}=    Set Variable    pri_1_pub_0.csv
    ${Upload file9}=    Set Variable    pri_1_pub_1.csv
    # t1 upload
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file}    Expect score=0.1    Input type=id    # Normal file
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file2}    Expect score=0.7    Input type=id
    Logout OCAIP
    # t3 upload
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file5}    Expect score=0.9    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file6}    Expect score=0.0    Input type=id
    Logout OCAIP
    # u5 upload
    Login To OCAIP    ${gTest semiadmin account5}    ${gTest semiadmin password5}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest semiadmin account5}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file4}    Expect score=0.8    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest semiadmin account5}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file3}    Expect score=0.5    Input type=id
    Logout OCAIP
    #u4 upload
    Login To OCAIP    ${gTest semiadmin account4}    ${gTest semiadmin password4}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest semiadmin account4}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file6}    Expect score=0.0    Input type=id
    Logout OCAIP
    # u3 upload
    Login To OCAIP    ${gTest semiadmin account3}    ${gTest semiadmin password3}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest semiadmin account3}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file9}    Expect score=1.0    Input type=id
    Logout OCAIP
    # t4 upload
    Login To OCAIP    ${gTest account4}    ${gTest password4}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account4}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file8}    Expect score=0.0    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account4}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file7}    Expect score=1.0    Input type=id
    Logout OCAIP
    # Verify highest score
    Check Ranking Of Statistics Analysis    ${gTopic Name Now}    First user=u3    First score=1.0    Second user=${gTest account4}    Second score=1.0    Third user=t1
    ...    Third score=0.7    Fourth user=u5    Fourth score=0.5    Fifth user=t3    Fifth score=0.0    Input type=name
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check View Percentage (Statistics Analysis)
    [Documentation]    Browse issue and check if statistics analysis page shows view percentage as expected.
    [Tags]    Statistics    Statistics_12
    ${File name}=    Set Variable    stats5
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    # t1 browse topic
    Go To Topic    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Click Element    //div[@class="navbar-header navbar-left pull-left"]//a[@href="/"]
    # t3 browse topic
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Go To Topic    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Click Element    //div[@class="navbar-header navbar-left pull-left"]//a[@href="/"]
    # u3 browse topic
    Login To OCAIP    ${gTest semiadmin account3}    ${gTest semiadmin password3}    Open browser=false
    Go To Topic    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Click Element    //div[@class="navbar-header navbar-left pull-left"]//a[@href="/"]
    # u4 browse topic
    Login To OCAIP    ${gTest semiadmin account4}    ${gTest semiadmin password4}    Open browser=false
    Go To Topic    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Click Element    //div[@class="navbar-header navbar-left pull-left"]//a[@href="/"]
    # u5 browse topic
    Login To OCAIP    ${gTest semiadmin account5}    ${gTest semiadmin password5}    Open browser=false
    Go To Topic    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Click Element    //div[@class="navbar-header navbar-left pull-left"]//a[@href="/"]
    # u1 browse topic and check school view percentage
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}    Open browser=false
    Go To Topic    ${gTopic ID Now}    Input type=id
    #3:1:1:1
    Check View Percentage Of Statistics Analysis    ${gTopic Name Now}    Expect first percentage=50.00%    Expect second percentage=16.67%    Expect third percentage=16.67%    Expect fourth percentage=16.67%    Input type=name
    #Test will fail if u1 u2 u3 u4 u5 been used by others.

Check Upload Percentage (Statistics Analysis)
    [Documentation]    Upload serveral correct files to issue and check if statistics analysis page shows upload percentage as expected.
    [Tags]    Statistics    Statistics_13
    ${File name}=    Set Variable    stats5
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Upload file}=    Set Variable    pri_0.1_pub_0.1.csv
    ${Upload file2}=    Set Variable    pri_0.5_pub_0.7.csv
    ${Upload file3}=    Set Variable    pri_0.7_pub_0.5.csv
    ${Upload file4}=    Set Variable    pri_0.8_pub_0.8.csv
    ${Upload file5}=    Set Variable    pri_0.9_pub_0.9.csv
    # t1 upload
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file}    Expect score=0.1    Input type=id
    Logout OCAIP
    # t3 upload
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    t3    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file2}    Expect score=0.7    Input type=id
    Logout OCAIP
    # u3 upload
    Login To OCAIP    ${gTest semiadmin account3}    ${gTest semiadmin password3}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    u3    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file3}    Expect score=0.5    Input type=id
    Logout OCAIP
    # u4 upload
    Login To OCAIP    ${gTest semiadmin account4}    ${gTest semiadmin password4}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    u4    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file4}    Expect score=0.8    Input type=id
    Logout OCAIP
    # t4 upload and check statistics analysis
    Login To OCAIP    ${gTest account4}    ${gTest password4}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account4}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file5}    Expect score=0.9    Input type=id
    Check Upload Percentage Of Statistics Analysis    ${gTopic Name Now}    Expect first percentage=60.00%    Expect second percentage=20.00%    Expect third percentage=20.00%    Input type=name

Check Download Percentage (Statistics Analysis)
    [Documentation]    Download data files from issue and check if statistics analysis page shows download percentage as expected.
    [Tags]    Statistics    Statistics_14
    ${File name}=    Set Variable    stats5
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    # t1 download
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Download Data From Topic    ${gTopic ID Now}    File name=test_images_data.zip    Need sign NDA=N    Input type=id
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # u3 download
    Login To OCAIP    ${gTest semiadmin account3}    ${gTest semiadmin password3}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Download Data From Topic    ${gTopic ID Now}    File name=test_images_data.zip    Need sign NDA=N    Input type=id
    Logout OCAIP
    # u4 download
    Login To OCAIP    ${gTest semiadmin account4}    ${gTest semiadmin password4}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Download Data From Topic    ${gTopic ID Now}    File name=train_images_data.zip    Need sign NDA=N    Input type=id
    Logout OCAIP
    # u5 download
    Login To OCAIP    ${gTest semiadmin account5}    ${gTest semiadmin password5}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Download Data From Topic    ${gTopic ID Now}    File name=train_images_data.zip    Need sign NDA=N    Input type=id
    Logout OCAIP
    # t4 download and check download percentage
    Login To OCAIP    ${gTest account4}    ${gTest password4}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Download Data From Topic    ${gTopic ID Now}    File name=test_images_data.zip    Need sign NDA=N    Input type=id
    Check Download Percentage Of Statistics Analysis    ${gTopic Name Now}    Expect first percentage=40.00%    Expect second percentage=20.00%    Expect third percentage=20.00%    Expect fourth percentage=20.00%    Input type=name

Check Upload Records Page
    [Documentation]    Check the content of upload records page.
    [Tags]    Statistics    Statistics_15
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats5
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=上傳紀錄
    ${uploadcount}=    Get Element Count    //table[@id="upload_record"]/tbody/tr
    Should Be Equal    ${uploadcount}    ${5}

Check Notification Management Page
    [Documentation]    Check the content of notification management page.
    [Tags]    Statistics    Statistics_16
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats5
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=通知管理
    Page Should Contain    通知類型
    Page Should Contain Element    //div[@id="form_content"]
    Page Should Contain Element    //input[@value="發送"]

Check User List Page
    [Documentation]    Check the content of user list page.
    [Tags]    Statistics    Statistics_17
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats5
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=用戶列表
    ${joincount}=    Get Element Count    //table[@id="join_table"]/tbody/tr
    # Fix BUG BAT-968
    Element Should Contain    //table[@id="join_table"]/tbody/tr[6]/td[1]    u5
    Element Should Contain    //table[@id="join_table"]/tbody/tr[6]/td[2]    u5
    Element Should Contain    //table[@id="join_table"]/tbody/tr[6]/td[4]    affiliation_institution_4
    Element Should Contain    //table[@id="join_table"]/tbody/tr[6]/td[5]    affiliation_department
    Element Should Contain    //table[@id="join_table"]/tbody/tr[6]/td[6]    True
    Should Be Equal    ${joincount}    ${6}
    ${downloadcount}=    Get Element Count    //table[@id="download_table"]/tbody/tr
    Should Be Equal    ${downloadcount}    ${5}
    ${uploadcount}=    Get Element Count    //table[@id="upload_table"]/tbody/tr
    Should Be Equal    ${uploadcount}    ${5}
    Click Element    //table[@id="join_table"]/tbody/tr[last()]//a
    Input Text    //div[@id="delete_confirm"]//textarea    exit testing
    Click Element    //div[@id="delete_confirm"]//input[@id="submit"]
    ${exitcount}=    Get Element Count    //table[@id="exit_table"]/tbody/tr
    Should Be Equal    ${exitcount}    ${1}
    Element Should Contain    //table[@id="exit_table"]/tbody/tr[1]/td[1]    u5
    Element Should Contain    //table[@id="exit_table"]/tbody/tr[1]/td[3]    exit testing

Check Final Score Page
    [Documentation]    Check the content of final score page.
    [Tags]    Statistics    Statistics_18
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats5
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=最後成績
    ${rankcount}=    Get Element Count    //table[@id="final_public_private_ranking_table"]/tbody/tr
    Should Be Equal    ${rankcount}    ${5}
    Click Element    //button[contains(text(),"匯出最後成績排名csv檔案")]
    Alert Should Be Present    您確定要匯出最後成績排名檔案嗎?
    Check if file downloaded is done    final_ranking.csv
    [Teardown]    Run Keywords    Compatibility Teardown
    ...    AND    Remove File    ${gDefault download dir}${/}final_ranking.csv

Check Board Management Page
    [Documentation]    Check the content of board management page.
    [Tags]    Statistics    Statistics_19
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats5
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=公佈欄管理
    # Choose The Topic And Input The Announcement Content
    ${Test content}=    Set Variable    公佈欄測試
    Input Text    id=subtitle    ${Test content}1
    Input Text    id=content    ${Test content}2
    Input Text    id=notification_content    ${Test content}3
    Input Date for Datepicker    //input[@id="expiration_date"]    Shift Date=1 days    Input Time=True
    Click Element    //input[@id="submit"]
    # Check Existence
    Wait Until Page Contains    發送公告成功
    #t4
    Login To OCAIP    ${gTest account4}    ${gTest password}
    Check Bell Message    Title=「${gTopic Name Now}」公告通知    Message=${Test content}3    Notify=Yes    Click=Yes
    Location Should Contain    ${gTopic ID Now}
    Wait Until Page Contains    ${Test content}2
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Post A Notification To Topics Members By Statistics
    [Documentation]    Post a notification to team members of a topic by statistics
    [Tags]    Statistics    Statistics_20
    [Setup]    Login To OCAIP    ${gTest account4}    ${gTest password}
    ${File name}=    Set Variable    stats6
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=通知管理
    Make Announcements To Topic Members    Title=快訊通知測試    Content=內容    Issue=${gTopic Name Now}    Team=${gTest account4}
    Switch Browser    1
    Refresh Page
    Check Bell Message    Title=快訊通知測試    Message=內容    Notify=Yes

Send An Email To Topics Members By Statistics
    [Documentation]    Post a email notification to team members of a topic by statistics
    [Tags]    Statistics    Statistics_21
    [Setup]    No Operation
    ${File name}=    Set Variable    stats6
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Login To OCAIP    ${gTest first account}    ${gTest first password}
    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=通知管理
    Make Announcements To Topic Members    Title=[#{${gTopic Name Now}}]Email通知測試    Content=[#{account_name}]內容    Issue=${gTopic Name Now}    Type=僅發送e-mail    Team=${gTest first account}
    Switch Browser    1
    Clear Mail Box    Title=${gTopic Name Now}Email通知測試
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Team Information (Statistics Analysis)
    [Documentation]    Check team information showing correctly
    [Tags]    Statistics    Statistics_22
    [Setup]    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    ${File name}=    Set Variable    stats3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To Statistics Topic    ${gTopic Name Now}    Statistics type=隊伍列表
    Element Should Contain    //table[@id="team_table"]/tbody/tr[1]/td[1]    t1
    Element Should Contain    //table[@id="team_table"]/tbody/tr[1]/td[3]    t1
    Element Should Contain    //table[@id="team_table"]/tbody/tr[1]/td[4]    t1
    Element Should Contain    //table[@id="team_table"]/tbody/tr[2]/td[1]    Team_t2t3
    Element Should Contain    //table[@id="team_table"]/tbody/tr[2]/td[3]    t2
    Element Should Contain    //table[@id="team_table"]/tbody/tr[2]/td[4]    t2 t3
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Statistics Button Settings (Register)
    [Documentation]    check statistics button settings (related to register)
    ...    allow_join/is_academic/enclosed/need_phone_info
    [Tags]    Statistics    Statistics_23
    ${File name}=    Set Variable    stats7
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Operation=nosign
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    Modify Topic Settings    allow_join    Type=button
    Modify Topic Settings    is_academic    Type=button
    Modify Topic Settings    need_phone_info    Type=button
    Switch Browser    1
    # allow_join off
    Go To Topic    ${gTopic ID Now}    Input type=id
    Element Should Be Disabled    //div[@id="countdown"]//button
    Page Should Contain    *額滿
    # allow_join on & is_academic on
    Switch Browser    2
    Modify Topic Settings    allow_join    Type=button
    Go To Topic List
    Page Should Contain Element    //a[@href="/topic/${gTopic ID Now}"]//div[@class="for_school"]/h6
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    Go To Topic    ${gTopic ID Now}    Input type=id
    Page Should Contain Element    //div[@id="countdown"]//button[text()="僅限學界報名"]
    # need_phone_info on
    Switch Browser    1
    Go To Topic    ${gTopic ID Now}    Input type=id
    Click Element    //div[@id="register_topic"]
    Page Should Contain Element    //input[@id="recipient-name"]
    Refresh Page
    # enclosed on
    Switch Browser    2
    Modify Topic Settings    enclosed    Type=button
    Switch Browser    1
    Go To Topic    ${gTopic ID Now}    Input type=id
    Page Should Not Contain Element    //div[@id="register_topic"]
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0

Statistics Button Settings (Issue)
    [Documentation]    check statistics button settings (related to issue)
    ...    is_data_batch_download/need_discuss/need_timeline/need_publish_dashboard/protected_dashboard
    [Tags]    Statistics    Statistics_24
    ${File name}=    Set Variable    stats7
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    Modify Topic Settings    is_data_batch_download    Type=button
    Modify Topic Settings    need_discuss    Type=button
    Modify Topic Settings    need_timeline    Type=button
    Modify Topic Settings    protected_dashboard    Type=button
    Switch Browser    1
    # need_discuss off
    Run Keyword And Expect Error    STARTS: Element with locator '//ul[@role="tablist"]//a[text()="討論"]' not found.
    ...    Check Zero Message From Topic    ${gTopic ID Now}    Input type=id
    # need_timeline off
    Page Should Not Contain Element    //div[@id="timeline_bar"]
    # protected_dashboard on
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    Go To Topic    ${gTopic ID Now}    Input type=id
    Element Attribute Value Should Be    //a[@href="#topic-ranking"]/parent::li    class    disabled
    # need_publish_dashboard off
    Switch Browser    2
    Modify Topic Settings    need_publish_dashboard    Type=button
    Page Should Not Contain Element    //a[contains(text(),"排行榜")]
    # is_data_batch_download off
    Download Data From Topic    ${gTopic ID Now}    File name=test_images_data_2.zip    Need sign NDA=N    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Statistics Button Settings (Upload)
    [Documentation]    Check statistics button settings (related to upload)
    ...    auto_evaluate/need_report/need_team_info/need_upload_eval_result
    ...    need_upload_program/need_show_ranking/show_other_metrics
    [Tags]    Statistics    Statistics_25
    ${File name}=    Set Variable    stats7_json
    Create Topic With Argument    ${File name}    pri_single_reg_AOI_json
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    Modify Topic Settings    need_report    Type=button
    Modify Topic Settings    need_team_info    Type=button
    Modify Topic Settings    need_show_ranking    Type=button
    Modify Topic Settings    upload_file_extension    Content=json
    Switch Browser    1
    # need_show_ranking off
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}
    ...    File location=${gTest data path AOI}${/}Correct_File${/}pri_0.5_pub_0.5.json    Input type=id
    Run Keyword And Expect Error    STARTS: Element with locator '//div[@id="public"]//tr[contains(@class,"upload_inf")][1]//td[contains(@class,"accuracy")][2]/h6' not found.
    ...    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/1    Input type=id
    # need_upload_program on
    Switch Browser    2
    Go To Home Page
    Modify Topic Settings    need_upload_program    Type=button
    Modify Topic Settings    auto_evaluate    Type=button
    Modify Topic Settings    need_publish_dashboard    Type=button
    Modify Topic Settings    show_other_metrics    Type=button
    Switch Browser    1
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}
    ...    File location=${gTest data path AOI}${/}Correct_File${/}pri_0.5_pub_0.5.json
    ...    Msg from where=button    Expected msg=此議題僅接受 zip格式且包含 main.py 之英文檔名的檔案    Input type=id
    # show_other_metrics on
    ${ranks}=    Create List    1    1
    ${scores}=    Create List    0.70601    0.53804    0.37686
    Check Leaderboard Is Correct    ${gTopic ID Now}    Expect user=t1    Expect ranks=${ranks}    Expect score=0.5394019    Input type=id    Board type=public    Other score=${scores}
    # auto_evaluate off
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Run Keyword And Expect Error    STARTS: Keyword 'Get Text' failed after retrying for 3 seconds. The last error was: Element with locator '//div[@id="private"]//tr[contains(@class,"upload_inf")][1]//td[contains(@class,"accuracy")]/h6' not found.
    ...    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.5389730
    # need_upload_eval_result off
    Switch Browser    2
    Modify Topic Settings    need_upload_eval_result    Type=button
    Switch Browser    1
    Go To Topic    ${gTopic ID Now}    Input type=id
    Page Should Not Contain Element    //a[contains(text(),'上傳成果')]
    # need_report on
    Page Should Contain Element    //a[contains(text(),'上傳說明文件')]
    # need_team_info on
    Page Should Contain Element    //a[contains(text(),'上傳隊伍資訊')]
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Statistics Textarea Settings (Description)
    [Documentation]    Check textarea button settings (related to description)
    ...    datasets_description/description/eval_description/event_time_description
    ...    prize_description/topic_rule/upload_format_description
    ...    big_image_name/small_image_name/title/keyword/total_prize_money
    [Tags]    Statistics    Statistics_27
    ${File name}=    Set Variable    stats8
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Join=No
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    ${Prefix_Path}=    Normalize Path    ${gTest data path Carousel}${/}banner_
    Modify Topic Settings    big_image_name    Content=${Prefix_Path}black.png    Type=image
    Modify Topic Settings    small_image_name    Content=${Prefix_Path}s_black.png    Type=image
    Modify Topic Settings    title    Content=${gTopic Name Now}Textarea測試    Type=textarea
    Modify Topic Settings    keyword    Content=keyword測試    Type=textarea
    Modify Topic Settings    datasets_description    Content=資料說明測試    Type=textarea
    Modify Topic Settings    description    Content=簡介說明測試    Type=textarea
    Modify Topic Settings    eval_description    Content=評估標準測試    Type=textarea
    Modify Topic Settings    event_time_description    Content=活動時間測試    Type=textarea
    Modify Topic Settings    prize_description    Content=獎項說明測試    Type=textarea
    Modify Topic Settings    total_prize_money    Content=10000    Type=textarea
    Modify Topic Settings    topic_rule    Content=規則說明測試    Type=textarea
    Modify Topic Settings    upload_format_description    Content=上傳格式說明測試    Type=textarea
    Switch Browser    1
    # title
    Go To Topic List
    Page Should Contain Element    //a[contains(@href,"${gTopic ID Now}")]//h4[text()="${gTopic Name Now}Textarea測試"]
    # keyword (Website TBD)
    # small_image_name
    Page Should Contain Element    //a[contains(@href,"${gTopic ID Now}")]//img[contains(@src,"banner_s_black.png")]
    # big_image_name
    Go To Topic    ${gTopic ID Now}    Input type=id
    Page Should Contain Element    //section[@class="issue_banner"]//img[contains(@src,"banner_black.png")]
    # description
    Element Should Be Visible    //p[normalize-space(text())="簡介說明測試"]
    # prize_description
    Element Should Be Visible    //p[normalize-space(text())="獎項說明測試"]
    # total_prize_money (Website TBD)
    # event_time_description
    Element Should Be Visible    //p[normalize-space(text())="活動時間測試"]
    # eval_description
    Element Should Be Visible    //p[normalize-space(text())="評估標準測試"]
    # topic_rule
    Click Element    //a[contains(text(),'規則')]
    Element Should Be Visible    //p[normalize-space(text())="規則說明測試"]
    # datasets_description
    Click Element    //a[contains(text(),'資料')]
    Element Should Be Visible    //p[normalize-space(text())="資料說明測試"]
    # upload_format_description
    Click Element    //a[contains(text(),'上傳')]
    Click Element    //li[@data-tab="u_rule"]
    Element Should Be Visible    //p[normalize-space(text())="上傳格式說明測試"]
    # Change title back
    Switch Browser    2
    Modify Topic Settings    title    Content=${gTopic Name Now}    Type=textarea

Statistics Textarea Settings (Upload Datetime)
    [Documentation]    Check textarea button settings (related to upload datetime)
    ...    eval_select_end_date/eval_select_start_date/eval_submit_end_date/eval_submit_start_date
    ...    report_end_date/report_start_date/team_info_end_date/team_info_start_date
    [Tags]    Statistics    Statistics_28
    ${File name}=    Set Variable    stats8
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    # eval_select_start_date
    Modify Topic Settings    need_report    Type=button
    Modify Topic Settings    need_team_info    Type=button
    Modify Topic Settings    eval_select_start_date    Content=-1 days    Type=datetime
    Switch Browser    1
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}
    ...    File location=${gTest data path taxi}${/}Correct_File${/}pri_58.52349955359813_pub_51.881274720911264.csv    Input type=id
    Select Uploaded Score
    # eval_select_end_date
    Switch Browser    2
    Modify Topic Settings    eval_select_end_date    Content=-1 days    Type=datetime
    Switch Browser    1
    Run Keyword And Expect Error    STARTS: Checkbox '//table[@id="pickscore"]//tr[1]//input' should not have been selected    Select Uploaded Score
    # eval_submit_start_date
    Switch Browser    2
    Modify Topic Settings    eval_submit_start_date    Content=1 days    Type=datetime
    Switch Browser    1
    Upload Function No Available    ${gTopic ID Now}    Input type=id
    ## eval_submit_end_date
    Switch Browser    2
    Modify Topic Settings    eval_submit_start_date    Content=-2 days    Type=datetime
    Modify Topic Settings    eval_submit_end_date    Content=-1 days    Type=datetime
    Switch Browser    1
    Upload Function No Available    ${gTopic ID Now}    Input type=id
    # report_start_date
    Switch Browser    2
    Modify Topic Settings    report_start_date    Content=1 days    Type=datetime
    Switch Browser    1
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=上傳
    Click Element    //a[contains(text(),'上傳說明文件')]
    Page Should Contain    非上傳時間
    # report_end_date
    Switch Browser    2
    Modify Topic Settings    report_start_date    Content=-2 days    Type=datetime
    Modify Topic Settings    report_end_date    Content=-1 days    Type=datetime
    Switch Browser    1
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=上傳
    Click Element    //a[contains(text(),'上傳說明文件')]
    Page Should Contain    非上傳時間
    # team_info_start_date
    Switch Browser    2
    Modify Topic Settings    team_info_start_date    Content=1 days    Type=datetime
    Switch Browser    1
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=上傳
    Click Element    //a[contains(text(),'上傳隊伍資訊')]
    Page Should Contain    非上傳時間
    # team_info_end_date
    Switch Browser    2
    Modify Topic Settings    team_info_start_date    Content=-2 days    Type=datetime
    Modify Topic Settings    team_info_end_date    Content=-1 days    Type=datetime
    Switch Browser    1
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=上傳
    Click Element    //a[contains(text(),'上傳隊伍資訊')]
    Page Should Contain    非上傳時間
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Statistics Textarea Settings (Function)
    [Documentation]    Check textarea button settings (related to function)
    ...    assistant/team_type/team_maximum_num/outside_assistant/limited_attend_list
    ...    eval_update_maximum/eval_type/eval_private_maximum/eval_method
    [Tags]    Statistics    Statistics_29
    ${File name}=    Set Variable    stats9
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account} ${gTest first account}    Expect=2
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    # limited_attend_list
    Modify Topic Settings    limited_attend_list    Content=['t1', 'u2']    Type=textarea
    Switch Browser    1
    Run Keyword And Expect Error    STARTS: Element with locator '//div[@id="register_topic"]' not found.    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    # eval_method
    Switch Browser    2
    Go To Home Page
    Modify Topic Settings    eval_method    Content=accuracy    Type=list
    # eval_update_maximum
    Modify Topic Settings    eval_update_maximum    Content=2    Type=textarea
    Switch Browser    1
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}
    ...    File location=${gTest data path taxi}${/}Correct_File${/}pri_58.52349955359813_pub_51.881274720911264.csv    Expect score=0.0    Input type=id
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}
    ...    File location=${gTest data path taxi}${/}Correct_File${/}pri_54.954526656136345_pub_55.82711408148075.csv    Expect score=0.1666666    Input type=id
    Run Keyword And Expect Error    STARTS: Element with locator '//input[@id='result_data'][@type='file']' not found.
    ...    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}
    ...    File location=${gTest data path taxi}${/}Correct_File${/}pri_0.0_pub_0.0.csv    Input type=id
    # eval_private_maximum
    Switch Browser    2
    Modify Topic Settings    eval_private_maximum    Content=1    Type=textarea
    Change Topic Date    ${gTopic ID Now}    Operation=START_SEL
    Switch Browser    1
    Select Uploaded Score
    Run Keyword And Expect Error    STARTS: Checkbox '//table[@id="pickscore"]//tr[2]//input' should have been selected but was not.    Select Uploaded Score    Sequence=2
    Click Element    //div[@id="private_select_alert"]//button[@id="to_assign"]
    # eval_type
    Switch Browser    2
    Modify Topic Settings    eval_type    Content=single_public    Type=textarea
    Switch Browser    1
    Run Keyword And Expect Error    STARTS: Element with locator '//div[@id="leaderboard"]//label[text()="Private Leaderboard"]' not found.
    ...    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/1    Input type=id    Board type=private
    # assistant by adding u1
    Switch Browser    2
    Modify Topic Settings    assistant    Content=['u2', 'u1']    Type=textarea
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    Modify Topic Settings    description    Content=u1助手測試    Type=textarea
    # outside_assistant (Website TBD)
    # team_maximum_num
    Modify Topic Settings    team_maximum_num    Content=1    Type=textarea
    Switch Browser    1
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=${gTest first account}    Contain team=yes    Input type=id    Status=exceed
    # team_type
    Switch Browser    2
    Modify Topic Settings    team_type    Content=single    Type=textarea
    Run Keyword And Expect Error    STARTS: Element with locator '//ul[@role="tablist"]//a[text()="組隊"]' not found.    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=組隊
    # Change team_type back
    Modify Topic Settings    team_type    Content=team    Type=textarea

Statistics Textarea Settings (Topic Datetime)
    [Documentation]    Check textarea button settings (related to topic datetime)
    ...    start_date/end_date/join_end_date/join_start_date/team_merge_date
    [Tags]    Statistics    Statistics_30
    ${File name}=    Set Variable    stats9
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Login To OCAIP    ${gTest semiadmin account2}    ${gTest semiadmin password2}
    # team_merge_date
    Modify Topic Settings    team_merge_date    Content=-1 days    Type=datetime
    Switch Browser    1
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=組隊
    Element Should Be Disabled    id=sent_merge_team_btn
    # join_start_date
    Switch Browser    2
    Modify Topic Settings    join_start_date    Content=1 days    Type=datetime
    Go To Topic List
    Element Should Contain    //a[contains(@href,"${gTopic ID Now}")]//h7[@class="issue_coming"]    即將開始
    Go To Topic    ${gTopic ID Now}    Input type=id
    Element Should Be Disabled    //strong[text()="非報名時間"]/parent::button
    # start_date
    Modify Topic Settings    start_date    Content=1 days    Type=datetime
    Go To Topic List
    Element Should Contain    //a[contains(@href,"${gTopic ID Now}")]//h7[@class="issue_coming"]    即將開始
    Go To Topic    ${gTopic ID Now}    Input type=id
    Element Should Be Disabled    //strong[text()="非報名時間"]/parent::button
    # join_end_date
    Modify Topic Settings    join_start_date    Content=-1 days    Type=datetime
    Modify Topic Settings    join_end_date    Content=-1 days    Type=datetime
    Go To Topic List
    Element Should Contain    //a[contains(@href,"${gTopic ID Now}")]//h7[@class="issue_going"]    進行中
    Go To Topic    ${gTopic ID Now}    Input type=id
    Element Should Be Disabled    //strong[text()="非報名時間"]/parent::button
    # end_date
    Modify Topic Settings    end_date    Content=-1 days    Type=datetime
    Go To Topic List
    Element Should Contain    //a[contains(@href,"${gTopic ID Now}")]//h7[@class="issue_done"]    結束
    Go To Topic    ${gTopic ID Now}    Input type=id
    Element Should Be Disabled    //button[text()="議題結束"]
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Admin ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Admin ---
    [Teardown]    No Operation

Assign Admin An Admin Roles
    [Documentation]    Login with admin account and check role exist or assign an admin role
    [Tags]    Admin    Admin_1
    [Setup]    No Operation
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Create A New Role    Role name=大大大
    Assign A Role To A User    User account=${gTest admin account}    Role=大大大

Add Topic Role To A User
    [Documentation]    Assign a role to user account and check showing correctly
    [Tags]    Admin    Admin_2
    [Setup]    No Operation
    ${Role name}=    Set Variable    議題管理人員
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Assign A Role To A User    User account=${gTest semiadmin account3}    Role=${Role name}
    Page Should Contain Element    //table[@id='personnel_table']//td[text()='${gTest semiadmin account3}']/following-sibling::td[text()='${Role name}']

Post A Notification To Topics Members
    [Documentation]    Post a notification to team members of a topic
    [Tags]    Admin    Admin_3
    [Setup]    Login To OCAIP    ${gTest account4}    ${gTest password}
    ${File name}=    Set Variable    admin1
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}    Open browser=true
    Go To Admin Page    Admin type=公告管理
    Make Announcements To Topic Members    Title=快訊通知測試    Content=內容    Issue=${gTopic Name Now}    Team=${gTest account4}
    Switch Browser    1
    Refresh Page
    Check Bell Message    Title=快訊通知測試    Message=內容    Notify=Yes    Click=Yes
    Location Should Contain    ${gTopic ID Now}

Send An Email To Topics Members
    [Documentation]    Post a email notification to team members of a topic
    [Tags]    Admin    Admin_4
    [Setup]    No Operation
    ${File name}=    Set Variable    admin1
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Login To OCAIP    ${gTest first account}    ${gTest first password}
    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}    Open browser=true
    Go To Admin Page    Admin type=公告管理
    Make Announcements To Topic Members    Title=[#{${gTopic Name Now}}]Email通知測試    Content=[#{account_name}]內容    Issue=${gTopic Name Now}    Type=僅發送e-mail    Team=${gTest first account}
    Switch Browser    1
    Clear Mail Box    Title=${gTopic Name Now}Email通知測試
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check A Role With All Privileges
    [Documentation]    Check a role who all privileges are selected correctly
    [Tags]    Admin    Admin_5
    [Setup]    No Operation
    ${Role name}=    Set Variable    大大大
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Go To Admin Page
    ${Boxes}=    Get Element Count    //tbody[@id='native_checkbox']//td[text()='${Role name}']/following-sibling::td/input
    FOR    ${INDEX}    IN RANGE    1    ${Boxes}+1
        Checkbox Should Be Selected    //tbody[@id='native_checkbox']//td[text()='${Role name}']/following-sibling::td[${INDEX}]/input
    END

Check Number of Users
    [Documentation]    Check number of registered users on website
    [Tags]    Admin    Admin_6
    [Setup]    No Operation
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Go To Admin Page    Admin type=平台會員
    ${Users}=    Get Element Count    //table[@id='table']//tr[@data-index]
    ${Users206}=    Run Keyword And Return Status    Run Keywords    Should Be Equal As Strings    ${Users}    10
    ...    AND    Page Should Contain Element    //span[@class="pagination-info" and contains(text(),"of 206 rows")]
    ${Users207}=    Run Keyword And Return Status    Run Keywords    Should Be Equal As Strings    ${Users}    10
    ...    AND    Page Should Contain Element    //span[@class="pagination-info" and contains(text(),"of 207 rows")]
    Should Be True    ${Users206} or ${Users207}

Export CSV Of Users Profiles
    [Documentation]    Export csv and check it existence
    [Tags]    Admin    Admin_7
    [Setup]    No Operation
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Go To Admin Page    Admin type=平台會員
    Click Element    //div[@id='toolbar']/button[text()='匯出csv檔案']
    Handle Alert
    Wait Until Keyword Succeeds    10 secs    1 secs    File Should Exist    ${gDefault download dir}${/}Platform_users.csv

Post A Announcement To Show In Topic Introduction
    [Documentation]    Using admin account to post an announcement and check the result.
    [Tags]    Admin    Admin_8
    [Setup]    No Operation
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Go To Admin Page    Admin type=公佈欄管理
    # Choose The Topic And Input The Announcement Content
    Click Element    //select[@id="title"]
    Click Element    //select[@id="title"]/option[text()="ainews"]/following-sibling::option
    ${topic name}=    Get Text    //select[@id="title"]/option[text()="ainews"]/following-sibling::option
    ${Test content}=    Set Variable    公佈欄測試
    Input Text    id=subtitle    ${Test content}1
    Input Text    id=content    ${Test content}2
    Input Text    id=notification_content    ${Test content}3
    Click Element    //input[@id="submit"]
    # Check Existence
    Wait Until Page Contains    發佈公告成功
    Go To Topic    ${topic name}    Input type=name
    Wait Until Page Contains    ${Test content}2

Post Multiple News To Home Page
    [Documentation]    Post multiple news to home page and check sequence, maximum 3, content length, and invisible when empty
    [Tags]    Admin    Admin_9
    ${date}=    Get Current Date
    ${date}=    Convert Date    ${date}    result_format=%Y/%m/%d
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}    Open browser=true
    #Page Should Not Contain Element    //div[@class="container-fluid news"]
    FOR    ${INDEX}    IN RANGE    1    5
        Go To Admin Page    Admin type=公告管理
        Make Announcements To Topic Members    Title=最新消息${INDEX}    Content=測試內容最大長度${INDEX}測試內容最大長度${INDEX}測試內容最大長度${INDEX}測試內容最大長度${INDEX}測試內容最大長度${INDEX}測試內容最大長度${INDEX}    Issue=aideanews
        Go To Home Page
        Page Should Contain Element    //div[@class="container-fluid news"]
        Element Should Contain    //div[@class="container-fluid news"]//div[@class="row"]/div/div[2]/span    ${date}
        Element Should Contain    //div[@class="container-fluid news"]//div[@class="row"]/div/div[2]/p    最新消息${INDEX}
        Element Should Contain    //div[@class="container-fluid news"]//div[@class="row"]/div/div[2]/p    測試內容最大長度${INDEX}測試內容最大長度${INDEX}測試內容最大長度${INDEX}測試內容最大長度${INDEX}測試內容最大長度${INDEX}測試內容最大長度${INDEX}
    END
    ${rowcount}=    Get Element Count    //div[@class="container-fluid news"]//div[@class="row"]/div/div
    Should Be Equal    ${rowcount}    ${4}
    # Delete news and invisible when empty (Website TBD)

Upload A New Carousel Image
    [Documentation]    Upload a new carousel, check show correctly,and then delete it
    [Tags]    Admin    Admin_10
    [Setup]    No Operation
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    #Upload
    Go To Admin Page    Admin type=輪播管理
    Click Element    //button[text()="+"]
    Wait Until Element Is Visible    //div[@id="create_item"]//form
    ${Prefix_Path}=    Normalize Path    ${gTest data path Carousel}${/}banner_
    Choose File    //input[@id="small_zh"]    ${Prefix_Path}s_black.png
    Choose File    //input[@id="middle_zh"]    ${Prefix_Path}m_black.png
    Choose File    //input[@id="big_zh"]    ${Prefix_Path}black.png
    Input Text    //input[@id="description"]    描述內容
    Input Text    //input[@id="link"]    ${gOCAIP URL}/about
    #Input Date for Datepicker    //input[@id="end_date"]    Shift Date=2 days
    Input Text    //input[@id="order"]    1
    Click Element    //input[@id="submit"]
    Wait Until Element Contains    //div[@id="flash_block"]/div[contains(@class,"alert")]    Create carousel successfully
    #Keep 2 Carousel for Page_23
    ${Delete}=    Run Keyword And Return Status    Page Should Contain Element    //ul[@class="carousel_list list-group"]/li[3]
    Go To Home Page
    Click Element    //div[@id="myCarousel"]/ol/li[last()]
    Wait Until Element Is Visible    //div[@id="myCarousel"]/div/div[last()][@class="item active"]    timeout=6
    Click Element    //div[@id="myCarousel"]/div/div[last()][@class="item active"]
    Wait Until Location Is    ${gOCAIP URL}/about
    #Delete
    Run Keyword If    "${Delete}"=="True"    Run Keywords    Go To Admin Page    Admin type=輪播管理
    ...    AND    Click Element    //ul[@class="carousel_list list-group"]/li[3]//em[contains(@class,"icon-delete3")]
    ...    AND    Wait Until Element Is Visible    //div[@id="delete_confirm"]
    ...    AND    Click Element    //div[@id="delete_confirm"]//button[text()="確定"]
    ...    AND    Wait Until Element Contains    //div[@id="flash_block"]/div[contains(@class,"alert")]    Delete carousel successfully
    ...    AND    Go To Home Page
    ...    AND    Page Should Not Contain Element    //div[@id="myCarousel"]/ol/li[3]

Check User Last Login
    [Documentation]    check user last login
    [Tags]    Admin    Admin_11
    [Setup]    No Operation
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Go To Admin Page    Admin type=系統分析
    ${date}=    Get Current Date
    ${date}=    Convert Date    ${date}    result_format=%Y-%-m-%-d
    Element Text Should Be    //table[@id="table_login"]/tbody/tr[last()]/td[1]    ${date}
    Element Should Contain    //table[@id="table_login"]/tbody/tr[last()]/td[2]    ${gTest admin account}

Check Roles Function
    [Documentation]    Check roles can be created, modified ,and deleted
    [Tags]    Admin    Admin_12
    [Setup]    No Operation
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    #Create
    Create A New Role    Role name=Testing
    #Modify
    UnSelect Checkbox    //td[text()="Testing"]/following-sibling::td/input
    Click Element    //td[text()="Testing"]/following-sibling::td//i[contains(@class,"icon-edit")]
    Wait Until Element Contains    //div[@class='permission_manage']//div[contains(@class,"alert-success")]     modify role <Testing> successfully
    Checkbox Should Not Be Selected    //td[text()="Testing"]/following-sibling::td/input
    #Delete
    Click Element    //i[@id='Testing']
    Handle Alert
    Wait Until Element Contains    //div[@class='permission_manage']//div[contains(@class,"alert-success")]     Delete role <Testing> successfully
    Page Should Not Contain Element    //td[text()="Testing"]
    #Delete Error in using
    Click Element    //i[@id='大大大']
    Handle Alert
    Wait Until Element Contains    //div[@class='permission_manage']//div[contains(@class,"alert-warning")]     Failed to delete role <大大大>. Please check if <大大大> is used
    Page Should Contain Element    //td[text()="大大大"]

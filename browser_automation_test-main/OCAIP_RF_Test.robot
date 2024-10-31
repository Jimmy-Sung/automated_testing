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
--- Timeout ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Timeout Test ---
    [Teardown]    No Operation

Check Topic List Loading Time
    [Documentation]    Go to issue list and check the loading time satisifies the requirement
    [Tags]    Timeout    Timeout_1
    [Timeout]    11
    [Setup]    Not Login    #About 5.5 Secs
    ${require time}=    Set Variable    5
    ${hour1}    ${min1}    ${sec1}    Get Time    hour,min,sec
    Go To Topic List
    ${hour2}    ${min2}    ${sec2}    Get Time    hour,min,sec
    ${hour1}    Convert To Integer    ${hour1}
    ${min1}    Convert To Integer    ${min1}
    ${sec1}    Convert To Integer    ${sec1}
    ${hour2}    Convert To Integer    ${hour2}
    ${min2}    Convert To Integer    ${min2}
    ${sec2}    Convert To Integer    ${sec2}
    ${diff}    Evaluate    ${hour2}*3600+${min2}*60+${sec2}-${hour1}*3600-${min1}*60-${sec1}-1    #minus 1 is to reduce the click time
    Run Keyword if    ${diff}<=${require time}    Log    Cost time meets the requirement
    ...    ELSE    Fail    Time exceed the requirement
    #verify the page is correct ot not
    Page Should Contain    產業議題

Check Course List Loading Time
    [Documentation]    Go to course list and check the loading time satisifies the requirement
    [Tags]    Timeout    Timeout_2
    [Timeout]    11
    [Setup]    Not Login    #About 5.5 Secs
    Go To Topic List    Topic type=course    #About 3 Secs

Check AI Cup List Loading Time
    [Documentation]    Go to AI cup list and check the loading time satisifies the requirement
    [Tags]    Timeout    Timeout_3
    [Timeout]    11
    [Setup]    Not Login    #About 5.5 Secs
    Go To Topic List    Topic type=aicup    #About 3 Secs

Check CTSP List Loading Time
    [Documentation]    Go to ctsp list and check the loading time satisifies the requirement
    [Tags]    Timeout    Timeout_4
    [Timeout]    14
    [Setup]    Not Login    #About 5.5 Secs
    Go To Topic List    Topic type=ctsp    #About 4 Secs

Check ASVDA List Loading Time
    [Documentation]    Go to asvda list and check the loading time satisifies the requirement
    [Tags]    Timeout    Timeout_5
    [Timeout]    14
    [Setup]    Not Login    #About 5.5 Secs
    Go To Topic List    Topic type=asvda    #About 4 Secs

Check Playground List Loading Time
    [Documentation]    Go to playground list and check the loading time satisifies the requirement
    [Tags]    Timeout    Timeout_6
    [Timeout]    11
    [Setup]    Not Login    #About 5.5 Secs
    Go To Topic List    Topic type=playground    #About 3 Secs

Check Career List Loading Time
    [Documentation]    Go to career list and check the loading time satisifies the requirement
    [Tags]    Timeout    Timeout_7
    [Timeout]    11
    [Setup]    Not Login    #About 5.5 Secs
    Go To Career    #About 3 Secs

Check Home Page Loading Time
    [Documentation]    Go to home page and check the loading time satisifies the requirement
    [Tags]    Timeout    Timeout_8
    [Timeout]    6
    [Setup]    No Operation
    Not Login    #About 5.5 Secs
    Go To Home Page

--- Page ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Page ---
    [Teardown]    No Operation

Press ITRI LOGO
    [Documentation]    Press the ITRI image and the page will show correctly.
    [Tags]    Page    Page_1
    [Setup]    Not Login
    Go To Home Page

Press About Page
    [Documentation]    Press "About" -> "About Platform" and the page will show correctly.
    [Tags]    Page    Page_2
    [Setup]    Not Login
    # Deprecated function
    #Click Element    //a[@href="/about"]/button
    # Way 1
    Click Element    //div[@id="navbar"]//a[@href="/about"]
    # Way 2
    Go To About Platform

Press Team Page
    [Documentation]    Press "About" -> "About Team" and the page will show correctly and Count the keyword.
    [Tags]    Page    Page_3
    [Setup]    Not Login
    Go To About Team

Press FAQ Page
    [Documentation]    Press "About" -> "FAQ" and the page will show correctly.
    [Tags]    Page    Page_4
    [Setup]    Not Login
    Go To FAQ

Press Statistic Page
    [Documentation]    Press "Statistic" and the page will show correctly.
    [Tags]    Page    Page_5
    [Setup]    No Operation
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}
    Go To Statistics List

Press Topic Statistic Page
    [Documentation]    Press "Statistic" and choose specific topic to enter, and the page will show correctly.
    [Tags]    Page    Page_6
    ${File name}=    Set Variable    content
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account}    ${gTest semiadmin password}    Open browser=false
    Go To Statistics Topic    ${gTopic Name Now}    Input type=name

Check User Page Without Statistic Page
    [Documentation]    Normal user should not have "Statistic" tab.
    [Tags]    Page    Page_7
    Click Element    //div[@id="navbar"]//div[@id="is_login_li"]
    Page Should Not Contain Link    //div[@id="navbar"]//a[text()="議題管理"]

Press Topic Intro Page
    [Documentation]    Press "Issue" -> "intro" and the page will show correctly.
    [Tags]    Page    Page_8
    [Setup]    Not Login
    # check if the issue file exists or not
    ${File name}=    Set Variable    content
    Import Existed Topic    ${File name}    pri_single_reg_AOI    Operation=nosign
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=簡介

Press Topic Rule Page
    [Documentation]    Press "Issue" -> "rule" and the page will show correctly.
    [Tags]    Page    Page_9
    [Setup]    Not Login
    # check if the issue file exists or not
    ${File name}=    Set Variable    content
    Import Existed Topic    ${File name}    pri_single_reg_AOI    Operation=nosign
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=規則

Press Career Page
    [Documentation]    Press "Career" and the page will show correctly.
    [Tags]    Page    Page_10
    [Setup]    Not Login
    Go To Career

Press ITRI LOGO (ENG)
    [Documentation]    (English Version) Press the ITRI image and the page will show correctly.
    [Tags]    Page    Page_11    i18n
    [Setup]    Not Login
    Select Website Language    Lang=en
    Go To Home Page    Lang=en

Press About Page (ENG)
    [Documentation]    (English Version) Press "About" -> "About Us" and the page will show correctly.
    [Tags]    Page    Page_12    i18n
    [Setup]    Not Login
    Select Website Language    Lang=en
    # Deprecated function
    #Click Element    //a[@href="/about"]/button
    # Way 1
    Click Element    //div[@id="navbar"]//a[@href="/about"]
    # Way 2
    Go To About Platform    Lang=en

Press Team Page (ENG)
    [Documentation]    (English Version) Press "About" -> "Our Team" and the page will show correctly and Count the keyword.
    [Tags]    Page    Page_13   i18n
    [Setup]    Not Login
    Select Website Language    Lang=en
    Go To About Team    Lang=en

Press FAQ Page (ENG)
    [Documentation]    (English Version) Press "FAQ" and the page will show correctly.
    [Tags]    Page    i18n    Page_14
    [Setup]    Not Login
    Select Website Language    Lang=en
    Go To FAQ    Lang=en

Press Topic Function Page
    [Documentation]    Press "Issue" -> "Rules", "Data" , "Uplaod", "Forum", "Team up" and the page will show correctly.
    [Tags]    Page    i18n    Page_15
    # check if the issue file exists or not
    ${File name}=    Set Variable    content_team
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    # check if pages shows correctly
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=簡介
    Page Should Contain    議題提供單位
    Click Element    //a[text()="規則"]
    Page Should Contain    規則
    Click Element    //a[text()="資料"]
    Page Should Contain    資料說明
    Page Should Contain    資料下載
    Click Element    //a[text()="上傳"]
    Page Should Contain    上傳成果
    Page Should Contain    上傳格式說明
    Click Element    //a[text()="討論"]
    Page Should Contain    不管任何問題，先問問大家就對了
    Click Element    //a[text()="組隊"]
    Page Should Contain    隊名
    Page Should Contain    成員
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Press Career Page (ENG)
    [Documentation]    (English Verison) Press "Career" and the page will show correctly.
    [Tags]    Page    i18n    Page_17
    [Setup]    Not Login
    Select Website Language    Lang=en
    Go To Career    Lang=en

Press Computing Resources Page
    [Documentation]    Press "About" -> "Computing Resources" and the page will show correctly.
    [Tags]    Page    Page_18
    [Setup]    Not Login
    Go To Computing Resources

Press Computing Resources Page (ENG)
    [Documentation]    (English Verison) Press "About" -> "Computing Resources" and the page will show correctly.
    [Tags]    Page    Page_19    i18n
    [Setup]    Not Login
    Select Website Language    Lang=en
    Go To Computing Resources    Lang=en

Press AI CUP Page
    [Documentation]    Press "Competition" -> "AI CUP 2020" and "AI CUP 2019" and the page will show correctly.
    [Tags]    Page    Page_20
    [Setup]    Not Login
    Go To AI CUP

Press Facebook Icon
    [Documentation]    Press the Facebook icon and check if the page shows correctly.
    [Tags]    Page    Page_21
    [Setup]    Not Login
    Page Should Contain Element    //img[@class="logo_fb"]
    ${URL} =    Get Element Attribute    //img[@class="logo_fb"]/parent::a    href
    Should Contain    ${URL}    facebook.com/aidea.itri/
    Click Element    //img[@class="logo_fb"]
    Select Window    NEW
    Wait Until Page Contains    facebook
    # The URL will be redirected to login page on VPS

Press Topic Function Page (ENG)
    [Documentation]    (English Version) Press "Issue" -> "Rules", "Data" , "Uplaod", "Forum", "Team up" and the page will show correctly.
    [Tags]    Page    i18n    Page_22
    Select Website Language    Lang=en
    # check if the issue file exists or not
    ${File name}=    Set Variable    content_team
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    # check if pages shows correctly
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=Introduction
    Page Should Contain    Topic provider
    Click Element    //a[text()="Rules"]
    Page Should Contain    Rules
    Click Element    //a[text()="Data"]
    Page Should Contain    Data description
    Page Should Contain    Data download
    Click Element    //a[text()="Upload"]
    Page Should Contain    Upload results
    Page Should Contain    Upload format description
    Click Element    //a[text()="Forum"]
    Page Should Contain    Regardless of any question，Just ask us here!
    Click Element    //a[text()="Team up"]
    Page Should Contain    Team name
    Page Should Contain    Members
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Press Carousel Page
    [Documentation]    Check Home Page Carousel Show Correctly
    [Tags]    Page    Page_23
    [Setup]    Not Login
    Element Attribute Value Should Be    //div[@id="myCarousel"]/ol/li[1]    class    active
    Element Attribute Value Should Be    //div[@id="myCarousel"]/div/div[1]    class    item active
    #Wait auto carousel
    Wait Until Element Is Visible    //div[@id="myCarousel"]/div/div[2][@class="item active"]    timeout=6
    Element Attribute Value Should Be    //div[@id="myCarousel"]/ol/li[2]    class    active
    Wait Until Element Is Visible    //div[@id="myCarousel"]/div/div[1][@class="item active"]    timeout=6
    Element Attribute Value Should Be    //div[@id="myCarousel"]/ol/li[1]    class    active
    #Click left arrow
    Click Element    //div[@id="myCarousel"]/a[@class="left carousel-control"]
    Wait Until Element Is Visible    //div[@id="myCarousel"]/div/div[2][@class="item active"]    timeout=6
    Element Attribute Value Should Be    //div[@id="myCarousel"]/ol/li[2]    class    active
    #Click left indicator
    Click Element    //div[@id="myCarousel"]/ol/li[1]
    Wait Until Element Is Visible    //div[@id="myCarousel"]/div/div[1][@class="item active"]    timeout=6
    Element Attribute Value Should Be    //div[@id="myCarousel"]/ol/li[1]    class    active

Press Topic Category Page
    [Documentation]    Check home page topic category shows correctly
    [Tags]    Page    Page_24
    [Setup]    Not Login
    ${date}=    Get Current Date
    ${date}=    Convert Date    ${date}    result_format=%m/%d/%y
    ${File name}=    Set Variable    category
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Operation=nosign
    Click Element    //div[contains(@class,"topic_tag_content")]//h4[text()="科技生活"]
    Wait Until Element Contains    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4    ${date}
    Go To Home Page
    ${File name}=    Set Variable    category2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    Click Element    //div[contains(@class,"topic_tag_content")]//h4[text()="智慧製造"]
    Wait Until Element Contains    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4    ${date}
    Go To Home Page
    ${File name}=    Set Variable    category3
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic    Operation=nosign
    Click Element    //div[contains(@class,"topic_tag_content")]//h4[text()="環保節能"]
    Wait Until Element Contains    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4    ${date}

Press AINews Page
    [Documentation]    Check ainews and links correctly
    [Tags]    Page    Page_25
    [Setup]    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    ${date}=    Get Current Date
    ${date}=    Convert Date    ${date}    result_format=%Y/%m/%d
    Go To Admin Page    Admin type=公告管理
    Make Announcements To Topic Members    Title=AINews${date}標題    Content=AINews${date}內容    Issue=ainews
    Go To Home Page
    Page Should Contain    AI 情報特蒐
    Click Element    //a[@href="/ai_news"]
    Wait Until Page Contains Element    //section[@class="section_ainews"]//h5[text()="${date}"]
    Page Should Contain    AINews${date}標題
    Click Element    //section[@class="section_ainews"]//h5[text()="${date}"]/following-sibling::p
    Select Window    NEW    #New popup
    Location Should Be    ${gOCAIP URL}/about

Check ITRI LOGO Color Change
    [Documentation]    Check logo and navbar changed when scrolling to bottom
    [Tags]    Page    Page_26
    [Setup]    Not Login
    Element Attribute Value Should Be    //img[@id="index_logo"]    src    ${gOCAIP URL}/images/web/logo_black.png
    Page Should Contain Element    //nav[contains(@class,"at_top")]
    Customized Mouse Over    //a[@id="dropdown_language"]
    Element Attribute Value Should Be    //img[@id="index_logo"]    src    ${gOCAIP URL}/images/web/logo_white.png
    Page Should Not Contain Element    //nav[contains(@class,"at_top")]

Press CTSP-AI Page
    [Documentation]    Press "Topic" -> "CTSP-AI" and the page will show correctly.
    [Tags]    Page    Page_27
    [Setup]    Not Login
    ${File name}=    Set Variable    content2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign    Tag=ctsp_ai
    Go To Topic    ${gTopic ID Now}    Input type=id    Topic type=ctsp
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Press COVID-19 Page
    [Documentation]    Press "Topic" -> "COIVD-19" and the page will show correctly.
    [Tags]    Page    Page_28
    [Setup]    Not Login
    ${File name}=    Set Variable    content3
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign    Tag=covid_19
    Go To Topic    ${gTopic ID Now}    Input type=id    Topic type=covid
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Topic Filter
    [Documentation]    Check topic type and the filter will show correctly.
    [Tags]    Page    Page_29
    [Setup]    Not Login
    ${File name}=    Set Variable    content
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To Topic List    Topic filter=數據類型
    Wait Until Element Is Visible    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4

Check Topic Search
    [Documentation]    Check topic search and the result will show correctly.
    [Tags]    Page    Page_30
    [Setup]    Not Login
    ${File name}=    Set Variable    content
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To Topic List    Topic search=${gTopic Name Now}
    Wait Until Element Is Visible    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    ${File name}=    Set Variable    content_s
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign    Tag=course
    Go To Topic List    Topic search=${gTopic Name Now}    Topic type=course
    Wait Until Element Is Visible    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Press AINews Page (ENG)
    [Documentation]    (English Verison) Check ainews and links correctly
    [Tags]    Page    i18n    Page_31
    [Setup]    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    ${date}=    Get Current Date
    ${date}=    Convert Date    ${date}    result_format=%Y/%m/%d
    Go To Admin Page    Admin type=公告管理
    Make Announcements To Topic Members    Title=AINews${date}Title    Content=AINews${date}Content    Issue=ainews
    Select Website Language    Lang=en
    Go To Home Page
    Page Should Contain    AI News
    Click Element    //a[@href="/ai_news"]
    Wait Until Page Contains Element    //section[@class="section_ainews"]//h5[text()="${date}"]
    Page Should Contain    AINews${date}Title
    Click Element    //section[@class="section_ainews"]//h5[text()="${date}"]/following-sibling::p
    Select Window    NEW    #New popup
    Location Should Be    ${gOCAIP URL}/about

Press Topic Category Page (ENG)
    [Documentation]    (English Verison) Check home page topic category shows correctly
    [Tags]    Page    i18n    Page_32
    [Setup]    Not Login
    ${date}=    Get Current Date
    ${date}=    Convert Date    ${date}    result_format=%m/%d/%y
    ${File name}=    Set Variable    category
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Select Website Language    Lang=en
    Click Element    //div[contains(@class,"topic_tag_content")]//h4[text()="Techlife"]
    Wait Until Element Contains    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4    ${date}
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Go To Home Page
    ${File name}=    Set Variable    category2
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Click Element    //div[contains(@class,"topic_tag_content")]//h4[text()="Manufacturing"]
    Wait Until Element Contains    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4    ${date}
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Go To Home Page
    ${File name}=    Set Variable    category3
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Click Element    //div[contains(@class,"topic_tag_content")]//h4[text()="Ecolife"]
    Wait Until Element Contains    //a[contains(@href,"${gTopic ID Now}")]//div[@class="list_info"]//h4    ${date}
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC

#Check Topic Sort
#    [Documentation]    Check topic list sorting shows correctly (Deprecated Function)
#    [Tags]    Page    Page_29
#    [Setup]    Not Login
#    Go To Topic List
#    Customized Select From List By Label    //select[@id="dynamic_select"]    開始日期
#    Wait Until Location Is    ${gOCAIP URL}/topic_list?sort=start_date
#    ${sdate1}=    Get Text    //div[@class="col-lg-4 col-md-6 col-sm-12"][1]//span/i[1]
#    ${sdate2}=    Get Text    //div[@class="col-lg-4 col-md-6 col-sm-12"][2]//span/i[1]
#    ${sdate3}=    Get Text    //div[@class="col-lg-4 col-md-6 col-sm-12"][3]//span/i[1]
#    ${sdate1}=    Convert Date    ${sdate1}    result_format=epoch    exclude_millis=yes
#    ${sdate2}=    Convert Date    ${sdate2}    result_format=epoch    exclude_millis=yes
#    ${sdate3}=    Convert Date    ${sdate3}    result_format=epoch    exclude_millis=yes
#    Should Be True    ${sdate1} >= ${sdate2} >= ${sdate3}
#    Customized Select From List By Label    //select[@id="dynamic_select"]    結束日期
#    Wait Until Location Is    ${gOCAIP URL}/topic_list?sort=end_date
#    ${sdate1}=    Get Text    //div[@class="col-lg-4 col-md-6 col-sm-12"][1]//span/i[2]
#    ${sdate2}=    Get Text    //div[@class="col-lg-4 col-md-6 col-sm-12"][2]//span/i[2]
#    ${sdate3}=    Get Text    //div[@class="col-lg-4 col-md-6 col-sm-12"][3]//span/i[2]
#    ${sdate1}=    Convert Date    ${sdate1}    result_format=epoch    exclude_millis=yes
#    ${sdate2}=    Convert Date    ${sdate2}    result_format=epoch    exclude_millis=yes
#    ${sdate3}=    Convert Date    ${sdate3}    result_format=epoch    exclude_millis=yes
#    Should Be True    ${sdate1} >= ${sdate2} >= ${sdate3}

--- Except ---
    [Tags]    Title
    [Setup]    No Operation
    Log    ---- Except ---
    [Teardown]    No Operation

Exceptional Operation On Discussion
    [Documentation]    First login with the account which signs up a specific issue and go the discussion page, then login out and login with another no sign up a specific issue, and go previous twice . the disscussion page should not appear.
    [Tags]    Except    Except_1
    ${File name}=    Set Variable    issue_test1
    Create Topic With Argument    ${File name}    Issue topic=pri_single_reg_AOI
    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Time prefix}_kerker    Expect Message=${Time prefix}_kerker    Input type=id    Post account=${gTest account}
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Go To Previous Page
    Go To Previous Page
    Go To Previous Page
    Page Should Not Contain    發表留言
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Exceptional Operation On Upload
    [Documentation]    First login with the account which signs up a specific issue and go the upload page, then login out and login with another no sign up a specific issue, and go previous twice . the upload page should not appear.
    [Tags]    Except    Except_2
    ${File name}=    Set Variable    issue_test1
    Import Existed Topic    ${File name}
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=上傳
    # Click "Upload" tab
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Go To Previous Page
    Go To Previous Page
    Element Attribute Value Should Be    //a[contains(text(),'上傳')]/..    class    disabled

Exceptional Operation On Data
    [Documentation]    First login with the account which signs up a specific issue and go the data page, then login out and login with another no sign up a specific issue, and go previous twice. The data page should not appear.
    [Tags]    Except    Except_3
    ${File name}=    Set Variable    issue_test1
    Import Existed Topic    ${File name}
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=資料
    # Click "Date" tab
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Go To Previous Page
    Go To Previous Page
    Element Attribute Value Should Be    //a[contains(@href, '#topic-data')]/..    class    disabled

Exceptional Operation On ResetPWD
    [Documentation]    Go To forget password page and login correct account and password should success.
    [Tags]    Except    Except_4
    [Setup]    Not Login
    # enter forget password page
    Forget Password Request And Expect Result    abc@def.com    common    Page status=fail
    # login to page
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false

--- Stress ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Stress ---
    [Teardown]    No Operation

Upload 100 Correct Result To AOI Issue
    [Documentation]    Upload 100 result to topic AOI.
    [Tags]    Stress    Stress_1
    ${File name}=    Set Variable    stress1
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    ${Upload file}=    Set Variable    pri_0.1_pub_0.1.csv
    FOR    ${INDEX}    IN RANGE    1    101
        Log To Console    ${INDEX}..    no_newline=true
        Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file}    Input type=id
    END

Post 200 Messages And Page Show Correct
    [Documentation]    Post 200 messages to topic and show correct.
    [Tags]    Stress    Discussion    Stress_2
    ${File name}=    Set Variable    stress1
    Import Existed Topic    ${File name}    pri_single_reg_AOI
    Go To Topic    ${gTopic ID Now}    Input type=id
    ${Message}=    Set Variable    ${Time prefix}_kerker
    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Message}    Expect Message=${Message}    Input type=id    Post account=${gTest account}
    Post Multiple Messages    ${gTopic ID Now}    Number=199
    # check the time satisify or not
    ${require time}=    Set Variable    4
    ${hour1}    ${min1}    ${sec1}    Get Time    hour,min,sec
    Execute Javascript    location.reload(0)
    ${hour2}    ${min2}    ${sec2}    Get Time    hour,min,sec
    ${hour1}    Convert To Integer    ${hour1}
    ${min1}    Convert To Integer    ${min1}
    ${sec1}    Convert To Integer    ${sec1}
    ${hour2}    Convert To Integer    ${hour2}
    ${min2}    Convert To Integer    ${min2}
    ${sec2}    Convert To Integer    ${sec2}
    ${diff}    Evaluate    ${hour2}*3600+${min2}*60+${sec2}-${hour1}*3600-${min1}*60-${sec1}-1    #minus 1 is to reduce the click time
    Run Keyword if    ${diff}<=${require time}    Log    Cost time meets the requirement
    ...    ELSE    Fail    Time exceed the requirement
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- TBD ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- TBD ---
    [Teardown]    No Operation

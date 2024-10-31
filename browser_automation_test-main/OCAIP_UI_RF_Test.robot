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
--- RWD ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- RWD ---
    [Teardown]    No Operation

Navbar Show Correct In Small Size Website Before Login
    [Documentation]    Navbar show correctly in small window size(767x1080) before login
    [Tags]    RWD    RWD_1
    [Setup]    Open Browser to Page    ${gOCAIP URL}    Window width=767    Window height=1080    Mobile=True    Block Image=False
    Check Navbar Content    Login Status=false    Window size=small

Navbar Show Correct In Small Size Website After Login
    [Documentation]    Navbar show correctly in small window size(767x1080) after login
    [Tags]    RWD    RWD_2
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True    Block Image=False
    Check Navbar Content    Login Status=true    Window size=small

Check Function Correctness Of Unsigned AOI Issue In Small Website
    [Documentation]    Check function showing correctly or not at different stages of unsigned AOI issue.
    [Tags]    RWD    RWD_3
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True
    ${File name}=    Set Variable    newAOI_RWD
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Window width=767
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up AOI Issue In Small Website
    [Documentation]    Check function showing correctly or not at different stages of signed up AOI issue.
    [Tags]    RWD    RWD_4
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True
    ${File name}=    Set Variable    newAOI_RWD2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Window width=767
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Window width=767
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Unsigned Team Issue In Small Website
    [Documentation]    Check function showing correctly or not at different stages of unsigned AOI issue (team version).
    [Tags]    RWD    RWD_5
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True
    ${File name}=    Set Variable    AOI_team_RWD
    Create Topic With Argument    ${File name}    pri_team_reg_AOI    Operation=nosign
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Team type=team    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=team    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=team    Window width=767
    # developing
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up Team Issue In Small Website
    [Documentation]    Check function showing correctly or not at different stages of signed up AOI issue (team version).
    [Tags]    RWD    RWD_6
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True
    ${File name}=    Set Variable    AOI_team_RWD2
    Create Topic With Argument    ${File name}    pri_team_reg_AOI    Window width=767
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Team type=team    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=team    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=team    Window width=767
    # developing
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Unsigned Enclosed Issue In Small Website
    [Documentation]    Check function showing correctly or not at different stages of unsigned AOI issue (enclosed version).
    [Tags]    RWD    RWD_7    Enclosed_Topic
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True
    ${File name}=    Set Variable    enclosed_AOI_team_RWD
    Create Topic With Argument    ${File name}    enclosed_pri_team_reg_AOI    Operation=nosign
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=team    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=team    Window width=767
    # developing
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up Enclosed Issue In Small Website
    [Documentation]    Check function showing correctly or not at different stages of signed up AOI issue (enclosed version).
    [Tags]    RWD    RWD_8    Enclosed_Topic
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True
    ${File name}=    Set Variable    enclosed_AOI_team_RWD2
    Create Topic With Argument    ${File name}    enclosed_pri_team_reg_AOI    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=team    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=team    Window width=767
    # developing
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Show Correct Carousel Image In Small Website
    [Documentation]    Check show correct carousel image in big/middle/small website
    [Tags]    RWD    RWD_9
    [Setup]    Not Login     Window width=900
    ${b}=    Execute Javascript    return $('div.item.active').find('img')[0].currentSrc;
    Should Contain    ${b}    banner_yellow.png
    Not Login    Window width=768    Mobile=True
    ${m}=    Execute Javascript    return $('div.item.active').find('img')[0].currentSrc;
    Should Contain    ${m}    banner_m_yellow.png
    Not Login    Window width=576    Mobile=True
    ${s}=    Execute Javascript    return $('div.item.active').find('img')[0].currentSrc;
    Should Contain    ${s}    banner_s_yellow.png

Check Function Correctness Of Unsigned Leaderboard Issue In Small Website
    [Documentation]    Check function showing correctly or not at different stages of unsigned taxi issue (leaderboard version).
    [Tags]    RWD    RWD_10
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True
    ${File name}=    Set Variable    taxi_RWD
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Operation=nosign
    ${types}=    Create List    team    leaderboard
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Team type=${types}    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=${types}    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=${types}    Window width=767
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up Leaderboard Issue In Small Website
    [Documentation]    Check function showing correctly or not at different stages of signed up taxi issue (leaderboard version).
    [Tags]    RWD    RWD_11
    [Setup]    Login To OCAIP And Expect Error    ${gTest account}    ${gTest password}    Window width=767    Window height=1080    Mobile=True
    ${File name}=    Set Variable    taxi_RWD2
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Window width=767    Join=No
    ${types}=    Create List    team    leaderboard
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Team type=${types}    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=${types}    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=${types}    Window width=767
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- UI ---
    [Tags]    UI
    [Setup]    No Operation
    Log    --- UI ---
    [Teardown]    No Operation

Capture Specific UI Screenshot For Small Size Website
    [Documentation]    Capture small size screenshots for user function, statistics, and all issues (pri_single_reg_AOI, pri_single_reg_hydraulic, pri_single_reg_taxi, pub_single_reg_hydraulic, pub_single_simple_topic_3_4, pri_team_reg_AOI).
    ...    - team issue not available yet
    [Tags]    UI    UI_1    Grab_UI_Answer
    [Setup]    Not Login    Window width=360    Window height=540    Mobile=True
    # user function
    Capture Exam Images For User Function    Window width=360    Window height=540
    # pri_single_reg_AOI
    ${File name}=    Set Variable    RWD1
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Window width=360
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=360    Window height=540    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=yes    Input type=id    Issue type=AOI
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # pri_single_reg_hydraulic
    ${File name}=    Set Variable    RWD2
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic    Window width=360
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=360    Window height=540    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=yes    Input type=id    Issue type=hydraulic
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # pri_single_reg_taxi
    ${File name}=    Set Variable    RWD3
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Window width=360    Join=No
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=360    Window height=540    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=no    Input type=id    Issue type=taxi
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    ##pub_single_reg_hydraulic
    #${File name}=    Set Variable    RWD4
    #Create Topic With Argument    ${File name}    pub_single_reg_hydraulic    Window width=360
    #Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=360    Window height=540    Evaluate type=public
    #...    Webflow type=simple    Team type=single    Join condition=yes    Input type=id    Issue type=hydraulic_public
    #Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    #Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # multistage_pri_team_reg_taxi
    ${File name}=    Set Variable    RWD5
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Window width=360    Join=No
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=360    Window height=540
    ...    Evaluate type=private    Webflow type=register    Team type=team    Join condition=no    Input type=id    Issue type=multistage    Rank=yes
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    #pub_single_simple_topic_3_4
    ${File name}=    Set Variable    RWD6
    Create Topic With Argument    ${File name}    pub_single_simple_topic_3_4    Operation=none    Window width=360
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=360    Window height=540    Evaluate type=public
    ...    Webflow type=simple    Team type=single    Join condition=no    Input type=id    Issue type=topic_3_4
    Logout OCAIP    Window width=360
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    #statistics
    Login To OCAIP And Expect Error    ${gTest semiadmin account}    ${gTest semiadmin password}    Window width=360    Window height=540    Open browser=false    Mobile=True
    Capture Exam Images For Statistics    Window width=360    Window height=540
    Logout OCAIP    Window width=360
    #admin
    Login To OCAIP And Expect Error    ${gTest admin account}    ${gTest admin password}    Window width=360    Window height=540    Open browser=false    Mobile=True
    Capture Exam Images For Administration    Window width=360    Window height=540

Reorganize Grabbed Images As Answer Layout For Small Size Website
    [Documentation]    Capture small size screenshots for user function, statistics, and all issues (pri_single_reg_AOI, pri_single_reg_hydraulic, pri_single_reg_taxi, pub_single_reg_hydraulic, pub_single_simple_topic_3_4, pri_team_reg_AOI).
    ...    - team issue not available yet
    [Tags]    Grab_UI_Answer    Grab_UI_Answer_1
    ${exist}    Run Keyword And Return Status    Directory Should Not Exist    ${gTest data path Exam Image}${/}small    msg=Please delete ${gTest data path Exam Image}${/}small to renew exam images
    #run this test when need to update test image or check will fail due to images already moved away
    Run Keyword If    "${exist}"=="True"    Reorganize Grabbed Images As Answer Layout    small    small

Capture Specific UI Screenshot For Normal Size Website
    [Documentation]    Capture small size screenshots for user function, statistics, and all issues (pri_single_reg_AOI, pri_single_reg_hydraulic, pri_single_reg_taxi, pub_single_reg_hydraulic, pub_single_simple_topic_3_4, pri_team_reg_AOI).
    ...    - team issue not available yet
    [Tags]    UI    UI_2    Grab_UI_Answer
    [Setup]    Not Login    Window width=767    Window height=1024    Mobile=True
    # user function
    Capture Exam Images For User Function    Window width=767    Window height=1024
    # pri_single_reg_AOI
    ${File name}=    Set Variable    RWD1_2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Window width=767
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=767    Window height=1024    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=yes    Input type=id    Issue type=AOI
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # pri_single_reg_hydraulic
    ${File name}=    Set Variable    RWD2_2
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic    Window width=767
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=767    Window height=1024    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=yes    Input type=id    Issue type=hydraulic
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # pri_single_reg_taxi
    ${File name}=    Set Variable    RWD3_2
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Window width=767    Join=No
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=767    Window height=1024    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=no    Input type=id    Issue type=taxi
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    ##pub_single_reg_hydraulic
    #${File name}=    Set Variable    RWD4_2
    #Create Topic With Argument    ${File name}    pub_single_reg_hydraulic    Window width=767
    #Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=767    Window height=1024    Evaluate type=public
    #...    Webflow type=simple    Team type=single    Join condition=yes    Input type=id    Issue type=hydraulic_public
    #Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    #Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # multistage_pri_team_reg_taxi
    ${File name}=    Set Variable    RWD5_2
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Window width=767    Join=No
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=767    Window height=1024
    ...    Evaluate type=private    Webflow type=register    Team type=team    Join condition=no    Input type=id    Issue type=multistage    Rank=yes
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    #pub_single_simple_topic_3_4
    ${File name}=    Set Variable    RWD6_2
    Create Topic With Argument    ${File name}    pub_single_simple_topic_3_4    Operation=none    Window width=767
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=767    Window height=1024    Evaluate type=public
    ...    Webflow type=simple    Team type=single    Join condition=no    Input type=id    Issue type=topic_3_4
    Logout OCAIP    Window width=767
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    #statistics
    Login To OCAIP And Expect Error    ${gTest semiadmin account}    ${gTest semiadmin password}    Window width=767    Window height=1024    Open browser=false    Mobile=True
    Capture Exam Images For Statistics    Window width=767    Window height=1024
    Logout OCAIP    Window width=767
    #admin
    Login To OCAIP And Expect Error    ${gTest admin account}    ${gTest admin password}    Window width=767    Window height=1024    Open browser=false    Mobile=True
    Capture Exam Images For Administration    Window width=767    Window height=1024

Reorganize Grabbed Images As Answer Layout For Normal Size Website
    [Documentation]    Capture small size screenshots for user function, statistics, and all issues (pri_single_reg_AOI, pri_single_reg_hydraulic, pri_single_reg_taxi, pub_single_reg_hydraulic, pub_single_simple_topic_3_4, pri_team_reg_AOI).
    ...    - team issue not available yet
    [Tags]    Grab_UI_Answer    Grab_UI_Answer_2
    ${exist}    Run Keyword And Return Status    Directory Should Not Exist    ${gTest data path Exam Image}${/}normal    msg=Please delete ${gTest data path Exam Image}${/}normal to renew exam images
    #run this test when need to update test image or check will fail due to images already moved away
    Run Keyword If    "${exist}"=="True"    Reorganize Grabbed Images As Answer Layout    normal    normal

Capture Specific UI Screenshot For Big Size Website
    [Documentation]    Capture small size screenshots for user function, statistics, and all issues (pri_single_reg_AOI, pri_single_reg_hydraulic, pri_single_reg_taxi, pub_single_reg_hydraulic, pub_single_simple_topic_3_4, pri_team_reg_AOI).
    ...    - team issue not available yet
    [Tags]    UI    UI_3    Grab_UI_Answer
    [Setup]    Not Login    Window width=1920    Window height=1080    Mobile=True
    # user function
    Capture Exam Images For User Function    Window width=1920    Window height=1080
    # pri_single_reg_AOI
    ${File name}=    Set Variable    RWD1_3
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=1920    Window height=1080    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=yes    Input type=id    Issue type=AOI
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # pri_single_reg_hydraulic
    ${File name}=    Set Variable    RWD2_3
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=1920    Window height=1080    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=yes    Input type=id    Issue type=hydraulic
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # pri_single_reg_taxi
    ${File name}=    Set Variable    RWD3_3
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Join=No
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=1920    Window height=1080    Evaluate type=private
    ...    Webflow type=register    Team type=single    Join condition=no    Input type=id    Issue type=taxi
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    ##pub_single_reg_hydraulic
    #${File name}=    Set Variable    RWD4_3
    #Create Topic With Argument    ${File name}    pub_single_reg_hydraulic
    #Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=1920    Window height=1080    Evaluate type=public
    #...    Webflow type=simple    Team type=single    Join condition=yes    Input type=id    Issue type=hydraulic_public
    #Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    #Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    # multistage_pri_team_reg_taxi
    ${File name}=    Set Variable    RWD5_3
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Join=No
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=1920    Window height=1080
    ...    Evaluate type=private    Webflow type=register    Team type=team    Join condition=no    Input type=id    Issue type=multistage    Rank=yes
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    #pub_single_simple_topic_3_4
    ${File name}=    Set Variable    RWD6_3
    Create Topic With Argument    ${File name}    pub_single_simple_topic_3_4    Operation=nosign
    Capture Exam Images For Issue Function    ${gTopic ID Now}    Window width=1920    Window height=1080    Evaluate type=public
    ...    Webflow type=simple    Team type=single    Join condition=no    Input type=id    Issue type=topic_3_4
    Logout OCAIP
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    #statistics
    Login To OCAIP And Expect Error    ${gTest semiadmin account}    ${gTest semiadmin password}    Window width=1920    Window height=1080    Open browser=false    Mobile=True
    Capture Exam Images For Statistics    Window width=1920    Window height=1080
    Logout OCAIP
    #admin
    Login To OCAIP And Expect Error    ${gTest admin account}    ${gTest admin password}    Window width=1920    Window height=1080    Open browser=false    Mobile=True
    Capture Exam Images For Administration    Window width=1920    Window height=1080

Reorganize Grabbed Images As Answer Layout For Big Size Website
    [Documentation]    Capture small size screenshots for user function, statistics, and all issues (pri_single_reg_AOI, pri_single_reg_hydraulic, pri_single_reg_taxi, pub_single_reg_hydraulic, pub_single_simple_topic_3_4, pri_team_reg_AOI).
    ...    - team issue not available yet
    [Tags]    Grab_UI_Answer    Grab_UI_Answer_3
    ${exist}    Run Keyword And Return Status    Directory Should Not Exist    ${gTest data path Exam Image}${/}big    msg=Please delete ${gTest data path Exam Image}${/}big to renew exam images
    #run this test when need to update test image or check will fail due to images already moved away
    Run Keyword If    "${exist}"=="True"    Reorganize Grabbed Images As Answer Layout    big    big

Check UI For Login
    [Documentation]    Check UI for login, including page before login , login form , page after login and personal information
    [Tags]    UI    UI_4
    [Setup]    No Operation
    ${Image folder}=    Set Variable    user_function
    Comment    ${gTemp folder path}=    Set Variable    ${gTemp parent folder path}${/}Temp_cbf0fbc277924d4fb4fd5f4e8bca2510
    # big image compare (1920 x 1080)
    ${Postfix}=    Set Variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}user_function
    ## Home page
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home3_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home3.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home4.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home6_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home6.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## Login form
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}login_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}login.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Login icon
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}icon_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}loginIcon.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Login profile
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}profile_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}profile.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Subscription
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}subscription_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}subscription.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}user_function
    ## Home page
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home3_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home3.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home4.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home6_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home6.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Login form
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}login_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}login.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Login icon
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}icon_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}loginIcon.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Login profile
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}profile_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}profile.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Subscription
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}subscription_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}subscription.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # small image compare (360 x 540)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}user_function
    ## Home page
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home3_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home3.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home4.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}home6_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}home6.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Login form
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}login_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}login.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Login icon
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}icon_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}loginIcon.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Login profile
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}profile_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}profile.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Subscription
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}subscription_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}subscription.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Log    developing

Check UI For Register
    [Documentation]    Check UI for register, including register form and register page
    [Tags]    UI    UI_5
    [Setup]    No Operation
    ${Image folder}=    Set Variable    user_function
    Comment    ${gTemp folder path}=    Set Variable    ${gTemp parent folder path}${/}Temp_cbf0fbc277924d4fb4fd5f4e8bca2510
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}register_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}register.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}register_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}register.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # small image compare (360 x 540)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}register_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}register.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98

Check UI For Change Password
    [Documentation]    Check UI for change password, including change password, old password, new password and \ confirm_password
    [Tags]    UI    UI_6
    [Setup]    No Operation
    ${Image folder}=    Set Variable    user_function
    Comment    ${gTemp folder path}=    Set Variable    ${gTemp parent folder path}${/}Temp_cbf0fbc277924d4fb4fd5f4e8bca2510
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}changepwd_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}changepwd.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}changepwd_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}changepwd.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # small image compare (360 x 540)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}changepwd_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}changepwd.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Log    developing

Check UI For Forget Password
    [Documentation]    Check UI for forget password, including forget password form , result page and forget password page
    [Tags]    UI    UI_7
    [Setup]    No Operation
    ${Image folder}=    Set Variable    user_function
    Comment    ${gTemp folder path}=    Set Variable    ${gTemp parent folder path}${/}Temp_cbf0fbc277924d4fb4fd5f4e8bca2510
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}forgetpwd_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}forgetpwd.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}forgetpwd_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}forgetpwd.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # small image compare (360 x 480)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}user_function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}forgetpwd_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}forgetpwd.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Log    developing

Check UI For Web Content
    [Documentation]    Check UI for web content, including home page, about team, about us and faq
    [Tags]    UI    UI_8
    [Setup]    No Operation
    ${Image folder}=    Set Variable    user_function
    Comment    ${gTemp folder path}=    Set Variable    ${gTemp parent folder path}${/}Temp_cbf0fbc277924d4fb4fd5f4e8bca2510
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}user_function
    ## About Us
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about3_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about3.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about4.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## About Team
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}team_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}team.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Computing
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}computing_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}computing.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Privacy
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}privacy_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}privacy.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## FAQ
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}faq_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}faq.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}user_function
    ## About Us
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about3_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about3.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about4.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## About Team
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}team_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}team.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Computing
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}computing_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}computing.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Privacy
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}privacy_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}privacy.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## FAQ
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}faq_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}faq.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # small image compare (360 x 540)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}user_function
    ## About Us
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about3_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about3.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}about4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}about4.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## About Team
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}team_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}team.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Computing
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}computing_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}computing.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## Privacy
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}privacy_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}privacy.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## FAQ
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}faq_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}faq.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Comment    ## Topic List
    Comment    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}topiclist_${Postfix}.png
    Comment    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}topiclist.png
    Comment    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Log    developing

Check UI For AOI Issue
    [Documentation]    Check UI for unsigned AOI issue, including introduction, rule, data, upload and discuss page
    [Tags]    UI    UI_9
    [Setup]    No Operation
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}pri_single_reg_AOI
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}pri_single_reg_AOI
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    # small image compare (360 x 540)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}pri_single_reg_AOI
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_AOI_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    Log    developing

Check UI For Hydraulic Issue
    [Documentation]    Check UI for unsigned Hydraulic issue, including introduction, rule, data, upload and discuss page
    [Tags]    UI    UI_11
    [Setup]    No Operation
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}pri_single_reg_hydraulic
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}pri_single_reg_hydraulic
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    # small image compare (360 x 480)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}pri_single_reg_hydraulic
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_hydraulic_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    Log    developing

Check UI For Taxi Issue
    [Documentation]    Check UI for unsigned Taxi issue, including introduction, rule, data, upload and discuss page
    [Tags]    UI    UI_13
    [Setup]    No Operation
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}pri_single_reg_taxi
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}pri_single_reg_taxi
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    # small image compare (360 x 480)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}pri_single_reg_taxi
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_taxi_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    Log    developing

Check UI For Multistage Issue
    [Documentation]    Check UI for unsigned multistage issue, including introduction, rule, data, upload and discuss page
    [Tags]    UI    UI_14
    [Setup]    No Operation
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}multistage_pri_team_reg_taxi
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## team
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}team_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}team.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## join
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}join_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}join.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}request_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}request.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## rank
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rank_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rank.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}multistage_pri_team_reg_taxi
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## team
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}team_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}team.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## join
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}join_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}join.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}request_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}request.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## rank
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rank_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rank.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    # small image compare (360 x 480)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}multistage_pri_team_reg_taxi
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## team
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}team_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}team.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## join
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}join_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}join.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}request_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}request.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## rank
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rank_multistage_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rank.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    Log    developing

#Check UI For SinglePublic Issue
#    [Documentation]    Check UI for unsigned SinglePublic issue, including introduction, rule, data, upload and discuss page
#    [Tags]    UI    UI_15
#    [Setup]    No Operation
#    # big image compare (1920 x 1080)
#    ${Postfix}=    Set variable    big
#    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}pub_single_reg_hydraulic
#    ## intro
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## rule
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## data
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## upload
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## discuss
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## post
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    # normal image compare (768 x 1024)
#    ${Postfix}=    Set variable    normal
#    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}pub_single_reg_hydraulic
#    ## intro
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## rule
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## data
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## upload
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## discuss
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    ## post
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.965
#    # small image compare (360 x 540)
#    ${Postfix}=    Set variable    small
#    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}pub_single_reg_hydraulic
#    ## intro
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.965
#    ## rule
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.965
#    ## data
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.965
#    ## upload
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.965
#    ## discuss
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.965
#    ## post
#    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_hydraulic_public_${Postfix}.png
#    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
#    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.965
#    Log    developing

Check UI For Topic_3_4 Issue
    [Documentation]    Check UI for Topic_3_4 issue, including introduction, rule, data, upload and discuss page
    [Tags]    UI    UI_17
    [Setup]    No Operation
    # big image compare (1920 x 1080)
    ${Postfix}=    Set variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}pub_single_simple_topic_3_4
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    # normal image compare (768 x 1024)
    ${Postfix}=    Set variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}pub_single_simple_topic_3_4
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    # small image compare (360 x 480)
    ${Postfix}=    Set variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}pub_single_simple_topic_3_4
    ## intro
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}intro_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}intro.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## rule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## data
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}data_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}data.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## datarule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}datarule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}datarule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## upload
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## uploadrule
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}uploadrule_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}uploadrule.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96
    ## discuss
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}discuss_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}discuss.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    ## post
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}post_topic_3_4_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}post.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.96    #0.96
    Log    developing

Check UI For Team Issue
    [Documentation]    Check UI for unsigned TeamUp issue, including introduction, rule, data, upload , discuss and teamup page
    [Tags]    UI    UI_18
    [Setup]    No Operation
    Comment    # big image compare (1920 x 1080)
    Comment    ${Postfix}=    Set variable    big
    Comment    ${Exam path}=    Set variable    ${gTest data path Exam Image}${/}big${/}pri_team_reg_AOI
    Comment    ${Test Big Image}=    Set Variable    ${gTemp folder path}
    Comment    ${Exam Big Image}=    Set Variable    ${Exam path}${/}exam1.png
    Comment    Check Two Image Similarity    ${Test Big Image}    ${Exam Big Image}    0.98
    Comment    # normal image compare (768 x 1024)
    Comment    ${Postfix}=    Set variable    normal
    Comment    ${Exam path}=    Set variable    ${gTest data path Exam Image}${/}normal${/}pri_team_reg_AOI
    Comment    ${Test Normal Image}=    Set Variable    ${gTemp folder path}
    Comment    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}exam2.png
    Comment    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Comment    # small image compare (360 x 480)
    Comment    ${Postfix}=    Set variable    small
    Comment    ${Exam path}=    Set variable    ${gTest data path Exam Image}${/}small${/}pri_team_reg_AOI
    Comment    ${Test Normal Image}=    Set Variable    ${gTemp folder path}
    Comment    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}exam3.png
    Comment    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Log    developing

Check UI For Statistic Page
    [Tags]    UI    UI_20
    [Setup]    No Operation
    # big image compare (1920 x 1080)
    ${Postfix}=    Set Variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}statistics
    ## browser number chart
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}browser_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}browser_chart.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## browser school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}browser_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}browser_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## download school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}download_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}download_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## attend school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}attend_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}attend_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## statistic function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}function_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}function.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## hight score
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}score_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}score.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Comment    ## statistic list
    Comment    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}statistic_list_${Postfix}.png
    Comment    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}statistics_list.png
    Comment    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## upload recoard
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_record_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload_record.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## upload school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## notification
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}notification_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}notification.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## participant
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}participant_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}participant.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## rank_stat
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rank_stat_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rank_stat.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## board_stat
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}board_stat_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}board_stat.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## setting
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}setting_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}setting.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # normal image compare (768 x 1024)
    ${Postfix}=    Set Variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}statistics
    ## browser number chart
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}browser_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}browser_chart.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## browser school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}browser_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}browser_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## download school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}download_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}download_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## attend school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}attend_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}attend_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## statistic function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}function_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}function.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## hight score
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}score_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}score.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Comment    ## statistic list
    Comment    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}statistic_list_${Postfix}.png
    Comment    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}statistics_list.png
    Comment    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## upload recoard
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_record_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload_record.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## upload school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## notification
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}notification_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}notification.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## participant
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}participant_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}participant.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## rank_stat
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rank_stat_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rank_stat.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## board_stat
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}board_stat_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}board_stat.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## setting
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}setting_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}setting.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    # small image compare (360 x 540)
    ${Postfix}=    Set Variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}statistics
    ## browser number chart
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}browser_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}browser_chart.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## browser school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}browser_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}browser_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## download school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}download_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}download_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## attend school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}attend_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}attend_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## statistic function
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}function_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}function.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## hight score
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}score_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}score.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    Comment    ## statistic list
    Comment    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}statistic_list_${Postfix}.png
    Comment    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}statistics_list.png
    Comment    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## upload recoard
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_record_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload_record.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## upload school
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}upload_school_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}upload_school.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.95    #0.97
    ## notification
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}notification_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}notification.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## participant
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}participant_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}participant.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## rank_stat
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}rank_stat_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}rank_stat.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## board_stat
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}board_stat_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}board_stat.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    ## setting
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}setting_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}setting.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.98
    Log    developing

Check UI For Administration Page
    [Tags]    UI    UI_21
    [Setup]    No Operation
    # big image compare (1920 x 1080)
    ${Postfix}=    Set Variable    big
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}big${/}administration
    ## permission
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}permission_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}permission.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}member_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}member.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## member table
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}member_table_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}member_table.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## total member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}total_member_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}total_member.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## role
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}role_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}role.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## announcement
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}announcement_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}announcement.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## invite
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}invite_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}invite.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## invite non-member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}invite2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}invite2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## board
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}board_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}board.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## carousel
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}carousel_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}carousel.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    # normal image compare (768 x 1024)
    ${Postfix}=    Set Variable    normal
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}normal${/}administration
    ## permission
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}permission_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}permission.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}member_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}member.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## member table
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}member_table_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}member_table.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## total member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}total_member_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}total_member.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## role
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}role_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}role.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## announcement
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}announcement_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}announcement.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## invite
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}invite_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}invite.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## invite non-member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}invite2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}invite2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## board
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}board_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}board.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## carousel
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}carousel_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}carousel.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    # small image compare (360 x 540)
    ${Postfix}=    Set Variable    small
    ${Exam path}=    Set Variable    ${gTest data path Exam Image}${/}small${/}administration
    ## permission
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}permission_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}permission.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}member_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}member.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## member table
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}member_table_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}member_table.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## total member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}total_member_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}total_member.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## role
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}role_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}role.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## announcement
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}announcement_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}announcement.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## invite
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}invite_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}invite.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## invite non-member
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}invite2_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}invite2.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## board
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}board_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}board.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    ## carousel
    ${Test Normal Image}=    Set Variable    ${gTemp folder path}${/}carousel_${Postfix}.png
    ${Exam Normal Image}=    Set Variable    ${Exam path}${/}carousel.png
    Check Two Image Similarity    ${Exam Normal Image}    ${Test Normal Image}    0.97
    Log    developing

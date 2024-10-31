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
--- TimeBar ---
    [Tags]    Title
    [Setup]    No Operation
    Comment    Log    --- TimeBar ---
    [Teardown]    No Operation

Check Timebar Correctness Of Unsigned AOI Issue
    [Documentation]    Check timebar order will show correct or not
    [Tags]    TimeBar    TimeBar_1
    ${File name}=    Set Variable    AOI_t
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=False
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Signed Up AOI Issue
    [Tags]    TimeBar    TimeBar_2
    ${File name}=    Set Variable    AOI_t2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=True
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Unsigned Hydraulic Issue
    [Tags]    TimeBar    TimeBar_3
    ${File name}=    Set Variable    Hydraulic_t
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic    Operation=nosign
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=False
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Signed Up Hydraulic Issue
    [Tags]    TimeBar    TimeBar_4
    ${File name}=    Set Variable    Hydraulic_t2
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=True
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Unsigned Taxi Issue
    [Tags]    TimeBar    TimeBar_5
    ${File name}=    Set Variable    Taxi_t
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Operation=nosign
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=False
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Signed Up Taxi Issue
    [Tags]    TimeBar    TimeBar_6
    ${File name}=    Set Variable    Taxi_t2
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Join=No
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=True
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Unsigned Single Public Issue
    [Tags]    TimeBar    TimeBar_7
    ${File name}=    Set Variable    SinglePublic_t
    Create Topic With Argument    ${File name}    pub_single_reg_hydraulic    Operation=nosign
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=False
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Signed Up Single Public Issue
    [Tags]    TimeBar    TimeBar_8
    ${File name}=    Set Variable    SinglePublic_t2
    Create Topic With Argument    ${File name}    pub_single_reg_hydraulic
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=True
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Topic_3_4
    [Tags]    TimeBar    TimeBar_9
    ${File name}=    Set Variable    topic_3_4_t
    Create Topic With Argument    ${File name}    pub_single_simple_topic_3_4    Flow type=simple    Join=No
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=True
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Unsigned Enclosed Issue
    [Tags]    TimeBar    TimeBar_10    Enclosed_Topic
    ${File name}=    Set Variable    Enclosed_t
    Create Topic With Argument    ${File name}    enclosed_pri_team_reg_AOI    Operation=nosign
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=False    Enclosed=True
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Timebar Correctness Of Signed Up Enclosed Issue
    [Tags]    TimeBar    TimeBar_11    Enclosed_Topic
    ${File name}=    Set Variable    Enclosed_t2
    Create Topic With Argument    ${File name}    enclosed_pri_team_reg_AOI    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0
    Check Timebar At Different Stages    ${gTopic ID Now}    Input type=id    Sign status=True    Enclosed=True
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Function_Verification ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Function_Verification ---
    [Teardown]    No Operation

Check Function Correctness Of Unsigned AOI Issue
    [Documentation]    Check function showing correctly or not at different stages of unsigned AOI issue.
    [Tags]    Function_Verification    Function_Verification_1
    ${File name}=    Set Variable    newAOI
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up AOI Issue
    [Documentation]    Check function showing correctly or not at different stages of signed up AOI issue.
    [Tags]    Function_Verification    Function_Verification_2
    ${File name}=    Set Variable    newAOI2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Unsigned Hydraulic Issue
    [Documentation]    Check function showing correctly or not at different stages of unsigned hydraulic issue.
    [Tags]    Function_Verification    Function_Verification_3
    ${File name}=    Set Variable    newHydraulic
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic    Operation=nosign
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up Hydraulic Issue
    [Documentation]    Check function showing correctly or not at different stages of signed up hydraulic issue.
    [Tags]    Function_Verification    Function_Verification_4
    ${File name}=    Set Variable    newHydraulic2
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Unsigned Taxi Issue
    [Documentation]    Check function showing correctly or not at different stages of unsigned taxi issue.
    [Tags]    Function_Verification    Function_Verification_5
    ${File name}=    Set Variable    newTaxi
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Operation=nosign
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up Taxi Issue
    [Documentation]    Check function showing correctly or not at different stages of signed up taxi issue.
    [Tags]    Function_Verification    Function_Verification_6
    ${File name}=    Set Variable    newTaxi2
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Join=No
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Unsigned Single Public Issue
    [Documentation]    Check function showing correctly or not at different stages of unsigned single public version issue.
    [Tags]    Function_Verification    Function_Verification_7
    ${File name}=    Set Variable    SinglePublic1
    Create Topic With Argument    ${File name}    pub_single_reg_hydraulic    Operation=nosign
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Evaluate type=sinpub
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Evaluate type=sinpub
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Evaluate type=sinpub
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up Single Public Issue
    [Documentation]    Check function showing correctly or not at different stages of signed up single public version issue.
    [Tags]    Function_Verification    Function_Verification_8
    ${File name}=    Set Variable    SinglePublic2
    Create Topic With Argument    ${File name}    pub_single_reg_hydraulic
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Evaluate type=sinpub
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Evaluate type=sinpub
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Evaluate type=sinpub
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Topic_3_4
    [Documentation]    Check function showing correctly or not at topic_3_4 issues (eval_type = single public && web_status_flow_type = simple).
    [Tags]    Function_Verification    Function_Verification_9
    ${File name}=    Set Variable    topic34_2
    Create Topic With Argument    ${File name}    pub_single_simple_topic_3_4    Flow type=simple    Join=No
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Evaluate type=sinpub    Flow type=simple
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Evaluate type=sinpub    Flow type=simple
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Unsigned Team Issue
    [Documentation]    Check function showing correctly or not at different stages of unsigned AOI issue (team version).
    [Tags]    Function_Verification    Function_Verification_10
    ${File name}=    Set Variable    AOI_team
    Create Topic With Argument    ${File name}    pri_team_reg_AOI    Operation=nosign
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Team type=team
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=team
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=team
    # developing
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up Team Issue
    [Documentation]    Check function showing correctly or not at different stages of signed up AOI issue (team version).
    [Tags]    Function_Verification    Function_Verification_11
    ${File name}=    Set Variable    AOI_team2
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin    Team type=team
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=team
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=team
    # developing
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Unsigned Enclosed Team Issue
    [Documentation]    Check function showing correctly or not at different stages of unsigned enclosed AOI issue (enclosed version).
    [Tags]    Function_Verification    Function_Verification_12    Enclosed_Topic
    ${File name}=    Set Variable    enclosed
    Create Topic With Argument    ${File name}    enclosed_pri_team_reg_AOI    Operation=nosign
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=team
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=team
    # developing
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Signed Up Enclosed Team Issue
    [Documentation]    Check function showing correctly or not at different stages of signed up enclosed AOI issue (enclosed version).
    [Tags]    Function_Verification    Function_Verification_13    Enclosed_Topic
    ${File name}=    Set Variable    enclosed2
    Create Topic With Argument    ${File name}    enclosed_pri_team_reg_AOI    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account}    Expect=0
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue    Team type=team
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Functions At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end    Team type=team
    # developing
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of News Honor NTU
    [Documentation]    Check function showing correctly or not for news honor ntu.
    [Tags]    Function_Verification    Function_Verification_14    Enclosed_Topic    TeamUp_Course
    ${File name}=    Set Variable    news_honor
    Create Topic With Argument    ${File name}    news_honor-ntu-test    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=${gTest account} ${gTest first account}    Expect=0
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id    Status=exceed    Topic type=course
    Download Function No Available
    FOR    ${INDEX}    IN RANGE    0    3
        Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${CURDIR}${/}Test_Data${/}News_Honor${/}Correct_File${/}pri_0_pub_1.csv    Input type=id    Topic type=course    # Normal file
    END
    Page Should Contain    上傳次數已達本日上限
    Page Should Not Contain Element    //a[contains(text(),'上傳說明文件')]
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

#Check Function Correctness Of News Application NTU
#    [Documentation]    Check function showing correctly or not for news pplication ntu.
#    [Tags]    Function_Verification    Function_Verification_15    TeamUp_Aicup
#    ${File name}=    Set Variable    news_application
#    Create Topic With Argument    ${File name}    news_application-ntu-test    Join=No    Topic type=aicup
#    Logout OCAIP
#    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
#    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id    Join=No    Topic type=aicup
#    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t1    Contain team=yes    Input type=id    Topic type=aicup
#    Logout OCAIP
#    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
#    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t2    Request leader=t2    Operation=accept    Input type=id
#    Download Function No Available
#    Click Element    //a[@href="#topic-upload" and text()="上傳"]
#    #Page Should Not Contain Element    //a[contains(text(),'上傳成果')]    #Web Function TBD
#    Click Element    //a[contains(text(),'上傳說明文件')]

Check Function Correctness Of External Link
    [Documentation]    Check external link show correct
    [Tags]    Function_Verification    Function_Verification_16
    ${File name}=    Set Variable    elink_1
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Join=No
    Download Data From Topic    ${gTopic ID Now}    File name=link    Need sign NDA=N    Input type=id    External=Y
    Location Should Be    https://aidea-web.tw/
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Function_Verification_Not_Login ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Function_Verification_Not_Login ---
    [Teardown]    No Operation

Check Function Correctness Of Not Login AOI Issue
    [Documentation]    Check function showing correctly or not for AOI issue without login.
    [Tags]    Function_Verification    Function_Verification_Not_Login_1    Not_Login
    [Setup]    Not Login
    ${File name}=    Set Variable    newAOI_not_login
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Not Login Hydraulic Issue
    [Documentation]    Check function showing correctly or not for hydraulic issue without login.
    [Tags]    Function_Verification    Function_Verification_Not_Login_2    Not_Login
    [Setup]    Not Login
    ${File name}=    Set Variable    newHydraulic_not_login
    Create Topic With Argument    ${File name}    pri_single_reg_hydraulic    Operation=nosign
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Check Function Correctness Of Not Login Taxi Issue
    [Documentation]    Check function showing correctly or not for taxi issue without login.
    [Tags]    Function_Verification    Function_Verification_Not_Login_3    Not_Login
    [Setup]    Not Login
    ${File name}=    Set Variable    newTaxi_not_login
    Create Topic With Argument    ${File name}    pri_single_reg_taxi    Operation=nosign
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=begin
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=continue
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Time Countdown At Different Stages    ${gTopic ID Now}    Input type=id    Issue type=end
    Check Functions When Not Login    ${gTopic ID Now}    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Discussion ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Discussion ---
    [Teardown]    No Operation

Check Zero Message Show Correct
    [Documentation]    Zero message from topic and the page show correct
    [Tags]    Discussion    Discussion_1
    ${File name}    Set Variable    discussion
    Create Topic With Argument    File name=${File name}    Issue topic=pri_single_reg_AOI
    Check Zero Message From Topic    ${gTopic ID Now}    Input type=id

Post A Message
    [Documentation]    Post a message to topic.
    [Tags]    Discussion    Discussion_2
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Message}=    Set Variable    ${Time prefix}_kerker
    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Message}    Expect Message=${Message}    Input type=id    Post account=${gTest account}
    Open Discussion Notification Page   Post Message=${Message}    Post account=${gTest account}

Post Bad Program And Page Show Correct
    [Documentation]    Post bad program to topic and the page will show correct and no alert happen
    [Tags]    Discussion    Discussion_3
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Post Message}=    Set Variable    <script>alert("Boo!")</script>
    ${Expect Message}=    Set Variable    ${Post Message}
    ${Post time}=    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Post Message}    Expect Message=${Expect Message}    Input type=id    Post account=${gTest account}
    Alert Should Not Be Present
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Expect message}'    Post account=${gTest account}    Post time=${Post time}    Input type=id

Post Special Character And Page Show Correct
    [Documentation]    Post special characters to topic and the page will show correct and no alert happen
    [Tags]    Discussion    Discussion_4
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Post Message}=    Set Variable    <&'">
    ${Expect Message}=    Set Variable    ${Post Message}
    ${Post time}=    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Post Message}    Expect Message=${Expect Message}    Input type=id    Post account=${gTest account}
    Alert Should Not Be Present
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='<&"">'    Post account=${gTest account}    Post time=${Post time}    Input type=id

Delete A Message
    [Documentation]    Delete a message from topic.
    [Tags]    Discussion    Discussion_5
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${EMPTY}    Input type=id

Like A Message
    [Documentation]    Like a message from topic.
    [Tags]    Discussion    Discussion_6
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Message}=    Set Variable    ${Time prefix}_kerker
    ${Post time to like}=    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Message}    Expect Message=${Message}    Input type=id    Post account=${gTest account}
    Set Suite Variable    ${Post time to like}
    Like Message Of Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${Post time to like}    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Like Message Of Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${Post time to like}    Input type=id
    ${Wanted msg}=    Check If Message Existed In Discussion Zone Of Topic    text()='${Time prefix}_kerker'    ${gTest account}    ${Post time to like}
    Element Text Should Be    ${Wanted msg}//div[@class="number"]    2

Dislike A Message
    [Documentation]    Dislike the message from topic.
    [Setup]    No Operation
    [Tags]    Discussion    Discussion_7
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}
    Dislike Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${Post time to like}    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Dislike Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${Post time to like}    Input type=id
    ${Wanted msg}=    Check If Message Existed In Discussion Zone Of Topic    text()='${Time prefix}_kerker'    ${gTest account}    ${Post time to like}
    Element Text Should Be    ${Wanted msg}//div[@class="number"]    0
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${Post time to like}    Input type=id

Delete All Message
    [Documentation]    Delete all message and show correct
    [Tags]    Discussion    Discussion_8
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    # verify if there exist a message on the topic
    Check Zero Message From Topic    ${gTopic ID Now}    Input type=id
    # gen message
    ${Message}=    Set Variable    ${Time prefix}_kerker
    ${Post time}=    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Message}    Expect Message=${Message}    Input type=id    Post account=${gTest account}
    # delete message
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${Post time}    Input type=id
    #verify if there exist a message on the topic
    Check Zero Message From Topic    ${gTopic ID Now}    Input type=id

Delete Message With Order
    [Documentation]    Post three messages and delete with specific order.
    [Tags]    Discussion    Discussion_9
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    #post message
    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Time prefix}_kerker1    Expect Message=${Time prefix}_kerker1    Input type=id    Post account=${gTest account}
    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Time prefix}_kerker2    Expect Message=${Time prefix}_kerker2    Input type=id    Post account=${gTest account}
    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Time prefix}_kerker3    Expect Message=${Time prefix}_kerker3    Input type=id    Post account=${gTest account}
    # delete message with order
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker2'    Post account=${gTest account}    Post time=${EMPTY}    Input type=id
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker1'    Post account=${gTest account}    Post time=${EMPTY}    Input type=id
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker3'    Post account=${gTest account}    Post time=${EMPTY}    Input type=id
    #verify if there exist a message on the topic
    Check Zero Message From Topic    ${gTopic ID Now}    Input type=id

Click Many Times Of Like
    [Documentation]    Click many times of like to check if the page will show correct.
    [Tags]    Discussion    Discussion_10
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Message}=    Set Variable    ${Time prefix}_kerker
    ${Post time to like}=    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Message}    Expect Message=${Message}    Input type=id    Post account=${gTest account}
    Click Many Times Of Like To Check Correct    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Click times=5    Posted user=${gTest account}    Posted time=${Post time to like}    Input type=id
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${EMPTY}    Input type=id

Other User Can Not Delete Other User Message
    [Documentation]    Other user can't delete other user's message
    [Tags]    Discussion    Discussion_11
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Message}=    Set Variable    ${Time prefix}_kerker
    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Message}    Expect Message=${Message}    Input type=id    Post account=${gTest account}
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Delete A Message From Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker'    Post account=${gTest account}    Post time=${EMPTY}    Input type=id    self=no

Other User Can Like Other User Message
    [Documentation]    Other can like other user's message
    [Tags]    Discussion    Discussion_12
    ${File name}    Set Variable    discussion
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Message}=    Set Variable    ${Time prefix}_kerker1
    ${Post time to like}=    Post A Message To Topic    ${gTopic ID Now}    Post Message=${Message}    Expect Message=${Message}    Input type=id    Post account=${gTest account}
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Like Message Of Topic    ${gTopic ID Now}    Message=text()='${Time prefix}_kerker1'    Post account=${gTest account}    Post time=${Post time to like}    Input type=id
    Clear Mail Box    Sequence=all    Title=在您管理的議題
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- ChangeDate ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- ChangeDate ---
    [Teardown]    No Operation

Download Page Should Show Correct
    [Documentation]    Check if download page show correct when the issue is close with achieving deadline.
    [Tags]    ChangeDate    ChangeDate_1
    ${File name}=    Set Variable    closeIssue01
    Create Topic With Argument    ${File name}    Issue topic=pri_single_reg_AOI
    Change Topic Date    ${gTopic ID Now}    END_TOPIC
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Page Should Show Correct With No Upload
    [Documentation]    Check if upload page show correct when the issue is close with achieving deadline.
    [Tags]    ChangeDate    ChangeDate_2
    ${File name}=    Set Variable    closeIssue02
    Create Topic With Argument    ${File name}    Issue topic=pri_single_reg_AOI
    Change Topic Date    ${gTopic ID Now}    END_TOPIC
    Check Issue Page No Specific Function Available    ${gTopic ID Now}    Input type=id    Func type=upload    Topic type=past    # since now issue is close then    the type will be past
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Page Should Show Correct With Upload
    [Documentation]    Check if upload page show correct when the issue is close with achieving deadline.
    [Tags]    ChangeDate    ChangeDate_3
    ${File name}=    Set Variable    closeIssue03
    Create Topic With Argument    ${File name}    Issue topic=pri_single_reg_AOI
    # multiple user upload same data
    ${upload file}=    Set Variable    pri_0.5_pub_0.7.csv
    # t1
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${upload file}    Expect score=0.7    Input type=id
    Logout OCAIP
    # t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Sleep    1s
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest normal account}    File location=${gTest data path AOI}${/}Correct_File${/}${upload file}    Expect score=0.7    Input type=id
    # check if the rank is true
    # t3
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=2/2    Input type=id
    Logout OCAIP
    # t1
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/2    Input type=id
    #verify private board
    Change Topic Date    ${gTopic ID Now}    END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.5
    Check Upload Rank Is Correct    ${gTopic ID Now}    Expect rank=1/2    Input type=id    Board type=private
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Download Page Should Show Correct With Multistage
    [Documentation]    Check if download page show correct when the issue is stage 2
    [Tags]    ChangeDate    ChangeDate_4
    ${File name}=    Set Variable    multidownload_1
    Create Topic With Argument    ${File name}    multistage_pri_team_reg_taxi    Join=No
    Download Data From Topic    ${gTopic ID Now}    File name=test_images_data.zip    Need sign NDA=N    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_STAGE    Success msg=Successfully changed topic stage.    Error msg=Change end_stage date failed!
    Download Data From Topic    ${gTopic ID Now}    File name=test_images_data_2.zip    Need sign NDA=N    Input type=id
    Run Keyword And Expect Error    STARTS: Element with locator '//a[contains(text(),"test_images_data.zip")]' not found.    Download Data From Topic    ${gTopic ID Now}    File name=test_images_data.zip    Need sign NDA=N    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Upload Result In Last Seconds
    [Documentation]    Upload result in last seconds and check show correct
    [Tags]    ChangeDate    ChangeDate_5
    ${File name}=    Set Variable    uploadAOI_secs
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    Change Topic Date    ${gTopic ID Now}    Operation=END_JOIN    Success msg=Successfully changed topic join_end_date    Error msg=Change end_join date failed!
    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC    Shift=30
    ${Upload file}=    Set Variable    pri_0.1_pub_0.1.csv
    Upload Result For Topic And Expect Error    ${gTopic ID Now}    ${gTest account}    File location=${gTest data path AOI}${/}Correct_File${/}${Upload file}    Input type=id    Refresh=False
    Alert Should Be Present    議題狀態改變    timeout=30
    Upload Function No Available    ${gTopic ID Now}    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

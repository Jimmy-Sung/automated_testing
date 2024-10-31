*** Settings ***
Suite Setup       Suite Setup
Suite Teardown    Suite Teardown
Test Setup
Test Teardown
Force Tags        API
Library           SeleniumLibrary    30    3    run_on_failure=None
Library           RequestsLibrary    # ssl_verify=false
Library           Collections
Resource          ./Keywords/OCAIP_API_Keywords.txt
Resource          Keywords/OCAIP_Keywords.txt

*** Test Cases ***
Topics List
    [Documentation]    Get all topics lists wih API.
    [Setup]    Login To OCAIP    ${gTest account}    ${gTest password}
    # create pri_team_reg_AOI
    ${File name}=    Set Variable    API_AOI
    Create Topic With Argument    ${File name}    pri_team_reg_AOI    Operation=nosign
    ${Topics list}=    Get All Topics List By API
    : FOR    ${Each topic}    IN    @{Topics list}
    \    Log List    ${Each topic}
    \    ${Topic desciption}=    Get From Dictionary    ${Each topic}    description
    \    Log    ${Topic desciption}
    ${gTest topic}=    Get From Dictionary    @{Topics list}[0]    title
    ${Topic id}=    Get From Dictionary    @{Topics list}[0]    topic_id
    Sign Up To Sign NDA    ${Topic id}    Input type=id
    Set Suite Variable    ${gTest topic}
    [Teardown]    Run Keywords    Delete All Sessions
    ...    AND    Compatibility Teardown    ${gTopic ID Now}

Get Specific Topic Information
    [Documentation]    Get test topic information with API.
    Variable Should Exist    ${gTest topic}    Variable which stores test topic name does not exist, please execute test case "Topic List" to get it.
    ${Topic info}    Get Topic Information By API    ${gTest topic}
    Log Dictionary    ${Topic info}
    [Teardown]    Delete All Sessions

Users List
    [Documentation]    Get all users lists with API.
    [Setup]    No Operation
    ${Users list}=    Get All Users List By API
    : FOR    ${Each user}    IN    @{Users list}
    \    Log Dictionary    ${Each user}
    \    ${User name}=    Get From Dictionary    ${Each user}    username
    \    Log    ${User name}
    [Teardown]    Delete All Sessions

Get Specific User Infomation
    [Documentation]    Get user information with API.
    [Setup]    No Operation
    ${User name}=    Set Variable    Admin
    ${User info}=    Get User Information By API    ${User name}
    Log Dictionary    ${User info}
    [Teardown]    Delete All Sessions

Check If User Email Exists In System
    [Documentation]    Check if email is used with API.
    ${Mail Domain}=    Split String    ${gTest mail account}    @
    Check If User Email Exists In System By API    ocaip.test+admin@${Mail Domain[1]}

Get Teams List From Topic
    [Documentation]    Get all teams information in a list of test topic with API.
    Variable Should Exist    ${gTest topic}    Variable which stores test topic name does not exist, please execute test case "Topic List" to get it.
    ${Teams list}=    Get All Teams Information From Topic By API    ${gTest topic}
    : FOR    ${Each team}    IN    @{Teams list}
    \    Log List    ${Each team}
    \    ${Team name}    Get From Dictionary    ${Each team}    name
    \    Log    ${Team name}

Check If User Attends a Topic
    [Documentation]    Check if user is an attendee in test topic with API.
    Variable Should Exist    ${gTest topic}    Variable which stores test topic name does not exist, please execute test case "Topic List" to get it.
    Check If User Attends a Topic By API    ${gTest topic}    t1

Get Remaining Time Of Topic
    [Documentation]    Get ramining time of test topic with API.
    Variable Should Exist    ${gTest topic}    Variable which stores test topic name does not exist, please execute test case "Topic List" to get it.
    ${Time in sec}=    Get Remaining Time Of Topic By API    ${gTest topic}
    Log    ${Time in sec}

Get Team Information From Topic
    [Documentation]    Get specific team information of test topic with API.
    Variable Should Exist    ${gTest topic}    Variable which stores test topic name does not exist, please execute test case "Topic List" to get it.
    ${My team info}=    Get Team Information From Topic By API    ${gTest topic}    t1
    Log Dictionary    ${My team info}

Get Notifications Messages Of An User
    [Documentation]    Get an user's all notification messages with API.
    ${Msg list}=    Get Notification Messages Of A User By API    t1
    : FOR    ${Each msg}    IN    @{Msg list}
    \    Log Dictionary    ${Each msg}
    \    ${Msg}=    Get From Dictionary    ${Each msg}    content

Get Join Condition For A Topic
    [Documentation]    Get the join condition of test topic by API.
    Variable Should Exist    ${gTest topic}    Variable which stores test topic name does not exist, please execute test case "Topic List" to get it.
    ${Condition}=    Get Join Condition For A Topic By API    ${gTest topic}
    Log List    ${Condition}

Check If Team Is Invited Into Topic
    Variable Should Exist    ${gTest topic}    Variable which stores test topic name does not exist, please execute test case "Topic List" to get it.
    Check If Team Can Be Invited Into Topic By API    ${gTest topic}    Admin    t1

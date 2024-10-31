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
--- TeamUp ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- TeamUp ---
    [Teardown]    No Operation

Initial Team Up Status Should Show Correct
    [Documentation]    Initial team up status should correct, including myteam page, get_request page and sent_request page.
    [Tags]    TeamUp    TeamUp_1
    ${File name}=    Set Variable    teamup
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    Check Initial Team Up State    ${gTopic ID Now}    ${gTest account}

Input Empty Message To Change Team Name Should Trigger Error
    [Documentation]    Input empty message to change team name will trigger error 'Please fill out this field.'
    [Tags]    TeamUp    TeamUp_2
    ${File name}=    Set Variable    teamup
    Import Existed Topic    ${File name}    pri_team_reg_AOI
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    請填寫這個欄位
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    請填寫此欄位
    Change Team Name And Expect Error    ${gTopic ID Now}    ${EMPTY}    ${Expected msg}

Invite Invalid User To Team Up And Failed
    [Documentation]    Invite inexistent user and unregistered user to team up and failed.
    [Tags]    TeamUp    TeamUp_3
    ${File name}=    Set Variable    teamup
    Import Existed Topic    ${File name}    pri_team_reg_AOI
    # Invite inexistent user to team up
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=Team_not_exist    Contain team=no    Input type=id
    # Invite exist but unregistered user to team up
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=no    Input type=id
    Logout OCAIP
    # Sending invitation is case insensitive in this version.
    # t2 sign up issue
    # Login To OCAIP    ${gTest first account}    ${gTest first password}    Login status=common    Open browser=false
    # ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    # Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    # t2 invite exist and registered user(t1) but with capital team name(T1)
    # Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=T1    Contain team=no    Input type=id

Invite Invalid Teams By Pressing Invite Button Before Disabled
    [Documentation]    First input valid team name, then quickly press any key (makes the input team name invalid) and click submit button, page should show alert.
    ...    - ex: Type 't2'(valid team name) to the search field, then press 'a' (making the input team name invalid) and click the submit button almost at the same time (before the button automatically disabled), then page should show alert.
    ...    - ex: Type 't2'(valid team name) to the search field, then press 'backspace'(making the input team name invalid) and click the submit button almost at the same time (before the button automatically disabled), then page should show alert. (but it shows inviting succeed to 't1')
    [Tags]    TeamUp    TeamUp_4
    ${File name}=    Set Variable    teamup
    #Import Existed Topic    ${File name}    pri_team_reg_AOI
    #Logout OCAIP
    ## t2 sign up issue
    #Login To OCAIP    ${gTest first account}    ${gTest first password}    Login status=common    Open browser=false
    #${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    #Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    #Logout OCAIP
    ## t1 press invite button before disabled
    #Login To OCAIP    ${gTest account}    ${gTest password}    Login status=common    Open browser=false
    #Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=組隊
    #Wait Until Element Is Visible    id=search_team
    ## Input valid team name
    #Input Text    id=search_team    t2
    ## Type other characters to make the input team name invalid
    #Set Selenium Speed    0s
    #Press Keys    id=search_team    \\97
    #Click Element    //input[@id="sent_merge_team_btn"]
    #Wait Until Page Contains    此隊名可能已被更改而不存在，請重新再試!
    #Sleep    2s
    ## Input valid team name
    #Set Selenium Speed    0.3s
    #Input text    id=search_team    t2
    ## Press backspace to make the input team name invalid
    #Set Selenium Speed    0s
    #Press Keys    id=search_team    \\8
    #Click Element    //input[@id="sent_merge_team_btn"]
    #Wait Until Page Contains    不得邀請自己的隊伍

Invite Myself To Team Up And Failed
    [Documentation]    Invite myself to team up and failed.
    ...    - ex : t1 invites t1
    [Tags]    TeamUp    TeamUp_5
    ${File name}=    Set Variable    teamup
    Import Existed Topic    ${File name}    pri_team_reg_AOI
    # t1 invites t1 and failed
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t1    Contain team=no    Input type=id
    # t1 invites T1 and failed
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=T1    Contain team=no    Input type=id

Invite Single User To Team Up And Cancel Before Reply
    [Documentation]    Invite single user (not team up yet) to team up and cancel invitation before replied.
    ...    - ex : t1 invites t2, and t1 cancels the invitation before t2 accepts or rejects.
    [Tags]    TeamUp    TeamUp_6
    ${File name}=    Set Variable    teamup
    Import Existed Topic    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t1 sign up issue and invite t2 to team up
    Login To OCAIP    ${gTest account}    ${gTest password}    Login status=common    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    # t1 tries to invite t2 again before t2 replies and failed
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=no    Input type=id
    # t1 cancel invitation to t2
    Cancel Team Request    ${gTopic ID Now}    Invite team=t2    Input type=id
    Logout OCAIP
    # Check t2's invitation record show correctly or not
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Login status=common    Open browser=false
    Check Receive Record    ${gTopic ID Now}    Request team=t1    Status=cancel    Input type=id

Invite Single User To Team Up And Reject
    [Documentation]    Invite single user to team up and reject.
    ...    - ex : t1 invites t2 (t2 not team up yet) to team up, and t2 rejects t1's invitation
    [Tags]    TeamUp    TeamUp_7
    ${File name}=    Set Variable    teamup
    Import Existed Topic    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t1 sign up issue and invite t2 to team up
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 reject t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=reject    Input type=id
    Logout OCAIP
    # Check t1's invitation record show correctly or not
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=t2    Status=reject    Input type=id

Invite A Team To Team Up And Reject
    [Documentation]    Invite a team to team up and reject.
    ...    - ex : t1 invites "Team_t2t3" to team up, and Team_t2t3's team leader t2 rejects t1's invitation
    [Tags]    TeamUp    TeamUp_8
    ${File name}=    Set Variable    teamup
    Import Existed Topic    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # t3 sign up issue
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t2 sign up issue, change team name and invite t3 to team up
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA2}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA2}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=Team_t2t3    Expect msg=隊名更改成功!    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    Logout OCAIP
    # t3 accept t2's invitation
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=Team_t2t3    Request leader=t2    Operation=accept    Input type=id
    Logout OCAIP
    # t1 sign up issue, change team name and invite t2t3's team to team up
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=Team_t1t2t3    Expect msg=隊名更改成功!    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=Team_t2t3    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 reject t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=Team_t1t2t3    Request leader=t1    Operation=reject    Input type=id
    Logout OCAIP
    # Check t1's invitation record show correctly or not
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=Team_t2t3    Status=reject    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Invite Single User To Team Up
    [Documentation]    Invite single user to team up and succeed.
    ...    - ex : t2 changes team name to "Team_t2t3", invites t3 to team up, and t3 accepts t2's invitation to join Team_t2t3
    [Tags]    TeamUp    TeamUp_9
    ${File name}=    Set Variable    teamup_2
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    # t3 sign up issue
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    # sign in t2 to invite t3
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=Team_t2t3    Expect msg=隊名更改成功!    Input type=id
    # sign in t3 to accept t2's request
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=Team_t2t3    Request leader=t2    Operation=accept    Input type=id
    # check record is correct or not
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=t3    Status=accept    Input type=id

Invite A Team To Team Up
    [Documentation]    Invite a team to team up and succeed.
    ...    - ex : t1 changes team name to "Team_t1t2t3", invites "Team_t2t3" to team up, and Team_t2t3's team leader t2 accepts t1's invitation to join Team_t1t2t3
    [Tags]    TeamUp    TeamUp_10
    ${File name}=    Set Variable    teamup_2
    Import Existed Topic    ${File name}
    # Team_t1t2t3 invite Team_t2t3
    ${Team name}=    Set Variable    Team_t1t2t3
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=${Team name}    Expect msg=隊名更改成功!
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=Team_t2t3    Contain team=yes    Input type=id
    # sign in t2 to accept Team_t1t2t3's request
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=${Team name}    Request leader=t1    Operation=accept    Input type=id
    # check record is correct or not
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=Team_t2t3    Status=accept    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Change Team Name
    [Tags]    TeamUp    TeamUp_11
    ${File name}=    Set Variable    teamup_3
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    # t1 change team name to 't2'
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=t2    Expect msg=隊名更改成功!    Input type=id
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    # check t2's team name, should be t2_2
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=組隊
    Page Should Contain Element    //input[@id="team_name" and @value="${gTest first account}_2"]
    # t2 tries to change team name to t2 and failed
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=t2    Expect msg=隊名更改失敗，此隊名已存在，請重新再試!    Input type=id
    # t2 tries to change team name to 't1' and succeed
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=t1    Expect msg=隊名更改成功!    Input type=id

Assign User To Leader
    [Documentation]    Check if assign leader function runs correctly.
    ...    - ex : t1 invites t2 to team up, and assign t2 to be the team leader
    [Tags]    TeamUp    TeamUp_12
    ${File name}=    Set Variable    teamup_3
    Import Existed Topic    ${File name}
    # Invite t2 to team up
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t1    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 accept Team_t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t2    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    # t1 assign t2 to leader
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    ${Next leader}=    Set Variable    t2
    Assign Leader    ${gTopic ID Now}    ${Next leader}    Input type=id
    Logout OCAIP
    # sign up to t2 and check the result is correct or not
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=組隊
    Page Should Contain Element    //div[contains(@class,"team_member_list")]/div/h6[text()="${Next leader}"]/../../div[contains(@class,"iam_leader")]
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Autocomplete Should Work
    [Documentation]    Check If autocomplete function is correct or not
    ...    - ex1: t1 sign up issue and input 't' to invite form then autocomplete show 't1'
    ...    - ex2: t1,t2 sign up issue and input 't' to invite form then autocomplete show 't1' and 't2'
    ...    - ex3: t1,t2,t3 sign up issue and input 't' to invite form then autocomplete show 't1' , 't2' and 't3'
    ...    - ex3: t1,t2,t3 sign up issue and change t3 to t32, then input '2' to invite form the autocomplete show 't2' and 't32'
    [Tags]    TeamUp    TeamUp_13
    ${File name}=    Set Variable    teamup_4
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    # autocomplete should show t1
    Check Team Up Autocomplete    ${gTopic ID Now}    Input text=t    Expect Length=1    Expect teams=t1
    Logout OCAIP
    # autocomplete should show t1,t2
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Check Team Up Autocomplete    ${gTopic ID Now}    Input text=t    Expect Length=2    Expect teams=t1 t2
    Logout OCAIP
    # autocomplete should show t1,t2,t3
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Check Team Up Autocomplete    ${gTopic ID Now}    Input text=t    Expect Length=3    Expect teams=t1 t2 t3
    # autocomplete should show t2, t32
    Change Team Name And Expect Error    ${gTopic ID Now}    t32    隊名更改成功!
    Check Team Up Autocomplete    ${gTopic ID Now}    Input text=2    Expect Length=2    Expect teams=t2 t32

Change Team Name After Inviting Other Teams To Team Up
    [Documentation]    Change team name after inviting other teams to team up, and other teams' receive record should show the invite team's new team name.
    ...    - ex: t1 invites t2 to team up and then change team name to t1_change, then t2's receive record should show t1's new team name 't1_change'.
    [Tags]    TeamUp    TeamUp_14
    ${File name}=    Set Variable    teamup_4
    Import Existed Topic    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t1 invites t2 to team up
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=t1_change    Expect msg=隊名更改成功!    Input type=id
    Logout OCAIP
    # Check if t2's receive record shows t1's new team name
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Receive Record    ${gTopic ID Now}    Request team=t1_change    Status=wait    Input type=id

Change Team Name After Receiving Invitations From Other Teams
    [Documentation]    Change team name after receiving invitations from other teams, and other teams' request record should show it's old team name.
    ...    - ex: t2 was invited by t1, then t2 change team name to t2_change, and t1's request record should show t2's old team name 't2'.
    [Tags]    TeamUp    TeamUp_15
    ${File name}=    Set Variable    teamup_4
    Import Existed Topic    ${File name}
    Logout OCAIP
    # t2 change team name
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=t2_change    Expect msg=隊名更改成功!    Input type=id
    Logout OCAIP
    # Check if t1's request record shows t2's old team name
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Go To Topic    ${gTopic ID Now}    Input type=id    Tablist=組隊
    Click Element    //label[@for="sent_request-ctrl"]
    Page Should Contain Element    //div[@class="sent_request_list"]//h6[text()="t2"]
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Cancellation And Rejection Between Two Teams Won't Affect Other Invitations
    [Documentation]    Cancelling or rejecting one team's invitation won't affect the invitation with other teams.
    ...    - ex: t1 cancels the invitation to t2 or t2 rejects the invitation from t1 will not affect the invitation between t2 and t3.
    [Tags]    TeamUp    TeamUp_16
    ${File name}=    Set Variable    teamup_5
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t1 invites t2 to team up
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Logout OCAIP
    # t3 signs up issue and invites t2 to team up
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Logout OCAIP
    # t1 cancels the invitation to t2
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Cancel Team Request    ${gTopic ID Now}    Invite team=t2    Input type=id
    Logout OCAIP
    # Check if invitation between t2 and t3 shows correctly
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Check Receive Record    ${gTopic ID Now}    Request team=t1    Status=cancel    Input type=id
    Check Receive Record    ${gTopic ID Now}    Request team=t3    Status=wait    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=t2    Status=wait    Input type=id
    Logout OCAIP
    # t1 invites t2 again
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 rejects t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=reject    Input type=id
    # Check if invitation between t2 and t3 shows correctly
    Check Receive Record    ${gTopic ID Now}    Request team=t3    Status=wait    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=t2    Status=wait    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Multiple Users Send Invitations And Some Automatically Canceled
    [Documentation]    Multiple users send team up invitations to each other and page should show correctly after replied.
    ...    - ex : t1 invites t2, t2 invites t3, then t2 accepts t1's invitation, and t2's invitation to t3 would be canceled automatically (if t3 replies t2's invitation after t2 accetps t1's invitation but before refreshing the page, page will show alert that the invitation was not existed anymore).
    [Tags]    TeamUp    TeamUp_17
    ${File name}=    Set Variable    teamup_6
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=true
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t3 sign up issue
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t1 invites t2 to team up
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 invites t3 to team up
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    # t3 check t2's invitation
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=true
    Check Receive Record    ${gTopic ID Now}    Request team=t2    Status=wait    Input type=id
    # t2 accepts t1's invitation
    Switch Browser    2
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    # t3 replies t2's invitation before refreshing the page
    Switch Browser    3
    Click Element    //div[@class="get_request_list"]/div/h6[text()="t2"]/../../div/button[text()="接受"]
    Wait Until Element Is Visible    //div[@id="agree"]/div/div/div/button[text()="我知道了"]
    Page Should Contain Element    //div[@id="agree"]/div/div/div/h4[text()="無法併隊"]
    Page Should Contain Element    //div[@id="agree"]/div/div/div/button[@id="understand_alert"]
    Click Element    //div[@id="agree"]/div/div/div/button[text()="我知道了"]
    Sleep    0.5s
    Page Should Not Contain Element    //div[@class="team_member_list"]//h6[text()="t2"]
    Close Browser
    # t3's page should't show t2's invitation
    Switch Browser    2
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Check Receive Record    ${gTopic ID Now}    Request team=t2    Status=cancel    Input type=id
    Logout OCAIP
    # t1's page should show t2 to be the team member
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=t2    Status=accept    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Multiple Users Send Invitations And Showed Team Merged
    [Documentation]    Multiple users send invitations to each other and if someone accepts invitation, others invitation record will show 'merged'.
    ...    - ex : t1 and t3 both invite t2, and t2 accepts t1's invitation, then t1's request record will show t2 accept and t3's request record will show t2 was merged.
    [Tags]    TeamUp    TeamUp_18
    ${File name}=    Set Variable    teamup_7
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    # t1 sign up issue
    Go To Topic    ${gTopic ID Now}    Input type=id
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t2 sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t1 invites t2 to team up
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Logout OCAIP
    # t3 signs up issue and invites t2 to team up
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Logout OCAIP
    # t2 accepts t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    # t3 check request record
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=t2    Status=merged    Input type=id
    Logout OCAIP
    # t1 check request record
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Check Request Record    ${gTopic ID Now}    Invite team=t2    Status=accept    Input type=id
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Multiple Users Send Invitations And Showed Team Request No Exist Without Refresh Page
    [Tags]    TeamUp    TeamUp_19
    ${File name}=    Set Variable    teamup_8
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    # open other user window
    Login To OCAIP    ${gTest first account}    ${gTest first password}    # window2
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    # window3
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t1    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    # switch to t1 and invite t2 and t3
    Switch Browser    1
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    # switch to t2 and invite t1 and t3
    Switch Browser    2
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t1    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    Click Element    //a[@href="#topic-team" and text()="組隊"]
    Click Element    //label[@for="get_request-ctrl"]
    Page Should Contain Element    //div[@class="get_request_list"]//h6[text()="t3"]
    # t3 accept t1 and switch to t2,and check if the t2 press acept t1 button will show no request exist ot not
    Switch Browser    3
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Switch Browser    2
    # Verify the behavior is correct or not
    Click Element    //div[@class="get_request_list"]/div/h6[text()="t3"]/../../div/button[text()="接受"]
    Page Should Contain    邀請不存在(該隊伍可能取消邀請或被其他隊伍併走)!
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Team Member Reached Maximum Capacity
    [Documentation]    If the number of team member already reached maximum capacity and other teams still try to accept the invitation from this team, page should show alert '此隊伍已超過人數上限'. (developing)
    [Tags]    TeamUp    TeamUp_20
    ${File name}=    Set Variable    teamup_9
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    Logout OCAIP
    # other user sign up issue
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account5}    ${gTest semiadmin password5}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account3}    ${gTest semiadmin password3}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account4}    ${gTest semiadmin password4}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Logout OCAIP
    # t1 send invitation to other teams
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=u5    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=u3    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=u4    Contain team=yes    Input type=id
    Logout OCAIP
    # Other teams accept t1's invitation
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account5}    ${gTest semiadmin password5}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account3}    ${gTest semiadmin password3}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    # t1's team reach to limit
    Logout OCAIP
    Login To OCAIP    ${gTest semiadmin account4}    ${gTest semiadmin password4}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=exceed    Input type=id
    # Other teams invite t1's team
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t1    Contain team=yes    Input type=id    Status=exceed
    Logout OCAIP
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Sign Up 50/100/200 Members And Check Show Correctly
    [Documentation]    sign up 50/100/200 members and check show correctly
    [Tags]    TeamUp    TeamUp_21    Stress
    ${File name}=    Set Variable    teamup_10
    Create Topic With Argument    ${File name}    news_ntu_2stages    Operation=nosign
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50    Expect=50
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65 t66 t67 t68 t69 t70 t71 t72 t73 t74 t75 t76 t77 t78 t79 t80 t81 t82 t83 t84 t85 t86 t87 t88 t89 t90 t91 t92 t93 t94 t95 t96 t97 t98 t99 t100    Expect=100
    Multiple Sign Up    ${gTopic ID Now}    Input type=id    Members=tb1 tb2 tb3 tb4 tb5 tb6 tb7 tb8 tb9 tb10 tb11 tb12 tb13 tb14 tb15 tb16 tb17 tb18 tb19 tb20 tb21 tb22 tb23 tb24 tb25 tb26 tb27 tb28 tb29 tb30 tb31 tb32 tb33 tb34 tb35 tb36 tb37 tb38 tb39 tb40 tb41 tb42 tb43 tb44 tb45 tb46 tb47 tb48 tb49 tb50 tb51 tb52 tb53 tb54 tb55 tb56 tb57 tb58 tb59 tb60 tb61 tb62 tb63 tb64 tb65 tb66 tb67 tb68 tb69 tb70 tb71 tb72 tb73 tb74 tb75 tb76 tb77 tb78 tb79 tb80 tb81 tb82 tb83 tb84 tb85 tb86 tb87 tb88 tb89 tb90 tb91 tb92 tb93 tb94 tb95 tb96 tb97 tb98 tb99 tb100    Expect=200
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t2    Contain team=yes    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t3    Contain team=yes    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest first account}    ${gTest first password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest normal account}    ${gTest normal password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Go To Topic    ${gTopic ID Now}    Input type=id
    ${signed}=    Get Text    //div[@id='countdown']//h2
    Should Be Equal    ${signed}    200 / 198
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

--- Notification ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Notification ---
    [Teardown]    No Operation

Check Bell Basic Information
    [Documentation]    Click the bell icon should show the expected message
    [Tags]    Notification    Notification_1
    Check Bell Message    Message=${EMPTY}    Notify=No

Send Invitation And The Bell Message Should Show Correct
    [Tags]    Notification    Notification_TeamUp_1
    ${File name}=    Set Variable    notification_1
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    # t5 sign up issue
    Logout OCAIP
    Login To OCAIP    ${gTest account5}    ${gTest password}
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    # t1 sign up issue and invite t5 to team up
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t5    Contain team=yes    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest account5}    ${gTest password}    Open browser=false
    Sleep    0.5s
    Check Bell Message    Message=隊伍 「t1」 向您提出組隊邀請！    Notify=Yes
    [Teardown]    Run Keywords    Compatibility Teardown

Accept Inviattion And The Bell Message Should Show Correct
    [Tags]    Notification    Notification_TeamUp_2
    [Setup]    Login To OCAIP    ${gTest account5}    ${gTest password}
    ${File name}=    Set Variable    notification_1
    Import Existed Topic    ${File name}
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t1    Request leader=t1    Operation=accept    Input type=id
    Refresh Page
    Check Bell Message    Message=「t5」 接受了 「t1」 的組隊邀請，隊伍合併成功!    Notify=Yes
    # login to t1 to check bell message
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}    Login status=common    Open browser=false
    Check Bell Message    Message=「t5」 接受了 「t1」 的組隊邀請，隊伍合併成功!    Notify=Yes

Change Team Name And The Bell Message Should Show Correct
    [Tags]    Notification    Notification_TeamUp_3
    ${File name}=    Set Variable    notification_1
    Import Existed Topic    ${File name}
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=TFT    Expect msg=隊名更改成功!    Input type=id
    Check Bell Message    Message=您的隊伍有新的名稱 「TFT」！    Notify=Yes
    # check t5's notification
    Logout OCAIP
    Login To OCAIP    ${gTest account5}    ${gTest password}    Open browser=false
    Check Bell Message    Message=您的隊伍有新的名稱 「TFT」！    Notify=Yes

Change Leader And The Bell Message Should Show Correct
    [Tags]    Notification    Notification_TeamUp_4
    # t1 assign t5 to leader
    ${File name}=    Set Variable    notification_1
    Import Existed Topic    ${File name}
    Assign Leader    ${gTopic ID Now}    t5    Input type=id
    Refresh Page
    Check Bell Message    Message=您的隊伍現在有新的隊長 「t5」！    Notify=Yes
    # check t5's notification
    Logout OCAIP
    Login To OCAIP    ${gTest account5}    ${gTest password}    Open browser=false
    Check Bell Message    Message=您的隊伍現在有新的隊長 「t5」！    Notify=Yes
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Multiple Bell Message Should Show Correct
    [Tags]    Notification    Notification_TeamUp_5
    [Setup]    Login To OCAIP    ${gTest account4}    ${gTest password}
    ${File name}=    Set Variable    notification_2
    Create Topic With Argument    ${File name}    pri_team_reg_AOI
    # t4 initial bell num
    Click Element    //div[@id="svg_bell"]
    # t1 sign up issue
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Click Element    //div[@id="svg_bell"]
    # t4 sign up issue and invite t1 to team up
    Logout OCAIP
    Login To OCAIP    ${gTest account4}    ${gTest password}    Open browser=false
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    "${signed NDA}"=="False"    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Send Invitation To Team Up And Expect Error    ${gTopic ID Now}    Invite team=t1    Contain team=yes    Input type=id
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    # t1 accept invitation
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Reply Team Up Invitation    ${gTopic ID Now}    Request team=t4    Request leader=t4    Operation=accept    Input type=id
    # t4 change TeamName
    Logout OCAIP
    Login To OCAIP    ${gTest account4}    ${gTest password}    Open browser=false
    Change Team Name And Expect Error    ${gTopic ID Now}    Team name=TFT    Expect msg=隊名更改成功!    Input type=id
    # check t4's notification
    Page Should Contain Element    //span[@id="notify_counter"]
    Wait Until Keyword Succeeds    10 secs    1 secs    Element Should Contain    //span[@id="notify_counter"]    2
    # check t1's notification
    Logout OCAIP
    Login To OCAIP    ${gTest account}    ${gTest password}    Open browser=false
    Page Should Contain Element    //span[@id="notify_counter"]
    Wait Until Keyword Succeeds    10 secs    1 secs    Element Should Contain    //span[@id="notify_counter"]    3
    Log    -- developing ---
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

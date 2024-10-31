*** Settings ***
Suite Setup       Suite Setup
Suite Teardown    Suite Teardown
Test Setup        CLI Login
Test Teardown     Run Keywords    Compatibility Teardown    AND    Remove File    ~${/}.aidea${/}config.txt
Library           SeleniumLibrary    30    3    run_on_failure=None
Resource          ./Keywords/OCAIP_Keywords.txt
Resource          ./Variables/OCAIP_Variables.txt
Library           OperatingSystem
Library           Process
Library           DateTime
Library           Dialogs

*** Test Cases ***
--- CLI ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- CLI ---
    [Teardown]    No Operation

Check CLI Login
    [Documentation]    Check CLI login
    [Tags]    CLI    CLI_1
    [Setup]    No Operation
    CLI Login

Check CLI List
    [Documentation]    Check CLI list
    [Tags]    CLI    CLI_2
    ${File name}=    Set Variable    CLI
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    ${output}=    Run    aidea topics list
    Should Contain    ${output}    ${gTopic ID Now}

Check CLI Files And Download
    [Documentation]    Check CLI list files and download them
    [Tags]    CLI    CLI_3
    Login To OCAIP
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${File name}=    Set Variable    CLI
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${output}=    Run    aidea topics files -t ${gTopic ID Now}
    Should Contain    ${output}    test_images_data.zip
    # Bug? It will error 503 without sleep
    Sleep    1s
    ${rc}    ${output}=    Run And Return RC And Output    cd ${gTemp folder path} && aidea topics download -t ${gTopic ID Now}
    Should Be Equal As Integers    ${rc}    0
    File Should Exist    ${gTemp folder path}${/}train_images_data.zip
    File Should Exist    ${gTemp folder path}${/}test_images_data.zip

Check CLI Submit
    [Documentation]    Check CLI submit
    [Tags]    CLI    CLI_4
    Login To OCAIP
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${File name}=    Set Variable    CLI
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${Upload file}=    Set Variable    ${gTest data path AOI}${/}Correct_File${/}pri_0.5_pub_0.7.csv
    ${output}=    Run    aidea topics submit -t ${gTopic ID Now} -f ${Upload file}
    Should Contain    ${output}    Submit file OK
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=public    Expect score1=0.7
    Change Topic Date    ${gTopic ID Now}    Operation=END_TOPIC
    Check Upload Score Is Correct    ${gTopic ID Now}    Input type=id    Board type=private    Expect score1=0.5

Check CLI Login With Wrong Password
    [Documentation]    Check CLI login with wrong password
    [Tags]    CLI    CLI_5
    [Setup]    No Operation
    Run Keyword And Expect Error    STARTS: ta1 login failed    CLI Login    CLI Account=ta1
    Run Keyword And Expect Error    STARTS: ${gTest account} login failed    CLI Login    CLI Password=123
    Run Keyword And Expect Error    STARTS: ta1 login failed    CLI Login    CLI Account=ta1    CLI Password=123

Check CLI All Topic Commands Without Login
    [Documentation]    Check CLI all topic commands without login
    [Tags]    CLI    CLI_6
    [Setup]    No Operation
    ${File name}=    Set Variable    CLI_2
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Operation=nosign
    ${output}=    Run    aidea topics list
    Should Contain    ${output}    Please login first
    ${output}=    Run    aidea topics files -t ${gTopic ID Now}
    Should Contain    ${output}    Please login first
    ${output}=    Run    aidea topics download -t ${gTopic ID Now}
    Should Contain    ${output}    Please login first
    ${Upload file}=    Set Variable    ${gTest data path AOI}${/}Correct_File${/}pri_0.5_pub_0.7.csv
    ${output}=    Run    aidea topics submit -t ${gTopic ID Now} -f ${Upload file}
    Should Contain    ${output}    Please login first

Check CLI All Topic Commands Without Signup
    [Documentation]    Check CLI all topic commands without signup
    [Tags]    CLI    CLI_7
    ${File name}=    Set Variable    CLI_2
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${output}=    Run    aidea topics files -t ${gTopic ID Now}
    Should Contain    ${output}    Your do not register the topic yet
    # Bug? It will error 503 without sleep
    Sleep    1s
    ${output}=    Run    aidea topics download -t ${gTopic ID Now}
    Should Contain    ${output}    Status code = 403
    # Bug? It will error 503 without sleep
    Sleep    1s
    ${Upload file}=    Set Variable    ${gTest data path AOI}${/}Correct_File${/}pri_0.5_pub_0.7.csv
    ${output}=    Run    aidea topics submit -t ${gTopic ID Now} -f ${Upload file}
    Should Contain    ${output}    Your do not register the topic yet

Check CLI All Topic Commands When Topic Ended
    [Documentation]    Check CLI all topic commands when topic ended
    [Tags]    CLI    CLI_8
    [Setup]    No Operation
    # Bug? It will error 503 without sleep
    Sleep    1s
    CLI Login
    ${File name}=    Set Variable    CLI
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    ${output}=    Run    aidea topics files -t ${gTopic ID Now}
    Should Contain    ${output}    Your do not register the topic yet
    # Bug? It will error 503 without sleep
    Sleep    1s
    ${output}=    Run    aidea topics download -t ${gTopic ID Now}
    Should Contain    ${output}    Status code = 403
    # Bug? It will error 503 without sleep
    Sleep    1s
    ${Upload file}=    Set Variable    ${gTest data path AOI}${/}Correct_File${/}pri_0.5_pub_0.7.csv
    ${output}=    Run    aidea topics submit -t ${gTopic ID Now} -f ${Upload file}
    Should Contain    ${output}    Your do not register the topic yet

Check CLI All Topic Commands Before Topic Starts
    [Documentation]    Check CLI all topic commands before topic starts
    [Tags]    CLI    CLI_9
    ${File name}=    Set Variable    CLI_3
    Create Topic With Argument    ${File name}    pri_single_reg_AOI    Date type=future    Operation=nosign
    ${output}=    Run    aidea topics files -t ${gTopic ID Future}
    Should Contain    ${output}    Your do not register the topic yet
    # Bug? It will error 503 without sleep
    Sleep    1s
    ${output}=    Run    aidea topics download -t ${gTopic ID Future}
    Should Contain    ${output}    Status code = 403
    # Bug? It will error 503 without sleep
    Sleep    1s
    ${Upload file}=    Set Variable    ${gTest data path AOI}${/}Correct_File${/}pri_0.5_pub_0.7.csv
    ${output}=    Run    aidea topics submit -t ${gTopic ID Future} -f ${Upload file}
    Should Contain    ${output}    Your do not register the topic yet

Check CLI Invalid Choice
    [Documentation]    Check CLI invalid choice
    [Tags]    CLI    CLI_10
    Login To OCAIP
    ${signed NDA}=    Run Keyword And Return Status    Check Upload Page Is Available    ${gTopic ID Now}    Input type=id
    Run Keyword If    ${signed NDA}==False    Sign Up to Sign NDA    ${gTopic ID Now}    Input type=id
    ${File name}=    Set Variable    CLI_2
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    # Argument error
    ${output}=    Run    aidea topic files -t ${gTopic ID Now}
    Should Contain    ${output}    invalid choice: 'topic'
    ${output}=    Run    aidea TOPICS files -t ${gTopic ID Now}
    Should Contain    ${output}    invalid choice: 'TOPICS'
    ${output}=    Run    aidea topics file -t ${gTopic ID Now}
    Should Contain    ${output}    invalid choice: 'file'
    ${output}=    Run    aidea topics FILES -t ${gTopic ID Now}
    Should Contain    ${output}    invalid choice: 'FILES'
    # Topic ID error
    ${output}=    Run    aidea topics files -t ${gTopic ID Now}a
    Should Contain    ${output}    Topic ID error
    # Path error
    ${Upload file}=    Set Variable    ${gTest data path AOI}${/}Correct_File${/}pri_0.5_pub_0.1.csv
    ${output}=    Run    aidea topics submit -t ${gTopic ID Now} -f ${Upload file}
    Should Contain    ${output}    "${Upload file}" does not exist

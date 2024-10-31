*** Settings ***
Library           SeleniumLibrary
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser

*** Variables ***
${URL}            http://v5lungct2.v5.com.tw/M1/login
${BROWSER}        chrome
${USERNAME}       Jimmy
${PASSWORD}       Jimmy
${LOGIN_XPATH}    /html/body/div/form/div[3]/div/div/span/button
${CHROMEDRIVER_PATH}    C:/Python27/chromedriver.exe

*** Test Cases ***
Login Test
    Login To Application    ${USERNAME}    ${PASSWORD}

Search Test
    Search Patient    LIDC-IDRI-1001

Click First Patient ID
    Click First Patient

Check Required Elements
    Check Elements

Navigate Menu
    Navigate To Menu    /html/body/div[1]/div/section/section/section/main/div/div[1]/div[3]    //li[@class='ant-select-dropdown-menu-item' and text()='Sales']

*** Keywords ***
Open Browser To Login Page
    [Documentation]    Open the browser to the login page
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --ignore-certificate-errors
    Open Browser    ${URL}    ${BROWSER}    options=${chrome_options}
    Maximize Browser Window

Login To Application
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    id=name
    Input Text    id=name    ${username}
    Input Text    id=password    ${password}
    Click Element    xpath=${LOGIN_XPATH}
    Sleep    1s

Search Patient
    [Arguments]    ${patient_id}
    Wait Until Element Is Visible    xpath=/html/body/div/div/section/section/section/main/div/div[1]/input
    Input Text    xpath=/html/body/div/div/section/section/section/main/div/div[1]/input    ${patient_id}
    Sleep    2s

Click First Patient
    Wait Until Element Is Visible    xpath=(//span[@class='span_patientID'])[1]
    Click Element    xpath=(//span[@class='span_patientID'])[1]
    Sleep    2s

Check Elements
    ${required_xpaths}=    Create List    //div[@class='ml-4']//div//*[name()='svg']    //h3[normalize-space()='Medical Viewer']    //button[@data-cy='WindowLevel-split-button-primary']//*[name()='svg']
    FOR    ${xpath}    IN    @{required_xpaths}
        Wait Until Element Is Visible    xpath=${xpath}    timeout=10s
        Log    ${xpath} exists
    END

Navigate To Menu
    [Arguments]    ${element_xpath}    ${item_xpath}
    Click Element    xpath=${element_xpath}
    Click Element    xpath=${item_xpath}

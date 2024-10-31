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
--- Login ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Login ---
    [Teardown]    No Operation

Login Correctly
    [Documentation]    Login with correct account and password.
    [Tags]    Login    Login_1
    [Setup]    No Operation
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Check User Profile    ${gTest account5}

Login With Wrong Password
    [Documentation]    Login with correct account and wrong password.
    [Tags]    Login    Login_2
    [Setup]    No Operation
    Login To OCAIP And Expect Error    ${gTest account5}    5566    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Wrong Account
    [Documentation]    Login with incorrect account and password.
    [Tags]    Login    Login_3
    [Setup]    No Operation
    Login To OCAIP And Expect Error    abc    123    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Other's Password
    [Documentation]    Login with account and others password.
    [Tags]    Login    Login_4
    [Setup]    No Operation
    Login To OCAIP And Expect Error    ${gTest account5}    p2    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Empty Password
    [Documentation]    Login with empty password.
    [Tags]    Login    Login_5
    [Setup]    No Operation
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    請填寫這個欄位
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    請填寫此欄位
    Login To OCAIP And Expect Error    ${gTest account5}    ${EMPTY}    Msg from where=password    Expected msg=${Expected msg}

Login with Blank Account
    [Documentation]    Login with only password. (account is empty)
    [Tags]    Login    Login_6
    [Setup]    No Operation
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    請填寫這個欄位
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    請填寫此欄位
    Login To OCAIP And Expect Error    ${EMPTY}    ${gTest password}    Msg from where=username    Expected msg=${Expected msg}

Login with Blank All
    [Documentation]    Login with empty account and password.
    [Tags]    Login    Login_7
    [Setup]    No Operation
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    請填寫這個欄位
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    請填寫此欄位
    Login To OCAIP And Expect Error    ${EMPTY}    ${EMPTY}    Msg from where=username    Expected msg=${Expected msg}

Login With Account Padding
    [Documentation]    Login with account with redundant character and correct password.
    [Tags]    Login    Login_8
    [Setup]    No Operation
    Login To OCAIP And Expect Error    ${gTest account5}123    ${gTest password}    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Password Padding
    [Documentation]    Login with account and password with redundant character.
    [Tags]    Login    Login_9
    [Setup]    No Operation
    Login To OCAIP And Expect Error    ${gTest account5}    ${gTest password}123    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login Fail With Long Account
    [Documentation]    Login with very long account and wrong password.
    [Tags]    Login    Login_10
    [Setup]    No Operation
    Login To OCAIP And Expect Error    123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890    p123    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login Fail With Long Password
    [Documentation]    Login with incorrect account and very long password.
    [Tags]    Login    Login_11
    [Setup]    No Operation
    Login To OCAIP And Expect Error    123    123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Invalid Account
    [Documentation]    Login with account with special chars and wrong password.
    [Tags]    Login    Login_12
    [Setup]    No Operation
    Login To OCAIP And Expect Error    abc*&/    p123    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Invalid Password
    [Documentation]    Login with incorrect account and wrong password with special chars.
    [Tags]    Login    Login_13
    [Setup]    No Operation
    Login To OCAIP And Expect Error    u2    /?=    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Code Injection Account
    [Documentation]    Login with account which executable command and random password.
    [Tags]    Login    Login_14
    [Setup]    No Operation
    Login To OCAIP And Expect Error    "><script>eval(console.log("here"))</script>    123    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Code Injection Password
    [Documentation]    Login with random account and password with executable command.
    [Tags]    Login    Login_15
    [Setup]    No Operation
    Login To OCAIP And Expect Error    abc    "><script>alert("WARNING!")</script>    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Uppercase Password
    [Documentation]    Login with account and uppercase password.
    [Tags]    Login    Login_16
    [Setup]    No Operation
    ${Uppercase password}=    Convert To Uppercase    ${gTest password}
    Login To OCAIP And Expect Error    ${gTest account5}    ${Uppercase password}    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試

Login With Uppercase Account
    [Documentation]    Login with uppercase account and password.
    [Tags]    Login    Login_17
    [Setup]    No Operation
    ${Uppercase account}=    Convert To Uppercase    ${gTest account5}
    Login To OCAIP    ${Uppercase account}    ${gTest password}
    Check User Profile    ${gTest account5}

Login Fail 5 Times In A Row
    [Documentation]    Login with wrong password 5 times and check IP blocked successfully
    [Tags]    Login    Login_18
    [Setup]    No Operation
    FOR    ${INDEX}    IN RANGE    1    6
        Login To OCAIP And Expect Error    ${gTest normal account}    123    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試    Open browser=true
        Run Keyword If    "${INDEX}" != "5"    Close Browser
    END
    Execute Javascript    document.elementFromPoint(0,0).click();
    #Prevent Auto Unblock by Login To OCAIP And Expect Error
    Input Username And Password    ${gTest normal account}    123
    Wait Until Page Contains Element    //div[@id="resend_email"]    timeout=3
    Go To Home Page
    ${Mail Domain}=    Split String    ${gTest mail account}    @
    Forget Password Request And Expect Result    ocaip.test+t2@${Mail Domain[1]}    common
    Open Resetpassword Page    ${gTest mail account}    ${gTest mail password}
    Wait Until Page Contains    重設密碼
    Fill In Reset Password Info    ${gTest password}    ${gTest password}
    Login To OCAIP    ${gTest normal account}    ${gTest password}
    #Clear all login fail mails
    Clear Mail Box    ${gTest mail account}    ${gTest mail password}    Sequence=all    Title=A

Login With Email
    [Documentation]    Login with email and password.
    [Tags]    Login    Login_19
    [Setup]    No Operation
    ${Mail Domain}=    Split String    ${gTest mail account}    @
    Login To OCAIP    ocaip.test+${gTest account5}@${Mail Domain[1]}    ${gTest password5}
    Check User Profile    ${gTest account5}

--- Register (Common)---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Register (Common) ---
    [Teardown]    No Operation

Register Without Recaptcha
    [Documentation]    Input correct email without signing recaptcha check box.
    [Tags]    Register    RegisterCommon_1
    [Setup]    Not Login
    Register A User Account And Expect Error    vip@gmail.com    common    Recaptcha flag=True

Register With Invalid Email
    [Documentation]    Input wrong format email without signing recaptcha check box.
    [Tags]    Register    RegisterCommon_2
    [Setup]    Not Login
    ${System}=    Evaluate    platform.system()    platform
    ${Expected msg}=    Set Variable    錯誤的電子郵件!
    Register A User Account And Expect Error    QAQ    common    Recaptcha flag=True    Expected msg=${Expected msg}

Register With Used Email
    [Documentation]    Input the already registered email without signing recaptcha check box.
    [Tags]    Register    RegisterCommon_3
    [Setup]    Not Login
    Register A User Account And Expect Error    ${gTest mail account}    common    Recaptcha flag=True    Expected msg=電子郵件已被使用過

Register With Blank Email
    [Documentation]    Submit without inputting email and signing recaptcha check box.
    [Tags]    Register    RegisterCommon_4
    [Setup]    Not Login
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    請填寫這個欄位
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    請填寫此欄位
    Register A User Account And Expect Error    ${EMPTY}    email    Recaptcha flag=False    Expected msg=${Expected msg}

Register With Dots Or Plus Signs
    [Documentation]    Input email with dot/plus signs and show already registered email
    [Tags]    Register    RegisterCommon_5
    [Setup]    Not Login
    ${Mail Domain}=    Split String    ${gTest mail account}    @
    Register A User Account And Expect Error    ocaip.t.e.s.t@${Mail Domain[1]}    common    Recaptcha flag=True    Expected msg=電子郵件已被使用過
    Not Login
    Register A User Account And Expect Error    ocaip.t.e.s.t@${Mail Domain[1]}    common    Recaptcha flag=True    Expected msg=電子郵件已被使用過    Sign Up type=business
    Not Login
    Register A User Account And Expect Error    ocaiptest+1@${Mail Domain[1]}    common    Recaptcha flag=True    Expected msg=電子郵件不得含+號字元
    Not Login
    Register A User Account And Expect Error    ocaiptest+1@${Mail Domain[1]}    common    Recaptcha flag=True    Expected msg=電子郵件不得含+號字元    Sign Up type=business

--- Register (business)---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Register (business) ---
    [Teardown]    No Operation

Register With Long Infomration (Business)
    [Documentation]    Open gmail and fill in the register infomration with long information to create a new account successfully.(business)
    [Tags]    Register    Register1    Register1_1
    [Setup]    Not Login
    # delete orginal user
    ${flag}    Run Keyword And Return Status    Login To OCAIP    ${gTest register account}    ${gTest mail password}
    Run Keyword If    "${flag}"=="True"    Delete Test User
    # change to first browser
    Switch Browser    1
    Sleep    1min
    Register A User Account And Expect Error    ${gTest mail account}    common    Recaptcha flag=True    Expected msg=${EMPTY}    Sign Up type=business
    #Log    recaptcha needs manual passed
    # fill the account information
    Open Registration Page    ${gTest mail account}    ${gTest mail password}
    Wait Until Page Contains    會員註冊
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    神秘力量研究所QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQ QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA
    ...    神秘力量研究所QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQ QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA    Msg from where=common    type=business
    Clear Mail Box    ${gTest mail account}    ${gTest mail password}    Title=註冊成功通知

Register With Valid Email (Business)
    [Documentation]    Input correct email and sign recaptcha check box to enter registration \ page successfully (business
    ...    ).
    [Tags]    Register    Register1    Register1_2
    [Setup]    Not Login
    # delete orginal user
    ${flag}    Run Keyword And Return Status    Login To OCAIP    ${gTest register account}    ${gTest mail password}
    Run Keyword If    "${flag}"=="True"    Delete Test User
    # change to first browser
    Switch Browser    1
    Comment    Sleep    1min
    Register A User Account And Expect Error    ${gTest mail account}    common    Recaptcha flag=True    Expected msg=${EMPTY}    Sign Up type=business
    #Log    recaptcha needs manual passed
    # go to register link
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    # check link is correct or not
    Page Should Not Contain    哎呀，你查看的頁面不存在了！

Register With Used Account (Business)
    [Documentation]    Enter registration page and enter user account that already exists, then the error shows correctly.(business)
    [Tags]    Register    Register1    Register1_3
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    ${Error msg}=    Set Variable    需為 4-20 個字元
    Wait Until Page Contains    會員註冊
    Input Text    id=account_field    ${gTest account5}
    Press Keys    id=account_field    TAB
    Wait Until Element Contains    id=account    ${Error msg}
    Input Text    id=account_field    ${gTest account5}12345123451234512345
    Press Keys    id=account_field    TAB
    Wait Until Element Contains    id=account    ${Error msg}
    ${Error msg}=    Set Variable    只能使用字母 數字或底線(_)
    Input Text    id=account_field    ${gTest account5}_!
    Press Keys    id=account_field    TAB
    Wait Until Element Contains    id=account    ${Error msg}
    Input Text    id=account_field    ${gTest account5}_
    Press Keys    id=account_field    TAB
    Wait Until Element Does Not Contain    id=account    ${Error msg}
    Input Text    id=account_field    ${gTest admin account}
    Press Keys    id=account_field    TAB
    Wait Until Element Contains    id=account    使用者已存在

Register With Blank Account (Business)
    [Documentation]    Enter registration page without inputting the user account information, then the error show correctly(business).
    [Tags]    Register    Register1    Register1_4
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${EMPTY}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    人資部    Msg from where=username    Expected msg=${Expected msg}    type=business

Register With Consistent Email (Business)
    [Documentation]    Enter registration page, check email field disabled ,and equal to register email(business).
    [Tags]    Register    Register1    Register1_5
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    Element Should Be Disabled    //input[@id="email_field"]
    ${email}=    Get Element Attribute    //input[@id="email_field"]    value
    Should Be Equal    ${gTest mail account}    ${email}

Register Without Last Name (Business)
    [Documentation]    Enter registration page without inputting the last name information, then the error show correctly(business).
    [Tags]    Register    Register1    Register1_6
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    ${EMPTY}    大    工研院
    ...    人資部    Msg from where=last_name    Expected msg=${Expected msg}    type=business

Register Without First Name (Business)
    [Documentation]    Enter registration page without inputting the first name information, then the error show correctly(business).
    [Tags]    Register    Register1    Register1_7
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    ${EMPTY}    工研院
    ...    人資部    Msg from where=first_name    Expected msg=${Expected msg}    type=business

Register Without Company (Business)
    [Documentation]    Enter registration page without inputing company information, then the error show correctly(business).
    [Tags]    Register    Register1    Register1_8
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    ${EMPTY}
    ...    人資部    Msg from where=company    Expected msg=${Expected msg}    type=business

Register Without Department (Business)
    [Documentation]    Enter registration page without inputting the department information, then the error show correctly(business).
    [Tags]    Register    Register1    Register1_9
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    ${EMPTY}    Msg from where=department    Expected msg=${Expected msg}    type=business

Register Without Phone Number (Business)
    [Documentation]    Enter registration page without inputting the phone information or wrong phone number format, then the error shows correctly(business).
    [Tags]    Register    Register1    Register1_10
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    User phone=${EMPTY}    Msg from where=phone    Expected msg=${Expected msg}    type=business
    ${Expected msg}=    Set Variable    請符合要求的格式
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    User phone=090000000a    Msg from where=    Expected msg=${Expected msg}    type=business
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    User phone=090000000!    Msg from where=    Expected msg=${Expected msg}    type=business

Register Without Password (Business)
    [Documentation]    Enter registration page without inputting the password information, then the error show correctly (business).
    [Tags]    Register    Register1    Register1_11
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${EMPTY}    ${gTest mail password}    天使    大    工研院
    ...    人資部    Msg from where=password    Expected msg=${Expected msg}    type=business

Register Without Confirmed Password (Business)
    [Documentation]    Enter registration page without inputting the confirm password information, then the error show correctly (business).
    [Tags]    Register    Register1    Register1_12
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    此欄位必須和密碼相同
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${EMPTY}    天使    大    工研院
    ...    人資部    Msg from where=common    Expected msg=${Expected msg}    type=business

Register Without Invalid Password (Business)
    [Documentation]    Enter registration page and input invalid length password and confirm password information, then the error show correctly (business).
    [Tags]    Register    Register1    Register1_13
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    必須介於8~20個字元
    Fill In Registration Info And Expect Error    ${gTest register account}    123    123    天使    大    工研院
    ...    人資部    Msg from where=common    Expected msg=${Expected msg}    type=business
    Fill In Registration Info And Expect Error    ${gTest register account}    012345678901234567891    012345678901234567891    天使    大    工研院
    ...    人資部    Msg from where=common    Expected msg=${Expected msg}    type=business
    Input Text    id=new_password    01234567
    Wait Until Element Contains    id=password_strength    密碼強度: 弱
    Input Text    id=new_password    01234567a
    Wait Until Element Contains    id=password_strength    密碼強度: 中
    Input Text    id=new_password    01234567a!
    Wait Until Element Contains    id=password_strength    密碼強度: 強

Register Without Inconsistent Password (Business)
    [Documentation]    Enter registration page and input different password and confirm password information, then the error show correctly(business).
    [Tags]    Register    Register1    Register1_14
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest long password}    天使    大    工研院
    ...    人資部    Msg from where=common    Expected msg=此欄位必須和密碼相同    type=business

Register Without Agreement (Business)
    [Documentation]    Enter registration page without check register agreement, then the error shows correctly(business).
    [Tags]    Register    Register1    Register1_15
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    如果你要繼續執行，請勾選這個核取方塊
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    Msg from where=agreement    Expected msg=${Expected msg}    type=business

Check FAQ Link (Business)
    [Documentation]    Enter registration page and click FAQ link, then the page shows correctly(business).
    [Tags]    Register    Register1    Register1_16
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    Click Element    //a[text()="我同意服務條款及隱私權政策"]
    Switch Window    locator=NEW
    Location Should Contain    ${gOCAIP URL}/faq

Register Without Tax Number (Business)
    [Documentation]    Enter registration page without inputting the tax information or wrong tax number format, then the error shows correctly(business).
    [Tags]    Register    Register1    Register1_17
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    Tax number=${EMPTY}    Msg from where=tax    Expected msg=${Expected msg}    type=business
    ${Expected msg}=    Set Variable    查無此統一編號
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    Tax number=aaaaaaaa    Msg from where=alert    Expected msg=${Expected msg}    type=business
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    Tax number=0000000    Msg from where=alert    Expected msg=${Expected msg}    type=business

Register Successfully (Business)
    [Documentation]    Open gmail and fill in the register infomration to create a new account successfully.(business)
    [Tags]    Register    Register1    Register1_18
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    工研院
    ...    人資部    Msg from where=common    type=business
    Clear Mail Box    ${gTest mail account}    ${gTest mail password}    Title=註冊成功通知

Check Old Register Link (Business)
    [Documentation]    Open gmail and click old register link, then the page will show correctly.(business)
    [Tags]    Register    Register1    Register1_19
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}
    Sleep    2s
    Page Should Contain    此連結已超過使用次數

--- Register (Academic)---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- Register (Academic)---
    [Teardown]    No Operation

Register With Long Infomration (Academic)
    [Documentation]    Open gmail and fill in the register information with long information to create a new account successfully.(academic)
    [Tags]    Register    Register2    Register2_1
    [Setup]    Not Login
    # check utest is exist or not delete orginal user
    ${flag}    Run Keyword And Return Status    Login To OCAIP    ${gTest register account}    ${gTest mail password}
    Run Keyword If    "${flag}"=="True"    Delete Test User
    # change to first browser
    Switch Browser    1
    Sleep    1min
    Register A User Account And Expect Error    ${gTest mail account}    common    Recaptcha flag=True    Expected msg=${EMPTY}
    #Log    recaptcha needs manual passed
    # fill basic information and create account
    Open Registration Page    ${gTest mail account}    ${gTest mail password}
    Wait Until Page Contains    會員註冊
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    User department=神秘力量研究所QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQ QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA QAQAQAQAQAQAQAQAQAQAQAQAQAQAQAQQAQAQAQAQAQQAQAQAQQAQA
    ...    Msg from where=common
    Clear Mail Box    ${gTest mail account}    ${gTest mail password}    Title=註冊成功通知

Register With Valid Email (Academic)
    [Documentation]    Input correct email and sign recaptcha check box to enter registration page successfully (academic).
    [Tags]    Register    Register2    Register2_2
    [Setup]    Not Login
    #Delete Test User
    # check utest is exist or not delete orginal user
    ${flag}    Run Keyword And Return Status    Login To OCAIP    ${gTest register account}    ${gTest mail password}
    Run Keyword If    "${flag}"=="True"    Delete Test User
    # change to first browser
    Switch Browser    1
    Register A User Account And Expect Error    ${gTest mail account}    common    Recaptcha flag=True    Expected msg=${EMPTY}
    #Log    recaptcha needs manual passed
    # go to register link
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    # check link is correct or not
    Page Should Not Contain    哎呀，你查看的頁面不存在了！

Register With Used Account (Academic)
    [Documentation]    Enter registration page and enter user account that already exists, then the error shows correctly.(academic)
    [Tags]    Register    Register2    Register2_3
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    ${Error msg}=    Set Variable    需為 4-20 個字元
    Wait Until Page Contains    會員註冊
    Input Text    id=account_field    ${gTest account5}
    Press Keys    id=account_field    TAB
    Wait Until Element Contains    id=account    ${Error msg}
    Input Text    id=account_field    ${gTest account5}12345123451234512345
    Press Keys    id=account_field    TAB
    Wait Until Element Contains    id=account    ${Error msg}
    ${Error msg}=    Set Variable    只能使用字母 數字或底線(_)
    Input Text    id=account_field    ${gTest account5}_!
    Press Keys    id=account_field    TAB
    Wait Until Element Contains    id=account    ${Error msg}
    Input Text    id=account_field    ${gTest account5}_
    Press Keys    id=account_field    TAB
    Wait Until Element Does Not Contain    id=account    ${Error msg}
    Input Text    id=account_field    ${gTest admin account}
    Press Keys    id=account_field    TAB
    Wait Until Element Contains    id=account    使用者已存在

Register With Blank Account (Academic)
    [Documentation]    Enter registration page without inputting the user account information, then the error shows correctly(academic).
    [Tags]    Register    Register2    Register2_4
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${EMPTY}    ${gTest mail password}    ${gTest mail password}    天使    大    User department=新聞系
    ...    Msg from where=username    Expected msg=${Expected msg}

Register With Consistent Email (Academic)
    [Documentation]    Enter registration page, check email field disabled ,and equal to register email(academic).
    [Tags]    Register    Register2    Register2_5
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    Element Should Be Disabled    //input[@id="email_field"]
    ${email}=    Get Element Attribute    //input[@id="email_field"]    value
    Should Be Equal    ${gTest mail account}    ${email}

Register Without Last Name (Academic)
    [Documentation]    Enter registration page without inputting the last name information, then the error shows correctly(academic).
    [Tags]    Register    Register2    Register2_6
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    ${EMPTY}    大    User department=新聞系
    ...    Msg from where=last_name    Expected msg=${Expected msg}

Register Without First Name (Academic)
    [Documentation]    Enter registration page without inputting the first name information, then the error shows correctly(academic).
    [Tags]    Register    Register2    Register2_7
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    ${EMPTY}    User department=新聞系
    ...    Msg from where=first_name    Expected msg=${Expected msg}

Register Without Area (Academic)
    [Documentation]    Enter registration page without selecting the area information, then the error shows correctly(academic).
    [Tags]    Register    Register2    Register2_8
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請選取一個清單中的項目。
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    User department=新聞系
    ...    Msg from where=area    Expected msg=${Expected msg}

Register Without Department (Academic)
    [Documentation]    Enter registration page without inputting the department information, then the error shows correctly(academic).
    [Tags]    Register    Register2    Register2_9
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    ${EMPTY}
    ...    Msg from where=department    Expected msg=${Expected msg}

Register Without Phone Number (Academic)
    [Documentation]    Enter registration page without inputting the phone information or wrong phone number format, then the error shows correctly(academic).
    [Tags]    Register    Register2    Register2_10
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    User department=新聞系
    ...    User phone=${EMPTY}    Msg from where=phone    Expected msg=${Expected msg}
    ${Expected msg}=    Set Variable    請符合要求的格式
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    User department=新聞系
    ...    User phone=090000000a    Msg from where=    Expected msg=${Expected msg}
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    User department=新聞系
    ...    User phone=090000000!    Msg from where=    Expected msg=${Expected msg}

Register Without Password (Academic)
    [Documentation]    Enter registration page without inputting the password information, then the error shows correctly (academic).
    [Tags]    Register    Register2    Register2_11
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    請填寫這個欄位
    Fill In Registration Info And Expect Error    ${gTest register account}    ${EMPTY}    ${gTest mail password}    天使    大    User department=新聞系
    ...    Msg from where=password    Expected msg=${Expected msg}

Register Without Confirmed Password (Academic)
    [Documentation]    Enter registration page without inputting the confirm password information, then the error shows correctly (academic).
    [Tags]    Register    Register2    Register2_12
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    此欄位必須和密碼相同
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${EMPTY}    天使    大    User department=新聞系
    ...    Msg from where=common    Expected msg=${Expected msg}

Register Without Invalid Password (Academic)
    [Documentation]    Enter registration page and input invalid length password and confirm password information, then the error shows correctly (academic).
    [Tags]    Register    Register2    Register2_13
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    必須介於8~20個字元
    Fill In Registration Info And Expect Error    ${gTest register account}    123    123    天使    大    User department=新聞系
    ...    Msg from where=common    Expected msg=${Expected msg}
    Fill In Registration Info And Expect Error    ${gTest register account}    012345678901234567891    012345678901234567891    天使    大    User department=新聞系
    ...    Msg from where=common    Expected msg=${Expected msg}
    Input Text    id=new_password    01234567
    Wait Until Element Contains    id=password_strength    密碼強度: 弱
    Input Text    id=new_password    01234567a
    Wait Until Element Contains    id=password_strength    密碼強度: 中
    Input Text    id=new_password    01234567a!
    Wait Until Element Contains    id=password_strength    密碼強度: 強

Register Without Inconsistent Password (Academic)
    [Documentation]    Enter registration page and input different password and confirm password information, then the error shows correctly(academic).
    [Tags]    Register    Register2    Register2_14
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest long password}    天使    大    User department=新聞系
    ...    Msg from where=common    Expected msg=此欄位必須和密碼相同

Register Without Agreement (Academic)
    [Documentation]    Enter registration page without check register agreement, then the error shows correctly(academic).
    [Tags]    Register    Register2    Register2_15
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    ${Expected msg}=    Set Variable    如果你要繼續執行，請勾選這個核取方塊
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    User department=新聞系
    ...    Msg from where=agreement    Expected msg=${Expected msg}

Check FAQ Link (Academic)
    [Documentation]    Enter registration page and click FAQ link, then the page shows correctly(academic).
    [Tags]    Register    Register2    Register2_16
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    Click Element    //a[text()="我同意服務條款及隱私權政策"]
    Switch Window    locator=NEW
    Location Should Contain    ${gOCAIP URL}/faq

Register Successfully (Academic)
    [Documentation]    Open gmail and fill in the register infomration to create a new account successfully.(academic)
    [Tags]    Register    Register2    Register2_17
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    會員註冊
    Fill In Registration Info And Expect Error    ${gTest register account}    ${gTest mail password}    ${gTest mail password}    天使    大    User department=新聞系
    ...    Msg from where=common
    Clear Mail Box    ${gTest mail account}    ${gTest mail password}    Title=註冊成功通知

Check Old Register Link (Academic)
    [Documentation]    Open gmail and click old register link, then the page will show correctly.(academic)
    [Tags]    Register    Register2    Register2_18
    [Setup]    No Operation
    Open Registration Page    ${gTest mail account}    ${gTest mail password}
    Sleep    2s
    Page Should Contain    此連結已超過使用次數

--- ResetPWD ---
    [Tags]    Title
    [Setup]    No Operation
    Log    --- ResetPWD ---
    [Teardown]    No Operation

Reset With Correct Email
    [Documentation]    Input with correct email
    [Tags]    ResetPWD    ResetPWD_1
    [Setup]    No Operation
    Check If Utest Account Exists
    Forget Password Request And Expect Result    ${gTest mail account}    common
    Clear Mail Box    Title=重設密碼

Reset With Invalid Email
    [Documentation]    Input with wrong format email
    [Tags]    ResetPWD    ResetPWD_2
    [Setup]    Not Login
    Forget Password Request And Expect Result    i_am_correct_email    common    Page status=fail    Expected msg=電子郵件格式不正確

Check Old Password Invalidity
    [Documentation]    Input with correct email, then go to the reset page and enter correct format password, confirm password, and check login fail with old password
    [Tags]    ResetPWD    ResetPWD_3
    [Setup]    Not Login
    # reset password
    Forget Password Request And Expect Result    ${gTest mail account}    common
    Open Resetpassword Page    ${gTest mail account}    ${gTest mail password}    Delete=False
    Wait Until Page Contains    重設密碼
    Fill In Reset Password Info    ${gTest long password}    ${gTest long password}
    #Check old password
    Login To OCAIP And Expect Error    ${gTest register account}    ${gTest mail password}    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試
    # reset to original password
    Login To OCAIP    ${gTest register account}    ${gTest long password}
    Change Password And Expect Error    ${gTest long password}    ${gTest mail password}    ${gTest mail password}    common    ${Empty}

Check Old Link Invalidity
    [Documentation]    After Resetting password successfully , go to email and open reset password page again, then the page will show correct
    [Tags]    ResetPWD    ResetPWD_4
    [Setup]    Not Login
    Open Resetpassword Page    ${gTest mail account}    ${gTest mail password}
    Sleep    2s
    Page Should Contain    哎呀，你查看的頁面不存在了！

Reset With Blank Confirmed Password
    [Documentation]    Input with only correct password (confirm_password is empty), then the page should show correctly
    [Tags]    ResetPWD    ResetPWD_5
    [Setup]    Not Login
    Forget Password Request And Expect Result    ${gTest mail account}    common
    Open Resetpassword Page    ${gTest mail account}    ${gTest mail password}
    Wait Until Page Contains    重設密碼
    ${Expected msg}=    Set Variable    請填寫這個欄位。
    Fill In Reset Password Info And Expected Error    ${gTest mail password}    ${EMPTY}    confirm_password    ${Expected msg}

Reset With Blank Password
    [Documentation]    Input with only correct confirm_password (password is empty), then the page should show correctly
    [Tags]    ResetPWD    ResetPWD_6
    [Setup]    Not Login
    Forget Password Request And Expect Result    ${gTest mail account}    common
    Open Resetpassword Page    ${gTest mail account}    ${gTest mail password}
    Wait Until Page Contains    重設密碼
    ${Expected msg}=    Set Variable    請填寫這個欄位。
    Fill In Reset Password Info And Expected Error    ${EMPTY}    ${gTest mail password}    password    ${Expected msg}

Reset With Inconsistent Password
    [Documentation]    input different password and confirm password then the page should show correctly
    [Tags]    ResetPWD    ResetPWD_7
    [Setup]    Not Login
    Forget Password Request And Expect Result    ${gTest mail account}    common
    Open Resetpassword Page    ${gTest mail account}    ${gTest mail password}
    Wait Until Page Contains    重設密碼
    Fill In Reset Password Info And Expected Error    ${gTest long password}    ${gTest mail password}    common    確認密碼需要與新密碼相同

Reset With Invalid Password
    [Documentation]    input incorrect length password or confirm password then the page should show correctly
    [Tags]    ResetPWD    ResetPWD_8
    [Setup]    Not Login
    Forget Password Request And Expect Result    ${gTest mail account}    common
    Open Resetpassword Page    ${gTest mail account}    ${gTest mail password}
    Wait Until Page Contains    重設密碼
    ${Expected msg1}=    Set Variable    請將這段文字加長到 8 個字元以上 (目前使用字元數：3)。
    ${Expected msg2}=    Set Variable    請將這段文字加長到 8 個字元以上 (目前使用字元數：4)。
    ${Expected msg3}=    Set Variable    請將這段文字加長到 8 個字元以上 (目前使用字元數：5)。
    Fill In Reset Password Info And Expected Error    123    12345678    password    ${Expected msg1}
    Fill In Reset Password Info And Expected Error    12345678    1234    confirm_password    ${Expected msg2}
    Fill In Reset Password Info And Expected Error    12345    123    password    ${Expected msg3}

Reset With Email With Dots
    [Documentation]    Input correct email with dots and reset correctly
    [Tags]    ResetPWD    ResetPWD_9
    [Setup]    Not Login
    ${Mail Domain}=    Split String    ${gTest mail account}    @
    # utest
    Forget Password Request And Expect Result    ocaip.t.e.s.t@${Mail Domain[1]}    common
    Open Resetpassword Page    ${gTest mail account}    ${gTest mail password}
    Wait Until Page Contains    重設密碼
    Fill In Reset Password Info    ${gTest long password}    ${gTest long password}
    # reset to original password
    Login To OCAIP    ${gTest register account}    ${gTest long password}
    Change Password And Expect Error    ${gTest long password}    ${gTest mail password}    ${gTest mail password}    common    ${Empty}

--- Profile ---
    [Tags]    Title
    [Setup]    No Operation
    Log    ---- Profile ---
    [Teardown]    No Operation

Change Password
    [Documentation]    Change password and login correctly.
    [Tags]    Profile    Profile_1
    [Setup]    No Operation
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error   ${gTest password}    a1234567890    a1234567890    common    ${Empty}
    Logout OCAIP
    Login To OCAIP    ${gTest account5}    a1234567890    Open browser=false
    Change Password And Expect Error    a1234567890    ${gTest password}    ${gTest password}    common    ${Empty}
    Logout OCAIP
    Login To OCAIP    ${gTest account5}    ${gTest password}    Open browser=false

Change Password With Wrong Old Password
    [Documentation]    Change password with incorrect old password and show expected error
    [Tags]    Profile    Profile_2
    [Setup]    No Operation
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error    QAQ    ${gTest password}    ${gTest password}    common    輸入的密碼錯誤

Change Password With Invalid Short Password
    [Documentation]    Change password with new password and confirm password which are too short.
    [Tags]    Profile    Profile_4
    [Setup]    No Operation
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    [長度須為8至20字元]
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    [長度須為8至20字元]
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error    ${gTest password}    0000    0000    common    ${Expected msg}

Change Password With Wrong Confirmed Password
    [Documentation]    Change password with incorrect confirm password and show expected error
    [Tags]    Profile    Profile_3
    [Setup]    No Operation
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error    ${gTest password}    ${gTest password}    QAQAQAQAQAQAQA    common    新密碼輸入需要相同

Change Password With Invalid Long Password
    [Documentation]    Change password with new password and confirm password which are too long should be cut
    [Tags]    Profile    Profile_5
    [Setup]    No Operation
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error    ${gTest password}    QAQ12345678987654321QAQ    QAQ12345678987654321QAQ    common    ${Empty}
    Logout OCAIP
    Login To OCAIP    ${gTest account5}    QAQ12345678987654321    Open browser=false
    Change Password And Expect Error    QAQ12345678987654321    ${gTest password}    ${gTest password}    common    ${Empty}

Change Password With Blank New Password
    [Documentation]    Change password with blank new password and confirm password.
    [Tags]    Profile    Profile_6
    [Setup]    No Operation
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    請填寫這個欄位
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    請填寫此欄位
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error    ${gTest password}    \    \    newpwd    ${Expected msg}

Change Password With Blank Old Password
    [Documentation]    Change password with blank old password and confirm password.
    [Tags]    Profile    Profile_7
    [Setup]    No Operation
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    請填寫這個欄位
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    請填寫此欄位
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error    \    abc123456789    \    oldpwd    ${Expected msg}

Change Password With Blank All Password
    [Documentation]    Change password with blank old password and new password.
    [Tags]    Profile    Profile_8
    [Setup]    No Operation
    ${Which Browser}=    Get Current Browser
    ${Expected msg}=    Run Keyword If    "${Which Browser}" == "chrome"    Set Variable    請填寫這個欄位
    ...    ELSE IF    "${Which Browser}" == "firefox"    Set Variable    請填寫此欄位
    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error    \    \    abc123456789    oldpwd    ${Expected msg}

Check Attended Topics Correctly
    [Documentation]    Check attended topic in profile and link
    [Tags]    Profile    Profile_9
    ${File name}=    Set Variable    profile1
    Create Topic With Argument    ${File name}    pri_single_reg_AOI
    Go To User Profile
    Click Element    //a[@href="user_info_topics"]
    Wait Until Page Contains Element    //a[@href="/topic/${gTopic ID Now}"]
    Click Element    //a[@href="/topic/${gTopic ID Now}"]
    Wait Until Location Is    ${gOCAIP URL}/topic/${gTopic ID Now}

Check 4 Types Of Topic Notification
    [Documentation]    Check 4 types of notification and send emails successfully
    [Tags]    Profile    Profile_10
    ${File name}=    Set Variable    profile1
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To Topic    ${gTopic ID Now}    Input type=id
    Go To User Profile
    Click Element    //a[@href="user_subscription"]
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}    Open browser=true
    Go To Admin Page    Admin type=公告管理
    Make Announcements To Topic Members    Title=服務公告通知測試    Content=內容    Issue=${gTopic Name Now}    Notification_Type=服務公告    Type=僅發送e-mail
    Make Announcements To Topic Members    Title=新議題上架通知測試    Content=內容    Issue=${gTopic Name Now}    Notification_Type=新議題上架    Type=僅發送e-mail
    Make Announcements To Topic Members    Title=主題活動推播通知測試    Content=內容    Issue=${gTopic Name Now}    Notification_Type=主題活動推播    Type=僅發送e-mail
    Make Announcements To Topic Members    Title=參與議題的重要訊息通知測試    Content=內容    Issue=${gTopic Name Now}    Notification_Type=參與議題的重要訊息    Type=僅發送e-mail
    Clear Mail Box    Title=參與議題的重要訊息通知測試
    Clear Mail Box    Title=主題活動推播通知測試
    Clear Mail Box    Title=新議題上架通知測試
    Clear Mail Box    Title=服務公告通知測試
    Switch Browser    1
    Click Element    //button[@id="system_service"]
    Click Element    //button[@id="new_topics"]
    Click Element    //button[@id="special_events"]
    Click Element    //button[@id="topic_updates"]
    Switch Browser    2
    Go To Admin Page    Admin type=公告管理
    Make Announcements To Topic Members    Title=服務公告通知測試    Content=內容    Issue=${gTopic Name Now}    Notification_Type=服務公告    Type=僅發送e-mail
    Make Announcements To Topic Members    Title=新議題上架通知測試    Content=內容    Issue=${gTopic Name Now}    Notification_Type=新議題上架    Type=僅發送e-mail
    Make Announcements To Topic Members    Title=主題活動推播通知測試    Content=內容    Issue=${gTopic Name Now}    Notification_Type=主題活動推播    Type=僅發送e-mail
    Make Announcements To Topic Members    Title=參與議題的重要訊息通知測試    Content=內容    Issue=${gTopic Name Now}    Notification_Type=參與議題的重要訊息    Type=僅發送e-mail
    Run Keyword And Expect Error    STARTS: Mail "參與議題的重要訊息通知測試" did not appear
    ...    Clear Mail Box    Title=參與議題的重要訊息通知測試
    Run Keyword And Expect Error    STARTS: Mail "主題活動推播通知測試" did not appear
    ...    Clear Mail Box    Title=主題活動推播通知測試
    Run Keyword And Expect Error    STARTS: Mail "新議題上架通知測試" did not appear
    ...    Clear Mail Box    Title=新議題上架通知測試
    Run Keyword And Expect Error    STARTS: Mail "服務公告通知測試" did not appear
    ...    Clear Mail Box    Title=服務公告通知測試
    Switch Browser    1
    Click Element    //button[@id="system_service"]
    Click Element    //button[@id="new_topics"]
    Click Element    //button[@id="special_events"]
    Click Element    //button[@id="topic_updates"]

Update Profile
    [Documentation]    Check profile edit correctly
    [Tags]    Profile    Profile_11
    [Setup]    Login To OCAIP    ${gTest first account}    ${gTest first password}
    Go To User Profile
    Input Text    //input[@id="last_name"]    lastname
    Input Text    //input[@id="first_name"]    firstname
    Customized Select From List By Label    //select[@id="area"]    臺北市
    Customized Select From List By Label    //select[@id="school-name"]    中央研究院
    Input Text    //input[@id="affiliation_department"]    department
    Input Text    //input[@id="mobile_phone"]    0912345678
    Click Element    //input[@id="submit"]
    Wait Until Element Contains    //section[@class="profile_banner"]//p    中央研究院
    Element Attribute Value Should Be    //input[@id="last_name"]    value    lastname
    Element Attribute Value Should Be    //input[@id="first_name"]    value    firstname
    Element Attribute Value Should Be    //input[@id="affiliation_department"]    value    department
    Element Attribute Value Should Be    //input[@id="mobile_phone"]    value    0912345678

Convert Academic Account Into Bussiness
    [Documentation]    Convert academic account into bussiness
    [Tags]    Profile    Profile_12
    [Setup]    Login To OCAIP    ${gTest register account}    ${gTest mail password}
    ${File name}=    Set Variable    profile1
    Import Resource    ${CURDIR}${/}Temp${/}${SUITE NAME}_${File name}.txt
    Go To User Profile
    Click Element    //a[text()="轉換業界"]
    Alert Should Be Present    僅提供學界轉換為業界，轉換身份別後，無法再變更。並請更新您的所屬機構、單位。
    Input Text    //input[@id="school-name"]    工研院
    Input Text    //input[@id="affiliation_department"]    巨資中心
    Click Element    //input[@id="submit"]
    Go To User Profile
    Element Attribute Value Should Be    //input[@id="affiliation_department"]    value    巨資中心
    Run Keyword And Expect Error    STARTS: Element with locator '//div[@id="register_topic"]' not found.
    ...    Sign Up To Sign NDA    ${gTopic ID Now}    Input type=id
    Login To OCAIP    ${gTest admin account}    ${gTest admin password}
    Go To Admin Page    Admin type=活動清單
    Element Text Should Be    //table[@id="user_event"]/tbody/tr[1]/td[2]    ${gTest register account}
    Element Text Should Be    //table[@id="user_event"]/tbody/tr[1]/td[3]    學界轉業界
    [Teardown]    Compatibility Teardown    ${gTopic ID Now}

Change Password And Login With Old Password
    [Documentation]    Change password and login with old password.
    [Tags]    Profile    Profile_13
    [Setup]    Login To OCAIP    ${gTest account5}    ${gTest password}
    Change Password And Expect Error    ${gTest password}    a1234567890    a1234567890    common    ${Empty}
    Logout OCAIP
    Login To OCAIP And Expect Error    ${gTest account5}    ${gTest password}    Msg from where=common    Expected msg=無法驗證您輸入的使用者名稱或密碼，請檢查並重試    Open browser=false
    Execute Javascript    document.elementFromPoint(0,0).click();
    Login To OCAIP    ${gTest account5}    a1234567890    Open browser=false
    Change Password And Expect Error    a1234567890    ${gTest password}    ${gTest password}    common    ${Empty}

Check Account Name On Navbar
    [Documentation]    Check account name on navbar and information on profile page show correctly.
    [Tags]    Profile    Profile_14
    [Setup]    Login To OCAIP    ${gTest account5}    ${gTest password}
    Page Should Contain Element    //div[@id="navbar"]//h6[@id="useracc" and text()="${gTest account5}"]
    Go To User Profile
    Page Should Contain Element    //div[@id="navbar"]//h6[@id="useracc" and text()="${gTest account5}"]
    ${Mail Domain}=    Split String    ${gTest mail account}    @
    Element Text Should Be    //section[@class="profile_banner"]//h3    ${gTest account5}
    Element Should Contain    //section[@class="profile_banner"]//p    ocaip.test+${gTest account5}@${Mail Domain[1]}

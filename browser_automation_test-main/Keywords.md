### Keywords 說明
| 名稱 | 在OCAIP_RF_Test使用情形/在其他Keyword中使用情形 | 參數 | 備註
| ----------------- | ----------------- | ----------------- | ----------------- | ----------------- |
| 【SETUP 及 TEARDOWN】 |
| Suite Setup |  | None | |
| Suite Teardown |  | None | |
| Compatibility Teardown |  | None | | 
| 【登入登出相關】 |
| Login To OCAIP | 232/9 | ${User account}, ${User Password}, ${Which Browser}, ${Login status}, ${Open browser}, ${Block Image} | |
| Login To OCAIP And Expect Error | 29/3 |${User account}, ${User Password}, ${Which Browser}, ${Msg from where}, ${Expected msg}, ${Open browser}, ${Window width}, ${Window height}, ${Mobile}, ${Block Image} |
| Logout OCAIP | 186/8 | ${Window width} |
| Login To Gmail | 0/4 | ${User gmail account}, ${User gmail password}, ${Which Browser} | |
| Get Admin Token | 0/1 | ${User account}, ${User password} | |
| Check IP Block | 0/1 | None | |
| 【開啟瀏覽器】 |
| Open Browser to Page | 9/3 | ${URL}, ${Block Image}, ${Window width}, ${Window height}, ${Mobile}, ${Lang}, ${Which Browser} | |
| Open Chrome Browser to Page | 0/3 | ${URL}, ${Block Image}, ${Window width}, ${Window height}, ${Mobile}, ${Lang} | |
| Open Firefox Browser to Page | 0/1 | ${URL}, ${Block Image}, ${Window width}, ${Window height}, ${Mobile}, ${Lang} | ${Block Image}, {Mobile} 未使用 |
| Not Login | 27/0 | ${Which Browser}, ${Block Image} |
| 【00010(Content)相關】 |
| Go To Home Page | 1/1 | None |
| Go To About Platform | 1/0 | None |
| Go To About Team | 1/0 | None |
| Go To Topic List | 2/2 | ${Window width}, ${Topic type} |
| Go To FAQ | 1/0 | None |
| Go To Computing Resources | 1/0 | None |
| Go To AI CUP | 1/0 | None |
| Go To Career | 1/0 | None |
| Go To Statistics List | 4/1 | ${Window width} |
| Go To Admin Page | 4/3 | ${Window width}, ${Admin type} |
| Go To Statistics Topic | 7/20 | ${Statistics Topic name}, ${Input type} |
| Go To Topic | 18/31 | ${Topic name}, ${Input type}, ${Window width}, ${Topic type |
| 【STATISTICS相關】 |
| Search Strings Through Whole Table In One Page | 0/1 | ${Search string}, ${Row size}, ${First row} |
| Search Date Through Whole Table In One Page | 0/1 | ${Begin date}, ${Begin unix}, ${End unix}, ${Row size}, ${First row} |
| Search Specific Strings In Statistics | 6/0 | ${Search string}, ${Topic name}, ${Input type} |
| Search Specific Date Intervals In Statistics | 6/0 | ${Topic name}, ${Begin date}, ${End date}, ${Input type} |
| Compare Highest Score Of Statistics Analysis And Upload Record | 2/0 | ${Topic name}, ${Input type} |
| Check Previous And Next Page Of Statistics | 2/0 | ${Topic name}, ${Input type} |
| Select Data Displayed Numbers Of Statistics | 2/0 | ${Topic name}, ${Input type} |
| Check Sorting Function Of Statistics | 3/0 | ${Topic name}, ${Input type} |
| Check Sorting Function Through Whole Table In One Page | 0/10 | ${Row size}, ${First row}, ${Min}, ${Max}, ${Sort method}, ${Sort column} |
| Check Overview Of Statistics Analysis | 1/0 | ${Topic name}, ${Login account}, ${Upload file}, ${Input type} |
| Check TeamUp Of Statistics Analysis | 1/0 | ${Topic name}, ${Input type} |  |
| Check Ranking Of Statistics Analysis | 1/0 | ${Topic name}, ${First user}, ${First score}, ${Second user}, ${Second score}, ${Third user}, ${Third score}, ${Fourth user}, ${Fourth score}, ${Fifth user}, ${Fifth score}, ${Input type} |
| Check View Percentage Of Statistics Analysis | 1/0 | ${Topic name}, ${Expect first percentage}, ${Expect second percentage}, ${Expect third percentage}, ${Expect fourth percentage}, ${Input type} |
| Check Upload Percentage Of Statistics Analysis | 1/0 | ${Topic name}, ${Expect first percentage}, ${Expect second percentage}, ${Expect third percentage}, ${Input type} |
| Check Download Percentage Of Statistics Analysis | 1/0 | ${Topic name}, ${Expect first percentage}, ${Expect second percentage}, ${Expect third percentage}, ${Expect fourth percentage}, ${Input type} |
| 【TIMEBAR相關】 |
| Check Timeline Bar | 0/3 | ${Topic name}, ${Input type}, ${Sign status} |  |
| Check Timebar At Different Stages | 11/0 | ${Topic name}, ${Input type}, ${Sign status}, ${Enclosed} |
| 【10020(Login)相關】 |
| Check User Profile | 2/0 | ${User account} | |
| 【10030(ChangePWD)相關】 |
| Change Password And Expect Error | 11/0 | ${User Password}, ${New Password}, ${Confirm Password}, ${Msg from where}, ${Expected msg} |
| 【10040(ForgetPWD)相關】 |
| Fill In Reset Password Info | 1/0 | ${User password}, ${User confirm password} | |
| Fill In Reset Password Info And Expected Error | 6/1 | ${User password}, ${User confirm password}, ${Msg from where}, ${Expected msg} | |
| Forget Password Request And Expect Result | 8/0 | ${User email}, ${Msg from where}, ${Page status}, ${Expected msg} |
| Open Resetpassword Page | 6/0 | ${User gmail account}, ${User gmail password}, ${Which Browser}, ${Delete} | |
| Check If Utest Account Exists | 1/0 | None |
| 【10050(Register)相關】 |
| Open Registration Page | 26/1 | ${User gmail account}, ${gTest gmail account}, ${User gmail password}, ${Which Browser}, ${Delete} | |
| Fill In Registration Info And Expect Error | 13/2 | ${User account}, ${User password}, ${User confirm password}, ${User last name}, ${User first name}, ${User company name}, ${User department}, ${Which Browser}, ${Msg from where}, ${Expected msg}, ${User phone}, ${type} | |
| Delete Test User | 4/0 | None | |
| Clear Mail Box | 5/0 | ${User gmail account}, ${User gmail password}, ${Which Browser}, ${Sequence}, ${Title} | |
| Register A User Account And Expect Error | 8/1 | ${User email}, ${Msg from where}, ${Recaptcha flag}, ${Expected msg}, ${Sign Up type} |
| 【Discussion相關】|
| Check If Message Existed In Discussion Zone Of Topic | 0/4 | ${Message}, ${Post account}, ${Post time} |  |
| Post A Message To Topic | 14/2 | ${Topic name}, ${Post Message}, ${Expect Message}, ${Input type}, ${Post account}, ${mode} |
| Delete A Message From Topic | 10/0 | ${Topic name}, ${Message}, ${Post account}, ${Post time}, ${Input type}, ${self} |
| Like Message Of Topic | 2/0 | ${Topic name}, ${Message}, ${Post account}, ${Post time}, ${Input type} |
| Dislike Message From Topic | 1/0 | ${Topic name}, ${Message}, ${Post account}, ${Post time}, ${Input type} |
| Check Zero Message From Topic | 4/0 | ${Topic name}, ${Input type} |
| Click Many Times Of Like To Check Correct | 1/0 | ${Topic name}, ${Message}, ${Click times}, ${Posted user}, ${Posted time}, ${Input type} |
| Open Discussion Notification Page | 1/0 | ${User gmail account}, ${User gmail password}, ${Which Browser}, ${Delete}, ${Post account}, ${Post Message} | |
| 【UPLOAD相關】 |
| Check Upload Page Is Available | 155/6 | ${Topic name}, ${Input type}, ${Topic type} |
| Upload Result For Topic And Expect Error | 187/2 | ${Topic name}, ${Upload account}, ${File location}, ${Msg from where}, ${Expected msg}, ${Expect score}, ${Topic type}, ${Refresh}, ${Input type} |
| Check Upload Score Is Correct | 27/0 | ${Topic name}, ${Input type}, ${Board type}, ${Expect score1}, ${Expect score2}, ${Expect score3} |
| Check Upload Rank Is Correct | 43/0 | ${Topic name}, ${Expect rank}, ${Input type}, ${Board type} |
| Check Default Upload Message | 1/0 | ${Topic name}, ${Input type} |
| 【FUNCTION VERIFICATION相關】 |
| Check Functions At Different Stages | 52/0 | ${Topic name}, ${Input type}, ${Issue type}, ${Evaluate type}, ${Flow type}, ${Team type}, ${Window width} |
| Upload Function No Available | 0/1 | ${Topic type} |
| Download Function No Available | 2/1 | None |
| Check Functions When Not Login | 9/0 | ${Topic name}, ${Input type}, ${Team type}, ${Window width} |
| Check Time Countdown At Different Stages | 15/0 | ${Topic name}, ${Input type}, ${Issue type}, ${Flow type}, ${Window width} |  |
| 【TEAMUP相關】 |
| Multiple Sign Up | 3/0 | ${Topic name}, ${Input type}, ${Window width}, ${Team}, ${Topic type}, ${Members}, ${Expect} |
| Check Initial Team Up State | 1/1 | ${Topic name}, ${User account}, ${Input type}, ${Window width} |
| Change Team Name And Expect Error | 13/1 | ${Topic name}, ${Team name}, ${Expect msg}, ${Input type} |
| Send Invitation To Team Up And Expect Error | 44/1 | ${Topic name}, ${Invite team}, ${Contain team}, ${Input type}, ${Status}, ${Topic type} |
| Assign Leader | 3/0 | ${Topic name}, ${next leader}, ${Input type} |
| Cancel Team Request | 2/0 | ${Topic name}, ${Invite team}, ${Input type} |
| Reply Team Up Invitation | 25/1 | ${Topic name}, ${Request team}, ${Request leader}, ${Operation}, ${Input type}, ${Topic type} |
| Check Request Record | 12/1 | ${Topic name}, ${Invite team}, ${Status}, ${Input type} |
| Check Receive Record | 7/0 | ${Topic name}, ${Request team}, ${Status}, ${Input type} |
| Check Team Up Autocomplete | 4/0 | ${Topic name}, ${Input text}, ${Expect Length}, ${Expect teams}, ${Input type} |
| 【UI相關】 |
| Check Two Image Similarity | 164/0 | ${image1}, ${image2}, ${target score} |
| Capture Exam Images For User Function | 3/0 | ${Window width}, ${Window height} |
| Capture Exam Images For Issue Function | 18/0 | ${Topic name}, ${Window width}, ${Window height}, ${Evaluate type}, ${Webflow type}, ${Team type}, ${Join condition}, ${Input type}, ${Issue type} |
| Capture Exam Images For Statistics | 3/0 | ${Window width}, ${Window height}, ${Evaluate type}, ${Join condition}, ${Input type}, ${Topic names} |
| Capture Exam Images For Administration | 3/0 | ${Window width}, ${Window height} |
| Reorganize Grabbed Images As Answer Layout | 6/0 | ${Size path name}, ${Postfix name} |
| 【NOTIFICATION相關】 |
| Check Bell Message | 9/0 | ${Title}, ${Message}, ${Notify} |
| 【RWD相關】 |
| Check Navbar Content | 2/0 | ${Login Status}, ${Window size} |
| 【ADMIN相關】 |
| Create A New Role | 1/0 | ${Role name}, ${Perms} |
| Assign A Role To A User | 2/0 | ${User account}, ${Role} |
| Make Announcements To Topic Members | 2/0 | ${Title}, ${Content}, ${Issue}, ${Title en}, ${Content en}, ${Type}, ${Team} |
| 【其他】 |
| Change Topic Date | 10/0 |${Topic ID}, ${Operation}, ${Success msg}, ${Error msg} |
| Create Topic With Argument | 54/0 | ${File name}, ${Issue topic}, ${Topic type}, ${Operation}, ${Window width}, ${Join}|
| Go To Previous Page | 9/1 | None |
| Refresh Page | 3/2 | None |
| Customized Mouse Over | 3/24 | ${Locator} |  |
| Customized Click Element | 0/1 | ${Clicked Locator} |
| Wait Until DOM Ready | 0/1 | None | |
| Test DOM Is Ready | 0/1 | None | |
| Check EULA | 0/1 | None |
| Sign NDA And Download File | 0/1 | ${File name} |
| Sign Up To Sign NDA | 157/4 | ${Topic name}, ${Input type}, ${Flow type}, ${Window width}, ${Join}, ${Topic type} |
| Download Data From Topic | 12/3 | ${Topic name}, ${File name}, ${Need sign NDA}, ${Input type} |
| Check Issue Page No Specific Function Available | 3/0 | ${Topic name}, ${Input type}, ${Func type}, ${Topic type}|
| Create Calculate Score File | 1/0 | ${File name}, ${Issue topic}, ${Method}, ${sol_file}, ${test_file}, ${pub_set} |
| Sign Up Issue | 1/0 | ${Topic name}, ${Input type} |








































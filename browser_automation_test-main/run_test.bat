echo off
SET batchpath=%~dp0
del /Q "%batchpath%\log\*.html"
del /Q "%batchpath%\log\*.png"
del /Q "%batchpath%\log\*.xml"
del /Q "%batchpath%\temp\*.csv"
robot --outputdir "%batchpath%\log" --exclude NA --exclude Title --variable "gOCAIP URL":%*
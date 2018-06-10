@echo off
IF %1.==. GOTO MISSING_FILE_NAME
set name=test
set exe=%name%.exe
cd ..\BIN
cls
cv %exe%
cd ..\code
GOTO END
:MISSING_FILE_NAME
    echo "Usage: debug <file.exe>"
:END
@echo off
IF %1.==. GOTO MISSING_FILE_NAME
set name=%1
set exe=%name%.exe
cd ..\BIN
cls
%exe%
cd ..\code
GOTO END
:MISSING_FILE_NAME
    echo "Usage: run <file.exe>"
    GOTO END
:END
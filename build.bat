@echo off
IF %1.==. GOTO MISSING_FILE_NAME
set name=%1
set file=%name%.asm
cd ..\BIN
Ml /Zm "..\code\%file%"
cd ..\code
GOTO END
:MISSING_FILE_NAME
    echo "Usage: build <file.asm>"
:END
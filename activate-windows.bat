@echo OFF
setlocal EnableDelayedExpansion
title Activate Windows


::::::::::::::::::::::: VARIABLES :::::::::::::::::::::::

set "TITLE=Activate Windows"

:: PRODUCT KEYS
set "KEYS[Enterprise]=NPPR9-FWDCX-D2C8J-H872K-2YT43|DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4|YYVX9-NTFWV-6MDM3-9PT4T-4M68B"
set "KEYS[Home]=TX9XD-98N7V-6WMQ6-BX7FG-H8Q99|3KHY7-WNT83-DGQKR-F7HPR-844BM|7HNRX-D7KGG-3K4RQ-4WPJ4-YTDFH"
set "KEYS[Education]=NW6C2-QMPVW-D7KKK-3GKT6-VCFB2|2WH4N-8QGBV-H22JP-CT43Q-MDWWJ"
set "KEYS[Pro]=W269N-WFGWX-YVC9B-4J6C9-T83GX|MH37W-N47XK-V7XM9-C7227-GCQG9|NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J"

:: KMS SERVERS
set "KMS=kms7.msguides.com|kms8.msguides.com|kms9.msguides.com"


::::::::::::::::::::::: MAIN SCRIPT :::::::::::::::::::::::

:: DETECT WINDOWS VERSION & EDITION
for /f "tokens=2 delims==" %%a in ('wmic os get caption /value') do (
    for /f "tokens=3,4" %%b in ("%%a") do (
        set "VERSION=%%b"
        set "EDITION=%%c"
    )
)

:: GET CONSOLE WIDTH
for /F "usebackq tokens=2* delims=: " %%w in (`mode con ^| findstr Columns`) do set CONSOLE_WIDTH=%%w

:: GET STRING LENGTH
>%TEMP%\~stringlength.tmp echo %TITLE%
for %%l in (%TEMP%\~stringlength.tmp) do set /A STR_LEN = %%~zl - 2
del %TEMP%\~stringlength.tmp

:: GENERATE SEPARATOR LINES
set /A num_chars=(%CONSOLE_WIDTH% - (%STR_LEN% + 2)) / 2
set "SEP_LINE1="
set "SEP_LINE2="
set "SEP_LINE_TITLE="
for /L %%i in (1,1,%CONSOLE_WIDTH%) do set "SEP_LINE1=!SEP_LINE1!#"
for /L %%i in (1,1,%CONSOLE_WIDTH%) do set "SEP_LINE2=!SEP_LINE2!-"
for /L %%i in (1,1,%num_chars%) do set "SEP_LINE_TITLE=!SEP_LINE_TITLE!#"

echo.
call :echoTitle "%TITLE%" "#"
echo Microsoft Windows %VERSION% %EDITION%
echo %SEP_LINE1%
echo.

:: ACTIVATION
set "keys=!KEYS[%EDITION%]!"
for %%s in ("%KMS:|=" "%") do (
    for %%k in ("%keys:|=" "%") do (
        call :echoTitle "Install KMS client key %%k" "-"
        cscript //nologo %WINDIR%\system32\slmgr.vbs /ipk %%~k >nul 2>&1 || (
            echo Failed to install KMS client key.
        )
        call :echoTitle "Set KMS machine address %%s" "-"
        cscript //nologo %WINDIR%\system32\slmgr.vbs /skms %%~s >nul 2>&1 || (
            echo Failed to set KMS machine address: Server might be unavailable.
        )
        call :echoTitle "Activate Windows" "-"
        cscript //nologo %WINDIR%\system32\slmgr.vbs /ato > "%TEMP%\~activation.tmp" 2>&1
        type "%TEMP%\~activation.tmp"
        find /i "successfully" "%TEMP%\~activation.tmp" >nul && (
            echo.
            call :echoTitle "Done" "#"
            echo Successfully activated Windows!
            echo %SEP_LINE1%
            goto :EOF
        ) || (
            echo Activation failed! Error details above.
        )
        echo.
    )
)

echo.
echo All activation attempts failed!
echo Please check your internet connection or try again later.
goto :EOF


::::::::::::::::::::::: FUNCTIONS :::::::::::::::::::::::

:echoTitle
:: GET CONSOLE WIDTH
for /F "usebackq tokens=2* delims=: " %%w in (`mode con ^| findstr Columns`) do set CONSOLE_WIDTH=%%w
:: GET STRING LENGTH
>%TEMP%\~stringlength.tmp echo %~1
for %%l in (%TEMP%\~stringlength.tmp) do set /A STR_LEN = %%~zl - 2
del %TEMP%\~stringlength.tmp
:: GENERATE SEPARATOR LINES
set /A num_chars=(%CONSOLE_WIDTH% - (%STR_LEN% + 2)) / 2
set "SEP_LINE="
for /L %%i in (1,1,%num_chars%) do set "SEP_LINE=!SEP_LINE!%~2"
:: OUTPUT
echo %SEP_LINE% %~1 %SEP_LINE%
goto :EOF


::::::::::::::::::::::: END :::::::::::::::::::::::

:EOF
echo.
pause

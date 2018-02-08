@Echo Off
REM This SImple Module will display simple Text Document in CMD console in 
REM Well Formatted Way! A little upgrade of the 'Type' Command, using Batbox.
REM Created by Kvc

SetLocal EnableDelayedExpansion
Title DisplayDOC Module v.1.0

If /I "%~1" == "" (Goto :End)
If /I "%~2" == "" (Goto :End)
If /I "%~3" == "" (Goto :End)

Set "_X=%~1"
Set "_Y=%~2"
Set "_File=%~3"

For /F "EOL=# UseBackq Tokens=*" %%A In ("%_File%") Do (
	IF /I "%%A" == "-" (Set /A _Y+=1) ELSE (Batbox /g !_X! !_Y! /d "%%A"&&Set /A _Y+=1)
	)
Goto :End

:End
Echo.
ENDLOCAL
Exit /b
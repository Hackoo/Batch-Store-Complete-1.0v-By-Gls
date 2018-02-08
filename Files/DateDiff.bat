@ECHO OFF
SETLOCAL EnableDelayedExpansion
REM Modified a little for perfect working...by kvc - www.thebateam.org
ECHO.

:: Check the Windows version
IF NOT "%OS%"=="Windows_NT" GOTO Syntax

:: Check the command line arguments
IF     "%~1"=="" GOTO Syntax
IF NOT "%~4"=="" GOTO Syntax

:: Read the Date format from the registry
CALL :ReadDateFormat

:: Use today if no second date was specified
IF "%~2"=="" (
	FOR %%A IN (%Date%) DO SET Date2=%%A
) ELSE (
	SET Date2=%2
)

:: Parse the first date
CALL :ParseDate %1

:: Convert the parsed Gregorian date to Julian
CALL :JDate %GYear% %GMonth% %GDay%

:: Save the resulting Julian date
SET JDate1=%JDate%

:: Parse the second date
CALL :ParseDate %Date2%

:: Convert the parsed Gregorian date to Julian
CALL :JDate %GYear% %GMonth% %GDay%

:: Calculate the absolute value of the difference in days
IF %JDate% GTR %JDate1% (
	SET /A DateDiff = %JDate% - %JDate1%
) ELSE (
	SET /A DateDiff = %JDate1% - %JDate%
)

:: Format output for singular or plural
SET Days=days
IF %DateDiff% EQU 1 SET Days=day

:: Prefix value with a minus sign if negative
IF %JDate% GTR %JDate1% SET DateDiff=-%DateDiff%

:: Display the result
ECHO First date  : %1
ECHO Second date : %Date2%
ECHO Difference  : %DateDiff% %Days%

:: Return the result in a variable named after this batch file
ENDLOCAL & SET %~n0=%DateDiff%
GOTO:EOF


::===================================::
::                                   ::
::   -   S u b r o u t i n e s   -   ::
::                                   ::
::===================================::


:JDate
:: Convert date to Julian
:: Arguments : YYYY MM DD
:: Returns   : Julian date
::
:: First strip leading zeroes; a logical error in this
:: routine was corrected with help from Alexander Shapiro
SET MM=%2
SET DD=%3
IF 1%MM% LSS 110 SET MM=%MM:~1%
IF 1%DD% LSS 110 SET DD=%DD:~1%
::
:: Algorithm based on Fliegel-Van Flandern
:: algorithm from the Astronomical Almanac,
:: provided by Doctor Fenton on the Math Forum
:: (http://mathforum.org/library/drmath/view/51907.html),
:: and converted to batch code by Ron Bakowski.
SET /A Month1 = ( %MM% - 14 ) / 12
SET /A Year1  = %1 + 4800
SET /A JDate  = 1461 * ( %Year1% + %Month1% ) / 4 + 367 * ( %MM% - 2 -12 * %Month1% ) / 12 - ( 3 * ( ( %Year1% + %Month1% + 100 ) / 100 ) ) / 4 + %DD% - 32075
FOR %%A IN (Month1 Year1) DO SET %%A=
GOTO:EOF 


:ParseDate
:: Parse (Gregorian) date depending on registry's date format settings
:: Argument : Gregorian date in local date format,
:: Requires : sDate (local date separator), iDate (local date format number)
:: Returns  : GYear (4-digit year), GMonth (2-digit month), GDay (2-digit day)
::
Set "_Date=%~1"
Set _Date=!_Date:-=%sDate%!

IF %iDate%==0 FOR /F "TOKENS=1-3 DELIMS=%sDate%" %%A IN ('ECHO.%_Date%') DO (
	SET GYear=%%C
	SET GMonth=%%A
	SET GDay=%%B
)
IF %iDate%==1 FOR /F "TOKENS=1-3 DELIMS=%sDate%" %%A IN ('ECHO.%_Date%') DO (
	SET GYear=%%C
	SET GMonth=%%B
	SET GDay=%%A
)
IF %iDate%==2 FOR /F "TOKENS=1-3 DELIMS=%sDate%" %%A IN ('ECHO.%_Date%') DO (
	SET GYear=%%A
	SET GMonth=%%B
	SET GDay=%%C
)
GOTO:EOF


:ReadDateFormat
:: Read the Date format from the registry.
:: Arguments : none
:: Returns   : sDate (separator), iDate (date format number)
::
:: First, export registry settings to a temporary file:
:: Now, read the exported data:

REM Modified here a little bit...No need of admin access just to read items...
REM #Kvc, www.thebateam.org
FOR /F "Skip=2 tokens=1,2,3*" %%A IN ('reg query "HKEY_CURRENT_USER\Control Panel\International" /v iDate') DO SET iDate=%%C
FOR /F "Skip=2 tokens=1,2,3*" %%A IN ('reg query "HKEY_CURRENT_USER\Control Panel\International" /v sDate') DO SET sDate=%%C

:: Remove quotes from the data read:
:: SET iDate=%iDate:"=%
FOR %%A IN (%iDate%) DO SET iDate=%%~A
:: SET sDate=%sDate:"=%
FOR %%A IN (%sDate%) DO SET sDate=%%~A
GOTO:EOF


:Syntax
ECHO DateDiff.bat,  Version 1.10 for Windows NT 4 / 2000 / XP / Server 2003 / Vista
ECHO Calculate the difference (in days) between two dates
ECHO.
ECHO Usage:  DATEDIFF  date  [ date ]
ECHO.
ECHO Where:  "date"  is a "normal" Gregorian date in the local computer's format;
ECHO                 if no second date is specified, today is assumed
ECHO.
ECHO Julian date conversion based on Fliegel-Van Flandern algorithms from
ECHO the Astronomical Almanac, provided by Doctor Fenton on the Math Forum
ECHO (http://mathforum.org/library/drmath/view/51907.html), and converted
ECHO to batch code by Ron Bakowski.
ECHO Bug found by and converted with help from Alexander Shapiro.
ECHO.
ECHO Written by Rob van der Woude
ECHO http://www.robvanderwoude.com

IF "%OS%"=="Windows_NT" ENDLOCAL

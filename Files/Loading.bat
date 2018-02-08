@Echo off
SetLocal EnableDelayedExpansion

REM [%~2] : Sequence of loading... [1 to 7 OR 'FINISH']
Set _Sequence=%~2

Window GSize
call :GetCoords _Max_Graphical_X= _Max_Graphical_Y=

Set /A "_Image_X=(!_Max_Graphical_X! / 2) - 156"
Set /A "_Image_Y=(!_Max_Graphical_Y! / 2) - 83"

IF /I "!_Sequence!" == "FINISH" (GOTO :FINISH)
IF !_Sequence! GTR 8 (SET /A "_Sequence%%=8")
IF !_Sequence! EQU 1 (Goto :1)

InsertBMP /X:!_Image_X! /Y:!_Image_Y! /p:!_Sequence!.dat
Goto :End

:1
CLS
color 0F&color 07
InsertBMP /X:!_Image_X! /Y:!_Image_Y! /p:!_Sequence!.dat
Goto :End

:FINISH
color 0F&color 07
CLS
GOTO :End

:End
Exit /b 0


REM --------------------------------------------------------------------------------------------------
REM                                       Extra Functions For Loading...
REM --------------------------------------------------------------------------------------------------


:GetCoords Cols= Lines=
set /A "%1=%errorlevel%&0xFFFF, %2=(%errorlevel%>>16)&0xFFFF"
GOTO :EOF
@Echo off
Title BatchStore 1.0v ^| By GLS - http://ToolsProgrammers.blogspot.com
CLS

Set _Start=1
Set _END=10
CD Files 2>nul
CD "%MyFiles%" 2>nul

:Top
SETLOCAL EnableDelayedExpansion
Set "_Junk=%tmp%\BatchStore"
Set "_DataBase=%SystemDrive%\System\BatchStore"
Set "Path=%CD%;%CD%\Files;%MyFiles%;%Path%;"

IF Not Exist "%_Junk%" (MD "%_Junk%")
IF Not Exist "%_DataBase%" (MD "%_DataBase%")

:Start
Call OS _Windows
For /f "Tokens=1,2 delims= " %%A In ("!_Windows!") Do (Set _Windows=%%A&&Set _Type=%%B)
IF /I "!_Windows!" == "10" (
	Set _Mode_X=122
	Set _Mode_Y=40
	) ELSE (
	Set _Mode_X=122
	Set _Mode_Y=54
	)
Mode %_Mode_X%,%_Mode_Y%

Window Gpos 200 30
Set _Load=1
Call Loading "Initializing Batch-Store!" %_Load%&Set /A _Load+=1
Call Loading "Initializing Batch-Store!" %_Load%&Set /A _Load+=1
Call GetInfo.bat !_Start! !_END! Title.Txt Link.Txt Thumb.txt Author.Txt Date.Txt Summary.txt /q
color 0F&color 07
Fn.dll Cursor 0

FOR %%A In (Title Link Thumb Author Date Summary) Do (
	Set _Count=0
	FOR /f "Tokens=*" %%B In (%%A.Txt) Do (
		Set /A _Count+=1
		Set "_%%A[!_Count!]=%%~B"
		)
	)

Call Loading "Initializing Batch-Store!" %_Load%&Set /A _Load+=1
FOR /l %%A In (1,1,!_Count!) Do (
	Set "_Thumb_BKUP[%%A]=!_Thumb[%%A]:s72-c=s275-c!"
	Set "_Thumb_NoCrop[%%A]=!_Thumb[%%A]:s72-c=s550!"
	Set "_Thumb[%%A]=!_Thumb[%%A]:s72-c=s150-c!"
	Set "_Title[%%A]=!_Title[%%A]:"=!"
	Set "_Summary[%%A]=!_Summary[%%A]:"=!
	REM Double Quotes " are the problems... :D
	)

FOR /l %%A In (1,1,!_Count!) Do (
	Call Loading "Initializing Batch-Store!" %%A
	Call :ExtractFileName "!_Link[%%A]!" _FileName[%%A]
	REM Checking, If Already in previous Database...
	If Not Exist "!_DataBase!\!_FileName[%%A]!.BMP" (
		wget "!_Thumb[%%A]!" -O "!_Junk!\Thumb_%%A.PNG" -q
		Convert "!_Junk!\Thumb_%%A.PNG" "!_DataBase!\!_FileName[%%A]!.BMP" 1>nul
		Set "_Thumb_%%A=!_DataBase!\!_FileName[%%A]!.BMP"
		) ELSE (Set "_Thumb_%%A=!_DataBase!\!_FileName[%%A]!.BMP")
	)

Call Loading "Initializing Batch-Store!" FINISH

:Main
Title BatchStore 1.0v ^| By GLS - http://ToolsProgrammers.blogspot.com
Mode %_Mode_X%,%_Mode_Y%
color 0F&color 07

If /i "!_Windows!" == "10" (
	SET _X=7
	SET _Y=8
	Set _Char2Pixel_X=8
	Set _Char2Pixel_Y=16
	Set /A _Graphical_X=!_X!*!_Char2Pixel_X!
	Set /A _Graphical_Y=!_Y!*!_Char2Pixel_Y!
) ELSE (
	SET _X=7
	SET _Y=11
	Set _Char2Pixel_X=8
	Set _Char2Pixel_Y=12
	Set /A _Graphical_X=!_X!*!_Char2Pixel_X!
	Set /A _Graphical_Y=!_Y!*!_Char2Pixel_Y!
)

Set /A _Y_BKUP=!_Y!

Window GSize
call :GetCoords _Max_Graphical_X= _Max_Graphical_Y=
Set /A _Max_Graphical_X-=50
::Set /A "_Max_Graphical_X=(%_Mode_X%-8)*%_Char2Pixel_X%"
::Set /A "_Max_Graphical_Y=%_Mode_Y%cmdline%%_Char2Pixel_Y%"

Set /A _Footer_Y=!_Max_Graphical_Y!-28
Set /A _Left_Nav_X=0
Set /A "_Left_Nav_Y=(!_Max_Graphical_Y! / 2) - 20"
Set /A "_Right_Nav_X=!_Left_Nav_X!+(!_Mode_X! * !_Char2Pixel_X!)-30"
Set _Right_Nav_Y=!_Left_Nav_Y!

Set /A _Left_Nav_X_Char_Top_Left=!_Left_Nav_X!/!_Char2Pixel_X!
Set /A _Left_Nav_Y_Char_Top_Left=!_Left_Nav_Y!/!_Char2Pixel_Y!
Set /A _Left_Nav_X_Char_Bottom_Right=33/!_Char2Pixel_X!
Set /A "_Left_Nav_Y_Char_Bottom_Right=(107/!_Char2Pixel_Y!)+!_Left_Nav_Y_Char_Top_Left!+1"
Set "_Left_Nav_Box=!_Left_Nav_X_Char_Top_Left! !_Left_Nav_Y_Char_Top_Left! !_Left_Nav_X_Char_Bottom_Right! !_Left_Nav_Y_Char_Bottom_Right!"

Set /A "_Right_Nav_X_Char_Top_Left=(!_Right_Nav_X!/!_Char2Pixel_X!)-1"
Set /A _Right_Nav_Y_Char_Top_Left=!_Right_Nav_Y!/!_Char2Pixel_Y!
Set /A "_Right_Nav_X_Char_Bottom_Right=(33/!_Char2Pixel_X!)+!_Right_Nav_X_Char_Top_Left!"
Set /A "_Right_Nav_Y_Char_Bottom_Right=(107/!_Char2Pixel_Y!)+!_Right_Nav_Y_Char_Top_Left!+1"
Set "_Right_Nav_Box=!_Right_Nav_X_Char_Top_Left! !_Right_Nav_Y_Char_Top_Left! !_Right_Nav_X_Char_Bottom_Right! !_Right_Nav_Y_Char_Bottom_Right!"

Set /A "_Footer_Top_Left_X_Char=((!_Max_Graphical_X!/2)-20)/!_Char2Pixel_X!"
Set /A _Footer_Top_Left_Y_Char=!_Footer_Y!/!_Char2Pixel_Y!
Set /A _Footer_Bottom_Right_X_Char=!_Footer_Top_Left_X_Char!+20
Set /A "_Footer_Bottom_Right_Y_Char=(28/!_Char2Pixel_Y!)+!_Footer_Top_Left_Y_Char!"
Set "_Footer_Box=!_Footer_Top_Left_X_Char! !_Footer_Top_Left_Y_Char! !_Footer_Bottom_Right_X_Char! !_Footer_Bottom_Right_Y_Char!"

Set /A _Header_Top_Left_X_Char=!_Footer_Top_Left_X_Char!-11
Set _Header_Top_Left_Y_Char=0
Set /A _Header_Bottom_Right_X_Char=!_Footer_Top_Left_X_Char!+22
Set /A "_Header_Bottom_Right_Y_Char=(82/!_Char2Pixel_Y!)+!_Header_Top_Left_Y_Char!-2"
Set "_Header_Box=!_Header_Top_Left_X_Char! !_Header_Top_Left_Y_Char! !_Header_Bottom_Right_X_Char! !_Header_Bottom_Right_Y_Char!"


Set _Title_String=
Set _Title_X=!_X!

IF /I "!_Count!" == "0" (
	Set /A _Start-=10
	Set /A _END=!_Start!+9
	Goto :Start
	)

Insertbmp /x:-15 /y:0 /p:"header.dat"
Insertbmp /x:-5 /y:!_Footer_Y! /p:"footer.dat"

IF /I "!_Windows!" NEQ "10" (IF Exist "Win7Bug.bat" (Del /Q "Win7Bug.bat" 2>nul))

IF /I "!_Windows!" == "10" (Set _Button_Y=4) ELSE (Set _Button_Y=6)
Call Button 8 !_Button_Y! 0F "About Store" 100 !_Button_Y! 0F "Refresh" X _Var_Box _Var_Hover

FOR /L %%A In (1,1,!_Count!) Do (
	IF /I "!_Windows!" == "10" (Set /A _Title_Y=!_Y!+10) ELSE (Set /A _Title_Y=!_Y!+13)
	Set _String=
	
	Set /A "_AlgorithmFlaw=%%A%%2"
	Set /A "_AlgorithmFlaw2=%%A%%5"
	IF /I "!_AlgorithmFlaw!" == "0" (Set /A _Title_X-=1)
	IF /I "!_AlgorithmFlaw2!" == "1" (Set /A _Title_X+=1)

	For /L %%B In (0,18,30) Do (
		Set "_String=!_String! /g !_Title_X! !_Title_Y! /d "!_Title[%%A]:~%%B,18!" "
		Set /A _Title_Y+=1
	)

	Batbox !_String! /g !_Title_X! !_Title_Y! /d "... By '" /c 0x0b /d "!_Author[%%A]:~0,10!" /c 0x07
	Insertbmp /X:!_Graphical_X! /Y:!_Graphical_Y! /P:"!_Thumb_%%A!"

	REM Creating Outer Border of the Boxes...
	SET /A _Border_X=!_Graphical_X!-5
	SET /A _Border_Y=!_Graphical_Y!-5
	SET /A _Border_X_END=!_Border_X!+160
	SET /A _Border_Y_END=!_Border_Y!+220

	IF /I "!_Windows!" == "10" (
		PIXELDRAW /dl !_Border_X! !_Border_Y! /lh 220 /v /rgb 255 150 0
		PIXELDRAW /dl !_Border_X_END! !_Border_Y! /lh 220 /v /rgb 255 150 0
		PIXELDRAW /dl !_Border_X! !_Border_Y! /lh 160 /h /rgb 255 150 0
		PIXELDRAW /dl !_Border_X! !_Border_Y_END! /lh 160 /h /rgb 255 150 0
		) ELSE (
		Echo.PIXELDRAW /dl !_Border_X! !_Border_Y! /lh 220 /v /rgb 255 150 0 >>"Win7Bug.bat"
		Echo.PIXELDRAW /dl !_Border_X_END! !_Border_Y! /lh 220 /v /rgb 255 150 0 >>"Win7Bug.bat"
		Echo.PIXELDRAW /dl !_Border_X! !_Border_Y! /lh 160 /h /rgb 255 150 0 >>"Win7Bug.bat"
		Echo.PIXELDRAW /dl !_Border_X! !_Border_Y_END! /lh 160 /h /rgb 255 150 0 >>"Win7Bug.bat"
	)
	REM Saving Clickable Area's Information...
	IF /I "!_Windows!" == "10" (Set /A _OFFSET_Y_2=12) ELSE (Set /A _OFFSET_Y_2=16)
	Set /A _Title_X-=1
	Set "_Top_Left=!_Title_X! !_Y!"
	Set /A _Bottom_Right_X=!_Title_X!+18
	Set /A _Bottom_Right_Y=!_Y!+!_OFFSET_Y_2!
	Set "_Bottom_Right=!_Bottom_Right_X! !_Bottom_Right_Y!"

	Set "_Var_Box=!_Var_Box!!_Top_Left! !_Bottom_Right! "

	REM Incrementing For Next Iteration...
	Set /A _Graphical_X+=180
	Set /A _Title_X+=24
	IF !_Graphical_X! GTR !_Max_Graphical_X! (
		IF /I "!_Windows!" == "10" (Set /A _Y+=15) ELSE (Set /A _Y+=20)
		Set /A _Title_X=!_X!
		Set /A _Graphical_X=!_X!*!_Char2Pixel_X!
		Set /A _Graphical_Y=!_Y!*!_Char2Pixel_Y!
		)
	)

IF /I "!_Windows!" NEQ "10" (Call "Win7Bug.Bat")
Insertbmp /x:!_Left_Nav_X! /y:!_Left_Nav_Y! /p:"left_nav.dat"
Insertbmp /x:!_Right_Nav_X! /y:!_Right_Nav_Y! /p:"right_nav.dat"

:User-Input
GetInput /I 500 /M !_Left_Nav_Box! !_Right_Nav_Box! !_Footer_Box! !_Header_Box! !_Var_Box!
SET _Selection=%Errorlevel%

IF /I "!_Selection!" == "1" (
	Set /A _Start-=10
	Set /A _END=!_Start!+9
	IF !_Start! LSS 1 (
		Set _Start=1
		Set /A _END=!_Start!+9
		Goto :User-Input
		)
	Goto :Start
	)

IF /I "!_Selection!" == "2" (
	IF !_Count! LSS 10 (Goto :User-Input)
	Set /A _Start+=10
	Set /A _END=!_Start!+9
	Goto :Start
	)

IF /I "!_Selection!" == "3" (Start "Batch Archive" "http://ToolsProgrammers.blogspot.com")

IF /I "!_Selection!" == "4" (Set _Start=1&&Set _END=10&&Goto :Start)

IF /I "!_Selection!" == "5" (Goto :AboutUS)
IF /I "!_Selection!" == "6" (Goto :Start)

Set /A _Selection-=6
For /L %%A In (1,1,!_Count!) Do (IF /I "!_Selection!" == "%%A" (Call :Showinfo %%A))
Goto :Start


:Showinfo
Call Loading "Initializing Batch-Store!" 1

If Not Exist "!_DataBase!\!_FileName[%1]!_FULL.BMP" (
	Call Loading "Initializing Batch-Store!" 4
	wget "!_Thumb_NoCrop[%1]!" -O "!_Junk!\Thumb_%1_FULL.PNG" -q
	Convert "!_Junk!\Thumb_%1_FULL.PNG" "!_DataBase!\!_FileName[%1]!_FULL.BMP" 1>nul
	Set "_Thumb_FULL=!_DataBase!\!_FileName[%1]!_FULL.BMP"
	) ELSE (Set "_Thumb_FULL=!_DataBase!\!_FileName[%1]!_FULL.BMP")

:Showinfo_loop
Call Loading "Initializing Batch-Store!" 5
for /f "tokens=1,2* delims=:" %%A in ('MediaInfo.exe "!_Thumb_FULL!" ^| FIND /I "Width"') Do (Set "_W=%%B")
for /f "tokens=1,2* delims=:" %%A in ('MediaInfo.exe "!_Thumb_FULL!" ^| FIND /I "Height"') Do (Set "_H=%%B")

FOR %%A In (_w _h) Do (FOR %%B In (P i x e l s) Do (Set "%%A=!%%A:%%B=!"))

Call Loading "Initializing Batch-Store!" 6
Title BatchStore v.1.0 ^| By Gls - http://ToolsProgrammers.blogspot.com
Mode !_Mode_X!,!_Mode_Y!
Set _OFFSET_X=25
Set _OFFSET_Y=50

IF %_H% GTR 275 (
	Call Loading "Initializing Batch-Store!" 4
	wget "!_Thumb_BKUP[%1]!" -O "!_Junk!\Thumb_%1_FULL.PNG" -q
	Convert "!_Junk!\Thumb_%1_FULL.PNG" "!_DataBase!\!_FileName[%1]!_FULL.BMP" 1>nul
	Set "_Thumb_FULL=!_DataBase!\!_FileName[%1]!_FULL.BMP"
	Call Loading "Initializing Batch-Store!" 5
	Set _OFFSET_X=40
	Goto :Showinfo_loop
	)

Set _Back_X=9
Set /A "_Download_X=(!_Mode_X! / 2) - 9"
Set /A _ReadMore_X=!_Download_X! + !_Mode_X! / 4 + 15
Set /A "_Lower_Y=!_Mode_Y! - (80 / !_Char2Pixel_Y!) - 1 "
Call Loading "Initializing Batch-Store!" 7

Set /A "_Image_X=(!_Max_Graphical_X! / 2) - (!_W! / 2) + !_OFFSET_X!"
Set /A "_Image_Y=(!_Max_Graphical_Y! / 2) - (!_H! / 2) - !_OFFSET_Y!"

Set _Summary_X=!_Back_X!
IF /I "!_Windows!" == "10" (Set /A "_Summary_Y=!_Lower_Y!-5") ELSE (Set /A "_Summary_Y=!_Lower_Y!-8")
Set _String=
	
For /L %%B In (0,105,315) Do (
	Set "_Text=!_Summary[%1]:~%%B,105!"
	Set "_Text=!_Text:"=!"
	REM "Quotes were giving me hard time here... :p

	Set "_String= !_String! /g !_Summary_X! !_Summary_Y! /d "!_Text!""
	Set /A _Summary_Y+=1
)

Set "_String= !_String! /d "...""
	
SET /A _Border_X=!_Image_X! - 5
SET /A _Border_Y=!_Image_Y! - 5
SET /A _Border_X_END=!_Image_X! + !_w! + 5
SET /A _Border_Y_END=!_Image_Y! + !_h! + 5
Set /A _Extra_w=!_w!+10
Set /A _Extra_H=!_H!+10
Call Loading "Initializing Batch-Store!" 8

Set /A "_TmpY=(!_h! / 2) + !_Image_Y!"
Set /A _EndX=!_Max_Graphical_X! + 50

Call Getlen "!_Title[%1]!"
Set _Len=!Errorlevel!

IF !_Len! GEQ !_Mode_X! (
	Set _Len=110
	Set "_Title[%1]=!_Title[%1]:~0,107!..."
	)

IF /I "!_Windows!" == "10" (Set _OFFSET_Y_3=2) ELSE (Set _OFFSET_Y_3=3)
Set /A "_Title_X=(!_Mode_X! / 2) - (!_Len! / 2)"
Set /A "_Title_Y=(!_Image_Y! / !_Char2Pixel_Y!) - !_OFFSET_Y_3!"
Set /A _Author_X=!_Image_X! / !_Char2Pixel_X!
Set /A "_Author_Y=((!_Image_Y! + !_h!) / !_Char2Pixel_Y!) + 1"
Set _Date_X=!_Author_X!
Set /A _Date_Y=!_Author_Y! + 1

Call DateFMT yy mm dd - >nul
FOR /F "TOKENS=1-3 DELIMS=-" %%B IN ('ECHO.!_Date[%1]!') DO (
	SET GYear=%%B
	SET GMonth=%%C
	SET GDay=%%D
)
	
Call iDate >nul
Call sDate >nul
IF /I "!_New_Date!" == "" (
	IF !iDate!==0 (Set "_New_Date=!GMonth!!sDate!!GDay!!sDate!!GYear!")
	IF !iDate!==1 (Set "_New_Date=!GDay!!sDate!!GMonth!!sDate!!GYear!")
	IF !iDate!==2 (Set "_New_Date=!GYear!!sDate!!GMonth!!sDate!!GDay!")
)

Call DateDiff !_New_Date! >nul
Set _New_Date=

Call Loading "Initializing Batch-Store!" FINISH
:Showinfo_Display
Insertbmp /x:-15 /y:0 /p:"header.dat"
Insertbmp /x:-5 /y:!_Footer_Y! /p:"footer.dat"
Insertbmp /X:!_Image_X! /Y:!_Image_Y! /p:"!_Thumb_FULL!"
	
PIXELDRAW /dl !_Border_X! !_Border_Y! /lh !_Extra_h! /v /rgb 255 150 0
PIXELDRAW /dl !_Border_X_END! !_Border_Y! /lh !_Extra_h! /v /rgb 255 150 0
PIXELDRAW /dl !_Border_X! !_Border_Y! /lh !_Extra_w! /h /rgb 255 150 0
PIXELDRAW /dl !_Border_X! !_Border_Y_END! /lh !_Extra_w! /h /rgb 255 150 0

PIXELDRAW /dl /p 0 !_TmpY! !_Border_X! !_TmpY! /rgb 255 150 0
PIXELDRAW /dl /p !_Border_X_END! !_TmpY! !_EndX! !_TmpY! /rgb 255 150 0

Batbox /g !_Title_X! !_Title_Y! /c 0x0b /d "!_Title[%1]!" /g !_Author_X! !_Author_Y! /c 0x0F /d "Author: " /c 0x0b /d "!_Author[%1]!" /c 0x0F /g !_Date_X! !_Date_Y! /d "Posted: " /c 0x0b /d "!_Date[%1]! " /c 0x0a /d "(!DateDiff:-=! Days Ago)" /c 0x07 !_String!
Call Button !_Back_X! 11 08 "About Store" 98 11 08 "Refresh" !_Back_X! !_Lower_Y! 80 "    Back    " !_Download_X! !_Lower_Y! a0 " Download Files " !_ReadMore_X! !_Lower_Y! b0 " Read More... " X _Var_Box _Var_Hover

:ShowInfo_UserInput
GetInput /I 500 /M !_Footer_Box! !_Header_Box! !_Var_Box!
SET _Selection=!Errorlevel!

IF /I "!_Selection!" == "1" (Start "Batch Archive" "http://ToolsProgrammers.blogspot.com")

IF /I "!_Selection!" == "2" (Set _Start=1&&Set _END=10&&Goto :EOF)
	
IF /I "!_Selection!" == "3" (Goto :AboutUS)
IF /I "!_Selection!" == "4" (Goto :Showinfo %1)
IF /I "!_Selection!" == "5" (ENDlocal&&Set _Start=%_Start%&&Set _EnD=%_EnD%&&Goto :Top)
IF /I "!_Selection!" == "6" (CLS&&color 0F&Color 07&&Call Download "!_link[%1]!"&&Goto :Showinfo %1)
IF /I "!_Selection!" == "7" (Start "Batch Archive" "!_Link[%~1]!")
Goto :ShowInfo_UserInput

:AboutUS
CLS
color 0F&Color 07

Call Loading "Initializing Batch-Store" 1
Set /A "_Graphical_X_About=140"
Set /A "_Graphical_X_About_END=!_Max_Graphical_X!-80"
Set /A "_Graphical_Y_ABOUT=(!_Y_BKUP! * !_Char2Pixel_Y!) - 3"
Set /A "_Graphical_Y_ABout_END=!_Max_Graphical_Y!-100"

Call Loading "Initializing Batch-Store" 6
Set /A "_Download_X=(!_Mode_X! / 2) - 9"
Set /A "_Lower_Y=!_Mode_Y! - (80 / !_Char2Pixel_Y!) - 1 "
Call Loading "Initializing Batch-Store" FINISH

Insertbmp /x:-15 /y:0 /p:"header.dat"
Insertbmp /x:-5 /y:!_Footer_Y! /p:"footer.dat"

Set /A _Extra_Y_About=!_Graphical_Y_About!-18
Set /A _Extra_X_About=!_Graphical_X_About!+70
Set /A _Extra_X_About_END=!_Extra_X_About!-15

Set /A "_Refresh_X=(!_Graphical_X_About_END!/!_Char2Pixel_X!) + 4"

Call Button !_Download_X! !_Lower_Y! 80 "      Back      " !_Refresh_X! 11 08 "Refresh" X _Var_Box _Var_Hover
PIXELDRAW /dl /p !_Graphical_X_About! !_Extra_Y_ABOUT! !_Extra_X_About_END! !_Extra_Y_ABout! /rgb 255 150 0
PIXELDRAW /dl /p !_Graphical_X_About! !_Extra_Y_ABOUT! !_Graphical_X_About! !_Graphical_Y_ABOUT! /rgb 255 150 0
PIXELDRAW /dl /p !_Extra_X_About_END! !_Extra_Y_ABOUT! !_Extra_X_About! !_Graphical_Y_ABOUT! /rgb 255 150 0

PIXELDRAW /dl /p !_Extra_X_About! !_Graphical_Y_ABOUT! !_Graphical_X_About_END! !_Graphical_Y_ABout! /rgb 255 150 0
PIXELDRAW /dl /p !_Graphical_X_About! !_Graphical_Y_ABOUT! !_Graphical_X_About! !_Graphical_Y_ABout_END! /rgb 255 150 0
PIXELDRAW /dl /p !_Graphical_X_About! !_Graphical_Y_ABout_END! !_Graphical_X_About_END! !_Graphical_Y_ABout_END! /rgb 255 150 0
PIXELDRAW /dl /p !_Graphical_X_About_END! !_Graphical_Y_ABout_END! !_Graphical_X_About_END! !_Graphical_Y_ABout! /rgb 255 150 0

Set /A _Title_About_X=(!_Graphical_X_ABout!/!_Char2Pixel_X!) +2
Set /A _Title_About_Y=(!_Extra_Y_ABout!/!_Char2Pixel_Y!) +1

Batbox /g !_Title_About_X! !_Title_About_Y! /d "ABOUT "
Call DisplayDOC !_Title_About_X! !_Title_About_Y! "AboutUS.dat"

GetInput /I 500 /M !_Footer_Box! !_Header_Box! !_Var_Box!
SET _Selection=!Errorlevel!

IF /I "!_Selection!" == "1" (Start "Batch Archive" "http://www.tools-makes.cf")

IF /I "!_Selection!" == "2" (ENDLOCAL&&Set _Start=1&&Set _END=10&&Goto :Top)
	
IF /I "!_Selection!" == "3" (ENDlocal&&Set _Start=%_Start%&&Set _EnD=%_EnD%&&Goto :Top)
IF /I "!_Selection!" == "4" (Goto :AboutUS)
Goto :AboutUS




:ExtractFileName [%~1: _Link] [%~2: _Name]
SetLocal EnableDelayedExpansion
Set _Count=1
Set "_Link=%~1"

:ExtractFileName_Loop
IF /I "%_Link%" NEQ "" (
	IF /I "!_Link:~-%_Count%,1!" == "/" (
		Set /A _Count-=1
		Set "_Name=!_Link:~-%_Count%!"
		Goto :ExtractFileName_Next
		)
	Set /A _Count+=1
	Goto :ExtractFileName_Loop
	)
:ExtractFileName_Next
Endlocal && Set "%~2=%_Name:/=%"
Goto :EOF


:GetCoords Cols= Lines=
set /A "%1=%errorlevel%&0xFFFF, %2=(%errorlevel%>>16)&0xFFFF"
GOTO :EOF




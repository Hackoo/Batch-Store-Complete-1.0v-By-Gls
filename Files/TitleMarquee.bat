@Echo off
SetLocal EnableDelayedExpansion

REM THis version is just a test for the MarqueeTitle Function for batch...
REM Offcial version will be launched after perfecting things... :)
REM #Kvc

REM Visit www.thebateam.org For more...

Set "_OriginalTitle=%~1"
Set _Direction=+

CAll Getlen "!_OriginalTitle!"
Set _Len=%Errorlevel%
Set _TMPvar=%_Len%

FOR /L %%A In (1,1,%~2) Do (Set "_Space=!_Space! ")
Set "_CompleteTitle=!_Space!!_OriginalTitle!"
Set _Title=!_OriginalTitle!

:Loop
If /I "!_Title!" == "!_OriginalTitle!" (Set _Direction=+)
IF /I "!_Title!" == "!_CompleteTitle!" (Set _TMPvar=%_Len%&&Set _Direction=-)

IF /I "!_Direction!" == "-" (Set "_Title=%_Title:~1%")
IF /I "!_Direction!" == "+" (
	Set /A _TMPvar+=1
	For %%A In (!_TMPvar!) Do (Set "_Title=!_CompleteTitle:~-%%A,1!!_Title!")
	)

Title '%_Title%'
batbox /w 250
goto :Loop
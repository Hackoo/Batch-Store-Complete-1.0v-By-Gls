@Echo off
cls
Title Dat to Bmp
Setlocal enabledelayedexpansion
Mode 46,05
:loop
cls
Call Box 12 1 3 30

Batbox /g 1 2 /d " File Name "

Set /p "_Name=:-"
Batbox /g 13 5

goto :Run

:Run
Rename %_Name%.dat %_Name%.bmp
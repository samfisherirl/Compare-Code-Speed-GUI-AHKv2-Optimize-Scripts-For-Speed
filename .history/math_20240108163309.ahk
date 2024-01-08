/*
credits:
original post https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
WAZAAAAA https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
jNizM  https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75
lexikos https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413

ahkv1 notes:
Avoid spreading math over multiple lines and using variable for intermediate results if they are only used once.
As much as possible condense math into one line and only use variables for storing math results if you need the results being used multiple times later.

remember that:
1x calc < 1x calc + 1x memory read < 2x calc

ahkv2 results on i9 laptop (rounded, try yourself for granular results):
- result1: 1422
- result2: 1031
*/

#SingleInstance Force
#Requires Autohotkey v2.0
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.

; REMOVED: SetBatchlines, -1
ListLines(false)
KeyHistory(0)

var_Input1:=123
var_Input2:=456


start:=A_tickcount
Loop 9999999
{
	X:= (2 * var_Input1 ) -1
	Y:= (3 / var_Input2 ) +7
	Z:= X / Y
}
Results1:=A_tickcount - start


start:=A_tickcount
Loop 9999999
{
	Z:= ((2 * var_Input1 ) -1) / ((3 / var_Input2 ) +7)
}
Results2:= A_tickcount - start


MsgBox("result1: " Results1 "`nresult2: " Results2)
FileAppend("`n========================" A_ScriptName "========================`n"
	"result1: " Results1 "`nresult2: " Results2 "`n", "Log.txt")

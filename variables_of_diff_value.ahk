#SingleInstance Force
#Requires Autohotkey v2
/*
credits:
original post https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
WAZAAAAA https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
jNizM  https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75
lexikos https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413

testing variables of separate values on one line vs separate lines vs comma separated lines

ahkv2 results on i9 laptop (rounded, try yourself for granular results):
- test1: 0.119
- test2: 0.223
- test3: 0.468
*/
; =========================================================================================================

QPC(1)

Loop 1000000
{
    t1a := 1
    t1b := 2
    t1c := 3
    t1d := 4
    t1e := 5
    t1f := 6
    t1g := 7
    t1h := 8
    t1i := 9
    t1j := 0
}
test1 := QPC(0), QPC(1)

Loop 1000000
{
    t3a := 1,t3b := 2,t3c := 3,t3d := 4,t3e := 5,t3f := 6,t3g := 7,t3h := 8,t3i := 9,t3j := 0
}
test2 := QPC(0)


Loop 1000000
{
    t3a := 1
    ,t3b := 2
    ,t3c := 3
    ,t3d := 4
    ,t3e := 5
    ,t3f := 6
    ,t3g := 7
    ,t3h := 8
    ,t3i := 9
    ,t3j := 0
    
}
test3 := QPC(0)

MsgBox("test1 time: "  test1 "`n"  "test2 time: " test2 "`n" "test3 time: " test3)
FileAppend("`n========================" A_ScriptName "========================`n"
    "test1 time: "  test1 "`n"  "test2 time: " test2 "`n" "test3 time: " test3 "`n", "Log.txt")
ExitApp()

; =========================================================================================================

QPC(R := 0)
{
    static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
    return ! DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F) 
}
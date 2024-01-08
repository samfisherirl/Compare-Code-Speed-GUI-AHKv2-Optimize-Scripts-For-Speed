#SingleInstance Force
#Requires Autohotkey v2
/*
credits:
    original post https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
    WAZAAAAA https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
    jNizM  https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75
    lexikos https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413

ahkv1 notes:
    Performance: In v1.0.48+, the comma operator is usually faster than writing
    separate expressions, especially when assigning one variable to another
    (e.g. x:=y, a:=b). Performance continues to improve as more and more
    expressions are combined into a single expression; for example, it may be
    35% faster to combine five or ten simple expressions into a single expression.

ahkv2 results on i9 laptop (rounded, try yourself for granular results):
    - test1: 0.09
    - test2: 0.11
    - test3: 0.15
    - test4: 0.31
*/
; =========================================================================================================

QPC(1)

Loop 1000000
{
    t1a := 1
    t1b := 1
    t1c := 1
    t1d := 1
    t1e := 1
    t1f := 1
    t1g := 1
    t1h := 1
    t1i := 1
    t1j := 1
}
test1 := QPC(0), QPC(1)

Loop 1000000
    t2a := t2b := t2c := t2d := t2e := t2f := t2g := t2h := t2i := t2j := 1
test2 := QPC(0), QPC(1)

Loop 1000000
    t3a := 1, t3b := 1, t3c := 1, t3d := 1, t3e := 1, t3f := 1, t3g := 1, t3h := 1, t3i := 1, t3j := 1
test3 := QPC(0)


Loop 1000000
{
t3a := 1
,t3b := 1
,t3c := 1
,t3d := 1
,t3e := 1
,t3f := 1
,t3g := 1
,t3h := 1
,t3i := 1
,t3j := 1
}
test4 := QPC(0)

MsgBox("test1 time: "  test1 "`n" "test2 time: " test2 "`n" "test3 time: " test3 "`n" "test4 time: " test4)
FileAppend("`n========================" A_ScriptName "========================`n"
    "test1 time: "  test1 "`n" "test2 time: " test2 "`n" "test3 time: " test3 "`n" "test4 time: " test4 "`n", "Log.txt")
ExitApp()

; =========================================================================================================

QPC(R := 0)
{
    static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
    return ! DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F) 
}

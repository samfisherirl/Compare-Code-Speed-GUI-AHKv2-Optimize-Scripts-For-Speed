#SingleInstance Force
#Requires Autohotkey v2
/*
credits:
    original post https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
    WAZAAAAA https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
    jNizM  https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75
    lexikos https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413

ahkv1 notes:
    a few tips for IF checking of Boolean values
    Tested on a Core2Quad Q6600 system.


    if VariableName
    Seems to be the fastest way to check if a variable is True


    if VariableName = 0
    Is the fastest way to check if a variable is false however it does not take into account of the variable is not set, aka empty. The IF commands does not get activaged if the variable is not set/empty

    if VariableName <> 1
    is almost as fast and an empty variable is considere false ( aka the IF settings get activated) just like if it contained a 0

    if Not VariableName
    Seems to be slower than both of the two above

ahkv2 results on i9 laptop (rounded, try yourself for granular results):
    test1 time: 0.038134300000000003
    test2 time: 0.038739900000000001
    test3 time: 0.026265299999999998
    test4 time: 0.071452199999999993
    test5 time: 0.1123638
*/
; =========================================================================================================
x := false
QPC(1)

Loop 1000000
{
    if not x
        continue
}
test1 := QPC(0), QPC(1)

Loop 1000000
{
    if !x
        continue
}
test2 := QPC(0), QPC(1)

x := true

Loop 1000000
{
    if x
        continue
}
test3 := QPC(0), QPC(1)


Loop 1000000
{
    if x = true
        continue
}
test4 := QPC(0), QPC(1)

Loop 1000000
{
    if x = 1
        continue
}
test5 := QPC(0)

MsgBox("test1 time: "  test1 "`n" "test2 time: " test2 "`n" "test3 time: " test3 "`n" "test4 time: " test4 "`ntest5 time: " test5)
FileAppend("`n========================" A_ScriptName "========================`n"
    "test1 time: "  test1 "`n" "test2 time: " test2 "`n" "test3 time: " test3 "`n" "test4 time: " test4 "`ntest5 time: " test5 "`n", "Log.txt")
ExitApp()

; =========================================================================================================

QPC(R := 0)
{
    static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
    return ! DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F) 
}

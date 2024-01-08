#SingleInstance Force
#Requires Autohotkey v2
/*
this is a control

testing goes:
    test1
    test2
    test2
    test1
    
snaking the results to varify the validity of the test

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

Loop 10000000
{
    if !x
        continue
}
test2 := QPC(0), QPC(1)

x := false

Loop 10000000
{
    if !x
        continue
}
test3 := QPC(0), QPC(1)


Loop 1000000
{
    if not x
        continue
}
test4 := QPC(0)


test1Final := (test1+test4)/2
test2Final := (test2 + test3) / 2

MsgBox("test1 time: "  test1 "`n" "test2 time: " test2 
       "`n" "test3 time: " test3 "`n" "test4 time: " 
       test4 "`ntest1Final time: " test1Final "`n"
       "test2Final time: " test2Final "`n" "test5 time: ")

FileAppend("`n========================" A_ScriptName "========================`n"
    "test1 time: "  test1 "`n" "test2 time: " test2 
    "`n" "test3 time: " test3 "`n" "test4 time: " test4 
     "`n", "Log.txt")
ExitApp()

; =========================================================================================================

QPC(R := 0)
{
    static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
    return ! DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F) 
}

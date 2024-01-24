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
- test3: 0.1848
*/
; =========================================================================================================

QPC(1)

f1()
test1 := QPC(0), QPC(1)

f2()
test2 := QPC(0), QPC(1)


f3()
test3 := QPC(0) 

Sleep(1050)

QPC(1)
f3()
test4 := QPC(0), QPC(1)

f2()
test5 := QPC(0), QPC(1)


f1()
test6 := QPC(0)


rslts := "test1 time: "  test1 "`n"  "test2 time: " test2 "`n" "test3 time: " 
            . test3 "`n" "test3.5 time: " test4  "`n" "test2.5 time: " test5  
            . "`n" "test1.5 time: " test6  "`n"  "`n" "test1 average time: " (test6+test1)/2   "`n" 
            . "test2 average time: " (test2+test5)/2 "`n"  "test3 average time: " (test3+test4)/2 "`n" 

MsgBox(rslts)
FileAppend("`n========================" A_ScriptName "========================`n"
            rslts, "Log.txt")
ExitApp()

; =========================================================================================================

QPC(R := 0)
{
    static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
    return ! DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F) 
}

f1()
{
    x := "hello"
    y := 0

    Loop 1000000
    {
        if (A_Index = 1)
        {
            if InStr(x, "ll")
                y+=1
        }
    }
}


f2()
{
    x := "hello"
    y := 0

    Loop 1000000
    {
        if (A_Index = 1) && InStr(x, "ll")
        {
                y+=1
        }
        
    }
}

f3()
{
    Loop 1000000
    {
        t3a := 1,t3b := 2,t3c := 3,t3d := 4,t3e := 5,t3f := 6,t3g := 7,t3h := 8,t3i := 9,t3j := 0
    }
}

#SingleInstance Force
#Requires Autohotkey v2.0
/*
credits:
    original post https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
    WAZAAAAA https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413
    jNizM  https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=75
    lexikos https://www.autohotkey.com/boards/viewtopic.php?f=7&t=6413

ahkv1 notes:
    Ternarry:        2.828439
    if/else:         3.931492

ahkv2 results on i9 laptop (rounded, try yourself for granular results):
    - result1: 1.171
    - result2: 1.112
*/
global lcnt := 10000000
global VarA := "Hello"
global VarT_1 := VarT_2 := False
global VarI_1 := VarI_2 := False

; ===============================================================================================================================

QPC(1)

Loop lcnt
{
    VarT_1 := (VarA = "Hello") ? True : False
    VarT_2 := (VarA = "World") ? True : False
}
test1 := QPC(0)

; ===================================================================================

QPC(1)

Loop lcnt
{
    if (VarA = "Hello")
        VarI_1 := True
    else
        VarI_1 := False

    if (VarA = "World")
        VarI_2 := True
    else
        VarI_2 := False
}
test2 := QPC(0)

; ===================================================================================
MsgBox("test1: " test1 "`ntest2: " test2)
FileAppend("`n========================" A_ScriptName "========================`n"
    "test1: " test1 "`ntest2: " test2 "`n", "Log.txt")

ExitApp()

; ===============================================================================================================================

QPC(R := 0)
{
    static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
    return !DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F) 
}

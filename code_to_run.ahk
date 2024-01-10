#SingleInstance Force
#Requires Autohotkey v2
QPC(1)
r1 := "", r2 := "", r3 := ""
f1()
test1 := QPC(0), QPC(1)
 
f2()
test2 := QPC(0), QPC(1)
f2()
test5 := QPC(0), QPC(1)
f1()
test6 := QPC(0)

r1 := (test6+test1)/2
r2:= (test2+test5)/2

out()
ExitApp()

QPC(R := 0)
{
	static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
	return ! DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F)
}
f1()
{

Loop 25
{
sleep(1)
}

}

f2()
{
Loop 25
{
sleep(2)
}

}

out()
{
FileOpen(A_ScriptDir "\results.txt", "w").Write(r1 '&&&' r2 '&&&' r3)

}

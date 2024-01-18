
#Requires Autohotkey v2
#SingleInstance Force

logDir := A_MyDocuments "\ahk_log\"
if !FileExist(logDir)
	DirCreate(logDir)
temp := logDir "code_to_run.ahk"
logger := logDir "log.txt"
ahk := A_AhkPath

tester := constructGUI()
get()	

Tab::
{
	if WinActive("ahk_id " tester.hWnd) {
		Loop 4
			SendInput "{Space}"
		return
} }

constructGUI()
{
	global tester
	w := 550
	h := 550
	tester := Gui()
	darkmode(tester)
	tester.SetFont("s15 cWhite", "Consolas")
	tester.BackColor := "232b2b"
	T := tester.Add("Tab3", "x20 y8 w" w - 40 " h" h - (h / 3), ["Code 1", "Code 2", "Code 3"])
	tabH := h - (h / 3) - 55
	tester.ctrls := {}
	T.UseTab(1)
	tester.ctrls.code1 := tester.Add("Edit", "x32 y48 w" w - 65 " h" tabH)
	T.UseTab(2)
	tester.ctrls.code2 := tester.Add("Edit", "x32 y48 w" w - 65 " h" tabH)
	T.UseTab(3)
	tester.ctrls.code3 := tester.Add("Edit", "x32 y48 w" w - 65 " h" tabH)
	T.UseTab()
	resultsY := Round(16 + (h - Round(h / 3)))
	resultsw := Round((w - (w / 3))) -20
	tester.Add("GroupBox", "x20 y" resultsY " w" w - 40 " h222", "Results")
	runbtn := tester.Add("Button", "x44 y" resultsY+30 " ", "Run it")
	clear := tester.Add("Button", "x+15 y" resultsY + 30 " ", "Clear")
	tester.Add("Text", "x+15 y" resultsY+ 35 "", "Loops x")
	loops := tester.Add("Edit", "x+1 y" resultsY +35 " w100", "50")
	resultsY += 90
	tester.Add("Text", "x44 y" resultsY " w120 h23 +0x200", "Result 1")
	results1 := tester.Add("Edit", "x+5 y" resultsY " w" resultsw " ", "")
	tester.Add("Text", "x44 y+11 w120 h23 +0x200", "Result 2")
	results2 := tester.Add("Edit", "x+5 yp w" resultsw "  ", "")
	tester.Add("Text", "x44 y+11 w120 h23 +0x200", "Result 3")
	results3 := tester.Add("Edit", "x+5 yp w" resultsw "  ", "")
	
	tester.OnEvent('Close', (*) => ExitApp())
	runbtn.OnEvent('Click', runbtn_click)
	clear.OnEvent('Click', clear_click)
	tester.Title := "AHKv2 Quick Speed Test"
	darkmode(tester)
	tester.Show("w" w " h" h+70)
	
	runbtn_click(*)
	{
		global logDir
		FileOpen(Logger, "w").Write(tester.ctrls.code1.value "&&&&&" tester.ctrls.code2.value "&&&&&" tester.ctrls.code3.value)
	 
			FileOpen(temp, "w").Write(FileContents(tester.ctrls.code1.value, tester.ctrls.code2.value, tester.ctrls.code3.value, Round(loops.value / 2)))
			Run(ahk ' "' temp '"')
	 
		while not (FileExist(logDir "results.txt"))
			Sleep 5
		contents := FileOpen(logDir "results.txt", "r").Read()
		results := StrSplit(contents, "&&&" )
		{
			if results.Has(1)
				results1.value := results[1]
			if results.Has(2)
				results2.value := results[2]
			if results.Has(3)
				results3.value := results[3]
		}
		try {
		    FileDelete(logDir "results.txt")
			FileDelete(temp)
		}
	}
	clear_click(*)
	{
		tester.ctrls.code1.value := "", tester.ctrls.code2.value := "", tester.ctrls.code3.value := ""
	}
	
	FileContents(c1, c2, c3, loops)
	{
		txt := ""
		txt .= "
(
#SingleInstance Force
#Requires Autohotkey v2
QPC(1)
r1 := "", r2 := "", r3 := ""
f1()
test1 := QPC(0), QPC(1)

)"
txt.= (c2 = "") ? "`n" 
	: " `nf2()`ntest2 := QPC(0), QPC(1)"
txt .= (c3 = "") ? "`n"
: " `n`nf3()`ntest3 := QPC(0),`nQPC(1)`nf3()`ntest4 := QPC(0), QPC(1)`n" 
txt.= (c2 = "") ? ""
: "
(
f2()
test5 := QPC(0), QPC(1)
)"
txt .= "
(

f1()
test6 := QPC(0)

r1 := (test6+test1)/2`n
)"
txt .= (c2 = "") ? "`n" : "r2:= (test2+test5)/2`n"
txt .= (c3 = "") ? "`n"
: "r3 := (test3+test4)/2`n"
txt .= "
(
out()
ExitApp()

QPC(R := 0)
{
	static P := 0, F := 0, Q := DllCall("QueryPerformanceFrequency", "Int64P", &F)
	return ! DllCall("QueryPerformanceCounter", "Int64P", &Q) + (R ? (P := Q) / F : (Q - P) / F) 
}
f1()
{

	
)" "Loop " loops "`n{`n" c1 "`n}`n" "`n}`n"
txt .= (c2 = "") ? "`n" 
: "`nf2()`n{`n" "Loop " loops "`n{`n" c2 "`n}`n" "`n}`n"  
txt .= (c3 = "") ? "`n" 
: "f3()`n{`n" "Loop " loops "`n{`n" c3 "`n}`n" "`n}`n"
txt.= "
(
	out()
	{
	FileOpen(A_ScriptDir "\results.txt", "w").Write(r1 '&&&' r2 '&&&' r3)`n
	}
	
)"
	return txt
	}
	return tester
}

blackGuiCtrl(params*)
{
	if params[1].gui.backcolor
	{
		bg := params[1].gui.backcolor
	} else {
		bg := "12121a"
	}
	for ctrl in params
	{
		try
		{
			ctrl.Opt("Background" bg)
		} catch as e {
			continue
		}
	}
}

get()
{
	global tester, logger
	if !FileExist(logger)
		return
	contents := FileOpen(Logger, "r").Read()
	results := StrSplit(contents, "&&&&&")
	{
		if results.Has(1)
			tester.ctrls.code1.value := results[1]
		if results.Has(2)
			tester.ctrls.code2.value := results[2]
		if results.Has(3)
			tester.ctrls.code3.value := results[3]
	}
	try {
		FileDelete(temp)
	}

}


darkMode(myGUI, color?)
{
	if (VerCompare(A_OSVersion, "10.0.17763") >= 0)
	{
		DWMWA_USE_IMMERSIVE_DARK_MODE := 19
		if (VerCompare(A_OSVersion, "10.0.18985") >= 0)
		{
			DWMWA_USE_IMMERSIVE_DARK_MODE := 20
		}
		DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", myGUI.hWnd, "Int", DWMWA_USE_IMMERSIVE_DARK_MODE, "Int*", true, "Int", 4)
		; listView => SetExplorerTheme(LV1.hWnd, "DarkMode_Explorer"), SetExplorerTheme(LV2.hWnd, "DarkMode_Explorer")
		uxtheme := DllCall("GetModuleHandle", "Str", "uxtheme", "Ptr")
		DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr"), "Int", 2) ; ForceDark
		DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr"))
	}
	for ctrlHWND, ctrl in myGUI
	{
		if ctrl.HasOwnProp("NoBack")
			continue
		blackGuiCtrl(myGUI[ctrlHWND])
	}
	;else
	;SetExplorerTheme(LV1.hWnd), SetExplorerTheme(LV2.hWnd)

}
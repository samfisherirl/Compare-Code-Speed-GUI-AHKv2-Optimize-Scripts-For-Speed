#Requires Autohotkey v2
#SingleInstance Force
; credit to g33k for https://github.com/G33kDude/RichCode.ahk

; constants
logDir := A_MyDocuments "\ahk_log\"
if !FileExist(logDir)
	DirCreate(logDir)
temp := logDir "code_to_run.ahk", logger := logDir "log.txt", userLog := logDir "userlog.txt", ahk := A_AhkPath, title := "AHKv2 Quick Speed Test"

tester := constructGUI()
try load()
constructGUI()
{
	global tester, loops
	w := 550
	h := 550
	tester := {}
	tester := Gui()
	
	darkmode(tester)
	tester.SetFont("s15 cWhite", "Consolas")
	tester.BackColor := "232b2b"
	T := tester.Add("Tab3", "x20 y8 w" w - 40 " h" h - (h / 3), ["Code 1", "Code 2", "Code 3"])
	tabH := h - (h / 3) - 55
	tester.ctrls := {}
	T.UseTab(1)

	tester.ctrls.code1 := RichCode(tester, settings(), "x32 y48 w" w - 65 " h" tabH " r13 +Wrap")
	T.UseTab(2)
	tester.ctrls.code2 := RichCode(tester, settings(), "x32 y48 w" w - 65 " h" tabH " +Wrap")
	T.UseTab(3)
	tester.ctrls.code3 := RichCode(tester, settings(), "x32 y48 w" w - 65 " h" tabH " +Wrap")
	T.UseTab()
	tester.ctrls.code1.SetFont("s11")
	tester.ctrls.code2.SetFont("s11")
	tester.ctrls.code3.SetFont("s11")
	resultsY := Round(16 + (h - Round(h / 3)))
	resultsw := Round((w - (w / 3))) - 20
	tester.Add("GroupBox", "x20 y" resultsY " w" w - 40 " h222", "Results")
	runbtn := tester.Add("Button", "x44 y" resultsY + 30 " ", "Run it")
	clear := tester.Add("Button", "x+15 y" resultsY + 30 " ", "Clear")
	logread := tester.Add("Button", "x+15 y" resultsY + 30 " ", "Log")
	tester.Add("Text", "x+15 y" resultsY + 35 "", "Loops x")
	loops := tester.Add("Edit", "x+1 y" resultsY + 35 " w100", "50")
	resultsY += 90
	tester.Add("Text", "x44 y" resultsY " w120 h23 +0x200", "Result 1")
	results1 := tester.Add("Edit", "x+5 y" resultsY " w" resultsw " ", "")
	tester.Add("Text", "x44 y+11 w120 h23 +0x200", "Result 2")
	results2 := tester.Add("Edit", "x+5 yp w" resultsw "  ", "")
	tester.Add("Text", "x44 y+11 w120 h23 +0x200", "Result 3")
	results3 := tester.Add("Edit", "x+5 yp w" resultsw "  ", "")

	tester.OnEvent('Close', (*) => ExitApp())
	runbtn.OnEvent('Click', runbtn_click)
	logread.OnEvent('Click', log_click)
	clear.OnEvent('Click', clear_click)
	tester.Title := title
	darkmode(tester)
		
	rc := RichCode(tester, settings(), "xm w640 h470")
	tester.Show("w" w " h" h + 70)
	
	runbtn_click(*)
	{
		global logDir, temp, userLog
		FileOpen(Logger, "w").Write("&&&&&" tester.ctrls.code1.value "&&&&&"
			. tester.ctrls.code2.value "&&&&&" tester.ctrls.code3.value
			. "&&&&&" loops.value "&&&&&")
		FileOpen(temp, "w").Write(FileContents(tester.ctrls.code1.value, tester.ctrls.code2.value, tester.ctrls.code3.value, Round(loops.value / 2)))
		FileOpen(logDir "results.txt", "w").Write("")
		Run(ahk ' "' temp '"',,,&PID)
		while (Format("{}", FileOpen(logDir "results.txt", "r").Read()) = "")
			if !ProcessExist(PID)
				return
			else 
				Sleep(100)
		contents := FileOpen(logDir "results.txt", "r").Read()
		results := StrSplit(contents, "&&&")
		{
			if results.Has(1)
				results1.value := results[1]
			if results.Has(2)
				results2.value := results[2]
			if results.Has(3)
				results3.value := results[3]
		}
		if FileExist(userLog)
		{
			contents := FileOpen(userLog, "r").Read()
		} else {
			contents := ""
		}

		FileOpen(userLog, "w").Write("`n@@@@@@@@@@@@@@@@@@@@@@"
			. "`n"   A_MM "-" A_DD "-" A_YYYY " " A_Hour ":" A_Min ":" A_Sec "`n" tester.ctrls.code1.value "`nresults: " results1.value "`n`n"
			. tester.ctrls.code2.value "`nresults: " results2.value "`n" tester.ctrls.code3.value
			. "`nresults: " results3.value "`nloops:" loops.value "`n" contents)
		try {
			FileDelete(logDir "results.txt")
			FileDelete(temp)
		} catch as e {
			FileOpen(logDir "results.txt", "w").Write("")
		}
	}
	log_click(*)
	{
		if FileExist(userLog)
			Run(userLog)
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
r1 := "", r2 := "", r3 := ""
QPC(1)
f1()
test1 := QPC(0)
QPC(1)

)"
		txt .= (c2 = "") ? "`n"
			: " `nf2()`ntest2 := QPC(0)`nQPC(1)"
		txt .= (c3 = "") ? "`n"
			: " `nf3()`ntest3 := QPC(0)`nQPC(1)`nf3()`ntest4 := QPC(0)`nQPC(1)`n"
		txt .= (c2 = "") ? ""
			: "
(
f2()
test5 := QPC(0)`nQPC(1)
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
		txt .= "
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
settings(){
	; Settings array for the RichCode control
	return settings := {
		TabSize: 4,
		Indent: "`t",
		FGColor: 0xEDEDCD,
		BGColor: 0x3F3F3F,
		Font: {Typeface: "Consolas", Size: 11, Bold: false},
		WordWrap: False,
		
		UseHighlighter: True,
		Highlighter: HighlightAHK,
		HighlightDelay: 200,
		Colors: {
			Comments:     0x7F9F7F,
			Functions:    0x7CC8CF,
			Keywords:     0xE4EDED,
			Multiline:    0x7F9F7F,
			Numbers:      0xF79B57,
			Punctuation:  0x97C0EB,
			Strings:      0xCC9893,
			
			; AHK
			A_Builtins:   0xF79B57,
			Commands:     0xCDBFA3,
			Directives:   0x7CC8CF,
			Flow:         0xE4EDED,
			KeyNames:     0xCB8DD9,
			
			; CSS
			ColorCodes:   0x7CC8CF,
			Properties:   0xCDBFA3,
			Selectors:    0xE4EDED,
			
			; HTML
			Attributes:   0x7CC8CF,
			Entities:     0xF79B57,
			Tags:         0xCDBFA3,
			
			; JS
			Builtins:     0xE4EDED,
			Constants:    0xF79B57,
			Declarations: 0xCDBFA3
		}
	}
}
load()
{
	global tester, logger, loops
	if !FileExist(logger)
		return
	contents := FileOpen(Logger, "r").Read()
	results := StrSplit(contents, "&&&&&")
	{
		if results.Has(2)
			tester.ctrls.code1.value := results[2]
		if results.Has(3)
			tester.ctrls.code2.value := results[3]
		if results.Has(4)
			tester.ctrls.code3.value := results[4]
		if results.Has(5)
			loops.value := (results[5] > 5000) ? 5000 : results[5]
	}
	if FileExist(temp)
		try {
			FileDelete(temp)
		} catch as e
		{
			Msgbox e.message
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

}

/*
	class RichCode({"TabSize": 4     ; Width of a tab in characters
		, "Indent": "`t"             ; What text to insert on indent
		, "FGColor": 0xRRGGBB        ; Foreground (text) color
		, "BGColor": 0xRRGGBB        ; Background color
		, "Font"                     ; Font to use
		: {"Typeface": "Courier New" ; Name of the typeface
			, "Size": 12             ; Font size in points
			, "Bold": False}         ; Bolded (True/False)


		; Whether to use the highlighter, or leave it as plain text
		, "UseHighlighter": True

		; Delay after typing before the highlighter is run
		, "HighlightDelay": 200

		; The highlighter function (FuncObj or name)
		; to generate the highlighted RTF. It will be passed
		; two parameters, the first being this settings array
		; and the second being the code to be highlighted
		, "Highlighter": Func("HighlightAHK")

		; The colors to be used by the highlighter function.
		; This is currently used only by the highlighter, not at all by the
		; RichCode class. As such, the RGB ordering is by convention only.
		; You can add as many colors to this array as you want.
		, "Colors"
		: [0xRRGGBB
			, 0xRRGGBB
			, 0xRRGGBB,
			, 0xRRGGBB]})
*/

class RichCode
{
	#DllLoad "msftedit.dll"
	static IID_ITextDocument := "{8CC497C0-A1DF-11CE-8098-00AA0047BE5D}"
	static MenuItems := ["Cut", "Copy", "Paste", "Delete", "", "Select All", ""
		, "UPPERCASE", "lowercase", "TitleCase"]

	_Frozen := False

	/** @type {Gui.Custom} the underlying control */
	_control := {}

	Settings := {}

	gutter := { Hwnd: 0 }

	; --- Static Methods ---

	static BGRFromRGB(RGB) => RGB >> 16 & 0xFF | RGB & 0xFF00 | RGB << 16 & 0xFF0000

	; --- Properties ---

	Text {
		get => StrReplace(this._control.Text, "`r")
		set => (this.Highlight(Value), Value)
	}

	; TODO: reserve and reuse memory
	selection[i := 0] {
		get => (
			this.SendMsg(0x434, 0, charrange := Buffer(8)), ; EM_EXGETSEL
			out := [NumGet(charrange, 0, "Int"), NumGet(charrange, 4, "Int")],
			i ? out[i] : out
		)

		set => (
			i ? (t := this.selection, t[i] := Value, Value := t) : "",
			NumPut("Int", Value[1], "Int", Value[2], charrange := Buffer(8)),
			this.SendMsg(0x437, 0, charrange), ; EM_EXSETSEL
			Value
		)
	}

	SelectedText {
		get {
			Selection := this.selection
			length := selection[2] - selection[1]
			b := Buffer((length + 1) * 2)
			if this.SendMsg(0x43E, 0, b) > length ; EM_GETSELTEXT
				throw Error("Text larger than selection! Buffer overflow!")
			text := StrGet(b, length, "UTF-16")
			return StrReplace(text, "`r", "`n")
		}

		set {
			this.SendMsg(0xC2, 1, StrPtr(Value)) ; EM_REPLACESEL
			this.Selection[1] -= StrLen(Value)
			return Value
		}
	}

	EventMask {
		get => this._EventMask

		set {
			this._EventMask := Value
			this.SendMsg(0x445, 0, Value) ; EM_SETEVENTMASK
			return Value
		}
	}

	_UndoSuspended := false
	UndoSuspended {
		get {
			return this._UndoSuspended
		}

		set {
			try { ; ITextDocument is not implemented in WINE
				if Value
					this.ITextDocument.Undo(-9999995) ; tomSuspend
				else
					this.ITextDocument.Undo(-9999994) ; tomResume
			}
			return this._UndoSuspended := !!Value
		}
	}

	Frozen {
		get => this._Frozen

		set {
			if (Value && !this._Frozen)
			{
				try ; ITextDocument is not implemented in WINE
					this.ITextDocument.Freeze()
				catch
					this._control.Opt "-Redraw"
			}
			else if (!Value && this._Frozen)
			{
				try ; ITextDocument is not implemented in WINE
					this.ITextDocument.Unfreeze()
				catch
					this._control.Opt "+Redraw"
			}
			return this._Frozen := !!Value
		}
	}

	Modified {
		get {
			return this.SendMsg(0xB8, 0, 0) ; EM_GETMODIFY
		}

		set {
			this.SendMsg(0xB9, Value, 0) ; EM_SETMODIFY
			return Value
		}
	}

	; --- Construction, Destruction, Meta-Functions ---

	__New(gui, Settings, Options := "")
	{
		this.__Set := this.___Set
		this.Settings := Settings
		FGColor := RichCode.BGRFromRGB(Settings.FGColor)
		BGColor := RichCode.BGRFromRGB(Settings.BGColor)

		this._control := gui.AddCustom("ClassRichEdit50W +0x5031b1c4 +E0x20000 " Options)

		; Enable WordWrap in RichEdit control ("WordWrap" : true)
		if this.Settings.HasOwnProp("WordWrap")
			this.SendMsg(0x448, 0, 0)

		; Register for WM_COMMAND and WM_NOTIFY events
		; NOTE: this prevents garbage collection of
		; the class until the control is destroyed
		this.EventMask := 1 ; ENM_CHANGE
		this._control.OnCommand 0x300, this.CtrlChanged.Bind(this)

		; Set background color
		this.SendMsg(0x443, 0, BGColor) ; EM_SETBKGNDCOLOR

		; Set character format
		f := settings.font
		cf2 := Buffer(116, 0)
		NumPut("UInt", 116, cf2, 0)          ; cbSize      = sizeof(CF2)
		NumPut("UInt", 0xE << 28, cf2, 4)    ; dwMask      = CFM_COLOR|CFM_FACE|CFM_SIZE
		NumPut("UInt", f.Size * 20, cf2, 12) ; yHeight     = twips
		NumPut("UInt", fgColor, cf2, 20) ; crTextColor = 0xBBGGRR
		StrPut(f.Typeface, cf2.Ptr + 26, 32, "UTF-16") ; szFaceName = TCHAR
		SendMessage(0x444, 0, cf2, this.Hwnd) ; EM_SETCHARFORMAT

		; Set tab size to 4 for non-highlighted code
		tabStops := Buffer(4)
		NumPut("UInt", Settings.TabSize * 4, tabStops)
		this.SendMsg(0x0CB, 1, tabStops) ; EM_SETTABSTOPS

		; Change text limit from 32,767 to max
		this.SendMsg(0x435, 0, -1) ; EM_EXLIMITTEXT

		; Bind for keyboard events
		; Use a pointer to prevent reference loop
		this.OnMessageBound := this.OnMessage.Bind(this)
		OnMessage(0x100, this.OnMessageBound) ; WM_KEYDOWN
		OnMessage(0x205, this.OnMessageBound) ; WM_RBUTTONUP

		; Bind the highlighter
		this.HighlightBound := this.Highlight.Bind(this)

		; Create the right click menu
		this.menu := Menu()
		for Index, Entry in RichCode.MenuItems
			(entry == "") ? this.menu.Add() : this.menu.Add(Entry, (*) => this.RightClickMenu.Bind(this))

		; Get the ITextDocument object
		bufpIRichEditOle := Buffer(A_PtrSize, 0)
		this.SendMsg(0x43C, 0, bufpIRichEditOle) ; EM_GETOLEINTERFACE
		this.pIRichEditOle := NumGet(bufpIRichEditOle, "UPtr")
		this.IRichEditOle := ComValue(9, this.pIRichEditOle, 1)
		; ObjAddRef(this.pIRichEditOle)
		this.pITextDocument := ComObjQuery(this.IRichEditOle, RichCode.IID_ITextDocument)
		this.ITextDocument := ComValue(9, this.pITextDocument, 1)
		; ObjAddRef(this.pITextDocument)
	}

	RightClickMenu(ItemName, ItemPos, MenuName)
	{
		if (ItemName == "Cut")
			Clipboard := this.SelectedText, this.SelectedText := ""
		else if (ItemName == "Copy")
			Clipboard := this.SelectedText
		else if (ItemName == "Paste")
			this.SelectedText := A_Clipboard
		else if (ItemName == "Delete")
			this.SelectedText := ""
		else if (ItemName == "Select All")
			this.Selection := [0, -1]
		else if (ItemName == "UPPERCASE")
			this.SelectedText := Format("{:U}", this.SelectedText)
		else if (ItemName == "lowercase")
			this.SelectedText := Format("{:L}", this.SelectedText)
		else if (ItemName == "TitleCase")
			this.SelectedText := Format("{:T}", this.SelectedText)
	}

	__Delete()
	{
		; Release the ITextDocument object
		this.ITextDocument := unset, ObjRelease(this.pITextDocument)
		this.IRichEditOle := unset, ObjRelease(this.pIRichEditOle)

		; Release the OnMessage handlers
		OnMessage(0x100, this.OnMessageBound, 0) ; WM_KEYDOWN
		OnMessage(0x205, this.OnMessageBound, 0) ; WM_RBUTTONUP

		; Destroy the right click menu
		this.menu := unset
	}

	__Call(Name, Params) => this._control.%Name%(Params*)
	__Get(Name, Params) => this._control.%Name%[Params*]
	___Set(Name, Params, Value) {
		try {
			this._control.%Name%[Params*] := Value
		} catch Any as e {
			e2 := Error(, -1)
			e.What := e2.What
			e.Line := e2.Line
			e.File := e2.File
			throw e
		}
	}

	; --- Event Handlers ---

	OnMessage(wParam, lParam, Msg, hWnd)
	{
		if (hWnd != this._control.hWnd)
			return

		if (Msg == 0x100) ; WM_KEYDOWN
		{
			if (wParam == GetKeyVK("Tab"))
			{
				; Indentation
				Selection := this.Selection
				if GetKeyState("Shift")
					this.IndentSelection(True) ; Reverse
				else if (Selection[2] - Selection[1]) ; Something is selected
					this.IndentSelection()
				else
				{
					; TODO: Trim to size needed to reach next TabSize
					this.SelectedText := this.Settings.Indent
					this.Selection[1] := this.Selection[2] ; Place cursor after
				}
				return False
			}
			else if (wParam == GetKeyVK("Escape")) ; Normally closes the window
				return False
			else if (wParam == GetKeyVK("v") && GetKeyState("Ctrl"))
			{
				this.SelectedText := A_Clipboard ; Strips formatting
				this.Selection[1] := this.Selection[2] ; Place cursor after
				return False
			}
		}
		else if (Msg == 0x205) ; WM_RBUTTONUP
		{
			this.menu.Show()
			return False
		}
	}

	CtrlChanged(control)
	{
		; Delay until the user is finished changing the document
		SetTimer this.HighlightBound, -Abs(this.Settings.HighlightDelay)
	}

	; --- Methods ---

	; First parameter is taken as a replacement value
	; Variadic form is used to detect when a parameter is given,
	; regardless of content
	Highlight(NewVal := unset)
	{
		if !(this.Settings.UseHighlighter && this.Settings.Highlighter) {
			if IsSet(NewVal)
				this._control.Text := NewVal
			return
		}

		; Freeze the control while it is being modified, stop change event
		; generation, suspend the undo buffer, buffer any input events
		PrevFrozen := this.Frozen, this.Frozen := True
		PrevEventMask := this.EventMask, this.EventMask := 0 ; ENM_NONE
		PrevUndoSuspended := this.UndoSuspended, this.UndoSuspended := True
		PrevCritical := Critical(1000)

		; Run the highlighter
		Highlighter := this.Settings.Highlighter
		if !IsSet(NewVal)
			NewVal := this.text
		RTF := Highlighter(this.Settings, &NewVal)

		; "TRichEdit suspend/resume undo function"
		; https://stackoverflow.com/a/21206620


		; Save the rich text to a UTF-8 buffer
		buf := Buffer(StrPut(RTF, "UTF-8"))
		StrPut(RTF, buf, "UTF-8")

		; Set up the necessary structs
		zoom := Buffer(8, 0) ; Zoom Level
		point := Buffer(8, 0) ; Scroll Pos
		charrange := Buffer(8, 0) ; Selection
		settextex := Buffer(8, 0) ; SetText settings
		NumPut("UInt", 1, settextex) ; flags = ST_KEEPUNDO

		; Save the scroll and cursor positions, update the text,
		; then restore the scroll and cursor positions
		MODIFY := this.SendMsg(0xB8, 0, 0)    ; EM_GETMODIFY
		this.SendMsg(0x4E0, ZOOM.ptr, ZOOM.ptr + 4)   ; EM_GETZOOM
		this.SendMsg(0x4DD, 0, POINT)        ; EM_GETSCROLLPOS
		this.SendMsg(0x434, 0, CHARRANGE)    ; EM_EXGETSEL
		this.SendMsg(0x461, SETTEXTEX, Buf) ; EM_SETTEXTEX
		this.SendMsg(0x437, 0, CHARRANGE)    ; EM_EXSETSEL
		this.SendMsg(0x4DE, 0, POINT)        ; EM_SETSCROLLPOS
		this.SendMsg(0x4E1, NumGet(ZOOM, "UInt")
			, NumGet(ZOOM, 4, "UInt"))        ; EM_SETZOOM
		this.SendMsg(0xB9, MODIFY, 0)         ; EM_SETMODIFY

		; Restore previous settings
		Critical PrevCritical
		this.UndoSuspended := PrevUndoSuspended
		this.EventMask := PrevEventMask
		this.Frozen := PrevFrozen
	}

	IndentSelection(Reverse := False, Indent := unset) {
		; Freeze the control while it is being modified, stop change event
		; generation, buffer any input events
		PrevFrozen := this.Frozen
		this.Frozen := True
		PrevEventMask := this.EventMask
		this.EventMask := 0 ; ENM_NONE
		PrevCritical := Critical(1000)

		if !IsSet(Indent)
			Indent := this.Settings.Indent
		IndentLen := StrLen(Indent)

		; Select back to the start of the first line
		sel := this.selection
		top := this.SendMsg(0x436, 0, sel[1]) ; EM_EXLINEFROMCHAR
		bottom := this.SendMsg(0x436, 0, sel[2]) ; EM_EXLINEFROMCHAR
		this.Selection := [
			this.SendMsg(0xBB, top, 0), ; EM_LINEINDEX
			this.SendMsg(0xBB, bottom + 1, 0) - 1 ; EM_LINEINDEX
		]

		; TODO: Insert newlines using SetSel/ReplaceSel to avoid having to call
		; the highlighter again
		Text := this.SelectedText
		out := ""
		if Reverse { ; Remove indentation appropriately
			loop parse text, "`n", "`r" {
				if InStr(A_LoopField, Indent) == 1
					Out .= "`n" SubStr(A_LoopField, 1 + IndentLen)
				else
					Out .= "`n" A_LoopField
			}
		} else { ; Add indentation appropriately
			loop parse Text, "`n", "`r"
				Out .= "`n" Indent . A_LoopField
		}
		this.SelectedText := SubStr(Out, 2)

		this.Highlight()

		; Restore previous settings
		Critical PrevCritical
		this.EventMask := PrevEventMask

		; When content changes cause the horizontal scrollbar to disappear,
		; unfreezing causes the scrollbar to jump. To solve this, jump back
		; after unfreezing. This will cause a flicker when that edge case
		; occurs, but it's better than the alternative.
		point := Buffer(8, 0)
		this.SendMsg(0x4DD, 0, POINT) ; EM_GETSCROLLPOS
		this.Frozen := PrevFrozen
		this.SendMsg(0x4DE, 0, POINT) ; EM_SETSCROLLPOS
	}

	; --- Helper/Convenience Methods ---

	SendMsg(Msg, wParam, lParam) =>
		SendMessage(msg, wParam, lParam, this._control.Hwnd)
}


class HighlightAHK {
	static flow := "if|else|loop|loop files|loop parse|loop read|loop reg|while|for|continue|break|until|try|throw|"
		. "catch|finally|class|global|local|static|return|goto"
	static library := (
		"Abs|ACos|ASin|ATan|BlockInput|Break|Buffer|CallbackCreate|CallbackFree|CaretGetPos|Catch|Ceil|Chr|Click|"
		"ClipboardAll|ClipWait|ComCall|ComObjActive|ComObjArray|ComObjConnect|ComObject|ComObjFlags|ComObjFromPtr|"
		"ComObjGet|ComObjQuery|ComObjType|ComObjValue|ComValue|Continue|ControlAddItem|ControlChooseIndex|"
		"ControlChooseString|ControlClick|ControlDeleteItem|ControlFindItem|ControlFocus|ControlGetChecked|"
		"ControlGetChoice|ControlGetClassNN|ControlGetEnabled|ControlGetFocus|ControlGetHwnd|ControlGetIndex|"
		"ControlGetItems|ControlGetPos|ControlGetStyle|ControlGetText|ControlGetVisible|ControlHide|"
		"ControlHideDropDown|ControlMove|ControlSend|ControlSetChecked|ControlSetEnabled|ControlSetStyle|"
		"ControlSetText|ControlShow|ControlShowDropDown|CoordMode|Cos|Critical|DateAdd|DateDiff|DetectHiddenText|"
		"DetectHiddenWindows|DirCopy|DirCreate|DirDelete|DirExist|DirMove|DirSelect|DllCall|Download|DriveEject|"
		"DriveGetCapacity|DriveGetFileSystem|DriveGetLabel|DriveGetList|DriveGetSerial|DriveGetSpaceFree|"
		"DriveGetStatus|DriveGetStatusCD|DriveGetType|DriveLock|DriveRetract|DriveSetLabel|DriveUnlock|Edit|"
		"EditGetCurrentCol|EditGetCurrentLine|EditGetLine|EditGetLineCount|EditGetSelectedText|EditPaste|Else|EnvGet|"
		"EnvSet|Exit|ExitApp|Exp|FileAppend|FileCopy|FileCreateShortcut|FileDelete|FileEncoding|FileExist|"
		"FileGetAttrib|FileGetShortcut|FileGetSize|FileGetTime|FileGetVersion|FileInstall|FileMove|FileOpen|FileRead|"
		"FileRecycle|FileRecycleEmpty|FileSelect|FileSetAttrib|FileSetTime|Finally|Float|Floor|For|Format|FormatTime|"
		"GetKeyName|GetKeySC|GetKeyState|GetKeyVK|GetMethod|Goto|GroupActivate|GroupAdd|GroupClose|GroupDeactivate|Gui|"
		"GuiCtrlFromHwnd|GuiFromHwnd|HasBase|HasMethod|HasProp|HotIf|Hotkey|Hotstring|If|IL_Add|IL_Create|IL_Destroy|"
		"ImageSearch|IniDelete|IniRead|IniWrite|InputBox|InputHook|InstallKeybdHook|InstallMouseHook|InStr|Integer|"
		"IsLabel|IsObject|IsSet|KeyHistory|KeyWait|ListHotkeys|ListLines|ListVars|ListViewGetContent|Ln|LoadPicture|"
		"Log|Loop|Map|Max|Menu|MenuBar|MenuFromHandle|MenuSelect|Min|Mod|MonitorGet|MonitorGetCount|MonitorGetName|"
		"MonitorGetPrimary|MonitorGetWorkArea|MouseClick|MouseClickDrag|MouseGetPos|MouseMove|MsgBox|Number|NumGet|"
		"NumPut|ObjAddRef|ObjBindMethod|ObjGetBase|ObjGetCapacity|ObjHasOwnProp|ObjOwnPropCount|ObjOwnProps|ObjSetBase|"
		"ObjSetCapacity|OnClipboardChange|OnError|OnExit|OnMessage|Ord|OutputDebug|Pause|Persistent|PixelGetColor|"
		"PixelSearch|PostMessage|ProcessClose|ProcessExist|ProcessGetName|ProcessGetParent|ProcessGetPath|"
		"ProcessSetPriority|ProcessWait|ProcessWaitClose|Random|RegCreateKey|RegDelete|RegDeleteKey|RegExMatch|"
		"RegExReplace|RegRead|RegWrite|Reload|Return|Round|Run|RunAs|RunWait|Send|SendEvent|SendInput|SendLevel|"
		"SendMessage|SendMode|SendPlay|SendText|SetCapsLockState|SetControlDelay|SetDefaultMouseSpeed|SetKeyDelay|"
		"SetMouseDelay|SetNumLockState|SetRegView|SetScrollLockState|SetStoreCapsLockMode|SetTimer|SetTitleMatchMode|"
		"SetWinDelay|SetWorkingDir|Shutdown|Sin|Sleep|Sort|SoundBeep|SoundGetInterface|SoundGetMute|SoundGetName|"
		"SoundGetVolume|SoundPlay|SoundSetMute|SoundSetVolume|SplitPath|Sqrt|StatusBarGetText|StatusBarWait|StrCompare|"
		"StrGet|String|StrLen|StrLower|StrPtr|StrPut|StrReplace|StrSplit|StrUpper|SubStr|Suspend|Switch|SysGet|"
		"SysGetIPAddresses|Tan|Thread|Throw|ToolTip|TraySetIcon|TrayTip|Trim|Try|Type|Until|VarSetStrCapacity|"
		"VerCompare|While|WinActivate|WinActivateBottom|WinActive|WinClose|WinExist|WinGetClass|WinGetClientPos|"
		"WinGetControls|WinGetControlsHwnd|WinGetCount|WinGetID|WinGetIDLast|WinGetList|WinGetMinMax|WinGetPID|"
		"WinGetPos|WinGetProcessName|WinGetProcessPath|WinGetStyle|WinGetText|WinGetTitle|WinGetTransColor|"
		"WinGetTransparent|WinHide|WinKill|WinMaximize|WinMinimize|WinMinimizeAll|WinMove|WinMoveBottom|WinMoveTop|"
		"WinRedraw|WinRestore|WinSetAlwaysOnTop|WinSetEnabled|WinSetRegion|WinSetStyle|WinSetTitle|WinSetTransColor|"
		"WinSetTransparent|WinShow|WinWait|WinWaitActive|WinWaitClose"
	)
	static keynames := (
		"alt|altdown|altup|appskey|backspace|blind|browser_back|browser_favorites|browser_forward|browser_home|"
		"browser_refresh|browser_search|browser_stop|bs|capslock|click|control|ctrl|ctrlbreak|ctrldown|ctrlup|del|"
		"delete|down|end|enter|esc|escape|f1|f10|f11|f12|f13|f14|f15|f16|f17|f18|f19|f2|f20|f21|f22|f23|f24|f3|f4|f5|"
		"f6|f7|f8|f9|home|ins|insert|joy1|joy10|joy11|joy12|joy13|joy14|joy15|joy16|joy17|joy18|joy19|joy2|joy20|joy21|"
		"joy22|joy23|joy24|joy25|joy26|joy27|joy28|joy29|joy3|joy30|joy31|joy32|joy4|joy5|joy6|joy7|joy8|joy9|joyaxes|"
		"joybuttons|joyinfo|joyname|joypov|joyr|joyu|joyv|joyx|joyy|joyz|lalt|launch_app1|launch_app2|launch_mail|"
		"launch_media|lbutton|lcontrol|lctrl|left|lshift|lwin|lwindown|lwinup|mbutton|media_next|media_play_pause|"
		"media_prev|media_stop|numlock|numpad0|numpad1|numpad2|numpad3|numpad4|numpad5|numpad6|numpad7|numpad8|numpad9|"
		"numpadadd|numpadclear|numpaddel|numpaddiv|numpaddot|numpaddown|numpadend|numpadenter|numpadhome|numpadins|"
		"numpadleft|numpadmult|numpadpgdn|numpadpgup|numpadright|numpadsub|numpadup|pause|pgdn|pgup|printscreen|ralt|"
		"raw|rbutton|rcontrol|rctrl|right|rshift|rwin|rwindown|rwinup|scrolllock|shift|shiftdown|shiftup|space|tab|up|"
		"volume_down|volume_mute|volume_up|wheeldown|wheelleft|wheelright|wheelup|xbutton1|xbutton2"
	)
	static builtins := "A_\w+|true|false|this|super"
	static needle := (
		"ims)"
		"((?:^|\s);[^\n]+)"          ; Comments
		"|(^\s*/\*.*?(?:^\s*\*\/|\*/\s*$|\z))"    ; Multiline comments
		"|(^\s*#\w+\b(?!:)(?:(?<!HotIf)[^\n]*)?)" ; Directives
		"|([$#+*!~&/\\<>^|=?:,().``%}{\[\]\-]+)"   ; Punctuation
		"|\b(0x[0-9a-fA-F]+|[0-9]+)" ; Numbers
		"|('[^'\n]*'|" . '"[^"\n]*")' ; Strings
		"|\b(" this.builtins ")\b"  ; A_Builtins
		"|\b(" this.flow ")\b"            ; Flow
		"|\b(" this.library ")(?!\()\b"       ; Commands
		"|\b(" this.keynames ")\b"        ; Keynames
		; "|\b(" this.keywords ")\b"        ; Other keywords
		"|(\w+(?=\())"     ; Functions
	)

	static Call(Settings, &Code) {
		GenHighlighterCache(Settings)
		Map := Settings.Cache.ColorMap

		rtf := ""
		Pos := 1
		while FoundPos := RegExMatch(Code, this.needle, &Match, Pos) {
			RTF .= (
				"\cf" Map.Plain " "
				EscapeRTF(SubStr(Code, Pos, FoundPos - Pos))
				"\cf" (
					Match.1 != "" && Map.Comments ||
					Match.2 != "" && Map.Multiline ||
					Match.3 != "" && Map.Directives ||
					Match.4 != "" && Map.Punctuation ||
					Match.5 != "" && Map.Numbers ||
					Match.6 != "" && Map.Strings ||
					Match.7 != "" && Map.A_Builtins ||
					Match.8 != "" && Map.Flow ||
					Match.9 != "" && Map.Commands ||
					Match.10 != "" && Map.Keynames ||
					; Match.11 != "" && Map.Keywords ||
					Match.11 != "" && Map.Functions ||
					Map.Plain
				) " "
				EscapeRTF(Match.0)
			), Pos := FoundPos + Match.Len
		}

		return Settings.Cache.RTFHeader . RTF
			. "\cf" Map.Plain " " EscapeRTF(SubStr(Code, Pos)) "\`n}"
	}
}
GenHighlighterCache(Settings)
{
	if Settings.HasOwnProp("Cache")
		return
	Cache := Settings.Cache := {}
	
	
	; --- Process Colors ---
	Cache.Colors := Settings.Colors.Clone()
	
	; Inherit from the Settings array's base
	BaseSettings := Settings
	while (BaseSettings := BaseSettings.Base)
		if BaseSettings.HasProp("Colors")
			for Name, Color in BaseSettings.Colors.OwnProps()
				if !Cache.Colors.HasProp(Name)
					Cache.Colors.%Name% := Color
	
	; Include the color of plain text
	if !Cache.Colors.HasOwnProp("Plain")
		Cache.Colors.Plain := Settings.FGColor
	
	; Create a Name->Index map of the colors
	Cache.ColorMap := {}
	for Name, Color in Cache.Colors.OwnProps()
		Cache.ColorMap.%Name% := A_Index
	
	
	; --- Generate the RTF headers ---
	RTF := "{\urtf"
	
	; Color Table
	RTF .= "{\colortbl;"
	for Name, Color in Cache.Colors.OwnProps()
	{
		RTF .= "\red"   Color>>16 & 0xFF
		RTF .= "\green" Color>>8  & 0xFF
		RTF .= "\blue"  Color     & 0xFF ";"
	}
	RTF .= "}"
	
	; Font Table
	if Settings.Font
	{
		FontTable .= "{\fonttbl{\f0\fmodern\fcharset0 "
		FontTable .= Settings.Font.Typeface
		FontTable .= ";}}"
		RTF .= "\fs" Settings.Font.Size * 2 ; Font size (half-points)
		if Settings.Font.Bold
			RTF .= "\b"
	}
	
	; Tab size (twips)
	RTF .= "\deftab" GetCharWidthTwips(Settings.Font) * Settings.TabSize
	
	Cache.RTFHeader := RTF
}

GetCharWidthTwips(Font)
{
	static Cache := Map()
	
	if Cache.Has(Font.Typeface "_" Font.Size "_" Font.Bold)
		return Cache[Font.Typeface "_" font.Size "_" Font.Bold]
	
	; Calculate parameters of CreateFont
	Height := -Round(Font.Size*A_ScreenDPI/72)
	Weight := 400+300*(!!Font.Bold)
	Face := Font.Typeface
	
	; Get the width of "x"
	hDC := DllCall("GetDC", "UPtr", 0)
	hFont := DllCall("CreateFont"
	, "Int", Height ; _In_ int     nHeight,
	, "Int", 0      ; _In_ int     nWidth,
	, "Int", 0      ; _In_ int     nEscapement,
	, "Int", 0      ; _In_ int     nOrientation,
	, "Int", Weight ; _In_ int     fnWeight,
	, "UInt", 0     ; _In_ DWORD   fdwItalic,
	, "UInt", 0     ; _In_ DWORD   fdwUnderline,
	, "UInt", 0     ; _In_ DWORD   fdwStrikeOut,
	, "UInt", 0     ; _In_ DWORD   fdwCharSet, (ANSI_CHARSET)
	, "UInt", 0     ; _In_ DWORD   fdwOutputPrecision, (OUT_DEFAULT_PRECIS)
	, "UInt", 0     ; _In_ DWORD   fdwClipPrecision, (CLIP_DEFAULT_PRECIS)
	, "UInt", 0     ; _In_ DWORD   fdwQuality, (DEFAULT_QUALITY)
	, "UInt", 0     ; _In_ DWORD   fdwPitchAndFamily, (FF_DONTCARE|DEFAULT_PITCH)
	, "Str", Face   ; _In_ LPCTSTR lpszFace
	, "UPtr")
	hObj := DllCall("SelectObject", "UPtr", hDC, "UPtr", hFont, "UPtr")
	size := Buffer(8, 0)
	DllCall("GetTextExtentPoint32", "UPtr", hDC, "Str", "x", "Int", 1, "Ptr", SIZE)
	DllCall("SelectObject", "UPtr", hDC, "UPtr", hObj, "UPtr")
	DllCall("DeleteObject", "UPtr", hFont)
	DllCall("ReleaseDC", "UPtr", 0, "UPtr", hDC)
	
	; Convert to twpis
	Twips := Round(NumGet(size, 0, "UInt")*1440/A_ScreenDPI)
	Cache[Font.Typeface "_" Font.Size "_" Font.Bold] := Twips
	return Twips
}

EscapeRTF(Code)
{
	for Char in ["\", "{", "}", "`n"]
		Code := StrReplace(Code, Char, "\" Char)
	return StrReplace(StrReplace(Code, "`t", "\tab "), "`r")
}

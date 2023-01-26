WinActivate("TI Connect")

Opt("SendKeyDelay", 40)		; default 5

For $i = 1 to 30
	Send("{DOWN}{ENTER}{ENTER}{TAB}{TAB}")
Next

WinActivate("SciTE")
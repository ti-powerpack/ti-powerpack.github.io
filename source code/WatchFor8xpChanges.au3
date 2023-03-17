#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "Includes\Debug.au3"
#include "Includes\WatchFolderForChanges.au3"
#include "Includes\Process8xpppFile.au3"

$folderToWatch = @ScriptDir & "\Test Watch Folder"

; WabbitEmu is a bit slow, so we need to increase the delay on keystrokes here:
AutoItSetOption("SendKeyDelay", 100)
AutoItSetOption("SendKeyDownDelay", 100)

; Start watching the folder
WatchFolderForChanges($folderToWatch, OptimizeScriptWhenSaved, "8xp,8xppp")

; Whenever a file is created/changed, run this function:
Func OptimizeScriptWhenSaved($filename)

   ; Don't reoptimize or execute optimized files
   If StringInStr($filename, ".optimized.8xp") Then Return

   Debug("Now compiling: " & $filename)
   $newFilename = $folderToWatch & "\" & StringRegExpReplace($filename, "\.8xp+$", ".optimized.8xp")
   Process8xpppFile($folderToWatch & "\" & $filename, $newFilename)

	; Run WabbitEmu
	; Send the optimized version to WabbitEmu
	$result = ShellExecute( _
		"D:\Dropbox\TI84 Calculator\Emulators\Wabbitemu.exe", _
		"""" & $newFilename & """" _
	)
	Sleep(100)
	;MsgBox(0,"", $result & @CRLF & @error)
	WinWait("Wabbitemu")
	WinActivate("Wabbitemu")
	WinWaitActive("Wabbitemu")
	Sleep(50)
	Send("{ENTER}")
EndFunc
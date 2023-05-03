#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;------------------------------------------------------
; PRESS F7 to compile this to EXE, then F5 to run
;------------------------------------------------------

; Force this script to only run when it's compiled as an EXE
If Not @Compiled Then

	Local $exeFilename = StringReplace(@ScriptName, ".au3", ".exe")

	; Is EXE newer than this?
	If FileGetTime($exeFilename, 0, 1) > FileGetTime(@ScriptName, 0, 1) Then
		; If so, then run it
		Run($exeFilename)
		Exit
	EndIf

	; Otherwise warn user
	MsgBox(16, @ScriptName, "Compile this script before executing." & @CRLF & @CRLF & "This script cannot be run solo. Press F7 in SciTE to compile it, then F5 to run." & @CRLF & @CRLF & "This runs it as a compiled EXE, which is necessary since it needs a console window.")
	Exit
EndIf

; TODO: Check for only one instance (singleton)?

#include "Includes\Debug.au3"
#include "Includes\WatchFolderForChangesBlocking.au3"
#include "Includes\Process8xpppFile.au3"

;---------- Options --------------
; TODO: Allow defining options via command line parameters
Local $WatchOptions[]
$WatchOptions.runWabbitAtStartUp = true
$WatchOptions.folder = @ScriptDir & "\.."
$WatchOptions.sendChangesToWabbit = true
$WatchOptions.sendEnterKeyToWabbit = true
$WatchOptions.pathToWabbitEmu = @ScriptDir & "\..\..\Emulators\Wabbitemu.exe"

Local $alwaysProcessScriptAtStartUp = ["SVTOOLS.8xp"]
;---------------------------------

; WabbitEmu is a bit slow, so we need to increase the delay on keystrokes here:
AutoItSetOption("SendKeyDelay", 100)
AutoItSetOption("SendKeyDownDelay", 100)

; Run Wabbit
If $WatchOptions.runWabbitAtStartUp Then
	RunWabbit()
EndIf

; Process any files immediately
; Be careful, since the ENTER key is commonly pressed after each one
For $file in $alwaysProcessScriptAtStartUp
	OptimizeScriptWhenSaved($file)
Next

; Start watching the folder and monitoring it for changes
; 3rd parameter is a list of file extensions that we want to be notified about
; 4th parameter is a list of substrings that should be ignored, and NOT have notifications about
;	(we don't want to process compiled files, so we ignore those)
WatchFolderForChangesBlocking($WatchOptions.folder, OptimizeScriptWhenSaved, "8xp,8xppp", ".optimized.8xp")

; Whenever an 8xp or 8xppp file is created/changed, run this function:
Func OptimizeScriptWhenSaved($filename)

	; Process and optimize 8XP file
	Debug("Now compiling: " & $filename)
	$newFilename = $WatchOptions.folder & "\" & StringRegExpReplace($filename, "\.8xp+$", ".optimized.8xp")
	Process8xpppFile($WatchOptions.folder & "\" & $filename, $newFilename)

	If $WatchOptions.sendChangesToWabbit Then
		; Run WabbitEmu
		; Send the optimized version to WabbitEmu
		RunWabbit($newFilename)
		;MsgBox(0,"", $result & @CRLF & @error)
		WinWait("Wabbitemu")

		; Make Wabbit the active Window, ready to receive keypresses
		WinActivate("Wabbitemu")
	EndIf

	; Send ENTER key to Wabbit
	; TODO: Only do this if we're running the same file that we did last time,
	; otherwise, we might execute a different app to the one we were expecting
	If $WatchOptions.sendEnterKeyToWabbit Then
		If Not WinActive("Wabbitemu") Then
			WinWaitActive("Wabbitemu")
		EndIf
		Sleep(50)
		Send("{ENTER}")
	EndIf

EndFunc

; Run WabbitEmu, optionally with an 8XP file that should be loaded into the system
Func RunWabbit($fileToLoad = "")
	; Wrap quotes around the filename to be passed to Wabbit
	If $fileToLoad Then $fileToLoad = """" & $fileToLoad & """"
	; Execute it
	$result = ShellExecute( _
		$WatchOptions.pathToWabbitEmu, _
		$fileToLoad _
	)
	If Not $result Then
		MsgBox(16, "Error", "Could not run WabbitEmu.exe for some reason. Perhaps check the path is correct.")
	EndIf

	; TODO: Check for Wabbit error message and perhaps try the loading again

	Sleep(100)
EndFunc

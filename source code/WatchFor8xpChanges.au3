;---------------------------------------------------------
; In SciTE or VSCode, PRESS F5 to run.
; File will first be compiled to EXE, and then executed.
;---------------------------------------------------------

; For beta versioning, use this format: 1.1.1-beta.1
$VERSION = "1.0.0-beta"

; Include necessary libraries
#include <AutoItConstants.au3>
#include <Misc.au3>
#include "Includes\PathTools.au3"
#include "Includes\Debug.au3"
#include "Includes\WatchFolderForChangesBlocking.au3"
#include "Includes\Process8xpppFile.au3"
#include "Includes\ConsoleWriteUnicode.au3"

; Force this script to only run when it's compiled as an EXE.
; If the AU3 source is run directly, then compile it to EXE first,
; and then run the compiled EXE.
; This is necessary because it's a *console* application, and it
; needs to be run from an EXE to function correctly.
If Not @Compiled Then

	; Get path to EXE file
	Local $au3Filename = @ScriptName
	Local $exeFilename = StringReplace(@ScriptName, ".au3", ".exe")

	; Is there a process already running for this EXE?
	; If so, kill it first
	KillProcessesByName(FileName($exeFilename))

	; Compile EXE
	Local $result = RunAndPipeOutput("C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe.exe /in """ & $au3Filename & """ /console")
	If Not $result Then
		Debug("Compilation FAILED. Exiting.")
		Exit
	EndIf

	; Run the EXE version and exit this script
	Debug("Compilation succeeded. Now running EXE...")
	Run($exeFilename & " .", "..")  ; Tell it to watch the parent folder
	Exit

	; OLD METHOD: Otherwise warn user and exit
	;~ 	MsgBox(16, @ScriptName, "Compile this script before executing." & @CRLF & @CRLF & "This script cannot be run solo. Press F7 in SciTE to compile it, then F5 to run." & @CRLF & @CRLF & "This runs it as a compiled EXE, which is necessary since it needs a console window.")
	;~ 	Exit

EndIf

; Check for only one instance (singleton)
If _Singleton("WatchFor8xpChanges", 1) = 0 Then
	MsgBox(16, "WatchFor8xpChanges", "Another instance of WatchFor8xpChanges is already running. Only one instance can run at a time.")
	Exit
EndIf


;---------- Default Options --------------
; TODO: Allow defining options via command line parameters
Global $WatchOptions[]
$WatchOptions.runWabbitAtStartUp = false
; $WatchOptions.folder = @ScriptDir & "\.."
$WatchOptions.sendChangesToWabbit = true
$WatchOptions.sendEnterKeyToWabbit = true
$WatchOptions.pathToWabbitEmu = @ScriptDir & "\..\..\Emulators\Wabbitemu.exe"
$WatchOptions.sourceCodeIntoSubfolder = "Source Code as Text"		; NOTE: also hard-coded into Process8xpppFile.au3
$WatchOptions.compiledCodeIntoSubfolder = "Compiled Programs"
; Local $alwaysProcessScriptAtStartUp = ["SVTOOLS.8xp"]
;---------------------------------

; Command line parameters are available in $CmdLine array
; $CmdLine[0] is the number of parameters

; Display intro
_ConsoleWriteUnicode("")
_ConsoleWriteUnicode("┌─────────────────────────────────────────────────────────────────┐")
_ConsoleWriteUnicode("│  _____ ___   ____                                         _     │")
_ConsoleWriteUnicode("│ |_   _|_ _| |  _ \ _____      _____ _ __ _ __   __ _  ___| | __ │")
_ConsoleWriteUnicode("│   | |  | |  | |_) / _ \ \ /\ / / _ \ '__| '_ \ / _` |/ __| |/ / │")
_ConsoleWriteUnicode("│   | |  | |  |  __/ (_) \ V  V /  __/ |  | |_) | (_| | (__|   <  │")
_ConsoleWriteUnicode("│   |_| |___| |_|   \___/ \_/\_/ \___|_|  | .__/ \__,_|\___|_|\_\ │")
_ConsoleWriteUnicode("│                                         |_|                     │")
_ConsoleWriteUnicode("└─────────────────────────────────────────────────────────────────┘")
_ConsoleWriteUnicode("v" & $VERSION)
_ConsoleWriteUnicode("")

; WabbitEmu is a bit slow, so we need to increase the delay on keystrokes here:
AutoItSetOption("SendKeyDelay", 100)
AutoItSetOption("SendKeyDownDelay", 100)

; Run Wabbit
If $WatchOptions.runWabbitAtStartUp Then
	RunWabbit()
EndIf

Local $WatchFolder

; Process files and folders specified in the command line
; For any files specified in the command line, process them immediately
; The first folder specified becomes the folder that we watch for changes
; (only 1 supported currently)
For $i = 1 To $CmdLine[0]
	Local $option = $CmdLine[$i]
	; Only process files. Is $option a file?
	Local $file = StringTrimQuotes($option) ; trim quotes
	If Not FileExists($file) Then ContinueLoop

	; Skip directories
	If StringInStr(FileGetAttrib($file), "D") Then
		If Not $WatchFolder Then $WatchFolder = $file
		ContinueLoop
	EndIf

	OptimizeScriptWhenSaved($file, false) ; don't send ENTER key for these initial files
Next

; No files/folders specified? Watch the folder 1 above the folder containing this EXE
If $CmdLine[0] = 0 Then
	$WatchFolder = Folder(@ScriptDir)
	Debug('No files/folders specified on command line. Watching parent folder for file changes.')
	Debug('')
EndIf

; Start watching the folder and monitoring it for changes
; 3rd parameter is a list of file extensions that we want to be notified about
; 4th parameter is a list of substrings that should be ignored, and NOT have notifications about
;	(we don't want to process compiled files, so we ignore those)
If $WatchFolder Then WatchFolderForChangesBlocking($WatchFolder, OptimizeScriptWhenSaved, "8xp,8xppp", ".optimized.8xp,.theta.")

; Whenever an 8xp or 8xppp file is created/changed, this function is called.
; $filename is the full path to the file, or a relative path based on this EXE's folder
Func OptimizeScriptWhenSaved($filename, $sendEnterKeyToWabbit = True)

	; Process and optimize 8XP file
	Debug("Now compiling: " & $filename)
	Local $filePath = $filename ; $WatchOptions.folder & "\" & $filename
	Local $parentFolder = Folder($filePath)
	Local $newFilename = StringRegExpReplace($filename, "\.8xp+$", ".optimized.8xp")

	; Place compiled file into subfolder
	;~ Local $newFilePath = $WatchOptions.folder & "\" & FileAppendPath($newFilename, $WatchOptions.compiledCodeIntoSubfolder)
	Local $newFilePath = FileAppendPath($newFilename, $WatchOptions.compiledCodeIntoSubfolder)

	; Create necessary folders
	; (I think DirCreate() will return true even if the folder already exists)
	Local $sourceFolder = $parentFolder & $WatchOptions.sourceCodeIntoSubfolder
	If Not FileExists($sourceFolder) And DirCreate($sourceFolder) Then Debug("  - Created folder " & $sourceFolder)
	Local $compilationFolder = Folder($newFilePath)
	If Not FileExists($compilationFolder) And DirCreate($compilationFolder) Then Debug("  - Created folder " & $compilationFolder)

	; Call the main processing function
	; This reads the 8XP file, decompiles it, optimizes the code,
	; recompiles it, and writes out the optimized 8XP file
	Process8xpppFile($filePath, $newFilePath)

	; If the option is enabled, load the new file into WabbitEmu,
	; ready for execution. Activate the WabbitEmu window too.
	If $WatchOptions.sendChangesToWabbit Then
		; Run WabbitEmu
		; Send the optimized version to WabbitEmu
		RunWabbit($newFilePath)
		;MsgBox(0,"", $result & @CRLF & @error)
		WinWait("Wabbitemu", "", 5)

		; Make Wabbit the active Window, ready to receive keypresses
		WinActivate("Wabbitemu")

		Debug("  - " & $newFilename & " sent to Wabbit and window activated")
	EndIf

	; BUG: Sometimes program hangs here for some reason. Not sure why.

	; Send ENTER key to Wabbit
	; TODO: Only do this if we're running the same file that we did last time,
	; otherwise, we might execute a different app to the one we were expecting
	If $sendEnterKeyToWabbit And $WatchOptions.sendEnterKeyToWabbit Then
		;Debug("  - sendEnterKeyToWabbit 1")
		If Not WinActive("Wabbitemu") Then
			;Debug("  - sendEnterKeyToWabbit 2")
			WinWaitActive("Wabbitemu", "", 10)
			;Debug("  - sendEnterKeyToWabbit 3")
		EndIf
		;Debug("  - sendEnterKeyToWabbit 4")
		Sleep(50)
		;Debug("  - sendEnterKeyToWabbit 5")
		If WinActive("Wabbitemu") Then Send("{ENTER}")

		Debug("  - Wabbit commands sent")
	EndIf

	;~ Debug("  - Returning to watching")
	Debug("")

EndFunc

; Run WabbitEmu emulator, optionally with an 8XP file that should be loaded into the system
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

; Trim quotes from start and end of string
Func StringTrimQuotes($str)
	Return StringRegExpReplace($str, '^"|"$', '')
EndFunc

; Run a console command and pipe its output to this script's STDOUT
; Useful for running other console apps and seeing their output in this script's console window
Func RunAndPipeOutput($command)
	; Example: Run a console app (e.g., "cmd /c echo Hello World") and pipe its output to STDOUT
	Debug("Running: " & $command)
	Local $pid = Run($command, "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)  ; Run in hidden mode, merge stderr

	If $pid Then
		While ProcessExists($pid)
			Local $output = StdoutRead($pid) & StderrRead($pid)  ; Read available output
			If $output Then ConsoleWrite($output)  ; Pass through to parent STDOUT
			Sleep(10)  ; Avoid tight loop
		Wend
		Return ProcessWaitClose($pid)  ; Ensure process finishes
	Else
		Debug(@error)
	EndIf
EndFunc

Func KillProcessesByName($processName)
	Local $existingPIDs = ProcessList(FileName($exeFilename))
	For $i = 1 To $existingPIDs[0][0]
		Debug("Killing existing process PID " & $existingPIDs[$i][1] & " for " & $exeFilename)
		ProcessClose($existingPIDs[$i][1])
	Next
EndFunc
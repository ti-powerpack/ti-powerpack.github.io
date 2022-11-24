; This script can be used in other scripts to monitor file changes.
; Simply include it like this and provide a function to be called:
;

#include <AutoItConstants.au3>
#include <StringConstants.au3>

Func WatchFolderForChanges($folder, $callback, $fileExtensionList = "")

   ; Start child process
   ; The important flag here is to use $STDOUT_CHILD which allows us to receive data
   ; We cannot use ShellExecute() here because of the need to set this flag.
   ConsoleWrite("Starting child process..." & @CRLF)
   Global $childProcessID = Run(@AutoItExe & " " & "WatchFolderForChangesChild.au3" & " """ & $folder & """", "", @SW_HIDE, $STDOUT_CHILD)

   ; Close child process when parent exits
   OnAutoItExitRegister("OnAutoItExit")

   $fileExtensionList = StringSplit($fileExtensionList, ",", $STR_NOCOUNT)

   ; Read data from child, while it exists
   ; Increase the sleep time to use less CPU, or decrease it to make it more responsive
   While 1
	  Sleep(100)
	  $data = StdoutRead($childProcessID)
	  If @error Then
		 ConsoleWrite("Child has exited." & @CRLF)
		 ExitLoop
	  EndIf
	  If $data Then
		 ; Clean up any whitespace, and process each line of output separately
		 $data = StringStripWS($data, $STR_STRIPLEADING + $STR_STRIPTRAILING)
		 $data = StringSplit($data, @CRLF, $STR_ENTIRESPLIT + $STR_NOCOUNT)
		 For $item In $data
			ConsoleWrite("Child returned: " & $item & @CRLF)
			ConsoleWrite("Extension: " & FileExtension($item) & @CRLF)
			If Not UBound($fileExtensionList) Or _ArraySearch($fileExtensionList, FileExtension($item)) > -1 Then
			   $callback($item)
			EndIf
		 Next
	  EndIf
   WEnd

EndFunc

Func OnAutoItExit()
   ConsoleWrite("Parent script told to exit. Now exiting child script also." & @CRLF)
   ProcessClose($childProcessID)
EndFunc

#include <File.au3>
#include <FileConstants.au3>
Func FileExtension($fullPath)
   Local $x = ""
   Return StringTrimLeft(_PathSplit($fullPath, $x, $x, $x, $x)[$PATH_EXTENSION], 1)
EndFunc

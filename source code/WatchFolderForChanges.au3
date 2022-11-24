; This script can be used in other scripts to monitor new/changed files in a specific folder.
; Simply include it like this and provide a function to be called:
;
;		#include "WatchFolderForChanges.au3"
;
;		WatchFolderForChanges("C:\MyFolder", MyCallback, "txt,zip")
;		Func MyCallback($filename)
;			; Do something with $filename
;		EndFunc


; TODO: Would be good to filter out duplicate events for the same file here. But I'm not sure of the best way to do that.

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
	  Sleep(200)
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
			; If a list of file extensions was provided, check if the file matches one in the list
			If $fileExtensionList[0] = "" Or _ArraySearch($fileExtensionList, FileExtension($item)) > -1 Then
			   ConsoleWrite("File change registered: " & $item & ", with file extension: " & FileExtension($item) & @CRLF)
			   $callback($item)
			Else
			   ConsoleWrite("File change ignored: " & $item & ", with file extension: " & FileExtension($item) & @CRLF)
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

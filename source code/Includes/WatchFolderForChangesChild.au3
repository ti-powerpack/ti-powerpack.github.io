; This script is meant to run standalone, NOT via an #include.
; It will watch a specific folder, as passed in via command line parameters
; And it will put the filename of any new/edited/removed file into the default console output (StdOut) on its own line
; Prefixed by a single character and a space: + = added, - = deleted, M = modified
; This output is designed to be handled by the parent script WatchFolderForChanges.au3

#include <WinAPIFiles.au3>
#include <Date.au3>
#include "Debug.au3"

;---------------------------------------------
$monitorSubfolders = 1
$path = $CmdLine[0] ? $CmdLine[1] : ""
$suppressRepeatedEventsWithinSeconds = 0.6
;---------------------------------------------
; TEMP TESTING
;~ $path = "D:\Dropbox\TI84 Calculator\MY APPS\Binary Optimization Script\Temp"
;~ Debug("Folder monitoring started.")
;---------------------------------------------


; Get a handle to a specific folder
Local $hDirectory = _WinAPI_CreateFileEx($path, $OPEN_EXISTING, $FILE_LIST_DIRECTORY, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $FILE_FLAG_BACKUP_SEMANTICS)
If @error Then
	_WinAPI_ShowLastError('', 1)
EndIf

; Create a 2mb buffer for storing list of files changed, this should be plenty
Local $pBuffer = _WinAPI_CreateBuffer(2000000)

; Create a map to store recent events
Global $RecentEvents[]

Local $arrayOfEvents
While 1

	; Wait until a file is created/modified/deleted in our watched folder.
	; This function is BLOCKING meaning the script will hang on this line until an event occurs.
	; This particular script cannot be exited via the tray icon until a file event occurs, which is why it's best used
	; with a parent script that controls it and can kill it when it's time to exit.
	; The function returns an array where there are possibly multiple file events if many files are
	; created/copied/deleted in quick succession.
	;
	; Since certain file events like new/changed files sometimes trigger 2 or 3 events for the same
	; file, we'll perform some de-duplication of those here also.
	;
	; For some more details about the WinAPI, see
	; https://learn.microsoft.com/en-us/windows/win32/api/winbase/nf-winbase-readdirectorychangesw
	$arrayOfEvents = _WinAPI_ReadDirectoryChanges( _
		$hDirectory, _
		BitOR( _
			$FILE_NOTIFY_CHANGE_FILE_NAME, _	; creating, renaming, deleting files
			$FILE_NOTIFY_CHANGE_DIR_NAME, _		; creating, renaming, deleting folders
			$FILE_NOTIFY_CHANGE_LAST_WRITE _	; modifying files
		), _
		$pBuffer, _
		2000000, _
		$monitorSubfolders _
	)

	If Not @error Then

		; FOR DEBUGGING
		; Uncomment this if you'd like to see the full array that is returned
;~ 		_ArrayDisplay($arrayOfEvents, '_WinAPI_ReadDirectoryChanges')

		For $i = 1 To $arrayOfEvents[0][0]
			Local $filePath = $arrayOfEvents[$i][0]

			If WasEventTriggeredRecently($filePath) Then ContinueLoop

			Local $action = $arrayOfEvents[$i][1]
			; $action will equal one of the following:
			;   $FILE_ACTION_ADDED = 0x0001
			;   $FILE_ACTION_REMOVED = 0x0002
			;   $FILE_ACTION_MODIFIED = 0x0003
			;   $FILE_ACTION_RENAMED_OLD_NAME = 0x0004
			;   $FILE_ACTION_RENAMED_NEW_NAME = 0x0005
			Switch $action
				Case 1, 5
					$action = "+"
				Case 2, 4
					$action = "-"
				Case 3
					$action = "M"
				Case Else
					$action = "?"
			EndSwitch

			; Print action and filename to StdOut to be picked up by parent program
			Debug($action & " " & $filePath)

			If $action <> "-" Then RecordRecentEvent($filePath)
		Next
	Else
		_WinAPI_ShowLastError('', 1)
	EndIf
WEnd



Func WasEventTriggeredRecently($filePath)
	ClearStaleRecentEvents()
	If $RecentEvents[$filePath] Then
;~ 		Debug("Suppressing duplicate event for " & $filePath)
		Return True
	Else
;~ 		Debug("Event " & $filePath & " not duplicate.")
	EndIf

	Return False
EndFunc

Func ClearStaleRecentEvents()
	Local $time = _Date_Time_GetTickCount()
	For $entry In MapKeys($RecentEvents)
		If $RecentEvents[$entry] < $time - ($suppressRepeatedEventsWithinSeconds * 1000) Then
;~ 			Debug("Removing stale entry for " & $entry)
			MapRemove($RecentEvents, $entry)
		EndIf
	Next
EndFunc


Func RecordRecentEvent($filePath)
	$RecentEvents[$filePath] = _Date_Time_GetTickCount()
EndFunc

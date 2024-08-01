; WARNING: If this script is run via an #include it will block the execution and be difficult to quit.
;          Best to compile as a console app if so.

; It will watch a specific folder, as passed in via command line parameters
; And it will put the filename of any new/edited/removed file into the default console output (StdOut) on its own line
; Prefixed by a single character and a space: + = added, - = deleted, M = modified
; It will also call a callback function as provided

#include <WinAPIFiles.au3>
#include <Date.au3>
#include "Debug.au3"
#include "FileExtension.au3"

;---------------------------------------------
; TODO: Maybe move these to a map, for less clashing
Local $monitorSubfolders = True
Local $path = $CmdLine[0] ? $CmdLine[1] : ""
Local $suppressRepeatedEventsWithinSeconds = 1.8
;---------------------------------------------
; TEMP TESTING
;~ $path = "D:\Dropbox\TI84 Calculator\MY APPS\Binary Optimization Script\Temp"
;~ Debug("Folder monitoring started.")
;---------------------------------------------

; Create a map to store recent events
Global $RecentEvents[]

Func WatchFolderForChangesBlocking($path, $callback, $fileExtensionList, $filenameSubstringsToIgnore)

	Debug("Now watching " & $path & "\*." & $fileExtensionList & " for changes...")

	; Array of file extensions to pay attention to, ignoring all others
	$fileExtensionList = StringSplit($fileExtensionList, ",", $STR_NOCOUNT)
	$filenameSubstringsToIgnore = StringSplit($filenameSubstringsToIgnore, ",", $STR_NOCOUNT)

	; Get a handle to a specific folder
	Local $hDirectory = _WinAPI_CreateFileEx( _
		$path, _
		$OPEN_EXISTING, _
		$FILE_LIST_DIRECTORY, _
		BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), _
		$FILE_FLAG_BACKUP_SEMANTICS _
	)
	If @error Then
		_WinAPI_ShowLastError('', 1)
		Return
	EndIf

	; Create a 2mb buffer for storing list of files changed, this should be plenty
	Local Const $bufferSize = 2000000
	Local $pBuffer = _WinAPI_CreateBuffer($bufferSize)

	Local $arrayOfEvents
	While 1

;~ 		Debug("  - Watching...")

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
				_ ; $FILE_NOTIFY_CHANGE_DIR_NAME, _		; creating, renaming, deleting folders
				$FILE_NOTIFY_CHANGE_LAST_WRITE _	; modifying files
			), _
			$pBuffer, _
			$bufferSize, _
			$monitorSubfolders _
		)

		If @error Then
			_WinAPI_ShowLastError('', 1)
			ContinueLoop
		EndIf

		; FOR DEBUGGING
		; Uncomment this if you'd like to see the full array that is returned
;~ 		_ArrayDisplay($arrayOfEvents, '_WinAPI_ReadDirectoryChanges')

		For $i = 1 To $arrayOfEvents[0][0]

;~ 			Debug("Processing item " & $i & " of " & UBound($arrayOfEvents) - 1)

			Local $filePath = $arrayOfEvents[$i][0]

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
					ContinueLoop ; ignoring these for now as they cause duplication
				Case 2, 4
					$action = "-"
					ContinueLoop ; ignore deletions
				Case 3
					$action = "M"
				Case Else
					$action = "?" ; don't think we should get any of these, but ignore anyway
					Debug("Hmmm... unknown file action: " & $action)
					ContinueLoop
			EndSwitch

			; Ignore repeated events within a certain timeframe
			If WasEventTriggeredRecently($filePath) Then
				; Debug("Ignoring repeat trigger for " & $filePath)
				ContinueLoop
			EndIf

			RecordRecentEvent($filePath)

			; If a list of file extensions was provided, check if the file matches one in the list
			If $fileExtensionList[0] <> "" And _ArraySearch($fileExtensionList, FileExtension($filePath)) = -1 Then
;~ 				ConsoleWrite("File change ignored: " & $filePath & ", due to file extension: " & FileExtension($filePath) & @CRLF)
				ContinueLoop
			EndIf

			; Ignore files that match any of the substrings that were provided
			For $substring in $filenameSubstringsToIgnore
				If StringInStr($filePath, $substring) Then ContinueLoop 2
			Next

			ConsoleWrite("File change detected: " & $filePath & ", with file extension: " & FileExtension($filePath) & @CRLF)

			;-----------------------------------
			; If we've got this far, we've found
			; a file that needs processing.
			; Run the callback!
			$callback($filePath)
			;-----------------------------------

		Next ; Process next file in the buffer

	WEnd

EndFunc


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
	; WARNING: _Date_Time_GetTickCount() will wrap around if Windows is run for more than 49.7 days
	Local $time = _Date_Time_GetTickCount()
	For $entry In MapKeys($RecentEvents)
		Local $elapsedSeconds = ($time - $RecentEvents[$entry]) / 1000
		If $elapsedSeconds > $suppressRepeatedEventsWithinSeconds Then
			; Debug("Removing stale entry for " & $entry & " since " & $elapsedSeconds & " seconds have elapsed.")
			MapRemove($RecentEvents, $entry)
		EndIf
	Next
EndFunc

Func RecordRecentEvent($filePath)
	$RecentEvents[$filePath] = _Date_Time_GetTickCount()
EndFunc


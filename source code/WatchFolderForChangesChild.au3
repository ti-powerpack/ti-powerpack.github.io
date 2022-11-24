#include <WinAPIFiles.au3>
;#include <Array.au3>

$monitorSubfolders = false
$path = $CmdLine[1]

;~ ConsoleWrite("Folder monitoring started." & @CRLF)

; Get a handle to a specific folder
Local $hDirectory = _WinAPI_CreateFileEx($path, $OPEN_EXISTING, $FILE_LIST_DIRECTORY, BitOR($FILE_SHARE_READ, $FILE_SHARE_WRITE), $FILE_FLAG_BACKUP_SEMANTICS)
If @error Then
   _WinAPI_ShowLastError('', 1)
EndIf

Local $pBuffer = _WinAPI_CreateBuffer(2000000)

Local $aData
While 1
   ; Wait until a file is created/modified/deleted in our watched folder.
   ; This function is BLOCKING meaning the script will hang on this line until an event occurs.
   ; This particular script cannot be exited via the tray icon until a file event occurs, which is why it's best used
   ; with a parent script that controls it and can kill it when it's time to exit.
   ; The function returns an array where there are possibly multiple file events if many files are
   ; created/copied/deleted in quick succession.
   ; Also note that certain file events like new/changed files sometimes trigger 2 or 3 events for the same
   ; file. If you want to exclude those duplicates, you'll need to handle that yourself.
   $aData = _WinAPI_ReadDirectoryChanges($hDirectory, BitOR($FILE_NOTIFY_CHANGE_FILE_NAME, $FILE_NOTIFY_CHANGE_LAST_WRITE), $pBuffer, 2000000, $monitorSubfolders)
   If Not @error Then
	  ; Uncomment this if you'd like to see the full array that is returned
	  ; _ArrayDisplay($aData, '_WinAPI_ReadDirectoryChanges')
	  For $i = 1 To $aData[0][0]
		 ; $aData[$i][1] will equal one of the following:
		 ;   $FILE_ACTION_ADDED = 0x0001
		 ;   $FILE_ACTION_REMOVED = 0x0002
		 ;   $FILE_ACTION_MODIFIED = 0x0003
		 ;   $FILE_ACTION_RENAMED_OLD_NAME = 0x0004
		 ;   $FILE_ACTION_RENAMED_NEW_NAME = 0x0005
		 ConsoleWrite($aData[$i][0] & @CRLF)
	  Next
   Else
	  _WinAPI_ShowLastError('', 1)
   EndIf
WEnd


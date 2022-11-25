#include "Includes\WatchFolderForChanges.au3"
#include "Includes\Process8xpppFile.au3"

$folderToWatch = @ScriptDir & "\Test Watch Folder"

WatchFolderForChanges($folderToWatch, OptimizeScriptWhenSaved, "8xppp")

Func OptimizeScriptWhenSaved($filename)
   ;; If StringInStr($filename, ".optimized.8xp") Then Return
   ConsoleWrite("Now compiling: " & $filename & @CRLF)
   Process8xpppFile($folderToWatch & "\" & $filename, $folderToWatch & "\" & StringReplace($filename, ".8xppp", ".8xp"))
EndFunc
#include "WatchFolderForChanges.au3"
#include "Optimize8xpFile.au3"

WatchFolderForChanges(@ScriptDir, OptimizeScriptWhenSaved, "8xp")

Func OptimizeScriptWhenSaved($filename)
   If StringInStr($filename, ".optimized.8xp") Then Return
   ConsoleWrite("Now compiling: " & $filename & @CRLF)
   Optimize8xpFile($filename)
EndFunc
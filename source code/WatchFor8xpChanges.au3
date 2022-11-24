#include "WatchFolderForChanges.au3"
#include "Optimize8xpFile.au3"

WatchFolderForChanges(@ScriptDir, OptimizeScriptWhenSaved, "8xp")

Func OptimizeScriptWhenSaved($filename)
   ConsoleWrite("Now compiling: " & $filename & @CRLF)
;~    Optimize8xpFile($filename)
EndFunc
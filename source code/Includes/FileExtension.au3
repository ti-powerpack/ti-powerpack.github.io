#include <File.au3>
#include <FileConstants.au3>

; Provide a full path to a file, returns only the extension, after the dot
Func FileExtension($fullPath)
   Local $x = ""
   Return StringTrimLeft(_PathSplit($fullPath, $x, $x, $x, $x)[$PATH_EXTENSION], 1)
EndFunc
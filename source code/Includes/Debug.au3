#include-once
#include <Array.au3>


Func Debug($string)
	ConsoleWrite($string & @CRLF)
EndFunc

Func DebugArray($array)
	_ArrayDisplay($array)
EndFunc


Func DebugMap($map)
	; _ArrayDisplay(MapKeys($map))
	For $key in MapKeys($map)
		ConsoleWrite("[" & $key & "] = " & $map[$key] & @CRLF)
	Next
EndFunc

Func WinMergeCompare($fileA, $fileB)
	Run("""C:\Program Files (x86)\WinMerge\WinMergeU.exe"" """ & $fileA & """ """ & $fileB & """")
	If @error Then MsgBox(0, "Error", "Unable to start WinMerge.")
EndFunc


#include-once
#include <Array.au3>


Func debug($string)
	ConsoleWrite($string & @CRLF)
EndFunc

Func DebugMap($map)
	_ArrayDisplay(MapKeys($map))
	For $key in MapKeys($map)
		ConsoleWrite("[" & $key & "] = " & $map[$key] & @CRLF)
	Next
EndFunc


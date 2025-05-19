#include-once
#include <Array.au3>


; ------ Tests ---------
If @ScriptName == "Debug.au3" Then
	Debug("Simple string")
	Debug("String with line" & @CRLF & " returns" & @CRLF, 1)
	Debug(123)

	; Simple array
	Local $array = [1,2,3]
	Debug($array)

	Local $nested = [$array, $array]
	Debug($nested)

	; 2D array
	Local $array[2][2] = [[1,2],[3,4]]
	Debug($array)

EndIf

;


Func Debug2($item1, $item2 = "", $item3 = "")
	Debug($item1 & " " & $item2 & " " & $item3)
EndFunc


Func Debug($stringOrArray, $showLineReturns = 0)

	; Handle 2D arrays
	If Is2dArray($stringOrArray) Then
		; DebugArray($stringOrArray)
		Debug("2D Array: (" & UBound($stringOrArray, 1) & " rows x " & UBound($stringOrArray, 2) & " cols)")
		For $i = 0 to UBound($stringOrArray, 1) - 1
			For $j = 0 to UBound($stringOrArray, 2) - 1
				Debug("  [" & $i & "][" & $j & "]:  " & ShowLineReturns($stringOrArray[$i][$j], $showLineReturns))
			Next
		Next
		Return
	EndIf

	; Handle nested arrays
	If IsArray($stringOrArray) And IsArray($stringOrArray[0]) Then
		Debug("Nested Array: (" & UBound($stringOrArray) & " rows)")
		For $i = 0 to UBound($stringOrArray) - 1
			For $j = 0 to UBound($stringOrArray[$i]) - 1
				Debug("  [" & $i & "][" & $j & "]:  " & ShowLineReturns(($stringOrArray[$i])[$j], $showLineReturns))
			Next
		Next
		Return
	EndIf

	; Handles 1D arrays only, not 2D
	If IsArray($stringOrArray) Then
		; Debug(UBound($stringOrArray, 2))
		Debug("Array: (" & UBound($stringOrArray) & " items)")
		Debug("  - " & _ArrayToString($stringOrArray, @CRLF & "  - "))
		Return
	EndIf

	ConsoleWrite(ShowLineReturns($stringOrArray, $showLineReturns) & @CRLF)

EndFunc

Func ShowLineReturns($string, $enabled = 1)
	If Not $enabled Then Return $string
	Return StringReplace(StringReplace($string, @CR, "\r"), @LF, "\n")
EndFunc


Func Is2dArray($var)
	; Return number of columns. All numbers, strings, and 1D arrays have 0 columns.
	Return UBound($var, 2)
EndFunc

; Shows array data in a popup box. Does NOT really handle nested arrays.
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


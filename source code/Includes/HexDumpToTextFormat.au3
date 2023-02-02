#include "Debug.au3"

HexDumpToText("..\..\CLOSURE2.optimized.8xp", "..\Tests\Full Test\CLOSURE.optimized.8xp.dump")
HexDumpToText("..\Tests\Full Test\CLOSURE2.compiled.8xp", "..\Tests\Full Test\CLOSURE2.compiled.8xp.dump")

; Useful to comparing two binary 8XP files,
; to see where the actual differences are

Func HexDumpToText($inputFile, $outputFile)
	$data = FileRead($inputFile)
	$header = BinaryMid($data, 1, 55) ; first 55 bytes
	$meta = BinaryMid($data, 56, 19)  ; next 19 bytes
	$body = BinaryMid($data, 56 + 19, BinaryLen($data) - 55 - 19 - 2)

	$output = "Header:" & @CRLF & Hex($header) & @CRLF & _
		@CRLF & _
		"Meta:" & @CRLF & Hex($meta) & @CRLF & _
		@CRLF & _
		"Body:" & @CRLF & BinaryToListOfHexCodes($body) & @CRLF
	debug($output)

EndFunc






; Takes a block of binary and returns a string of hex characters.
; Used for debugging and doing comparisons in a text compare tool like WinMerge
Func BinaryToListOfHexCodes($binary)
	Local $string = Hex($binary)
	$string = StringRegExpReplace($string, "\w\w", "\0" & @CRLF)	; two characters per line
	$string = StringRegExpReplace($string, "(?m)^(5C|5D|5E|60|61|62|63|7E|AA|BB|EF)\s+", "\1")	; except for certain prefixes which will be 4 per line
	Return $string
EndFunc
;~ MsgBox(0,"", BinaryToListOfHexCodes(Binary("0x00112233AABBCCDDEECCFF")))

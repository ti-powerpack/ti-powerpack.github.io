#include "Debug.au3"
#include "Tokens.au3"
#include "Process8xpppFile.au3"
#include <Array.au3>
#include <StringConstants.au3>

;~ HexDumpToText("..\..\CLOSURE2.optimized.8xp", "..\Tests\Full Test\CLOSURE.optimized.8xp.dump")
;~ HexDumpToText("..\Tests\Full Test\CLOSURE2.compiled.8xp", "..\Tests\Full Test\CLOSURE2.compiled.8xp.dump")

;~ HexDumpToText("..\Tests\Full Test\ALL TOKENS.8xppp", "..\Tests\Full Test\ALL TOKENS.8xppp.dump")
;~ HexDumpToText("..\Tests\Full Test\ALL TOKENS.compiled.8xp", "..\Tests\Full Test\ALL TOKENS.compiled.8xp.dump")

; Useful to comparing two binary 8XP files,
; to see where the actual differences are

; Takes a binary file and outputs a text file containing hex codes
Func HexDumpToText($inputFile, $outputFile)

	Local $data = Read8xpBinary($inputFile)

;~ 	$data = FileRead(FileOpen($inputFile, 16))		; open in binary mode
;~ 	If @error Then
;~ 		debug("HexDumpToText: Could not open input file: " & $inputFile)
;~ 		Return
;~ 	EndIf

	; TODO: Replace this with Read8xpBinary()

;~ 	$header = BinaryMid($data, 1, 55) ; first 55 bytes
;~ 	$meta = BinaryMid($data, 56, 19)  ; next 19 bytes
;~ 	$body = BinaryMid($data, 56 + 19, BinaryLen($data) - 55 - 19 - 2)
;~ 	$checksum = BinaryMid($data, BinaryLen($data)-1, 2)

	$output = "Header:" & @CRLF & Hex($data.header) & @CRLF & _
		@CRLF & _
		"Meta:" & @CRLF & Hex($data.meta) & @CRLF & _
		@CRLF & _
		"Body:" & @CRLF & BinaryToListOfHexCodes($data.body) & @CRLF & _
		@CRLF & _
		"Checksum: " & Hex($data.checksum)

;~ 	debug($output)

	FileWrite(FileOpen($outputFile, 2), $output)
	If @error Then debug("Could not write output file: " & $outputFile)

EndFunc




; Takes a block of binary and returns a string of hex characters.
; Used for debugging and doing comparisons in a text compare tool like WinMerge
Func BinaryToListOfHexCodes($binary)

	; Create one looooong hex string
	Local $string = Hex($binary)

	; Split long hex string into one byte (two hex characters) per line
	$string = StringRegExpReplace($string, "\w\w", "\0" & @CRLF)

	; Except for certain prefixes which will be 4 per line
	; (?m) activates multiline mode
	; We strip the line return following these prefixes:
	$string = StringRegExpReplace($string, "(?m)^(5C|5D|5E|60|61|62|63|7E|AA|BB|EF)\s+", "\1")

	; Now append the actual textual representation of the token after each, for easier reading/identification
	$array = StringSplit($string, @CRLF, $STR_ENTIRESPLIT + $STR_NOCOUNT)
	For $i = 0 To UBound($array) - 1
		$tokenCode = Dec($array[$i])
		$matchingIndex = _ArrayBinarySearch($8xpTokens, $tokenCode, 0, 0, 0)
		If $matchingIndex > -1 Then
			$token = $8xpTokens[$matchingIndex][1]
			$token = StringReplace($token, @CRLF, "[CRLF]")
			If $token = " " Then $token = "[space]"
			$array[$i] &= @TAB & $token
		Else
			$array[$i] &= @TAB & "(No matching token found)"
		EndIf
	Next

	$string = _ArrayToString($array, @CRLF)

	Return $string
EndFunc

;~ MsgBox(0,"", BinaryToListOfHexCodes(Binary("0x00112233AABBCCDDEECCFF")))

#include <FileConstants.au3>
#include "Calculate8xpChecksum.au3"
#include "OptimizeCode.au3"

;~ $filename = "temp\Hex Files to Compare\PROG3.8xp"

; Reads binary 8XP file, decompiles it, performs the processing/optimisation steps,
; and then recompiles it, calculates the checksum, and writes a new binary file
Func Process8xpppFile($inputFile, $outputFile)

   ; Open file and read data
   $file = FileOpen($inputFile, $FO_BINARY)
   $data = FileRead($file)
   FileClose($file)

   If @error Then
	  ConsoleWriteError("Compilation failed. Could not read " & $inputFile & @CRLF)
	  Return
   EndIf

   ; Extract sections of file
   $header = BinaryMid($data, 1, 55) ; first 55 bytes
   $meta = BinaryMid($data, 56, 19)  ; next 19 bytes
   $body = BinaryMid($data, 56 + 19, BinaryLen($data) - 55 - 19 - 2)

   ;~ MsgBox(0, "", $header);
   ;~ MsgBox(0, "", $meta);
   ;~ MsgBox(0, "", $body);

   ; Perform optimization operations on body section
   ; for now, just remove last two characters
;~    $body = BinaryMid($body, 1, BinaryLen($body) - 2)
   $body = ProcessBody($body, $inputFile, $outputFile)

   ; Recalculate new length of file
   Const $metaLength = 19			; always 19 bytes
   Const $checksumLength = 2		; always 2 bytes
   $bodyLength = BinaryLen($body)
   $metaAndBodyLength = $metaLength + $bodyLength
   $bodyAndChecksumLength = $bodyLength + $checksumLength

   ;~ MsgBox(0, "", Binary($bodyLength))

   ; Update fields within the header and meta to match the new length
   $header = BinaryModifyWord($header, 0x35 + 1, $metaAndBodyLength)
   $meta   = BinaryModifyWord($meta, 0x39 - 55 + 1, $bodyAndChecksumLength)
   $meta   = BinaryModifyWord($meta, 0x46 - 55 + 1, $bodyAndChecksumLength)
   $meta   = BinaryModifyWord($meta, 0x48 - 55 + 1, $bodyLength)

   ; Recombine header, meta, body
   $data = $header & $meta & $body

   ; Append checksum as the final 2 bytes of file
   $data = $data & Calculate8xpChecksum($data)

   ; Write to new file
   $file2 = FileOpen($outputFile, $FO_OVERWRITE + $FO_BINARY)
   FileWrite($file2, $data)
   FileClose($file2)

EndFunc


; Takes a block of binary code and decompiles, processes/manipulates it, and recompiles it
; Returns the updated binary code
;
; Does NOT work with the 8XP header, meta data, nor checksum. It's the program body only.
;
; During this process we also save a text copy of the original code and the optimized code
; (for use with source control and also for debugging issues with this script)
Func ProcessBody($binaryCode, $inputFile, $outputFile)

	; Convert binary code to text
	$textCode = BinaryCodeToTextCode($binaryCode)

	; Save a copy of original text code to disk
	; Can maybe just use a single FileWrite() call here, when just UTF8 text? Defaults to overwriting?
	$file = FileOpen($inputFile & "-source", $FO_OVERWRITE)
	FileWrite($file, $textCode)
	FileClose($file)

	; Process/manipulate the text-based code
	; $textCode &= @LF & "::: Appended!"
	$textCode = OptimizeCode($textCode)

	; Save processed text to file
	; Can maybe just use a single FileWrite() call here, when just UTF8 text? Defaults to overwriting?
	$file = FileOpen($outputFile & "-source", $FO_OVERWRITE)
	FileWrite($file, $textCode)
	FileClose($file)

	; Recompile back to binary format
	$binaryCode = TextCodeToBinaryCode($textCode)

	; Return original binary code, for now, until rest is implemented
	Return $binaryCode
EndFunc


#include "Tokens.au3"
#include <Array.au3>
Func BinaryCodeToTextCode($binaryCode)
	$textCode = ""

	; Loop through every character in file and replace with text representation
	For $i = 1 To BinaryLen($binaryCode)
		$char = BinaryMid($binaryCode, $i, 1)

		; TODO: Could potentially speed this up by not searching the array for
		; known 2-byte prefixes.
		; Could also potentially split the tokens into 2 arrays, single byte and double byte
		; so we're not searching the list unnecessarily
		; Anyway, seems fast enough for now...?

		$tokenIndex = _ArrayBinarySearch($8xpTokens, $char, 0, 0, 0)
		If $tokenIndex > -1 Then
;~ 			ConsoleWrite("Token found" & @CRLF)
;~ 			ConsoleWrite($tokenIndex)
			$textCode = $textCode & $8xpTokens[$tokenIndex][1]
			ContinueLoop
		EndIf

		; If not found within the list, it might be a 2-byte character, so let's look for that
		; Note: AutoIt converts binary to int in little endian format, which is NOT how 8XPs work.
		$char2 = BinaryMid($binaryCode, $i+1, 1)
		$tokenIndex = _ArrayBinarySearch($8xpTokens, Number($char2 & $char), 0, 0, 0)
		If $tokenIndex > 0 Then
;~ 			ConsoleWrite("Token found" & @CRLF)
;~ 			ConsoleWrite($tokenIndex)
			$textCode = $textCode & $8xpTokens[$tokenIndex][1]

			; Skip the next char because it's now used
			$i += 1

			ContinueLoop
		EndIf

		ConsoleWrite("Tokens " & $char & " and " & $char2 & " (" & Number($char2 & $char) & ") not found" & @CRLF)
	Next


	Return $textCode
EndFunc




; Updates 2 bytes within a binary variable at a specific position (indexed from 1)
; Supports numbers, binary vars, or strings like "0x12AB"
Func BinaryModifyWord($binaryData, $startingByte, $newData)
   Return BinaryMid($binaryData, 1, $startingByte - 1) & BinaryMid($newData, 1, 2) & BinaryMid($binaryData, $startingByte + 2)
EndFunc
;~ MsgBox(0, "BinaryModifyWord", BinaryModifyWord(Binary("0xAABBCCDDEEEE"), 3, "0x9999"))


; COMPILATION: Text to binary tokens
;
; This process is probably a little more complicated than the other way around (which is just reading bytes)
; Here we have to go character by character through the text and check for matching tokens
; and convert them to binary equivalent
;
; Things to watch out for:
;   - Some text strings match multiple binary tokens. For these we probably take the earliest match. Hmmm. TBC
;   - Some tokens appear like other ones:
;     "Horiz" and "Horizontal ", "Polar" and "PolarGC", "Q" and "Q₁", "r" and "r₁", "rand" and "randBin(" and "randInt(", "Seq" and "Sequential"
;     "s" and "sin(", "c" and "cos(", etc.
;	  We should always opt for the longer one, if it matches
;     The easiest (but slowest) way is to find the longest token, and for each character, grab that many subsequent characters, reducing
;     one by one until we find a matching token. But the loop will have to run 14x the number of characters in the file.
;	  Array search will likely need to be optimized by pre-indexing the array.
;
; Does NOT yet support the old/alternative strings, only the official TI Connect CE ones.
#include <Math.au3>
#include "Tokens.au3"

; Process8xpppFile("..\Tests\Test Decompile\CLOSURE2.8xppp", "..\Tests\Test Decompile\CLOSURE2.compiled.8xp")
;~ $a = _ArrayExtract($8xpTokens, 1, 1)
;~ _ArrayTranspose($a)
;~ _ArrayDisplay($a)

; Here is a simple test of this function. Should result in 0x12131415
;~ ConsoleWriteError("Oooops" & @CRLF)
$bin = Binary("")
;~ debug(Hex(TokenIntToBinary(0xAA11) & TokenIntToBinary(0x12) & TokenIntToBinary(0x13)))

debug("Result: " & Hex(TextCodeToBinaryCode("round(pxl-Test(augment(rowSwap(DDisp L₁")) & @CRLF)

Func TokenIntToBinary($int)
	; Ints are normally 4 bytes long, but we actually only want either 1 or 2 bytes
	Local $result
	If $int < 256 Then
		$result = BinaryMid($int, 1, 1)
	Else
		$result = BinaryMid($int, 2, 1) & BinaryMid($int, 1, 1)
	EndIf
;~ 	debug($result)
	Return $result
EndFunc


Func TextCodeToBinaryCode($text)
	Local $binary = Binary("")

	; Create a map for efficiently looking up tokens
	Local $tokens[]
;~ 	$tokens["Simon"] = "x"
;~ 	$tokens["Hello"] = "y"
;~ 	ConsoleWrite($tokens["Simon"])
	For $i = 0 to UBound($8xpTokens) - 1
;~ 		ConsoleWrite($i & " " & VarGetType($8xpTokens[$i][1]) & " " & $8xpTokens[$i][0] & " " & $8xpTokens[$i][1] & @CRLF)
		$tokenText = $8xpTokens[$i][1]
		$tokenBinary = TokenIntToBinary($8xpTokens[$i][0])
		; If $val = 1 Then ContinueLoop
		$tokens[$tokenText] = $tokenBinary
	Next

;~ 	DebugMap($tokens)

	debug("Tokens have been indexed")

	; Loop through entire string, character by character
	; TODO: This may (currently) be case sensitive. To be explored whether I should fix that.
	$textLength = StringLen($text)
	For $i = 1 to StringLen($text)
		; Start with grabbing the next 14 chars (the length of the longest token)
		; and keep removing characters until we find a matching token
		For $j = _Min(14, $textLength - $i + 1) to 1 Step -1
			$portion = StringMid($text, $i, $j)

			If MapExists($tokens, $portion) Then
				; Great, we've found a match
				; Put the token into our binary result
				debug($portion)
				debug("Found match: " & $tokens[$portion])
				$binary = $binary & $tokens[$portion]
				debug($binary)
				; Increment $i to not re-search for any of those same chars
				$i += $j-1
				ExitLoop

			ElseIf $j = 1 Then
				$char = StringMid($text, $i, 1)
				; TODO: Maybe this should be a fatal error?
				debug("COULD NOT FIND TOKEN MATCH FOR CHARACTER: """ & $char & """, ASCII Code: " & Asc($char) & ", Unicode: " & AscW($char) & ". Character skipped, with no bytes added for this.")
			EndIf

		Next
	Next

	Return $binary

;~ 	Exit

EndFunc

Func debug($string)
	ConsoleWrite($string & @CRLF)
EndFunc

Func DebugMap($map)
	_ArrayDisplay(MapKeys($map))
	For $key in MapKeys($map)
		ConsoleWrite("[" & $key & "] = " & $map[$key] & @CRLF)
	Next
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

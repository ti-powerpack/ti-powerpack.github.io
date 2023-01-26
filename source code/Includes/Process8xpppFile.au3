#include <FileConstants.au3>
#include "Calculate8xpChecksum.au3"
#include "OptimizeCode.au3"

;~ $filename = "temp\Hex Files to Compare\PROG3.8xp"

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
   $bodyLength = BinaryLen($body)
   $metaAndBodyLength = $bodyLength + 19
   $bodyAndChecksumLength = $bodyLength + 2

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


; Takes binary code and decompiles, processes/manipulates it, and recompiles it
; Returns the updated binary code
; Here we also save a text copy of the original code and the optimized code
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
	; TODO......

	; Return original binary code, for now, until rest is implemented
	Return $binaryCode
EndFunc


#include "Tokens.au3"
#include <Array.au3>

Process8xpppFile("..\Tests\Test Decompile\CLOSURE2.8xppp", "..\Tests\Test Decompile\CLOSURE2.compiled.8xp")
;~ _ArrayDisplay($8xpTokens)

Func BinaryCodeToTextCode($binaryCode)
	$textCode = ""

	; Loop through every character in file and replace with text representation
	For $i = 1 To BinaryLen($binaryCode)
		$char = BinaryMid($binaryCode, $i, 1)

		; TODO: Could potentially speed this up by not searching the array for
		; known 2-byte prefixes.
		; Could also potentially split the tokens into 2 arrays, single byte and double byte
		; so we're not searching the list unnecessarily

		$tokenIndex = _ArrayBinarySearch($8xpTokens, $char, 0, 0, 0)
		If $tokenIndex > 0 Then
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
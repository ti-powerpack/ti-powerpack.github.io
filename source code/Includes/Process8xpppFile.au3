#include-once
#include <FileConstants.au3>
#include "Calculate8xpChecksum.au3"
#include "OptimizeCode.au3"
#include "Tokens.au3"
#include "Debug.au3"
#include <Array.au3>

;~ $filename = "temp\Hex Files to Compare\PROG3.8xp"

; Reads and does basic parsing on an 8XP file
; Returns a map with the elements: programName, header, meta, body, checksum (all binary, except for programName)
Func Read8xpBinary($inputFilePath)

	; Open file and read data
	; Make 10 attempts as occasionally TI Connect is still writing to file and
	; the FileOpen() fails
	For $i = 0 to 10
		Local $file = FileOpen($inputFilePath, $FO_BINARY)
		If $file > -1 Then ExitLoop
		Sleep(100)
	Next
   If $file = -1 Then
	  Debug("  - FileOpen() failed after 10 attempts. Could not read " & $inputFilePath)
	  SetError(1)
	  Return
   EndIf

   Local $data = FileRead($file)
   If @error Then
	  SetError(2)
	  Debug("  - FileRead() failed. Could not read " & $inputFilePath)
	  Return
   EndIf
   FileClose($file)

   Local $binarySegments[]

   ; Extract sections of file
   $binarySegments.programName = BinaryMid($data, 0x3C + 1, 8)
   $binarySegments.isBasicProgram = (BinaryMid($data, 0x4A + 1, 2) <> Binary("0xBB6D"))
   Debug("  - Is Basic Prog? " & $binarySegments.isBasicProgram & " " & BinaryMid($data, 0x4A + 1, 2))
   $binarySegments.header = BinaryMid($data, 1, 55) 						; first 55 bytes
   $binarySegments.meta = BinaryMid($data, 56, 19)  						; next 19 bytes
   $binarySegments.body = BinaryMid($data, 56 + 19, BinaryLen($data) - 55 - 19 - 2)
   $binarySegments.checksum = BinaryMid($data, BinaryLen($data) - 1, 2)		; last 2 bytes

   Return $binarySegments
EndFunc

; Reads binary 8XP file, decompiles it, performs the processing/optimisation steps,
; and then recompiles it, calculates the checksum, and writes a new binary file
Func Process8xpppFile($inputFile, $outputFile, $performOptimization = True)

	Local $timer = TimerInit()

	Local $data = Read8xpBinary($inputFile)
	If @error Then Return

	; Exit here if this is an assembly program
	If Not $data.isBasicProgram Then
		Debug("  - Assembly program detected. Skipping optimization and compilation steps.")
		SetError(1)
		Return
	EndIf

	; Perform optimization operations on body section
	$data.body = ProcessBody($data.body, $inputFile, $outputFile, $performOptimization)

	Update8xpLengthFields($data)

	Write8xpBinary($data, $outputFile)

	Debug("  - Processing complete in: " & TimerDiff($timer)/1000 & " seconds")

EndFunc


; This function updates the .header and .meta sections
; with the correct length of .body
; Without this, the file may be invalid
Func Update8xpLengthFields(ByRef $binary)

	; Since this optimization operation may have affected the length of the file,
   ; we need to update the numbers in a few places.
   ; Recalculate new length of file:
   Const $metaLength = 19			; always 19 bytes
   Const $checksumLength = 2		; always 2 bytes
   Local $bodyLength = BinaryLen($binary.body)
   Local $metaAndBodyLength = $metaLength + $bodyLength
   Local $bodyAndChecksumLength = $bodyLength + $checksumLength

   ;~ MsgBox(0, "", Binary($bodyLength))

   ; Update fields within the header and meta to match the new length
   $binary.header = BinaryModifyWord($binary.header, 0x35 + 1, $metaAndBodyLength)
   $binary.meta   = BinaryModifyWord($binary.meta, 0x39 - 55 + 1, $bodyAndChecksumLength)
   $binary.meta   = BinaryModifyWord($binary.meta, 0x46 - 55 + 1, $bodyAndChecksumLength)
   $binary.meta   = BinaryModifyWord($binary.meta, 0x48 - 55 + 1, $bodyLength)

EndFunc


; Provide a map with .header, .meta and .body (all binary)
; Calculates the checksum, and writes to a file
Func Write8xpBinary($binaryPortions, $outputFile)
	; Recombine header, meta, body
   Local $data = $binaryPortions.header & $binaryPortions.meta & $binaryPortions.body

   ; Append checksum as the final 2 bytes of file
   $data = $data & Calculate8xpChecksum($data)

   ; Write to new file
   Local $file2 = FileOpen($outputFile, $FO_OVERWRITE + $FO_BINARY)
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
Func ProcessBody($binaryCode, $inputFile, $outputFile, $performOptimization = True)

	Local $timer = TimerInit();

	; Convert binary code to text
	Local $textCode = BinaryCodeToTextCode($binaryCode)

	ShowTimeTaken($timer, "  - Code decompiled in")

	; Save a copy of original text code to disk
	; Can maybe just use a single FileWrite() call here, when just UTF8 text? Actually NO. Defaults to appending.
	Local $file = FileOpen($inputFile & "-source", $FO_OVERWRITE)
	FileWrite($file, $textCode)
	FileClose($file)

	$timer = TimerInit();

	; Process/manipulate the text-based code
	; $textCode &= @LF & "::: Appended!"
	If $performOptimization Then
		$textCode = OptimizeCode($textCode)
	EndIf

	ShowTimeTaken($timer, "  - Code optimized in")

	; Save processed text to file
	; Can maybe just use a single FileWrite() call here, when just UTF8 text? Actually NO. Defaults to appending.
	$file = FileOpen($outputFile & "-source", $FO_OVERWRITE)
	FileWrite($file, $textCode)
	FileClose($file)

	$timer = TimerInit()

	; Recompile back to binary format
	$binaryCode = TextCodeToBinaryCode($textCode)

	ShowTimeTaken($timer, "  - Code compiled in")

	Return $binaryCode
EndFunc


Func ShowTimeTaken($timer, $description)
	debug($description & ": " & (TimerDiff($timer) / 1000) & " seconds")
EndFunc



Func BinaryCodeToTextCode($binaryCode)
	Local $textCode = ""

	; Loop through every byte in file and replace with text representation
	For $i = 1 To BinaryLen($binaryCode)

		; Grab a single byte
		Local $char = BinaryMid($binaryCode, $i, 1)

		; TODO: Could potentially speed this up by not searching the array for
		; known 2-byte prefixes.
		; Could also potentially split the tokens into 2 arrays, single byte and double byte
		; so we're not searching the list unnecessarily
		; Anyway, seems fast enough for now...?

		; Does this byte exist in our list?
		; If so, output the relevant text representation and continue onto next byte
		Local $tokenIndex = _ArrayBinarySearch($8xpTokens, $char, 0, 0, 0)
		If $tokenIndex > -1 Then
;~ 			ConsoleWrite("Token found" & @CRLF)
;~ 			ConsoleWrite($tokenIndex)
			$textCode = $textCode & $8xpTokens[$tokenIndex][1]
			ContinueLoop
		EndIf

		; If not found within the list, it might be a 2-byte character, so let's look for that
		; Note: AutoIt converts binary to int in little endian format, which is NOT how 8XPs work.
		Local $char2 = BinaryMid($binaryCode, $i+1, 1)
		$tokenIndex = _ArrayBinarySearch($8xpTokens, Number($char2 & $char), 0, 0, 0)
		If $tokenIndex > 0 Then
;~ 			ConsoleWrite("Token found" & @CRLF)
;~ 			ConsoleWrite($tokenIndex)
			$textCode = $textCode & $8xpTokens[$tokenIndex][1]

			; Skip the next char because it's now used
			$i += 1

			ContinueLoop
		EndIf

		; If we got this far, it means that we couldn't find the binary characters in our official list
		debug("Token " & $char & ", followed by " & $char2 & " (Int values " & Number($char2 & $char) & ") not found")
	Next


	Return $textCode
EndFunc



; Updates a single byte within a binary variable at a specific position (indexed from 1)
; Supports numbers, binary vars, or strings like "0x12AB"
Func BinaryModifyByte($binaryData, $startingByte, $newData)
   Return BinaryModifySection($binaryData, $startingByte, 2, $newData)
EndFunc
;~ MsgBox(0, "BinaryModifyByte", BinaryModifyByte(Binary("0xAABBCCDDEEEE"), 3, "0x9999"))


; Updates 2 bytes within a binary variable at a specific position (indexed from 1)
; Supports numbers, binary vars, or strings like "0x12AB"
Func BinaryModifyWord($binaryData, $startingByte, $newData)
   Return BinaryModifySection($binaryData, $startingByte, 1, $newData)
EndFunc
;~ MsgBox(0, "BinaryModifyWord", BinaryModifyWord(Binary("0xAABBCCDDEEEE"), 3, "0x9999"))

; Replaces a chunk of binary with another chunk
; Overall length of original binary remains the same
; Starting byte is indexed from 1 NOT zero
Func BinaryModifySection($binaryData, $startingByte, $length, $newData)
   Return BinaryMid($binaryData, 1, $startingByte - 1) & BinaryPad(BinaryMid($newData, 1, $length), $length) & BinaryMid($binaryData, $startingByte + $length)
EndFunc

; Extends the length of a binary variable by padding 0x00's to the end, up to specified length
; Does NOT truncate variables that are too long
Func BinaryPad($binaryData, $newLength)
	While BinaryLen($binaryData) < $newLength
		$binaryData = $binaryData & Binary("0x00")
	WEnd
	Return $binaryData
EndFunc



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
;~ $bin = Binary("")
;~ debug(Hex(TokenIntToBinary(0xAA11) & TokenIntToBinary(0x12) & TokenIntToBinary(0x13)))

;~ debug("Result: " & Hex(TextCodeToBinaryCode("round(pxl-Test(augment(rowSwap(DDisp L₁")) & @CRLF)


; Converts 0x62 or 0x6212 into actual binary representing those one or two bytes
; Ints in AutoIt are normally 4 bytes long, but we actually only want either 1 or 2 bytes
; And two bytes need reversing as AutoIt stores them as little endian I think?
Func TokenIntToBinary($int)
	Local $result
	If $int < 256 Then
		; Return 1 byte
		$result = BinaryMid($int, 1, 1)
	Else
		; Return 2 bytes
		$result = BinaryMid($int, 2, 1) & BinaryMid($int, 1, 1)
	EndIf
;~ 	debug($result)
	Return $result
EndFunc


Func TextCodeToBinaryCode($text)
	Local $binary = Binary("")

	; Create a map for efficiently looking up tokens
	; The text string is the key, and binary code is the value (either 1 or 2 bytes)
	; We loop through the list in REVERSE since there are a few duplicate tokens in the list
	; and we want EARLIER tokens to take priority over later ones
	;
	; TODO: We are NOT currently handling the alternative text options that are provided in the tokens list.
	;       These might be useful in some cases.
	Local $tokens[]
	For $i = UBound($8xpTokens) - 1 To 0 Step -1
;~ 		ConsoleWrite($i & " " & VarGetType($8xpTokens[$i][1]) & " " & $8xpTokens[$i][0] & " " & $8xpTokens[$i][1] & @CRLF)

		; Skip 0x00 as it breaks things, and I don't think we need it for compilation? Do we...?
		If $8xpTokens[$i][0] == 0 Then ContinueLoop

		Local $tokenText = $8xpTokens[$i][1]
		Local $tokenBinary = TokenIntToBinary($8xpTokens[$i][0])

		; If $val = 1 Then ContinueLoop
		$tokens[$tokenText] = $tokenBinary
	Next

;~ 	DebugMap($tokens)
;~ 	debug($tokens["["])

	; debug("Tokens have been indexed")

	; Loop through entire string, character by character
	; TODO: This may (currently) be case sensitive. To be explored whether I should fix that.
	Local $textLength = StringLen($text)
	For $i = 1 to $textLength
		; Start with grabbing the next 14 chars (the length of the longest token)
		; and keep removing characters until we find a matching token
		For $j = _Min(14, $textLength - $i + 1) to 1 Step -1
			Local $portion = StringMid($text, $i, $j)

			If MapExists($tokens, $portion) Then
				; Great, we've found a match
				; Put the token into our binary result
;~ 				debug($portion)
;~ 				debug("Found match: " & $tokens[$portion])
				$binary = $binary & $tokens[$portion]
;~ 				debug($binary)
				; Increment $i to not re-search for any of those same chars
				$i += $j-1
				ExitLoop

			ElseIf $j = 1 Then
				$char = StringMid($text, $i, 1)
				; TODO: Maybe this should be a fatal error?
				debug("  - COULD NOT FIND TOKEN MATCH FOR CHARACTER: """ & $char & """, ASCII Code: " & Asc($char) & ", Unicode: " & AscW($char) & ". Character skipped, with no bytes added for this.")
			EndIf

		Next
	Next

	Return $binary

;~ 	Exit

EndFunc

#include-once
#include <FileConstants.au3>
#include "Calculate8xpChecksum.au3"
#include "OptimizeCode.au3"
#include "Tokens.au3"
#include "Debug.au3"
#include <Array.au3>
#include "Create Theta Version Functions.au3"
#include "PathTools.au3"

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

   ; Attempt to read the data
   Local $data = FileRead($file)

   ; If there was an error reading file data...
   If @error Then
	  SetError(2)
	  Debug("  - FileRead() failed. Could not read " & $inputFilePath)
	  Return
   EndIf
   FileClose($file)

   Local $binarySegments[]

   ; Extract sections of file
   ; Theta characters that appear in some program names are actually the "[" character in ASCII
   $binarySegments.programNameBinary = BinaryMid($data, 0x3C + 1, 8)
   $binarySegments.programName = StringStripWS(BinaryToString($binarySegments.programNameBinary), 3)
   $binarySegments.isBasicProgram = (BinaryMid($data, 0x4A + 1, 2) <> Binary("0xBB6D"))
   ; Debug("  - Is Basic Prog? " & $binarySegments.isBasicProgram & " " & BinaryMid($data, 0x4A + 1, 2))
   $binarySegments.header = BinaryMid($data, 1, 55) 						; first 55 bytes
   $binarySegments.meta = BinaryMid($data, 56, 19)  						; next 19 bytes
   $binarySegments.body = BinaryMid($data, 56 + 19, BinaryLen($data) - 55 - 19 - 2)
   $binarySegments.checksum = BinaryMid($data, BinaryLen($data) - 1, 2)		; last 2 bytes

   Return $binarySegments
EndFunc

Func Is8xpBinaryFile($filePath)

	Local $file = FileOpen($filePath, $FO_BINARY)

	; Handle error getting handle
	If $file = -1 Then
	  Debug("  - ERROR: Could not open file: " & $filePath)
	  SetError(1)
	  Return
	EndIf

	; Attempt to read the data (8 chars)
	Local $data = FileRead($file, 8)

	; If there was an error reading file data...
	If @error Then
	  SetError(2)
	  Debug("  - ERROR: Could not read from file: " & $filePath)
	  Return
	EndIf

	FileClose($file)

	If $data = Binary("**TI83F*") Then
		Return True
	Else
		Return False
	EndIf

EndFunc

Func IsPlainText($fileContents)
	;~ If Not IsBinary($fileContents) Then Return SetError(1, 0, False)

    Local $iLen = BinaryLen($fileContents)
    If $iLen = 0 Then Return True  ; Empty file → treat as text

    Local $iBadCount = 0
    Local $bHasNull = False

    Local $iByteVal
    For $i = 1 To $iLen
        $iByteVal = Dec(Hex(BinaryMid($fileContents, $i, 1)))

        If $iByteVal = 0 Then $bHasNull = True

        ; Good bytes: TAB(9), LF(10), FF(12), CR(13), ESC(27), printable ASCII 32-126, all high bytes 128-255
        If Not ($iByteVal = 9 Or $iByteVal = 10 Or $iByteVal = 12 Or $iByteVal = 13 Or $iByteVal = 27 Or _
                ($iByteVal >= 32 And $iByteVal <= 126) Or _
                $iByteVal >= 128) Then
            $iBadCount += 1
        EndIf

        ; Early exit optimisation for very bad files (optional but useful)
        If $iBadCount * 100 > $iLen * 30 Then ExitLoop
    Next

    ; Null byte → definitely binary
    If $bHasNull Then Return False

    ; More than ~30% bad control bytes → binary
    If $iBadCount * 100 > $iLen * 30 Then Return False

    Return True
EndFunc

; Reads binary 8XP file, decompiles it, performs the processing/optimisation steps,
; and then recompiles it, calculates the checksum, and writes a new binary file
Func Process8xpppFile($inputFile, $outputFile, $performOptimization = True)

	Local $timer = TimerInit()
	Local $data[]
	Local $isBinary

	; Is this file a binary 8XP or plain source code?
	If Is8xpBinaryFile($inputFile) Then

		; We'll read in the binary 8XP file content, and make only the minimal changes needed
		; keeping the existing header and metadata intact
		$data = Read8xpBinary($inputFile)
		$isBinary = True

	Else

		$fileContents = FileRead($inputFile)
		If @error Then
			Debug("  - ERROR: Could not read from file: " & $inputFile)
			SetError(1)
			Return
		EndIf

		; If not plain text, then it's an invalid file. Exit here.
		If Not IsPlainText($fileContents) Then
			Debug("  - ERROR. Cannot proceed. Input file is neither a valid 8XP binary nor plain text source code: " & $inputFile)
			SetError(1)
			Return
		EndIf

		; If we've reached here, the file appears to be plain text source code
		$isBinary = False

		Debug("  - Input file detected as plain text source code")

		; Create basic 8XP structure:

		; Program name: derived from input filename
		; (Later, we might provide options to customize the program name via either a command line arg
		; or via metadata within the source code itself (like a special comment at the top))
		; We'll enforce uppercase letters and numbers only, max 8 chars
		$data.programName = StringUpper(StringLeft(StringRegExpReplace(FileNameNoExt($inputFile), "[^A-Za-z0-9]", ""), 8))

		Debug("  - Program name set to: " & $data.programName & " from " & FileNameNoExt($inputFile))

		$data.isBasicProgram = True

		; Header
		$data.header = _
			Binary("**TI83F*") & _		; TI83F signature
			Binary("0x1a0a0a") & _ 	    ; Signature part 2 and mystery byte
			PadWithNullBytes(Binary("Created by Powerpack"), 42) & _ ; Creator string, padded to 42 bytes
			Binary("0x0000")			; header.metaAndBodyLength (to be updated later)

		; Meta
		$data.meta = _
			Binary("0x0D") & _			; meta.flag
			Binary("0x00") & _			; meta.unknown
			Binary("0x0000") & _			; meta.bodyAndChecksumLength (to be updated later)
			Binary("0x05") & _			; meta.fileType (0x05 = Basic program)
			PadWithNullBytes(Binary($data.programName), 8) & _	; meta.programName (padded to 8 bytes)
			Binary("0x00") & _				; meta.version (not really sure what this does, but we'll set to 0)
			Binary("0x00") & _			; meta.isArchived
			Binary("0x0000") & _			; meta.bodyAndChecksumLength2 (to be updated later)
			Binary("0x0000") 				; meta.bodyLength (to be updated later)

		$data.body = $fileContents	; Plain text source code

	EndIf

	If @error Then Return

	; Exit here if this is an assembly program
	If Not $data.isBasicProgram Then
		Debug("  - Assembly program detected. Skipping optimization and compilation steps.")
		SetError(1)
		Return
	EndIf

	; Debug("  - File read in: " & Round(TimerDiff($timer)/1000, 3) & " seconds")

	; Perform parsing and optimization operations on body section
	$data.body = ProcessBody($data.body, $isBinary, $inputFile, $outputFile, $performOptimization, $data.programName)

	; Update length fields in header and meta sections to match new body length
	Update8xpLengthFields($data)

	; Apply version fix for WabbitEmu compatibility
	VersionFix($data)

	; Check destination folder exists, create if not
	Local $folder = Folder($outputFile)
	If Not FileExists($folder) Then	DirCreate($folder)

	; Write out new 8XP binary file
	Write8xpBinary($data, $outputFile)

	$timer2 = TimerInit()
	CreateThetaVersion($outputFile)
	ShowTimeTaken($timer2, "  - Theta version written in")

	Debug("  - Processing complete in: " & Round(TimerDiff($timer)/1000, 3) & " seconds")

EndFunc

; Takes a binary string and pads it with null bytes (0x00) up to the desired length
Func PadWithNullBytes($binary, $desiredLength)
	While BinaryLen($binary) < $desiredLength
		$binary &= Binary("0x00")
	WEnd
	Return $binary
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

   ; Update fields within the header and meta to match the new length:
   ; - header.metaAndBodyLength at offset 0x35 (2 bytes)
   ; - meta.bodyAndChecksumLength at offset 0x39 (2 bytes)
   ; - meta.bodyAndChecksumLength2 at offset 0x46 (2 bytes)
   ; - meta.bodyLength at offset 0x48 (2 bytes)
   $binary.header = BinaryModifyWord($binary.header, 0x35 + 1, $metaAndBodyLength)
   $binary.meta   = BinaryModifyWord($binary.meta, 0x39 - 55 + 1, $bodyAndChecksumLength)
   $binary.meta   = BinaryModifyWord($binary.meta, 0x46 - 55 + 1, $bodyAndChecksumLength)
   $binary.meta   = BinaryModifyWord($binary.meta, 0x48 - 55 + 1, $bodyLength)

EndFunc

; Small workaround for WabbitEmu bug whereby version field cannot exceed 0x06
Func VersionFix(ByRef $binary)
	; Change the 14th byte to a value of 6 (0x06)
	$binary.meta = BinaryModifyByte($binary.meta, 14, 6)
EndFunc


; Writes out an 8XP binary file from provided portions
; Provide a map object with .header, .meta and .body (all binary)
; Assumes that length fields are already correct, see Update8xpLengthFields()
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
Func ProcessBody($code, $isBinary, $inputFile, $outputFile, $performOptimization = True, $programName = "")

;~ 	Debug("Output file: " & $outputFile)
;~ 	Debug("Output file 2: " & FileAppendPath($outputFile, "Source Code as Text"))

	Local $timer = TimerInit();

	; Convert binary code to text
	Local $textCode = $isBinary ? BinaryCodeToTextCode($code) : $code

	ShowTimeTaken($timer, "  - Code decompiled in")

	; Save a copy of original text code to disk, under a different filename/path
	If $isBinary Then SaveSourceCodeToTextFile($inputFile, $textCode)

	Local $timer = TimerInit();

	; Process/manipulate the text-based code
	; $textCode &= @LF & "::: Appended!"
	If $performOptimization Then
		$textCode = OptimizeCode($textCode, $inputFile)
		ShowTimeTaken($timer, "  - Code optimized in")
	EndIf

	; Save processed text to file
	; Can maybe just use a single FileWrite() call here, when just UTF8 text? Actually NO. Defaults to appending.
	Local $file = FileOpen(FileAppendPath($outputFile, "..\Source Code as Text") & "-source", $FO_OVERWRITE)
	If Not FileWrite($file, $textCode) Then Debug("  ERROR: Could not write output source file.")
	If Not FileFlush($file) Then Debug("  ERROR: Could not flush output source file.")
	If Not FileClose($file) Then Debug("  ERROR: Could not close output source file.")

	; Recompile back to binary format
	$timer = TimerInit()
	Local $binaryCode = TextCodeToBinaryCode($textCode)
	ShowTimeTaken($timer, "  - Code compiled in")

	; Produce another text file that shows each line of the optimized text code alongside the number of bytes it compiles to, for debugging purposes
	$timer = TimerInit()
	Local $textCodeWithByteCounts = GenerateByteCounts($textCode, $programName)
	$file = FileOpen(FileAppendPath($outputFile, "..\Source Code as Text") & "-byte-counts", $FO_OVERWRITE)
	If Not FileWrite($file, $textCodeWithByteCounts) Then Debug("  ERROR: Could not write byte count file.")
	If Not FileFlush($file) Then Debug("  ERROR: Could not flush byte count file.")
	If Not FileClose($file) Then Debug("  ERROR: Could not close byte count file.")
	ShowTimeTaken($timer, "  - Byte-count file written in")

	Return $binaryCode
EndFunc

; This function generates a string that shows each line of the
; optimized text code alongside the number of bytes it compiles to,
; for debugging & optimization purposes
Func GenerateByteCounts($textCode, $programName = "")
	Local $output = ""
	Local $lines = StringSplit($textCode, @CRLF, 1)
	Local $totalBytes = 0

	For $i = 1 To $lines[0]
		Local $line = $lines[$i]
		Local $binary = TextCodeToBinaryCode($line)
		; add 1 byte for the newline, on all except the last line
		Local $byteCount = BinaryLen($binary) + ($i < $lines[0] ? 1 : 0)
		$totalBytes += $byteCount
		$output &= StringFormat("%4d", $byteCount) & " bytes: " & $line & @CRLF
	Next

	; Display total byte count at the end, and also total byte count including header and program name (for context)
	$output &= "------------------" & @CRLF
	$output &= StringFormat("%4d bytes total", $totalBytes) & @CRLF
	; Not exactly sure why header is 9 bytes when loaded onto calc, but seems to be the case based on testing
	; Probably internal metadata: potentially the checksum and type of program
	$output &= StringFormat("%4d bytes total (including header and program name: %s)", $totalBytes + 9 + StringLen($programName), $programName)

	Return $output
EndFunc

Func SaveSourceCodeToTextFile($originalFilename, $code)
	; Can maybe just use a single FileWrite() call here, when just UTF8 text? Actually NO. Defaults to appending.
	Local $file = FileOpen(FileAppendPath($originalFilename, "Source Code as Text") & "-source", $FO_CREATEPATH + $FO_OVERWRITE)
	If Not FileWrite($file, $code) Then Debug("  ERROR: Could not write input source file.")
	If Not FileFlush($file) Then Debug ("  ERROR: Could not flush input source file.")
	If Not FileClose($file) Then Debug("  ERROR: Could not close input source file.")
EndFunc


; Calculate time taken between sections of code. Example:
;     $timer = TimerInit()
;     ShowTimeTaken($timer, "section A")
;     ShowTimeTaken($timer, "section B")
;
; Reset timer by calling TimerInit() again.
Func ShowTimeTaken($timer, $description)
	debug($description & ": " & Round(TimerDiff($timer) / 1000, 3) & " seconds")
EndFunc


;;; Debugging ;;;
; debug(0xEF74)
; debug(0xEF75)
; debug(0x6234)
; debug(0x576216bbb8622429)
;~ debug(Hex(Binary("0x838485")))

;~ debug("BinaryCodeToTextCode: " & BinaryCodeToTextCode(Binary("0x0505EF96")))
;~ Debug(Hex(Binary("0x11112222333344445555")))

;~ debug(BinaryCodeToTextCode(Binary("0x838329ef973f")))

Func BinaryCodeToTextCode($binaryCode)
	Local $textCode = ""

;~ 	debugArray($8xpTokensSorted)

	; Loop through every byte in file and replace with text representation
	For $i = 1 To BinaryLen($binaryCode)

		; Grab a single byte
		Local $char = BinaryMid($binaryCode, $i, 1)

		; TODO: Speed improvements
		; - Should probably use a `Map` object instead, like we do in TextCodeToBinaryCode()
		; - Or... could potentially speed this up by not searching the array for
		;   known 2-byte prefixes.
		; - Could also potentially split the tokens into 2 arrays, single byte and double byte
		;   so we're not searching the list unnecessarily
		; Anyway, seems fast enough, kinda, except large apps can take >3 seconds to decompile.

		; Does this byte exist in our list?
		; If so, output the relevant text representation and continue onto next byte
		; Warning: when using _ArrayBinarySearch, array MUST be sorted in ASCENDING ORDER
		Local $tokenIndex = _ArrayBinarySearch($8xpTokensSorted, Hex($char), 0, 0, 0)
		If $tokenIndex > -1 Then
;~ 			Debug("Token found: " & $tokenIndex)
;~ 			ConsoleWrite($tokenIndex)
			$textCode = $textCode & $8xpTokensSorted[$tokenIndex][1]
			ContinueLoop
		; Else
;~ 			debug("Hex: " & Hex($char) & " " & Hex($8xpTokensSorted[17][0]))
		EndIf

		; If not found within the list, it might be a 2-byte character, so let's look for that
		; Note: AutoIt converts binary to int in little endian format, which is NOT how 8XPs work.
		Local $char2 = BinaryMid($binaryCode, $i+1, 1)
		$tokenIndex = _ArrayBinarySearch($8xpTokensSorted, Hex($char & $char2), 0, 0, 0)
		If $tokenIndex > 0 Then
;~ 			ConsoleWrite("Token found" & @CRLF)
;~ 			ConsoleWrite($tokenIndex)
			$textCode = $textCode & $8xpTokensSorted[$tokenIndex][1]

			; Skip the next char because it's now used
			$i += 1

			ContinueLoop
		EndIf

		; If we got this far, it means that we couldn't find the binary characters in our official list
;~ 		$textCode = ""

		; Is the first character known to indicate a 2-byte token? If so, we'll skip the next byte and continue thereafter.
		Local $doubleByteTokenPrefixes = [0x5C, 0x5D, 0x5E, 0x60, 0x61, 0x62, 0x63, 0x7E, 0xAA, 0xBB, 0xEF]
		If _ArraySearch($doubleByteTokenPrefixes, $char) > -1 Then
			$i += 1
			debug("ERROR: Binary token " & ($char & $char2) & " (Int values " & Number($char2 & $char) & ") is not a known token. This token will be skipped during decompilation.")
			$textCode = $textCode & "??"
		Else
			debug("ERROR: Binary token " & $char & ", followed by " & $char2 & " (Int values " & Number($char2 & $char) & ") is not a known token. This token will be skipped during decompilation.")
			$textCode = $textCode & "?"
		EndIf

	Next


	Return $textCode
EndFunc



; Updates a single byte within a binary variable at a specific position (indexed from 1)
; Supports numbers, binary vars, or strings like "0x12AB"
Func BinaryModifyByte($binaryData, $startingByte, $newData)
   Return BinaryModifySection($binaryData, $startingByte, 1, $newData)
EndFunc
;~ MsgBox(0, "BinaryModifyByte", BinaryModifyByte(Binary("0xAABBCCDDEEEE"), 3, "0x9999"))


; Updates 2 bytes within a binary variable at a specific position (indexed from 1)
; Supports numbers, binary vars, or strings like "0x12AB"
Func BinaryModifyWord($binaryData, $startingByte, $newData)
   Return BinaryModifySection($binaryData, $startingByte, 2, $newData)
EndFunc
;~ MsgBox(0, "BinaryModifyWord", BinaryModifyWord(Binary("0xAABBCCDDEEEE"), 3, "0x9999"))

; Replaces a chunk of binary with another chunk
; Overall length of original binary remains the same
; Starting byte is indexed from 1 NOT zero
Func BinaryModifySection($binaryData, $startingByte, $length, $newData)
   Return _
		BinaryMid($binaryData, 1, $startingByte - 1) & _			; content prior to section
		BinaryPad(BinaryMid($newData, 1, $length), $length) & _		; content to be modified (ensuring it's correct length)
		BinaryMid($binaryData, $startingByte + $length)				; content after section
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

;------- Test Runner --------
;~ Local $x = TextCodeToBinaryCode("LEFT")
;~ debug("Result (" & BinaryLen($x) & " bytes): 0x" & Hex($x) & @CRLF)

; Converts 0x62 or 0x6212 into actual binary representing those one or two bytes
; Ints in AutoIt are normally 4 bytes long, but we actually only want either 1 or 2 bytes
; And two bytes need reversing as AutoIt stores them as little endian I think?
Func TokenIntToBinary($int)

	; No longer converting since all tokens are already Binary.
	Return $int
	;;;;;;;;;;;;;;;;;;;;;;;;

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


Global $tokenMap[]  ; Map object for looking up tokens, initialized on first use of function below

; TextCodeToBinaryCode() debugging:
;~ Debug("Testing TextCodeToBinaryCode with simple string: " & Hex(TextCodeToBinaryCode("Thin")))
;~ Debug("Testing TextCodeToBinaryCode with simple string: " & Hex(TextCodeToBinaryCode("Think")))
;~ Debug("Testing TextCodeToBinaryCode with simple string: " & Hex(TextCodeToBinaryCode("AUTO")))
;~ Debug("Testing TextCodeToBinaryCode with simple string: " & Hex(TextCodeToBinaryCode("DEC")))
;~ Debug("Testing TextCodeToBinaryCode with simple string: " & Hex(TextCodeToBinaryCode("FRAC")))
;~ Debug("Testing TextCodeToBinaryCode with simple string: " & Hex(TextCodeToBinaryCode("LEFT")))
;~ Debug("Testing TextCodeToBinaryCode with simple string: " & Hex(TextCodeToBinaryCode("RED")))

; Converts plain text TI-Basic code into binary tokens, suitable for calculator.
; Operates on the BODY of the program only.
;
;------------------------------------------------------------------------------------------------
; Known bug:
; Certain reserved words like "AUTO", "DEC", "FRAC", etc. may fail when used in list names like ⌊DEC.
; This is because the special token is injected into the list name, rather than just the characters. 
; This causes programs to fail.
; 
; Solutions:
;
; 1. We either need to change the token strings themselves, perhaps by wrapping them in [BRACKETS] like with colour tokens
;    to prevent them from being accidentally injected into variable names, list names, etc
;    (making them less compatible with TIConnect)
;
;	or
;
; 2. Add more advanced search mechanisms here to replace tokens differently based on different contexts
;    (such as if letters follow a ⌊ symbol). This second option is more accurate, but complex.
;	 Via this method, any alphanumeric characters immediately following ⌊ should use the single letter tokens, 
;    rather than the reserved word tokens. So for example:
;     		"⌊DEC" should be tokenized as:
;     		"⌊" + "D" + "E" + "C"
;     		rather than using the "DEC" token.
;------------------------------------------------------------------------------------------------
Func TextCodeToBinaryCode($text)
	Local $binary = Binary("")

	; Create a map for efficiently looking up tokens
	; The text string is the key, and binary string is the value (either 1 or 2 bytes)
	; We loop through the list in REVERSE since there are a few duplicate tokens in the list
	; and we want EARLIER tokens to take priority over later ones
	;
	; TODO: We are NOT currently handling the alternative text options that are provided in the tokens list.
	;       These might be useful in some cases.
	;~ Local $tokens[]

	; Token map created yet? Create if not.
	If UBound(MapKeys($tokenMap)) = 0 Then
		For $i = UBound($8xpTokens) - 1 To 0 Step -1
	;~ 		ConsoleWrite($i & " " & VarGetType($8xpTokens[$i][1]) & " " & $8xpTokens[$i][0] & " " & $8xpTokens[$i][1] & @CRLF)

			; Skip 0x00 as it breaks things (such as the square bracket character "["
			; and I don't think we need it for compilation? Do we...?
			If $8xpTokens[$i][0] == "00" Then ContinueLoop

			Local $tokenText = $8xpTokens[$i][1]
			Local $tokenBinary = TokenIntToBinary($8xpTokens[$i][0])
			$tokenMap[$tokenText] = $tokenBinary
		Next
		Debug("  - Token map created with " & UBound(MapKeys($tokenMap)) & " entries")
	EndIf

	;~ DebugMap($tokenMap)
	;~ debug($tokenMap["["])

	; debug("Tokens have been indexed")

	; Loop through entire string, character by character
	; TODO: This may (currently) be case sensitive. To be explored whether I should fix that.
	Local $textLength = StringLen($text)
	For $i = 1 to $textLength
		; Start with grabbing the next 14 chars (the length of the longest token)
		; and keep removing characters until we find a matching token
		; TODO: Check for the size of the longest token, rather than hardcoding 14 here
		For $j = _Min(14, $textLength - $i + 1) to 1 Step -1
			Local $portion = StringMid($text, $i, $j)

			If MapExists($tokenMap, $portion) Then
				; Great, we've found a match
				; Put the token into our binary result
;~ 				debug($portion)
;~ 				debug("Found match: " & $tokenMap[$portion])
				$binary = $binary & Binary("0x" & $tokenMap[$portion])
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

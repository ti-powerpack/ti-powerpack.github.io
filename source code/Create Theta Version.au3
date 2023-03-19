; This script is run by appending 1 or more 8XP files to the command parameters
; Will output a copy of the 8XP that has the name changed and the archived flag set

#include "Includes\Debug.au3"
#include <File.au3>
#include "Includes\Process8xpppFile.au3"
#include "Includes\FileExtension.au3"

;~ $HELLO = Binary("0x48454C4C4F000000")
;~ Debug(StringToBinary("HELLO"))
;~ Exit

;--------------------
; FOR TESTING ONLY
;~ Local $CmdLine = [2, "D:\Dropbox\TI84 Calculator\MY APPS\Binary Optimization Script\Temp\test.8xp", "D:\Dropbox\TI84 Calculator\MY APPS\Binary Optimization Script\Temp\testing2.8xp"]
;--------------------

$NumberOfItems = $CmdLine[0]
$NumberOfItemsProcessed = 0

For $i = 1 to $NumberOfItems

	$filePath = $CmdLine[$i]

	; Only work on 8XP file extensions

	If FileExtension($filePath) <> "8xp" Then ContinueLoop

	; Open and parse file
	$data = Read8xpBinary($filePath)

	; Modify the title
	Update8xpProgramName($data, ApplyThetaPrefixToName($data.programName))

	; Modify the "archived" bit
	$data.meta = BinaryModifyByte($data.meta, 0x45 - 55 + 1, Binary("0x80"))

	; Recalc the checksum, and write new file to disk
	; WILL OVERWRITE EXISTING FILE(S)
	Write8xpBinary($data, StringReplace($filePath, ".8xp", ".theta.8xp"))

	$NumberOfItemsProcessed += 1

Next

;~ MsgBox(0, "", Binary("0xAABB") & Binary("["))
MsgBox(64, "Theta Versions Created", "Success. " & $NumberOfItemsProcessed & " files were processed.")


Func ApplyThetaPrefixToName($binaryName)
	$binaryName = "[" & $binaryName
	If StringLen($binaryName) > 8 Then
		; Find the A-Z char at the end of filename, or prior to any digits at the end of filename, and remove it
		$binaryName = StringRegExpReplace($binaryName, "[A-Z](?=($|\d$))", "")
	EndIf
	Return $binaryName
EndFunc


; Updates the 8XP program name, inside binary object to the new name provided (max 8 chars)
; Use "[" instead of theta, if you want that in the name
Func Update8xpProgramName(ByRef $binaryObject, $newName)

	; Ensure name is no more than 8 chars
;~ 	$newName = StringLeft($newName, 8)

	; Must be uppercase
;~ 	$newName = StringUpper($newName)

	; Any special treatment of theta chars? Yes, it should be 0x5B which I think is "[" in ASCII, maybe

	; Program name is stored at bytes 0x3C - 0x43 (zero indexed, from beginning of file). Any unused bytes are 0x00 I think?

	$binaryObject.programName = StringLeft($newName, 8)
	$binaryObject.programNameBinary = BinaryPad(StringToBinary($binaryObject.programName), 8)
	$binaryObject.meta = BinaryModifySection($binaryObject.meta, 0x3C - 55 + 1, 8, $binaryObject.programNameBinary)



EndFunc

Func Update8xpArchiveFlag(ByRef $binaryObject, $isArchived)
	; Archive flag is stored at byte 0x45 (zero indexed, from beginning of file)
	; 0x00 = not archived, 0x80 = archived
	$binaryObject.meta = BinaryModifyWord($binaryObject.meta, 0x45 - 55 + 1, $isArchived ? 0x80 : 0x00)
EndFunc
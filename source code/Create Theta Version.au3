#include <File.au3>
#include "Includes\Process8xpppFile.au3"

$NumberOfItems = $CmdLine[0]
$NumberOfItemsProcessed = 0

For $i = 1 to $NumberOfItems

	; Only work on 8XP file extensions
	$filePath = $CmdLine[$i]
	$null = ""
	$filePathSegments = _PathSplit($filePath, $null, $null, $null, $null)
	If $filePathSegments[$PATH_EXTENSION] <> "8xp" Then ContinueLoop

	; Open and parse file
	Read8xpBinary($filePath)

	; Modify the title


	; Modify the "archived" bit


	; Recalc the checksum, and write new file to disk
;~ 	Write8xpBinary()

	$NumberOfItemsProcessed += 1

Next

MsgBox(0, "", Binary("0xAABB") & Binary("["))


; Updates the 8XP program name, inside binary object to the new name provided (max 8 chars)
; Use "[" instead of theta, if you want that in the name
Func Update8xpProgramName(ByRef $binaryObject, $newName)

	; Ensure name is no more than 8 chars
	$newName = StringLeft($newName, 8)

	; Must be uppercase
	$newName = StringUpper($newName)

	; Any special treatment of theta chars? Yes, it should be 0x5B which I think is "[" in ASCII, maybe

	; Program name is stored at bytes 0x3C - 0x43 (zero indexed, from beginning of file). Any unused bytes are 0x00 I think?


EndFunc

Func Update8xpArchiveFlag(ByRef $binaryObject, $isArchived)
	; Archive flag is stored at byte 0x45 (zero indexed, from beginning of file)
	; 0x00 = not archived, 0x80 = archived
	$binaryObject.meta = BinaryModifyWord($binaryObject.meta, 0x45 - 55 + 1, $isArchived ? 0x80 : 0x00)
EndFunc
#include <File.au3>
#include "Create8xpppFile.au3"

$NumberOfItems = $CmdLine[0]
$NumberOfItemsProcessed = 0

For $i = 1 to $NumberOfItems

	; Only work on 8XP file extensions
	$filePath = $CmdLine[$i]
	$filePathSegments = _PathSplit($filePath)
	If $filePathSegments[$PATH_EXTENSION] <> "8xp" Then ContinueLoop

	; Open and parse file
	Read8xpBinary($filePath)

	; Modify the title


	; Modify the "archived" bit


	; Recalc the checksum, and write new file to disk
;~ 	Write8xpBinary()

	$NumberOfItemsProcessed += 1

Next



Func Update8xpProgramName(ByRef $binaryObject)
	; Ensure name is no more than 8 chars
	; Any special treatment of theta chars?
	; Program name is stored at bytes 0x3C - 0x43 (zero indexed, from beginning of file). Any unused bytes are 0x00 I think?
EndFunc

Func Update8xpArchiveFlag(ByRef $binaryObject, $isArchived)
	; Archive flag is stored at byte 0x45 (zero indexed, from beginning of file)
	; 0x00 = not archived, 0x80 = archived
	$binaryObject.meta = BinaryModifyWord($binaryObject.meta, 0x45 - 55 + 1, $isArchived ? 0x80 : 0x00)
EndFunc
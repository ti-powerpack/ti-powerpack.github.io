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
EndFunc

Func Update8xpArchiveFlag(ByRef $binaryObject, $isArchived)
	BinaryModifyWord($binaryObject.meta, 0x00,
EndFunc
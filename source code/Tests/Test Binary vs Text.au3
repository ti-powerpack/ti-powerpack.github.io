#include "..\Includes\Debug.au3"
#include "..\Includes\Process8xpppFile.au3"
#include "..\Includes\HexDumpToTextFormat.au3"



; TEST STEPS
; 1. Run this script
;
; 2. WinMerge will open to compare the following two source files
;
; 3. If there's any differences, it means that the binary code logic inside Process8xpppFile()
;    is incorrect and needs fixing. The name, body & length fields must all match exactly.
;	 We're aiming for an exact match.

; Decompile, process, and recompile the following files
$dest1 = "Binary vs Text\Compiled\Binary.compiled.8xp"
$dest2 = "Binary vs Text\Compiled\Text.compiled.8xp"
Debug("FILE 1:")
Process8xpppFile("Binary vs Text\Binary.8xp", $dest1)
Debug("FILE 2:")
Process8xpppFile("Binary vs Text\Text.8xppp", $dest2)

;~ HexDumpToText($dest1, $dest1 & ".hexdump.txt")
;~ HexDumpToText($dest2, $dest2 & ".hexdump.txt")

; Compare hex dumps
;~ WinMergeCompare($dest1 & ".hexdump.txt", $dest2 & ".hexdump.txt")
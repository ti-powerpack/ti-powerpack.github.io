#include <Array.au3>
#include "..\Includes\Debug.au3"
#include "..\Includes\Process8xpppFile.au3"
#include "..\Includes\HexDumpToTextFormat.au3"

; Other tests inspect just the decompilation, or the optimization steps.
; RUN THIS FOR TESTING COMPILATION, and everything, end-to-end

; Result is not fully matching currently.

Local $TestFiles[][] = [ _
	["..\Tests\Full Test\ALL TOKENS.8xppp", "..\Tests\Full Test\ALL TOKENS.compiled.8xp"] _
	_ ; , ["..\Tests\Full Test\CLOSURE2.8xp",     "..\Tests\Full Test\CLOSURE2.compiled.8xp"] _
]

For $i = 0 to UBound($TestFiles) - 1

	Debug("Testing file " & ($i+1) & "...")

	Local $file1 = $TestFiles[$i][0]
	Local $file2 = $TestFiles[$i][1]

	FileDelete($file1 & ".dump")
	FileDelete($file2 & ".dump")
	FileDelete($file2)

	; 1. We'll run a full decompile, optimize, and recompile of each file
	Process8xpppFile($file1, $file2, False)

	; 2. Convert the original and recompiled files to TXT HEX dumps for inspection
	HexDumpToText($file1, $file1 & ".dump")
	HexDumpToText($file2, $file2 & ".dump")

	WinMergeCompare($file1 & ".dump", $file2 & ".dump")

Next
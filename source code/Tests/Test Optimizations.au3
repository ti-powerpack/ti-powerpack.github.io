#include "..\Includes\Debug.au3"
#include "..\Includes\Process8xpppFile.au3"

; TEST STEPS (TO UPDATE)
; 1. Run this script
; 2. Compare the following two source files:
;	 winmerge "D:\Dropbox\TI84 Calculator\MY APPS\Binary Optimization Script\Tests\Optimizations\output.compiled.8xp-source" "D:\Dropbox\TI84 Calculator\MY APPS\Binary Optimization Script\Tests\Optimizations\output.expected.8xp-source"
; 3. If there's any differences, it means OptimizeCode.au3 needs updating and the
;    expected optimizations are not being performed correctly
;	 We're aiming for an exact match, ideally (or at least not breaking the code)

; Decompile, process, and recompile the following files
Process8xpppFile("Optimizations\input.8xp", "Optimizations\output.compiled.8xp")

; Show result
WinMergeCompare("Optimizations\output.expected.8xp-source", "Optimizations\output.compiled.8xp-source")

#include "..\Includes\Process8xpppFile.au3"

; TEST STEPS
; 1. Run this script
; 2. Compare the following two source files:
;	 winmerge "D:\Dropbox\TI84 Calculator\MY APPS\Binary Optimization Script\Tests\Test Decompile\ALL TOKENS.8xppp.8xp-source" "D:\Dropbox\TI84 Calculator\MY APPS\Binary Optimization Script\Tests\Test Decompile\ALL TOKENS.expected.8xp-source"
; 3. If there's any differences, it means the Tokens.au3 file needs updating and the
;    binary token is not being converted to text in the same way as TI-Connect does.
;	 We're aiming for an exact match.

; Decompile, process, and recompile the following files
Process8xpppFile("Test Decompile\CLOSURE2.8xppp", "Test Decompile\CLOSURE2.compiled.8xp")
Process8xpppFile("Test Decompile\ALL TOKENS.8xppp.8xp", "Test Decompile\ALL TOKENS.compiled.8xp")
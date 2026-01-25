; This script is run by appending 1 or more 8XP files to the command parameters
; Will output a copy of the 8XP that has the name changed and the archived flag set

#include "Includes\Debug.au3"
#include "Includes\PathTools.au3"
#include "Includes\Create Theta Version Functions.au3"

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

	CreateThetaVersion($filePath)

	$NumberOfItemsProcessed += 1

Next

;~ MsgBox(0, "", Binary("0xAABB") & Binary("["))
MsgBox(64, "Theta Versions Created", "Success. " & $NumberOfItemsProcessed & " files were processed.")

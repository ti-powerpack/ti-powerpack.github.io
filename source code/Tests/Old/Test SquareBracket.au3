#include "..\Includes\Debug.au3"
#include "..\Includes\Process8xpppFile.au3"

$testCode = "["
$expectedBinaryOutput = Binary("0x06")

$output = TextCodeToBinaryCode($testCode)
If $output == $expectedBinaryOutput Then
	MsgBox(0, "Test Passed", "Compilation produces expected " & $expectedBinaryOutput & " - " & $output)
Else
	MsgBox(0, "Test Failed", "Compilation expected " & $expectedBinaryOutput & " but produced " & $output)
EndIf
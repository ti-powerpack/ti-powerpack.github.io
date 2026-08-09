#include "..\Includes\Debug.au3"
#include "..\Includes\Process8xpppFile.au3"

;~ $testCode = @CRLF & "R²" & @CRLF
$testCode = "R²"
$expectedBinaryOutput = Binary("0x520D")

$output = TextCodeToBinaryCode($testCode)
If $output == $expectedBinaryOutput Then
	MsgBox(0, "Test Passed", "Compilation produces expected " & $expectedBinaryOutput & " - " & $output)
Else
	MsgBox(0, "Test Failed", "Compilation expected " & $expectedBinaryOutput & " but produced " & $output)
EndIf
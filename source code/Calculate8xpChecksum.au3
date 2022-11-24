#include <FileConstants.au3>

; Read in the binary data
;~ $file = FileOpen("temp\Hex Files to Compare\PROG1.8xp", $FO_BINARY)
;~ $file = FileOpen("CLOSURE2.8xp", $FO_BINARY)
;~ $data = FileRead($file)
;~ $data = BinaryMid($data, 1, BinaryLen($data) - 2)

;~ Calculate8xpChecksum($data)


; Pass in binary data, from start of file to end of body (EXCLUDING checksum)
Func Calculate8xpChecksum($binaryData)

   ; Extract bytes 56 to the end (minus 2 for checksum)
   $binaryData = BinaryMid($binaryData, 56, BinaryLen($binaryData) - 55)

   ; Get the numerical value of each byte and sum them together
   $sum = 0
   For $i = 1 to BinaryLen($binaryData)
	  $sum += Number(BinaryMid($binaryData, $i, 1))
   Next

   ; Get 2 bytes in little endian format
   $checksum = BinaryMid($sum, 1, 2)

   ; Display result, for debugging
;~    MsgBox(0, "Checksum", $sum & @CRLF & Binary($sum) & @CRLF & $checksum)

   Return $checksum

EndFunc
#include <FileConstants.au3>
#include "Calculate8xpChecksum.au3"

;~ $filename = "temp\Hex Files to Compare\PROG3.8xp"

Func Optimize8xpFile($filename)

   ; Open file and read data
   $file = FileOpen($filename, $FO_BINARY)
   $data = FileRead($file)

   ; Extract sections of file
   $header = BinaryMid($data, 1, 55) ; first 55 bytes
   $meta = BinaryMid($data, 56, 19)  ; next 19 bytes
   $body = BinaryMid($data, 56 + 19, BinaryLen($data) - 55 - 19 - 2)

   ;~ MsgBox(0, "", $header);
   ;~ MsgBox(0, "", $meta);
   ;~ MsgBox(0, "", $body);

   ; Perform optimization operations on body section
   ; for now, just remove last two characters
   $body = BinaryMid($body, 1, BinaryLen($body) - 2)

   ; Recalculate new length of file
   $bodyLength = BinaryLen($body)
   $metaAndBodyLength = $bodyLength + 19
   $bodyAndChecksumLength = $bodyLength + 2

   ;~ MsgBox(0, "", Binary($bodyLength))

   ; Update fields within the header and meta to match the new length
   $header = BinaryModifyWord($header, 0x35 + 1, $metaAndBodyLength)
   $meta   = BinaryModifyWord($meta, 0x39 - 55 + 1, $bodyAndChecksumLength)
   $meta   = BinaryModifyWord($meta, 0x46 - 55 + 1, $bodyAndChecksumLength)
   $meta   = BinaryModifyWord($meta, 0x48 - 55 + 1, $bodyLength)

   ; Recombine header, meta, body
   $data = $header & $meta & $body

   ; Append checksum as the final 2 bytes of file
   $data = $data & Calculate8xpChecksum($data)

   ; Write to new file
   $file2 = FileOpen(StringReplace($filename, ".8xp", ".optimized.8xp"), $FO_OVERWRITE + $FO_BINARY)
   FileWrite($file2, $data)

EndFunc


; Updates 2 bytes within a binary variable at a specific position (indexed from 1)
; Supports numbers, binary vars, or strings like "0x12AB"
Func BinaryModifyWord($binaryData, $startingByte, $newData)
   Return BinaryMid($binaryData, 1, $startingByte - 1) & BinaryMid($newData, 1, 2) & BinaryMid($binaryData, $startingByte + 2)
EndFunc
;~ MsgBox(0, "BinaryModifyWord", BinaryModifyWord(Binary("0xAABBCCDDEEEE"), 3, "0x9999"))
#include <Array.au3>
#include "Debug.au3"

; TEST CODE:
;~ Local $test[][] = [[1,2,3],[4,5,6]]
;~ Debug("starting")
;~ For $row in ArrayFix($test)
;~ 	Debug($row)
;~ Next


; Converts a 2D array into nested arrays, for easier looping over, like this:
;
;   For $row in ArrayFix($my2DArray)
;		Debug($row)
;   Next
;
; Apparently this is slightly slower than 2D arrays, but it's probably only a few milliseconds.
; Remember that to access elements directly after conversion you need to use brackets like:
;  ($array[0])[1]
Func ArrayFix($2dArray)

	; Create new array with same number of elements
	Local $result[UBound($2dArray)]

	For $i = 0 to UBound($2dArray) - 1
		; Get 1 row
		Local $item = _ArrayExtract($2dArray, $i, $i)
		; Convert cols to rows
		_ArrayTranspose($item, true)
		$result[$i] = $item
	Next

	Return $result

EndFunc

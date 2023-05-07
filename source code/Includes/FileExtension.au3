#include-once
#include <File.au3>
#include <FileConstants.au3>
#include "Debug.au3"

; Provide a full path to a file, returns only the extension, after the dot
Func FileExtension($fullPath)
   Local $x = ""
   Return StringTrimLeft(_PathSplit($fullPath, $x, $x, $x, $x)[$PATH_EXTENSION], 1)
EndFunc

; "C:\A\B\C.txt" --> "C:\A\B\SOMETHING-HERE\C.txt"
Func FileAppendPath($fullPath, $append)
	Local $path = PathToComponents($fullPath)
	$path.folder &= $append
	Return PathComponentsToString($path)
EndFunc

;~ FOR TESTING:
Debug(FileAppendPath("C:\somewhere\myfile.abc.txt","BBBB"))
;~ Debug(FileAppendPath("..\myfile.abc.txt","CCCC"))

; Returns a map object containing the various components of a file path
Func PathToComponents($path)
	Local $drive
	Local $folder
	Local $filename
	Local $extension
	_PathSplit($path, $drive, $folder, $filename, $extension)

	Local $map[]
	$map.drive = $drive
	$map.folder = $folder
	$map.filename = $filename
	$map.extension = $extension

;~ 	Debug($drive)
;~ 	Debug($folder)
;~ 	Debug($filename)
;~ 	Debug($extension)

	Return $map
EndFunc

; Pass in a map of the path components and it returns a string
Func PathComponentsToString($pathMap)
	Local $string = _PathMake($pathMap.drive, $pathMap.folder, $pathMap.filename, $pathMap.extension)
	; _PathMake sometimes turns relative paths into absolute ones by adding a slash at start. We'll strip that if so, since I rarely start paths with a slash.
	If StringLeft($string, 1) == "\" Then $string = StringMid($string, 2)
	Return $string
EndFunc

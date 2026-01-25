#include <Array.au3>
#include "Debug.au3"

If @ScriptName = 'RegexExceptWhen.au3' Then
	$source = "--- ALL COLONS REMOVED IN THESE LINES ---" & @CRLF & _
		  "Here is a colon:" & @CRLF & _
		  ":this one" & @CRLF & _
		  "and this:and : this" & @CRLF & _
		  "And ""this"" one should:" & @CRLF & _
		  """"": something" & @CRLF & _
		  "" & @CRLF & _
		  "--- COLONS REMAIN INSIDE THE STRINGS ONLY ---" & @CRLF & _
		  "Replaced: ""Not: replaced:"", and "":...:"" replaced again:" & @CRLF & _
		  "But ""this one:"" should not be matched" & @CRLF & _
		  "Nor ""this one: either""" & @CRLF & _
		  "Nor ""this"""":"""""" or ""this:""" & @CRLF & _
		  "AVOID: No colons should: be: replaced: on: this: line: "

	;~ Debug("Result:")
	Debug(RegexReplaceExceptWhen($source, "^AVOID.*|""([^""]|"""")*""", ":", "="))

	$example2 = "RemoveTrailingBracket(""x"")" & @CRLF & _
				"RemoveTrailingBracket(""y"",""z"")" & @CRLF & _
				"DoNotRemoveTrailingBracket(""Something 1()" & @CRLF & _
				"RemoveTrailingBracket(""a"")"

	Debug("Example 2 Result:")
	; Remove trailing brackets EXCEPT inside a string or an unclosed string
	Debug(RegexReplaceExceptInsideString($example2, "\)$", ""))
	
	Debug("Example 3 Result:")
	; All X to Y, except inside strings
	Debug(RegexReplaceExceptInsideString("XX(""X"","""",X,""X""""X""),", "X", "Y"))

EndIf

Func RegexReplaceExceptInsideString($text, $matchRegex, $replace)
	; Matches strings like "..." or """" (escaped quotes)
	Return RegexReplaceExceptWhen($text, """([^""]|"""")*""", $matchRegex, $replace)
EndFunc

; This function performs a global regex replace, EXCEPT
; when the match is found inside $exceptWhenRegex
; Multiline mode enabled
; $exceptWhenRegex can contain multiple patterns, each separated by a pipe
;
; ✔ Appears to be working from the test above
#include <StringConstants.au3>
Func RegexReplaceExceptWhen($text, $exceptWhenRegex, $matchRegex, $replace)
	
	; Uses this special technique provided by PCRE: (?:avoid1|avoid2)(*SKIP)(*FAIL)|What_I_want_to_match
	Return StringRegExpReplace($text, "(?m)(?:" & $exceptWhenRegex & ")(*SKIP)(*FAIL)|" & $matchRegex, $replace)

	#comments-start
	; Loop through each regex match, checking if group 1 has any matches
	; If so, manually replace it
	; Then continue searching from that point on
	$stringPos = 1
	While Not @error
		$matches = StringRegExp($text, $exceptWhenRegex & ", $STR_REGEXPARRAYFULLMATCH, $stringPos)
		If @error Then Break
		$stringPos = @extended
		If UBound($matches) = 1 Then ContinueLoop

		; Perform semi-manual replace
		$lengthPrior = StringLen($text)
		$match = $matches[1]
		$match = StringRegExpReplace($match, $matchRegex, $replace)


	WEnd
	_ArrayDisplay($matches)
	Return $text
	#comments-end
EndFunc

; Removes a portion of a string, and injects a new string in its place
; Positions start from 1
; Is this used anywhere? Not yet.
Func StringInject($string, $startPos, $endPos, $textToInject)
	Return StringLeft($string, $startPos-1) & $textToInject & StringMid($string, $endPos+1)
EndFunc

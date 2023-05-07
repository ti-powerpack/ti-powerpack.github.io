#include-once
;~ MsgBox(0, "Result", OptimizeCode(@CRLF & "  ""Something here" & @CRLF & "For(I,1,2)" & @CRLF & "y"))

; Pass in TI-BASIC code as UTF8 text
; Returns smaller version of that code, still as text
Func OptimizeCode($code)

	;----------- Optimization Phase ------------------------------
	; Perform regex to clean up script
	; Use (?m) at start to enable multiline mode where ^ matches the start of a line
	; (?!...) is a negative look-ahead

	; TODO: Convert all colons NOT inside a string into line returns. That way the following
	;       optimizations will apply to those cases too. Currently they do not.
	; 		For example "If X=(3+2):Then" will not have trailing bracket stripped.

	; TODO: Multiple DelVar statements do NOT need a line return in between.
	;       Can also remove line return after a DelVar in 95% of cases, but NOT preceding "Lbl" labels or an "End" statement for an "If" block

	; REMOVE WHITE-SPACE CHARACTERS
	$code = StringRegExpReplace($code, "(?m)^[ \t]+", "")				; remove tabs/spaces at start of a line (although tabs cannot be inserted by TI-Connect)
	$code = StringRegExpReplace($code, "(?m)^:+", "")  					; Remove colons at start of a line
	$code = StringRegExpReplace($code, "(\r\n){2,}", @CRLF)  			; Remove a run of multiple line returns (blank lines)
	$code = StringRegExpReplace($code, "^(\r\n)+", "")					; Remove blank line(s) at start of file
	$code = StringRegExpReplace($code, @CRLF & "$", "")			  	 	; remove trailing line return / blank line at end of script

	; COMMENTS
	; We need to also remove the trailing whitespace from comments, otherwise we might retain some blank lines in final script
	$code = StringRegExpReplace($code, "(?m)^""[^→\r]*\r\n", "")		; remove string comments (strings where there is NOT a store command) - won't remove comment on FINAL line of program, just in case this is desired
	$code = StringRegExpReplace($code, "(?s)^/\*.*\*/\s*", "")			; Multi-line comments with /* ... */ - (?s) enables dot to match ANY char, including line returns
	$code = StringRegExpReplace($code, "(?m)^//.*\s*", "")				; Single-line comments with // ...

	; Subroutines
	; IMPORTANT: SciTE does NOT show the negative sign prior to the 1 in the For() loops below, but it's there
	; "Call SA using X" becomes "For(X,-1,0):If X:Goto SA:End"
	$code = StringRegExpReplace($code, "(?m)^Call (\w{1,2}) using (\w)", "For(\2,­1,0):If \2:Goto \1:End")
	; "Call SA" becomes "For(Y,-1,0):If Y:Goto SA:End"
	$code = StringRegExpReplace($code, "(?m)^Call (\w{1,2})", "For(Y,­1,0):If Y:Goto \1:End")

	; Strip unnecessary closing quotes and brackets
	$code = StringRegExpReplace($code, "(?m)^{.*\K}", "")				; if line starts with { remove the closing }
	$code = StringRegExpReplace($code, "\)+→", "→")						; remove closing )'s when storing a number
	$code = StringRegExpReplace($code, "(?m)^""→", """""→")				; fix special case: storing an empty string, with only one set of quotes
	$code = StringRegExpReplace($code, """→", "→")						; remove closing " when storing a string
	$code = StringRegExpReplace($code, "(?m)→Ans$", "")					; remove →Ans, which is only for forcing a string to be placed in ans rather than being treated as a comment
	$code = StringRegExpReplace($code, "(?m)""\)$", "")					; Remove all quotes followed by closing bracket, when at end of a line.
																		; Previously this was all matches, not just those at end of a line,
																		; However this broke `InString() or InString()`
																		; Might still break string output that has a quote and string at end?

	; \K Resets start of match at the current point in subject string.
	; This is a workaround for being unable to replace only a subgroup of a match
	; From DOC: Note that groups already captured are left alone and still populate the returned array;
	;           it is therefore always possible to backreference to them later on.

	; Remove trailing brackets, EXCEPT when For is start of line, or there's quotes (string) in the line
	; Will miss a few, such as Menu("Abc", A), but will prevent stripping bracket from "This (Example)"
	$code = StringRegExpReplace($code, "(?m)^(?!For)[^""\r\n]*?\K\)+$", "")

	; There's a couple of special cases where we can definitely remove trailing brackets.
	$code = StringRegExpReplace($code, "(?m)^Menu\(.*\K\)$", "")
	$code = StringRegExpReplace($code, "(?m)^StringEqu\(.*\K\)$", "")

	$code = StringRegExpReplace($code, "(?m)^.*[^, ]\K""$", "")			; remove trailing double-quotes, except directly after comma or space
	;$code = StringRegExpReplace($code, "\)+DMS", "DMS")				; BUGGY: remove bracket before DMS

	; A few other special cases

	;--------------------------------------------------------------

	Return $code

EndFunc

Func RegExpReplaceExceptWhenPrecededBy($avoidThisAtStartOfLine, $avoidThisMidLine, $find, $replace)
	; $prefix = "(?m)" & $prefix & "\K"
EndFunc

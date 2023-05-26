#include-once
#include "Debug.au3"
#include <Array.au3>
#include "Process8xpppFile.au3"

;----- Run tests when this script is executed directly and NOT included from a parent script ----------
If @ScriptName == "OptimizeCode.au3" Then
	;~ MsgBox(0, "Result", OptimizeCode(@CRLF & "  ""Something here" & @CRLF & "For(I,1,2)" & @CRLF & "y"))
	$result = OptimizeCode( _
		"   #include ""test include.8xp.inc"" " & @CRLF & _
		"   #include ""test include 2.8xp.inc"" " & @CRLF & _
		"   #include ""test include 3.inc"" " & @CRLF & _
		"   #define @LabelExit X" & @CRLF & _
		"#define @LabelHome HX" & @CRLF & _
		"" & @CRLF & _
		"Lbl {{@LabelExit}}" & @CRLF & _
		"Lbl @LabelHome // comment" & @CRLF & _
		"Lbl @LabelExit // comment" & @CRLF & _
		"@LabelExit→A" & @CRLF & _
		"Goto @LabelHome" _
	)
	MsgBox(0, "Result", $result)
EndIf
;-----------------


; Pass in TI-BASIC code as UTF8 text
; Returns smaller version of that code, still as text
; Also applies advanced functionality such as #include statements, #define statements, etc.
Func OptimizeCode($code, $pathToSourceFile = "")

	;----------- Optimization Phase ------------------------------
	; Perform regex to clean up script
	; Use (?m) at start to enable multiline mode where ^ matches the start of a line
	; (?!...) is a negative look-ahead

	; TODO: Convert all colons NOT inside a string into line returns. That way the following
	;       optimizations will apply to those cases too. Currently they do not.
	; 		For example "If X=(3+2):Then" will not have trailing bracket stripped.

	; TODO: Multiple DelVar statements do NOT need a line return in between.
	;       Can also remove line return after a DelVar in 95% of cases, but NOT preceding "Lbl" labels or an "End" statement for an If block

	; Process #include directives
	$code = ParseAndPerformIncludeStatements($code, $pathToSourceFile)

	; REMOVE LEADING WHITE-SPACE
	$code = StringRegExpReplace($code, "(?m)^[ \t]+", "")				; remove tabs/spaces at start of a line (although tabs cannot be inserted by TI-Connect)
	$code = StringRegExpReplace($code, "(?m)^:+", "")  					; Remove colons at start of a line

	; COMMENTS
	; We need to also remove the trailing whitespace from comments, otherwise we might retain some blank lines in final script
	; Note: if a double slash appears inside a string, it will strip everything after it. Might not always be what we want.
	$code = StringRegExpReplace($code, "(?m)^""[^→\r]*\r\n", "")		; remove string comments (strings where there is NOT a store command) - won't remove comment on FINAL line of program, just in case this is desired
	$code = StringRegExpReplace($code, "(?s)^/\*.*\*/\s*", "")			; Multi-line comments with /* ... */ - (?s) enables dot to match ANY char, including line returns
	$code = StringRegExpReplace($code, "(?m)[ \t]*//.*", "")				; Single-line comments with // ...

	; Process #define directives
	$code = ParseAndReplaceDefinedVars($code)

	; Check for any erroneous redefinition of labels
	WarnIfLabelsAreRedefined($code)

	; REMOVE EXTRANEOUS LINE RETURNS
	$code = StringRegExpReplace($code, "(\r\n){2,}", @CRLF)  			; Remove a run of multiple line returns (blank lines)
	$code = StringRegExpReplace($code, "^(\r\n)+", "")					; Remove blank line(s) at start of file
	$code = StringRegExpReplace($code, @CRLF & "$", "")			  	 	; remove trailing line return / blank line at end of script

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


; Files can include other files using this syntax:
;
;	#include "myFile.8xp"
;
; This function searches for those directives and performs the actual include.
; Also supports nested includes.
Func ParseAndPerformIncludeStatements($code, $pathToSourceFile = "", $depth = 0)

	If $depth > 20 Then
		Debug("  - ERROR: #include statements created a recursive loop deeper than 20 levels. Cannot continue. Exiting.")
		Return $code
	EndIf

	; Scan for #include "..."
	Local $includeStatements = StringRegExp($code, "(?m)^[ \t]*#include ""([^""]*)""[ \t]*$", 4)
	; Debug($includeStatements, 1)

	; No matches? Return code unchanged.
	If $includeStatements == 1 Then Return $code

	For $include In $includeStatements

		; TODO: Has include already been included? If so, show error and stop processing includes.
		; Or maybe don't worry. We can just rely on the recursive loop detection.

		; Check if file exists
		Local $includeFilePath = $include[1]
		If Not FileExists($includeFilePath) Then
			Debug("  - ERROR: Could not open include file for " & $include[0])
			ExitLoop
		EndIf

		; Is this a binary file?
		If Is8xpBinaryFile($includeFilePath) Then
			; If so, parse binary into text code
			Local $includeCode = BinaryCodeToTextCode(Read8xpBinary($includeFilePath).body)
			; We'll also save a text copy of include file (original, prior to processing)
			; to assist with version control and performing text comparisons on different versions
			SaveSourceCodeToTextFile($includeFilePath, $includeCode)
		Else
			Local $includeCode = FileRead($includeFilePath)
		EndIf

		; Call this same function recursively, to process any sub-includes
		$includeCode = ParseAndPerformIncludeStatements($includeCode, $includeFilePath, $depth + 1)

		; Embed code from include file into parent code
		$code = StringReplace($code, $include[0], $includeCode)

	Next

	Return $code

EndFunc


; Scans $code and puts a warning in the console if "Lbl XX" appears more than once in the code
Func WarnIfLabelsAreRedefined($code)
	$matches = StringRegExp($code, "(?m)^Lbl (\w+)", 3)
	For $i = 0 To UBound($matches) - 2
		If _ArraySearch($matches, $matches[$i], $i+1) > -1 Then
			; MsgBox(0, "Compilation Error", "Oops! You have defined ""Lbl " & $matches[$i] & """ multiple times.")
			Debug("  - WARNING: You have defined ""Lbl " & $matches[$i] & """ multiple times.")
		EndIf
	Next
EndFunc



; This function provides support for defining variables in your script that are replaced throughout
; It allows for the use of longer label names, variable names, Y-function names, renaming functions, etc.
;
; EXAMPLE:
;
;	#define @LabelExit X
;	#define @LabelHome H
;	#define @myVar A
;
;	Lbl @LabelExit
;	Goto @LabelHome
;	{{@myVar}}B→C
;
; NOTE:
; Definitions are parsed all at once, and then replaced throughout the document.
; The order of definition is not important.
; However, this means that a definition cannot be defined twice, nor redefined later in the doc.
Func ParseAndReplaceDefinedVars($code)

	Local $definedVars[]

	; Create a array of all defined variables
	; The array will alternate between names and values (0 = name, 1 = value, 2 = name, etc...)
	;  (?m) = multiline mode
	;  (?i) = case-insensitive
	Local $regexToMatchDefines = "(?m)(?i)^#define (@[A-Z]+\w*)\s+(.+)"
	Local $matches = StringRegExp($code, $regexToMatchDefines, 3)
	; Debug($matches)

	; Display a warning if a variable is defined more than once
	For $i = 0 To UBound($matches) - 1 Step 2
		If _ArraySearch($matches, $matches[$i], $i+1) > -1 Then
			MsgBox(0, "Compilation Error", "Oops! You have multiple #define " & $matches[$i] & " statements.")
		EndIf
	Next

	; Erase definitions from code
	$code = StringRegExpReplace($code, $regexToMatchDefines, "")

	; Replace all vars with their contents
	; Variables within code must not be followed by other alphaNumeric characters, otherwise names could clash
	For $i = 0 To UBound($matches) - 1 Step 2
		$code = StringRegExpReplace($code, "{{" & $matches[$i] & "}}", $matches[$i+1])
		$code = StringRegExpReplace($code, $matches[$i] & "\b", $matches[$i+1])
	Next

	Return $code
EndFunc



; OLD VERSION. Now see "RegexExceptWhen.au3"
Func RegExpReplaceExceptWhenPrecededBy($avoidThisAtStartOfLine, $avoidThisMidLine, $find, $replace)
	; $prefix = "(?m)" & $prefix & "\K"
EndFunc

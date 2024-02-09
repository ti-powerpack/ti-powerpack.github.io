#include-once
#include "Debug.au3"
#include <Array.au3>
#include "Process8xpppFile.au3"

;----- We run the following tests when this script is executed directly, but NOT when included from a parent script ----------
; PRESS F5 to run this test.
If @ScriptName == "OptimizeCode.au3" Then
	; MsgBox(0, "Result", OptimizeCode(@CRLF & "  ""Something here" & @CRLF & "For(I,1,2)" & @CRLF & "y"))
	$result = OptimizeCode( _
		@CRLF & _
		"⌊REDLEVEL→X" & @CRLF & _
		"X→⌊REDLEVEL2" & @CRLF & _
		"X→⌊REDLEVEL(2)" & @CRLF & _
		"  /*   #include ""..\Tests\Include Directive\test include.8xp.inc"" " & @CRLF & _
		"   #include ""..\Tests\Include Directive\test include 2.8xp.inc"" " & @CRLF & _
		"   #include ""..\Tests\Include Directive\test include 3.inc"" */" & @CRLF & _
		"   #define @Label_Exit X" & @CRLF & _
		"   #define @Mod360 r₃" & @CRLF & _
		"   Disp @Mod360(B+180)" & @CRLF & _
		"#define @LabelHome HX" & @CRLF & _
		"" & @CRLF & _
		"Lbl {{@Label_Exit}}" & @CRLF & _
		"Lbl @LabelHome // comment" & @CRLF & _
		"Lbl @Label_Exit // comment" & @CRLF & _
		"@Label_Exit→A" & @CRLF & _
		"Goto @LabelHome" & @CRLF & _
		"If (X):Goto X" & @CRLF & _
		"If (X):Disp Y" & @CRLF & _
		"" & @CRLF & _
		"#define @SomeVar" & @CRLF & _
		"#define @TestVar 1" & @CRLF & _
		"#IfDefined @TestVar" & @CRLF & _
		"  CORRECT. TestVar is defined: @TestVar" & @CRLF & _
		"  #ifDefined @MissingVar" & @CRLF & _
		"    INCORRECT. MissingVar should be hidden." & @CRLF & _
		"  #Else" & @CRLF & _
		"    CORRECT. MissingVar is not defined. @MissingVar" & @CRLF & _
		"  #EndIfDefined" & @CRLF & _
		"#Else" & @CRLF & _
		"  INCORRECT. TestVar is defined, so this section should be hidden." & @CRLF & _
		"#EndIfDefined" & @CRLF & _
		"#IfNotDefined @MissingVar" & @CRLF & _
		"  CORRECT. MissingVar is not defined." & @CRLF & _
		"#Else" & @CRLF & _
		"  INCORRECT. MissingVar is not defined. @MissingVar" & @CRLF & _
		"#EndIfDefined" & @CRLF & _
		"" & @CRLF & _
		"  If Str1=""X"":Then" & @CRLF & _
		"  If ((Str1=""X"")):Then" & @CRLF & _
		"" & @CRLF & _
		"DelVar X" & @CRLF & _
		"DelVar ⌊ABC" & @CRLF & _
		"DelVar L₂" & @CRLF & _
		"DelVar AAADelVar BBBDelVar CCCDelVar DDD" & @CRLF & _
		"DelVar Y" & @CRLF & _
		"" & @CRLF & _
		"If X=0:Then" & @CRLF & _
		"If Y=0" & @CRLF & _
		"If Z=0 and X" & @CRLF & _
		"If T=0 or X" & @CRLF & _
		"(((X)))DMS" & @CRLF & _
		"Disp (((X)))DMS,(((Y)))DMS" & @CRLF & _
		"" & @CRLF _
	)
	Debug($result)
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
	; NOTE: You CANNOT do positive look-behinds that are variable length in AutoIt3. Instead:
	; 			- use \K to ignore preceding match.
	;        	- use submatches and replace with $1, $2, etc.
	;			- see RegexExceptWhen.au3

	; TODO: Convert all colons NOT inside a string into line returns. That way the following
	;       optimizations will apply to those cases too. Currently they do not.
	; 		For example "If X=(3+2):Then" will not have trailing bracket stripped.

	; TODO: {0,0}→⌊COORD  - ⌊ symbol can be stripped out in these cases. Test carefully.
	; TODO: L₁→⌊COORD     - ⌊ symbol can be stripped out in this case also. Test carefully.

	; TODO: Strip trailing spaces which can cause programs to crash. SOME tokens require it,
	;		however, so needs to be done carefully.
	;		Or at least WARN user about the trailing spaces.
	;		These tokens may appear with a trailing space, and then NOTHING: (I think)
    ; 			- FnOn
    ;			- FnOff
	;			- Pause
	;			- PlotsOff
	;			- AxesOn
	;			- SetUpEditor
	;			- Fix?
	;			...and maybe others

	; Process #include directives
	$code = ParseAndPerformIncludeStatements($code, $pathToSourceFile)

	; REMOVE LEADING WHITE-SPACE
	$code = StringRegExpReplace($code, "(?m)^[ \t]+", "")				; remove tabs/spaces at start of a line (although tabs cannot be inserted by TI-Connect)
	$code = StringRegExpReplace($code, "(?m)^:+", "")  					; Remove colons at start of a line

	; COMMENTS
	; We need to also remove the trailing whitespace from comments, otherwise we might retain some blank lines in final script
	; Note: if a double slash appears inside a string, it will strip everything after it. Might not always be what we want.
	$code = StringRegExpReplace($code, "(?m)^""[^""→\r]*\r\n", "")		; remove string comments (strings where there is NOT a store command or closing quotes) - won't remove comment on FINAL line of program, just in case this is desired
																		; Note that it will remove strings that are intended to be placed in Ans! Workaround: Put a closing quote (which will later be stripped), or a "(" bracket at the start to prevent this.
	$code = StringRegExpReplace($code, "(?sm)^/\*.*?\*/\s*", "")		; Multi-line comments with /* ... */ - (?s) enables dot to match ANY char, including line returns
	$code = StringRegExpReplace($code, "(?m)[ \t]*//.*", "")			; Single-line comments with // ... (we also strip leading space here, between any prior characters and start of the comment)

	; Process #ifDefined and #ifNotDefined directives
	$code = ParseAndPerformConditionalStatements($code)

	; Process #define directives
	$code = ParseAndReplaceDefinedVars($code)

	; Check for any erroneous redefinition of labels
	WarnIfLabelsAreRedefined($code)

	; COLON OPTIMIZATIONS:
	; Move some common statements after a colon to their own line so that they can use additional optimisations below
	; $code = StringRegExpReplace($code, "(?m):Then$", @CRLF & "Then")
	$code = StringRegExpReplace($code, "(?m):(Then$|Disp |Goto |Pause |Input |Prompt |Menu\(|Return|Stop|Output\(|Get\(|Send\(|ClrHome)", @CRLF & "$1")

	; Remove line returns between consecutive DelVar statements
	; To do: remove other line returns following DelVars (but not in ALL cases, beware)
	; Can also remove line return after a DelVar in 95% of other cases, but NOT preceding "Lbl" labels or an "End" statement for an If block
	$code = StringRegExpReplace($code, "(DelVar [⌊\S]+)\r\n(?=DelVar)", "$1")

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

	; Replace "If X=0" and "0=X" with "If not(X)", but only at end of a line. Earlier in line it doesn't save any bytes, so no use.
	$code = StringRegExpReplace($code, "(?m) ([A-Zθ])=0$", " not($1)")
	$code = StringRegExpReplace($code, "(?m) 0=([A-Zθ])$", " not($1)")

	; Strip unnecessary closing quotes and brackets
	$code = StringRegExpReplace($code, "(?m)^{.*\K}", "")				; if line starts with { remove the closing }
	$code = StringRegExpReplace($code, "[)}]+→", "→")					; remove closing brackets ")" and "}" when storing a number
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
	; Will miss a few, such as:
	;   - Menu("Abc", A)
	;   - If X and (Str1="." or Str1="x")
	;   - If (X):Disp "Something...
	; ...but will prevent stripping bracket from: Disp "This (Example)"
	; Could probably strip when "Then" is on the next line... although then it would break: If Str1=")":Then
	$code = StringRegExpReplace($code, "(?m)^(?!For)[^""\r\n]*?\K\)+$", "")

	; There's a couple of special cases where we can definitely remove trailing brackets.
	$code = StringRegExpReplace($code, "(?m)^Menu\(.*\K\)$", "")
	$code = StringRegExpReplace($code, "(?m)^StringEqu\(.*\K\)$", "")

	$code = StringRegExpReplace($code, "(?m)^.*[^, ]\K""$", "")			; remove trailing double-quotes, except directly after comma or space

	; Remove brackets before DMS, but only when DMS is the last item on a line
	; Otherwise this will break statements like "Disp (X)DMS,(Y)DMS"
	$code = StringRegExpReplace($code, "(?m)\)+DMS$", "DMS")

	; Strip "⌊" when assigning a value to a list. Doesn't appear to be needed.
	; But DON'T strip it when assigning to a specific list item.
	;  e.g.  {1,2,3}→⌊MYLIST      - OK to strip
	;        234→⌊MYLIST(1)		  - Not OK to strip. Needs to be included.
	;
	$code = StringRegExpReplace($code, "(?m)→⌊([A-Z0-9]+)$", "→$1")

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
	; Leading spaces/tabs are allowed
	; If an #include is commented out then it will NOT be detected here,
	; but instead will be stripped out in a later step
	Local $includeStatements = StringRegExp($code, "(?m)^[ \t]*#include ""([^""]*)""[ \t]*$", 4)

	; EXPLANATION OF REGEX:
	; (?m)^[ \t]*#include ""([^""]*)""[ \t]*$
	;
	; Match the remainder of the regex with the options: ^ and $ match at line breaks (m) «(?m)»
	; Assert position at the beginning of a line (at beginning of the string or after a line break character) «^»
	; Match a single character present in the list below «[ \t]*»
	;    Between zero and unlimited times, as many times as possible, giving back as needed (greedy) «*»
	;    The character " " « »
	;    A tab character «\t»
	; Match the characters "#include """ literally «#include ""»
	; Match the regular expression below and capture its match into backreference number 1 «([^""]*)»
	;    Match any character that is not a """ «[^""]*»
	;       Between zero and unlimited times, as many times as possible, giving back as needed (greedy) «*»
	; Match the characters """" literally «""»
	; Match a single character present in the list below «[ \t]*»
	;    Between zero and unlimited times, as many times as possible, giving back as needed (greedy) «*»
	;    The character " " « »
	;    A tab character «\t»
	; Assert position at the end of a line (at the end of the string or before a line break character) «$»

	; Debug($includeStatements, 1)

	; No matches? Return code unchanged.
	If $includeStatements == 1 Then Return $code

	For $include In $includeStatements

		; TODO: Has include already been included? If so, show error and stop processing includes.
		; Or maybe don't worry. We can just rely on the recursive loop detection.

		; Check if file exists
		Local $includeFilePath = Folder($pathToSourceFile) & $include[1]
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
			; Otherwise it's plain text, so we'll just do a simple read
			Local $includeCode = FileRead($includeFilePath)
		EndIf

		; Call this same function recursively, to process any sub-includes
		; increasing the depth each time so we can catch infinite recursion
		$includeCode = ParseAndPerformIncludeStatements($includeCode, $includeFilePath, $depth + 1)

		; Embed code from include file into parent code
		$code = StringReplace($code, $include[0], $includeCode)

	Next

	Return $code

EndFunc

; Parses code for any #ifDefined directives and applies the logic to the code, removing sections that do not match the criteria
; NOTE: Currently #define statements can be anywhere in the code. The order is not important. Later
;       we might make the order crucial to allow redefining vars.
Func ParseAndPerformConditionalStatements($code)

	; TOKENS: (not case sensitive)
	Local $tokens[]
	$tokens.ifDefined = "#ifDefined"
	$tokens.ifNotDefined = "#ifNotDefined"
	$tokens.else = "#else"
	$tokens.endIfDefined = "#endIfDefined"

	; Main loop that continues as long as a match is found
	; Exits when no more matches
	While 1

		; ------ #ifDefined ... #else ... #endIfDefined -------
		; Find first instance of #endIfDefined
		Local $endIfDefinedPos = StringInStr($code, $tokens.endIfDefined)
		If $endIfDefinedPos Then

			; Find closest preceding instance of #ifDefined or #ifNotDefined to get the full block
			; (Due to nested #ifDefined statements, this may not be the first one found sequentially from beginning of file)
			; so we search backwards
			$ifDefinedPos =    StringInStr($code, "#ifDefined",    0, -1, $endIfDefinedPos)
			$ifNotDefinedPos = StringInStr($code, "#ifNotDefined", 0, -1, $endIfDefinedPos)

			; Since #ifDefined and #ifNotDefined have the same closing token, whichever one
			; we find that's closer to the end token will be the one we use
			If $ifNotDefinedPos > $ifDefinedPos Then $ifDefinedPos = $ifNotDefinedPos

			; Did we find an unmatched block? Show error.
			If $ifDefinedPos = 0 Then
				Debug("  - ERROR: #endIfDefined directive found without a matching #ifDefined or #ifNotDefined. Remaining directives not processed.")
				ExitLoop
			EndIf

			; We now have the full block, plus starting and ending offsets
			Local $endIfDefinedFinalPos = $endIfDefinedPos + StringLen($tokens.endIfDefined)
			Local $codeBlock = StringMid($code, $ifDefinedPos, $endIfDefinedFinalPos - $ifDefinedPos)

			; I think we can safely assume that there will NOT be any nested #ifDefined within
			; our specific match as the algorithm should always match the innermost blocks
			; first and then process them outwards.

			; Split this specific code block into these pieces:
			;  - var (the name of the variable to look for, starting with "@"
			;  - negativeMatch (whether the block started with #ifNotDefined rather than #ifDefined)
			;  - true portion
			;  - else portion

			Local $var = StringRegExp($codeBlock, "(?i)#(?:ifDefined|ifNotDefined) (@\w+)", 1)[0]
			;Debug("Var: " & $var)

			Local $negativeMatch = ($ifNotDefinedPos = $ifDefinedPos)
			;Debug("NegativeMatch: " & $negativeMatch)

			; Is the $var variable actually defined? This determines which branch of code is used
			Local $varIsDefined = StringRegExp($code, "#[dD][eE][fF][iI][nN][eE][ \t]+" & $var & "\b")
			;Debug("varIsDefined: " & $varIsDefined)

			Local $truePortion = GetStringBetweenTags($codeBlock, "#if[^\r\n]+", "(#else|#endIfDefined)")
			;Debug("truePortion: " & $truePortion)

			; Else portion could be empty
			Local $elsePortion = GetStringBetweenTags($codeBlock, "#else\b", "#endIfDefined")
			;Debug("elsePortion: " & $elsePortion)

			; Piece the resulting code back together, with only the relevant pieces
			; Start with all the code leading up to the start of our block
			Local $updatedCode = StringLeft($code, $ifDefinedPos - 1)
			; Then the code left after the conditional
			If ($varIsDefined And Not $negativeMatch) Or (Not $varIsDefined And $negativeMatch) Then
				$updatedCode &= $truePortion
			Else
				$updatedCode &= $elsePortion
			EndIf
			; And then the final section of code that follows our block
			$updatedCode &= StringMid($code, $endIfDefinedFinalPos)

			$code = $updatedCode

;~ 			Debug("---- Updated Code ----")
;~ 			Debug($code)
;~ 			Debug("----------------------")

			; Re-run the loop to search for next set of conditional statements
			ContinueLoop

		EndIf

		ExitLoop
	WEnd

	Return $code

EndFunc

;~ Debug(GetStringBetweenTags("something <start> "&@CRLF&" and more here </end> ....", "<start>", "<(/?)end>"))

; Start and end tags are regular expressions
; Don't use groups in $startTag unless you mark it as non-capturing via (?:...)
Func GetStringBetweenTags($string, $startTag, $endTag)

	Local $match = StringRegExp($string, "(?i)" & $startTag & "([\d\D]*?)" & $endTag, 1)

;~ 	Debug($string)
;~ 	Debug($startTag)
;~ 	Debug($endTag)
;~ 	Debug($match)
;~ 	Debug(VarGetType($match))

	; $match will be 1 if there was no match
	If IsArray($match) Then Return $match[0]

	Return ""

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
; Rules for using variables:
; 	- Variables are CASE SENSITIVE (I think)
;   - Names must start with a letter, but can have numbers, underscores (periods were considered, but could lead to ambiguous replacements
;     such as MyVar and MyVar.Something. MyVar and MyVar_Something does NOT have this problem because _ is a word character.)
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
	Local $regexToMatchDefines = "(?m)(?i)^[ \t]*#define (@[A-Z]+\w*)[ \t]*(.*)"
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

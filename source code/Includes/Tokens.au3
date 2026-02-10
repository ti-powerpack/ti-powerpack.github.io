#include-once

; 8XP TI Calculator Commands/Tokens and Their Binary & Text Representations
; ---------------------------------------------------------------------------
; Some tokens have multiple text representations
; The first one listed is used when decompiling from binary, and should match
; the character(s) used in TI Connect CE, for best compatibility.
; Other alternatives may be used when compiling *from* text to binary form.

; Entries on the left are actually HEX codes for binary.
; In AutoIt, they can be converted to binary via Binary("0x" & string)

Global $8xpTokens[][] = [ _
	["00", 0x00], _
	["01", "DMS", "►DMS"], _
	["02", "Dec", "►Dec"], _
	["03", "Frac", "►Frac"], _
	["04", "→"], _   			; STO or "store", used for variable assignment
	["05", "Boxplot"], _
	["06", "["], _
	["07", "]"], _
	["08", "{"], _
	["09", "}"], _
	["0A", "", "ʳ"], _
	["0B", "°"], _   			; degree symbol
	["0C", "", "ˉ¹"], _
	["0D", "²"], _
	["0E", "", "ᵀ"], _
	["0F", "", "³"], _
	["10", "("], _
	["11", ")"], _
	["12", "round("], _
	["13", "pxl-Test("], _
	["14", "augment("], _
	["15", "rowSwap("], _
	["16", "row+("], _
	["17", "*row("], _
	["18", "*row+("], _
	["19", "max("], _
	["1A", "min("], _
	["1B", "RPr(", "R►Pr("], _
	["1C", "RPθ(", "R►Pθ("], _
	["1D", "PRx(", "P►Rx("], _
	["1E", "PRy(", "P►Ry("], _
	["1F", "median("], _
	["20", "randM("], _
	["21", "mean("], _
	["22", "solve("], _
	["23", "seq("], _
	["24", "fnInt("], _
	["25", "nDeriv("], _
	["27", "fMin("], _
	["28", "fMax("], _
	["29", " "], _				; space?
	["2A", """"], _				; double-quote character
	["2B", ","], _
	["2C", "", "[i]"], _
	["2D", "!"], _
	["2E", "CubicReg "], _
	["2F", "QuartReg "], _
	["30", "0"], _
	["31", "1"], _
	["32", "2"], _
	["33", "3"], _
	["34", "4"], _
	["35", "5"], _
	["36", "6"], _
	["37", "7"], _
	["38", "8"], _
	["39", "9"], _
	["3A", "."], _
	["3B", "", "ᴇ"], _
	["3C", " or "], _
	["3D", " xor "], _
	["3E", ":"], _			; Colons are treated similar to a line return in TI-BASIC, allowing multiple statements on the same line. But colons can also appear inside a string.
	["3F", @CRLF], _ 		; Line return. Or should this be @LF? @CRLF seems to be working well on Windows so far.
	["40", " and "], _
	["41", "A"], _
	["42", "B"], _
	["43", "C"], _
	["44", "D"], _
	["45", "E"], _
	["46", "F"], _
	["47", "G"], _
	["48", "H"], _
	["49", "I"], _
	["4A", "J"], _
	["4B", "K"], _
	["4C", "L"], _
	["4D", "M"], _
	["4E", "N"], _
	["4F", "O"], _
	["50", "P"], _
	["51", "Q"], _
	["52", "R"], _
	["53", "S"], _
	["54", "T"], _
	["55", "U"], _
	["56", "V"], _
	["57", "W"], _
	["58", "X"], _
	["59", "Y"], _
	["5A", "Z"], _
	["5B", "θ"], _			; theta
	["5F", "prgm"], _
	["64", "Radian"], _
	["65", "Degree"], _
	["66", "Normal"], _
	["67", "Sci"], _
	["68", "Eng"], _
	["69", "Float"], _
	["6A", "="], _
	["6B", "<"], _
	["6C", ">"], _
	["6D", "≤"], _
	["6E", "≥"], _
	["6F", "≠"], _
	["70", "+"], _
	["71", "-"], _			; minus sign
	["72", "Ans"], _
	["73", "Fix "], _
	["74", "Horiz"], _
	["75", "Full"], _
	["76", "Func"], _
	["77", "Param"], _
	["78", "Polar"], _
	["79", "Seq"], _
	["7A", "IndpntAuto"], _
	["7B", "IndpntAsk"], _
	["7C", "DependAuto"], _
	["7D", "DependAsk"], _
	["7F", "▫", "plotsquare"], _
	["80", "⁺", "﹢"], _
	["81", "[tinydotplot]", "·"], _		; Originally this duplicated 0xEF73. The reason the primary text here is [tinydotplot] and not the single character is to prevent the clash with 0xEF73.
	["82", "*"], _
	["83", "/"], _
	["84", "Trace"], _
	["85", "ClrDraw"], _
	["86", "ZStandard"], _
	["87", "ZTrig"], _
	["88", "ZBox"], _
	["89", "Zoom In"], _
	["8A", "Zoom Out"], _
	["8B", "ZSquare"], _
	["8C", "ZInteger"], _
	["8D", "ZPrevious"], _
	["8E", "ZDecimal"], _
	["8F", "ZoomStat"], _
	["90", "ZoomRcl"], _
	["91", "PrintScreen"], _
	["92", "ZoomSto"], _
	["93", "Text("], _
	["94", " nPr "], _
	["95", " nCr "], _
	["96", "FnOn "], _
	["97", "FnOff "], _
	["98", "StorePic "], _
	["99", "RecallPic "], _
	["9A", "StoreGDB "], _
	["9B", "RecallGDB "], _
	["9C", "Line("], _
	["9D", "Vertical "], _
	["9E", "Pt-On("], _
	["9F", "Pt-Off("], _
	["A0", "Pt-Change("], _
	["A1", "Pxl-On("], _
	["A2", "Pxl-Off("], _
	["A3", "Pxl-Change("], _
	["A4", "Shade("], _
	["A5", "Circle("], _
	["A6", "Horizontal "], _
	["A7", "Tangent("], _
	["A8", "DrawInv "], _
	["A9", "DrawF "], _
	["AB", "rand"], _
	["AC", "π"], _
	["AD", "getKey"], _
	["AE", "'"], _
	["AF", "?"], _
	["B0", "­", "⁻"], _ 		; negative sign (character doesn't show in SciTE for some reason)
	["B1", "int("], _
	["B2", "abs("], _
	["B3", "det("], _
	["B4", "identity("], _
	["B5", "dim("], _
	["B6", "sum("], _
	["B7", "prod("], _
	["B8", "not("], _
	["B9", "iPart("], _
	["BA", "fPart("], _
	["BC", "√("], _
	["BD", "√(", "³√("], _
	["BE", "ln("], _
	["BF", "^(", "e^("], _
	["C0", "log("], _
	["C1", "^(", "₁₀^("], _
	["C2", "sin("], _
	["C3", "sin(", "sin⁻¹("], _
	["C4", "cos("], _
	["C5", "cos(", "cos⁻¹("], _
	["C6", "tan("], _
	["C7", "tan(", "tan⁻¹("], _
	["C8", "sinh("], _
	["C9", "sinh(", "sinh⁻¹("], _
	["CA", "cosh("], _
	["CB", "cosh(", "cosh⁻¹("], _
	["CC", "tanh("], _
	["CD", "tanh(", "tanh⁻¹("], _
	["CE", "If "], _
	["CF", "Then"], _
	["D0", "Else"], _
	["D1", "While "], _
	["D2", "Repeat "], _
	["D3", "For("], _
	["D4", "End"], _
	["D5", "Return"], _
	["D6", "Lbl "], _
	["D7", "Goto "], _
	["D8", "Pause "], _
	["D9", "Stop"], _
	["DA", "IS>("], _
	["DB", "DS<("], _
	["DC", "Input "], _
	["DD", "Prompt "], _
	["DE", "Disp "], _
	["DF", "DispGraph"], _    ; space after?
	["E0", "Output("], _
	["E1", "ClrHome"], _
	["E2", "Fill("], _
	["E3", "SortA("], _
	["E4", "SortD("], _
	["E5", "DispTable"], _
	["E6", "Menu("], _
	["E7", "Send("], _
	["E8", "Get("], _
	["E9", "PlotsOn "], _
	["EA", "PlotsOff "], _
	["EB", "⌊", "ʟ"], _
	["EC", "Plot1("], _
	["ED", "Plot2("], _
	["EE", "Plot3("], _
	["F0", "^"], _
	["F1", "√", "ˣ√"], _
	["F2", "1-Var Stats "], _
	["F3", "2-Var Stats "], _
	["F4", "LinReg(a+bx) "], _
	["F5", "ExpReg "], _
	["F6", "LnReg "], _
	["F7", "PwrReg "], _
	["F8", "Med-Med "], _
	["F9", "QuadReg "], _
	["FA", "ClrList "], _
	["FB", "ClrTable"], _
	["FC", "Histogram"], _
	["FD", "xyLine"], _
	["FE", "Scatter"], _
	["FF", "LinReg(ax+b) "], _
	["5C00", "[A]"], _
	["5C01", "[B]"], _
	["5C02", "[C]"], _
	["5C03", "[D]"], _
	["5C04", "[E]"], _
	["5C05", "[F]"], _
	["5C06", "[G]"], _
	["5C07", "[H]"], _
	["5C08", "[I]"], _
	["5C09", "[J]"], _
	["5D00", "L₁"], _
	["5D01", "L₂"], _
	["5D02", "L₃"], _
	["5D03", "L₄"], _
	["5D04", "L₅"], _
	["5D05", "L₆"], _
	["5E10", "Y₁"], _
	["5E11", "Y₂"], _
	["5E12", "Y₃"], _
	["5E13", "Y₄"], _
	["5E14", "Y₅"], _
	["5E15", "Y₆"], _
	["5E16", "Y₇"], _
	["5E17", "Y₈"], _
	["5E18", "Y₉"], _
	["5E19", "Y₀"], _
	["5E20", "X₁", "X₁ᴛ"], _
	["5E21", "Y₁", "Y₁ᴛ"], _
	["5E22", "X₂", "X₂ᴛ"], _
	["5E23", "Y₂", "Y₂ᴛ"], _
	["5E24", "X₃", "X₃ᴛ"], _
	["5E25", "Y₃", "Y₃ᴛ"], _
	["5E26", "X₄", "X₄ᴛ"], _
	["5E27", "Y₄", "Y₄ᴛ"], _
	["5E28", "X₅", "X₅ᴛ"], _
	["5E29", "Y₅", "Y₅ᴛ"], _
	["5E2A", "X₆", "X₆ᴛ"], _
	["5E2B", "Y₆", "Y₆ᴛ"], _
	["5E40", "r₁"], _
	["5E41", "r₂"], _
	["5E42", "r₃"], _
	["5E43", "r₄"], _
	["5E44", "r₅"], _
	["5E45", "r₆"], _
	["5E80", "u"], _    ; duplicated later? To check these. Seems that TI-Connect prefers these. My script does not.
	["5E81", "v"], _    ; duplicated later? To check these
	["5E82", "w"], _    ; duplicated later? To check these
	["6000", "Pic1"], _
	["6001", "Pic2"], _
	["6002", "Pic3"], _
	["6003", "Pic4"], _
	["6004", "Pic5"], _
	["6005", "Pic6"], _
	["6006", "Pic7"], _
	["6007", "Pic8"], _
	["6008", "Pic9"], _
	["6009", "Pic0"], _
	["6100", "GDB1"], _
	["6101", "GDB2"], _
	["6102", "GDB3"], _
	["6103", "GDB4"], _
	["6104", "GDB5"], _
	["6105", "GDB6"], _
	["6106", "GDB7"], _
	["6107", "GDB8"], _
	["6108", "GDB9"], _
	["6109", "GDB0"], _
	["6201", "RegEQ"], _
	["6202", "n"], _    ; duplicated later? To check these
	["6203", "", "ẋ"], _
	["6204", "Σx"], _
	["6205", "Σx²"], _
	["6206", "Sx"], _
	["6207", "σx"], _
	["6208", "minX"], _
	["6209", "maxX"], _
	["620A", "minY"], _
	["620B", "maxY"], _
	["620C", "", "ȳ"], _
	["620D", "Σy"], _
	["620E", "Σy²"], _
	["620F", "Sy"], _
	["6210", "σy"], _
	["6211", "Σxy"], _
	["6212", "r"], _    ; duplicated later? To check these
	["6213", "Med"], _
	["6214", "Q₁", "Q1"], _
	["6215", "Q₃", "Q3"], _
	["6216", "a"], _    ; duplicated later? To check these
	["6217", "b"], _    ; duplicated later? To check these
	["6218", "c"], _    ; duplicated later? To check these
	["6219", "d"], _    ; duplicated later? To check these
	["621A", "e"], _    ; duplicated later? To check these
	["621B", "x₁"], _
	["621C", "x₂"], _
	["621D", "x₃"], _
	["621E", "y₁"], _
	["621F", "y₂"], _
	["6220", "y₃"], _
	["6221", "", "[recursiven]"], _
	["6222", "p"], _    ; duplicated later? To check these
	["6223", "z"], _    ; duplicated later? To check these
	["6224", "t"], _    ; duplicated later? To check these
	["6225", "χ²"], _
	["6226", "", "[|F]"], _
	["6227", "df", "[df]"], _
	["6228", "", "[ṗ]"], _
	["6229", "₁", "ṗ₁"], _
	["622A", "₂", "ṗ₂"], _
	["622B", "₁", "ẋ₁"], _
	["622C", "Sx₁"], _
	["622D", "n₁"], _
	["622E", "₂", "ẋ₂"], _
	["622F", "Sx₂"], _
	["6230", "n₂"], _
	["6231", "Sxp", "[Sxp]"], _
	["6232", "lower"], _
	["6233", "upper"], _
	["6234", "s"], _    ; duplicated later? To check these
	["6235", "r²"], _
	_
	_ ;---------------------------------------------------------------------
	_ ; R² bugfix
	_ ; Unfortunately TI Connect 5 and 6 has a bug whereby it saves the formula R²
	_ ; as a single token (the statistic R²) instead of the R token followed by the ² token.
	_ ; This breaks simple formulas such as πR².
	_ ; So the next line provides a fix/workaround so that our script does NOT have the same bug.
	_ ; So what this means is that both 0x520D and 0x6236 will be decoded to the text R².
	_ ; When re-encoding, "R²" will always be 0x520D, which is the more likely option.
	_ ; To encode it as the single statistical token 0x6236, use the text "Rsquared".
	  ["520D", "R²"], _					; Force it to encode as two single tokens R and ²
	  ["6236", "R²", "Rsquared"], _
	_ ;---------------------------------------------------------------------
	_
	["6237", "[factordf]"], _    ; may need updating as per TI Connect CE
	["6238", "[factorSS]"], _    ; may need updating as per TI Connect CE
	["6239", "[factorMS]"], _    ; may need updating as per TI Connect CE
	["623A", "[errordf]"], _    ; may need updating as per TI Connect CE
	["623B", "[errorSS]"], _    ; may need updating as per TI Connect CE
	["623C", "[errorMS]"], _    ; may need updating as per TI Connect CE
	["6300", "ZXscl"], _
	["6301", "ZYscl"], _
	["6302", "Xscl"], _
	["6303", "Yscl"], _
	["6304", "u(Min)", "u(nMin)"], _		; Note: this currently gets broken during optimization phase due to trailing bracket
	["6305", "v(Min)", "v(nMin)"], _		; Note: this currently gets broken during optimization phase due to trailing bracket
	["6306", "Un-₁"], _
	["6307", "Vn-₁"], _
	["6308", "Zu(Min)", "Zu(nmin)"], _		; Note: this currently gets broken during optimization phase due to trailing bracket
	["6309", "Zv(Min)", "Zv(nmin)"], _		; Note: this currently gets broken during optimization phase due to trailing bracket
	["630A", "Xmin"], _
	["630B", "Xmax"], _
	["630C", "Ymin"], _
	["630D", "Ymax"], _
	["630E", "Tmin"], _
	["630F", "Tmax"], _
	["6310", "θmin"], _
	["6311", "θmax"], _
	["6312", "ZXmin"], _
	["6313", "ZXmax"], _
	["6314", "ZYmin"], _
	["6315", "ZYmax"], _
	["6316", "Zθmin"], _
	["6317", "Zθmax"], _
	["6318", "ZTmin"], _
	["6319", "ZTmax"], _
	["631A", "TblStart"], _
	["631B", "PlotStart"], _
	["631C", "ZPlotStart"], _
	["631D", "Max", "nMax"], _
	["631E", "ZMax", "ZnMax"], _
	["631F", "Min", "nMin"], _
	["6320", "ZMin", "ZnMin"], _
	["6321", "Tbl", "∆Tbl"], _
	["6322", "Tstep"], _
	["6323", "θstep"], _
	["6324", "ZTstep"], _
	["6325", "Zθstep"], _
	["6326", "X", "∆X"], _
	["6327", "Y", "∆Y"], _
	["6328", "XFact"], _
	["6329", "YFact"], _
	["632A", "TblInput"], _
	["632B", "Ś", "N"], _
	["632C", "I%"], _
	["632D", "PV"], _
	["632E", "PMT"], _
	["632F", "FV"], _
	["6330", "P/Y", "|P/Y"], _
	["6331", "C/Y", "|C/Y"], _
	["6332", "w(Min)", "w(nMin)"], _		; Note: this currently gets broken during optimization phase due to trailing bracket
	["6333", "Zw(Min)", "Zw(nMin)"], _		; Note: this currently gets broken during optimization phase due to trailing bracket
	["6334", "PlotStep"], _
	["6335", "ZPlotStep"], _
	["6336", "Xres"], _
	["6337", "ZXres"], _
	["7E00", "Sequential"], _
	["7E01", "Simul"], _
	["7E02", "PolarGC"], _
	["7E03", "RectGC"], _
	["7E04", "CoordOn"], _
	["7E05", "CoordOff"], _
	["7E06", "Connected"], _ ; was "Thick", not sure why
	["7E07", "Dot", "Dot-Thick"], _
	["7E08", "AxesOn "], _
	["7E09", "AxesOff"], _
	["7E0A", "GridOn"], _
	["7E0B", "GridOff"], _
	["7E0C", "LabelOn"], _
	["7E0D", "LabelOff"], _
	["7E0E", "Web"], _
	["7E0F", "Time"], _
	["7E10", "uvAxes"], _
	["7E11", "vwAxes"], _
	["7E12", "uwAxes"], _
	["AA00", "Str1"], _
	["AA01", "Str2"], _
	["AA02", "Str3"], _
	["AA03", "Str4"], _
	["AA04", "Str5"], _
	["AA05", "Str6"], _
	["AA06", "Str7"], _
	["AA07", "Str8"], _
	["AA08", "Str9"], _
	["AA09", "Str0"], _
	["BB00", "npv("], _
	["BB01", "irr("], _
	["BB02", "bal("], _
	["BB03", "ΣPrn("], _
	["BB04", "ΣInt("], _
	["BB05", "Nom(", "►Nom("], _
	["BB06", "Eff(", "►Eff("], _
	["BB07", "dbd("], _
	["BB08", "lcm("], _
	["BB09", "gcd("], _
	["BB0A", "randInt("], _
	["BB0B", "randBin("], _
	["BB0C", "sub("], _
	["BB0D", "stdDev("], _
	["BB0E", "variance("], _
	["BB0F", "inString("], _
	["BB10", "normalcdf("], _
	["BB11", "invNorm("], _
	["BB12", "tcdf("], _
	["BB13", "χ²cdf("], _
	["BB14", "cdf(", "Fcdf("], _
	["BB15", "binompdf("], _
	["BB16", "binomcdf("], _
	["BB17", "poissonpdf("], _
	["BB18", "poissoncdf("], _
	["BB19", "geometpdf("], _
	["BB1A", "geometcdf("], _
	["BB1B", "normalpdf("], _
	["BB1C", "tpdf("], _
	["BB1D", "χ²pdf("], _
	["BB1E", "pdf(", "Fpdf("], _
	["BB1F", "randNorm("], _
	["BB20", "tvm_Pmt"], _
	["BB21", "tvm_I%"], _
	["BB22", "tvm_PV"], _
	["BB23", "tvm_Ś", "tvm_N"], _
	["BB24", "tvm_FV"], _
	["BB25", "conj("], _
	["BB26", "real("], _
	["BB27", "imag("], _
	["BB28", "angle("], _
	["BB29", "cumSum("], _
	["BB2A", "expr("], _
	["BB2B", "length("], _
	["BB2C", "List(", "DeltaList("], _
	["BB2D", "ref("], _
	["BB2E", "rref("], _
	["BB2F", "Rect", "►Rect"], _
	["BB30", "Polar", "►Polar"], _
	["BB31", "", "e"], _
	["BB32", "SinReg "], _
	["BB33", "Logistic "], _
	["BB34", "LinRegTTest "], _
	["BB35", "ShadeNorm("], _
	["BB36", "Shade_t("], _
	["BB37", "Shadeχ²("], _
	["BB38", "Shade(", "ShadeF("], _
	["BB39", "Matrlist(", "Matr►list("], _
	["BB3A", "Listmatr(", "List►matr("], _
	["BB3B", "Z-Test("], _
	["BB3C", "T-Test "], _
	["BB3D", "2-SampZTest("], _
	["BB3E", "1-PropZTest("], _
	["BB3F", "2-PropZTest("], _
	["BB40", "χ²-Test("], _
	["BB41", "ZInterval "], _
	["BB42", "2-SampZInt("], _
	["BB43", "1-PropZInt("], _
	["BB44", "2-PropZInt("], _
	["BB45", "GraphStyle("], _
	["BB46", "2-SampTTest "], _
	["BB47", "2-SampTest ", "2-SampFTest"], _
	["BB48", "TInterval "], _
	["BB49", "2-SampTInt "], _
	["BB4A", "SetUpEditor "], _
	["BB4B", "Pmt_End"], _
	["BB4C", "Pmt_Bgn"], _
	["BB4D", "Real"], _
	["BB4E", "r^θ", "re^θi"], _
	["BB4F", "a+b", "a+bi"], _
	["BB50", "ExprOn"], _
	["BB51", "ExprOff"], _
	["BB52", "ClrAllLists"], _
	["BB53", "GetCalc("], _
	["BB54", "DelVar "], _
	["BB55", "EquString(", "Equ►String("], _
	["BB56", "StringEqu(", "String►Equ("], _
	["BB57", "Clear Entries"], _
	["BB58", "Select("], _
	["BB59", "ANOVA("], _
	["BB5A", "ModBoxplot"], _
	["BB5B", "NormProbPlot"], _
	["BB64", "G—T", "G-T"], _
	["BB65", "ZoomFit"], _
	["BB66", "DiagnosticOn"], _
	["BB67", "DiagnosticOff"], _
	["BB68", "Archive "], _
	["BB69", "UnArchive "], _
	["BB6A", "Asm("], _
	["BB6B", "AsmComp("], _
	["BB6C", "AsmPrgm"], _
	["BB6E", "Á"], _
	["BB6F", "À"], _
	["BB70", "Â"], _
	["BB71", "Ä"], _
	["BB72", "á"], _
	["BB73", "à"], _
	["BB74", "â"], _
	["BB75", "ä"], _
	["BB76", "É"], _
	["BB77", "È"], _
	["BB78", "Ê"], _
	["BB79", "Ë"], _
	["BB7A", "é"], _
	["BB7B", "è"], _
	["BB7C", "ê"], _
	["BB7D", "ë"], _
	["BB7F", "Ì"], _
	["BB80", "Î"], _
	["BB81", "Ï"], _
	["BB82", "í"], _
	["BB83", "ì"], _
	["BB84", "î"], _
	["BB85", "ï"], _
	["BB86", "Ó"], _
	["BB87", "Ò"], _
	["BB88", "Ô"], _
	["BB89", "Ö"], _
	["BB8A", "ó"], _
	["BB8B", "ò"], _
	["BB8C", "ô"], _
	["BB8D", "ö"], _
	["BB8E", "Ú"], _
	["BB8F", "Ù"], _
	["BB90", "Û"], _
	["BB91", "Ü"], _
	["BB92", "ú"], _
	["BB93", "ù"], _
	["BB94", "û"], _
	["BB95", "ü"], _
	["BB96", "Ç"], _
	["BB97", "ç"], _
	["BB98", "Ñ"], _
	["BB99", "ñ"], _
	["BB9A", "´"], _
	["BB9B", "|`"], _     ; may need updating as per TI Connect CE
	["BB9C", "¨"], _
	["BB9D", "¿"], _
	["BB9E", "¡"], _
	["BB9F", "α"], _
	["BBA0", "β"], _
	["BBA1", "γ"], _
	["BBA2", "", "Δ"], _
	["BBA3", "δ"], _
	["BBA4", "ε"], _
	["BBA5", "λ"], _
	["BBA6", "µ", "μ"], _
	["BBA7", "|π"], _     ; may need updating as per TI Connect CE
	["BBA8", "ρ"], _
	["BBA9", "Σ"], _
	["BBAB", "φ", "Φ"], _
	["BBAC", "Ω"], _
	["BBAD", "ṗ"], _
	["BBAE", "χ"], _
	["BBAF", "|F"], _    ; may need updating as per TI Connect CE
	["BBB0", "a"], _
	["BBB1", "b"], _
	["BBB2", "c"], _
	["BBB3", "d"], _
	["BBB4", "e"], _
	["BBB5", "f"], _
	["BBB6", "g"], _
	["BBB7", "h"], _
	["BBB8", "i"], _
	["BBB9", "j"], _
	["BBBA", "k"], _
	["BBBC", "l"], _
	["BBBD", "m"], _
	["BBBE", "n"], _
	["BBBF", "o"], _
	["BBC0", "p"], _
	["BBC1", "q"], _
	["BBC2", "r"], _
	["BBC3", "s"], _
	["BBC4", "t"], _
	["BBC5", "u"], _
	["BBC6", "v"], _
	["BBC7", "w"], _
	["BBC8", "x"], _
	["BBC9", "y"], _
	["BBCA", "z"], _
	["BBCB", "σ"], _
	["BBCC", "τ"], _
	["BBCD", "Í"], _
	["BBCE", "GarbageCollect"], _
	["BBCF", "~", "|~"], _
	["BBD1", "@"], _
	["BBD2", "#"], _
	["BBD3", "$"], _
	["BBD4", "&"], _
	["BBD5", "`"], _
	["BBD6", ";"], _
	["BBD7", "\"], _
	["BBD8", "|"], _
	["BBD9", "_"], _
	["BBDA", "%"], _
	["BBDB", "…"], _
	["BBDC", "∠"], _
	["BBDD", "ß"], _
	["BBDE", "", "ˣ"], _
	["BBDF", "", "ᴛ"], _
	["BBE0", "₀"], _
	["BBE1", "₁"], _
	["BBE2", "₂"], _
	["BBE3", "₃"], _
	["BBE4", "₄"], _
	["BBE5", "₅"], _
	["BBE6", "₆"], _
	["BBE7", "₇"], _
	["BBE8", "₈"], _
	["BBE9", "₉"], _
	["BBEA", "", "₁₀"], _
	["BBEB", "", "◄"], _
	["BBEC", "", "►"], _
	["BBED", "↑"], _
	["BBEE", "↓"], _
	["BBF0", "×"], _
	["BBF1", "∫"], _
	["BBF2", "", "bolduparrow"], _
	["BBF3", "", "bolddownarrow"], _
	["BBF4", "√"], _
	["BBF5", "Ŝ", "invertedequal"], _
	["EF00", "setDate("], _
	["EF01", "setTime("], _
	["EF02", "checkTmr("], _
	["EF03", "setDtFmt("], _
	["EF04", "setTmFmt("], _
	["EF05", "timeCnv("], _
	["EF06", "dayOfWk("], _
	["EF07", "getDtStr("], _
	["EF08", "getTmStr("], _
	["EF09", "getDate"], _
	["EF0A", "getTime"], _
	["EF0B", "startTmr"], _
	["EF0C", "getDtFmt"], _
	["EF0D", "getTmFmt"], _
	["EF0E", "isClockOn"], _
	["EF0F", "ClockOff"], _
	["EF10", "ClockOn"], _
	["EF11", "OpenLib("], _
	["EF12", "ExecLib"], _
	["EF13", "invT("], _
	["EF14", "χ²GOF-Test("], _
	["EF15", "LinRegTInt "], _
	["EF16", "Manual-Fit "], _
	["EF17", "ZQuadrant1"], _
	["EF18", "ZFrac12", "ZFrac1/2"], _
	["EF19", "ZFrac13", "ZFrac1/3"], _
	["EF1A", "ZFrac14", "ZFrac1/4"], _
	["EF1B", "ZFrac15", "ZFrac1/5"], _
	["EF1C", "ZFrac18", "ZFrac1/8"], _
	["EF1D", "ZFrac110", "ZFrac1/10"], _
	["EF1E", "mathprintbox"], _
	["EF2E", "", "⁄"], _
	["EF2F", "␣", "ᵤ"], _
	["EF30", "ndUnd", "►n⁄d◄►Un⁄d"], _
	["EF31", "FD", "►F◄►D"], _
	["EF32", "remainder("], _
	["EF33", "Σ("], _
	["EF34", "logBASE("], _
	["EF35", "randIntNoRep("], _
	["EF37", "MATHPRINT"], _
	["EF38", "CLASSIC"], _
	["EF39", "nd", "n⁄d"], _
	["EF3A", "Und", "Un⁄d"], _
	["EF3B", "AUTO", "[AUTO]"], _   ; WARNING
	["EF3C", "DEC", "[DEC]"], _		; WARNING: Using AUTO/DEC/FRAC in a list name will likely cause issues here. Avoid ⌊DEC or ⌊XDECX
	["EF3D", "FRAC", "[FRAC]"], _   ; WARNING
	["EF3F", "STATWIZARD ON"], _
	["EF40", "STATWIZARD OFF"], _
	["EF41", "[BLUE]"], _			; Color tokens MUST be wrapped in brackets to prevent them from being accidentally injected into a list name like ⌊RED
	["EF42", "[RED]"], _
	["EF43", "[BLACK]"], _
	["EF44", "[MAGENTA]"], _
	["EF45", "[GREEN]"], _
	["EF46", "[ORANGE]"], _
	["EF47", "[BROWN]"], _
	["EF48", "[NAVY]"], _
	["EF49", "[LTBLUE]"], _
	["EF4A", "[YELLOW]"], _
	["EF4B", "[WHITE]"], _
	["EF4C", "[LTGREY]"], _
	["EF4D", "[MEDGREY]"], _
	["EF4E", "[GREY]"], _
	["EF4F", "[DARKGREY]"], _
	_ ; some tokens missing here (EF50-EF59)
	["EF5A", "GridLine"], _
	["EF5B", "BackgroundOn"], _
	_ ; some tokens missing here (EF5C-EF63)
	["EF64", "BackgroundOff"], _
	["EF65", "GraphColor("], _
	_ ; EF66 missing
	["EF67", "TextColor("], _
	["EF68", "Asm84CPrgm"], _
	_ ; EF69 missing
	["EF6A", "DetectAsymOn"], _
	["EF6B", "DetectAsymOff"], _
	["EF6C", "BorderColor"], _
	_ ; some tokens missing here (EF6D-EF72)
	["EF73", "·", "tinydotplot"], _		; Duplicates 0x81 I think?
	["EF74", "Thin"], _ ; Does this work OK when used inside a string?
	["EF75", "Dot-Thin"], _
	_
	_ ;------------- Extras ---------------
	_ ; Not sure where these are from. TI Basic 68k I think? But TI Connect sometimes compiles these tokens even for 8XP programs.
	_ ; Well, except when I put them inside a string!
	_ ;
	_ ; The entries below ensure that we DECOMPILE them to the correct string,
	_ ; and them COMPILE them to the raw text, NOT to the token used by TI Connect.
	_ ; I don't think the TI-84+ can read/understand these tokens.
	_ ;
	_ ; The first entry is always used for COMPILATION (since the array is searched forward for the first matching string)
	_ ; The second entry is     used for DECOMPILATION (since the array is searched forward for the first matching bytes)
	_ ;
	_ ;EF90 SEQ(+1)
	_ ;EF91 SEQ(+2)
	_ ;EF95 invBinom(
	_
	["4C454654", "LEFT"], _				; Used for compilation only. Bugfix.
	["EF92", "LEFT"], _
	_
	["43454E544552", "CENTER"], _		; Used for compilation only. Bugfix.
	["EF93", "CENTER"], _
	_
	["5249474854", "RIGHT"], _			; Used for compilation only. Bugfix.
	["EF94", "RIGHT"], _
	_
	["576216bbb8622429", "Wait "], _	; When compiling, set "Wait " to the actual text characters. It's first in array as it should take priority. Wait command doesn't work on TI-84+.
	["EF96", "Wait "], _					; Added support for decompiling this to reduce bugs
	_
	["6224BBBF5362246212BBB86202BBB610", "toString("], _ ; Used for compilation only. Bugfix.
	["EF97", "toString("], _
	_
	["621A5E816216BBBC10", "eval("], _ 	; Used for compilation only. Bugfix.
	["EF98", "eval("] _
	_
	_ ;EF99 considered "bad token" by TI Connect
]

; Since _ArrayBinarySearch requires a SORTED array, we'll sort the array by token
Global $8xpTokensSorted = $8xpTokens
_ArraySort($8xpTokensSorted)

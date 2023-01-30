#include-once

; 8XP TI Calculator Commands/Tokens and Their Binary & Text Representations
; ---------------------------------------------------------------------------
; Some tokens have multiple text representations
; The first one listed is used when decompiling from binary, and should match
; the character(s) used in TI Connect CE, for best compatibility.
; Other alternatives may be used when compiling *from* text to binary form.

Global $8xpTokens[][] = [ _
    [0x00, 0x00], _
    [0x01, "DMS", "►DMS"], _
    [0x02, "Dec", "►Dec"], _
    [0x03, "Frac", "►Frac"], _
    [0x04, "→"], _   ; assignment
    [0x05, "Boxplot"], _
    [0x06, "["], _
    [0x07, "]"], _
    [0x08, "{"], _
    [0x09, "}"], _
    [0x0A, "", "ʳ"], _
    [0x0B, "°"], _   ; degree symbol
    [0x0C, "", "ˉ¹"], _
    [0x0D, "²"], _
    [0x0E, "", "ᵀ"], _
    [0x0F, "", "³"], _
    [0x10, "("], _
    [0x11, ")"], _
    [0x12, "round("], _
    [0x13, "pxl-Test("], _
    [0x14, "augment("], _
    [0x15, "rowSwap("], _
    [0x16, "row+("], _
    [0x17, "*row("], _
    [0x18, "*row+("], _
    [0x19, "max("], _
    [0x1A, "min("], _
    [0x1B, "RPr(", "R►Pr("], _
    [0x1C, "RPθ(", "R►Pθ("], _
    [0x1D, "PRx(", "P►Rx("], _
    [0x1E, "PRy(", "P►Ry("], _
    [0x1F, "median("], _
    [0x20, "randM("], _
    [0x21, "mean("], _
    [0x22, "solve("], _
    [0x23, "seq("], _
    [0x24, "fnInt("], _
    [0x25, "nDeriv("], _
    [0x27, "fMin("], _
    [0x28, "fMax("], _
    [0x29, " "], _
    [0x2A, """"], _
    [0x2B, ","], _
    [0x2C, "", "[i]"], _
    [0x2D, "!"], _
    [0x2E, "CubicReg "], _
    [0x2F, "QuartReg "], _
    [0x30, "0"], _
    [0x31, "1"], _
    [0x32, "2"], _
    [0x33, "3"], _
    [0x34, "4"], _
    [0x35, "5"], _
    [0x36, "6"], _
    [0x37, "7"], _
    [0x38, "8"], _
    [0x39, "9"], _
    [0x3A, "."], _
    [0x3B, "", "ᴇ"], _
    [0x3C, " or "], _
    [0x3D, " xor "], _
    [0x3E, ":"], _
    [0x3F, @CRLF], _ ; or should it be @LF?
    [0x40, " and "], _
    [0x41, "A"], _
    [0x42, "B"], _
    [0x43, "C"], _
    [0x44, "D"], _
    [0x45, "E"], _
    [0x46, "F"], _
    [0x47, "G"], _
    [0x48, "H"], _
    [0x49, "I"], _
    [0x4A, "J"], _
    [0x4B, "K"], _
    [0x4C, "L"], _
    [0x4D, "M"], _
    [0x4E, "N"], _
    [0x4F, "O"], _
    [0x50, "P"], _
    [0x51, "Q"], _
    [0x52, "R"], _
    [0x53, "S"], _
    [0x54, "T"], _
    [0x55, "U"], _
    [0x56, "V"], _
    [0x57, "W"], _
    [0x58, "X"], _
    [0x59, "Y"], _
    [0x5A, "Z"], _
    [0x5B, "θ"], _
    [0x5F, "prgm"], _
    [0x64, "Radian"], _
    [0x65, "Degree"], _
    [0x66, "Normal"], _
    [0x67, "Sci"], _
    [0x68, "Eng"], _
    [0x69, "Float"], _
    [0x6A, "="], _
    [0x6B, "<"], _
    [0x6C, ">"], _
    [0x6D, "≤"], _
    [0x6E, "≥"], _
    [0x6F, "≠"], _
    [0x70, "+"], _
    [0x71, "-"], _
    [0x72, "Ans"], _
    [0x73, "Fix "], _
    [0x74, "Horiz"], _
    [0x75, "Full"], _
    [0x76, "Func"], _
    [0x77, "Param"], _
    [0x78, "Polar"], _
    [0x79, "Seq"], _
    [0x7A, "IndpntAuto"], _
    [0x7B, "IndpntAsk"], _
    [0x7C, "DependAuto"], _
    [0x7D, "DependAsk"], _
    [0x7F, "▫", "plotsquare"], _
    [0x80, "⁺", "﹢"], _
    [0x81, "·"], _
    [0x82, "*"], _
    [0x83, "/"], _
    [0x84, "Trace"], _
    [0x85, "ClrDraw"], _
    [0x86, "ZStandard"], _
    [0x87, "ZTrig"], _
    [0x88, "ZBox"], _
    [0x89, "Zoom In"], _
    [0x8A, "Zoom Out"], _
    [0x8B, "ZSquare"], _
    [0x8C, "ZInteger"], _
    [0x8D, "ZPrevious"], _
    [0x8E, "ZDecimal"], _
    [0x8F, "ZoomStat"], _
    [0x90, "ZoomRcl"], _
    [0x91, "PrintScreen"], _
    [0x92, "ZoomSto"], _
    [0x93, "Text("], _
    [0x94, " nPr "], _
    [0x95, " nCr "], _
    [0x96, "FnOn "], _
    [0x97, "FnOff "], _
    [0x98, "StorePic "], _
    [0x99, "RecallPic "], _
    [0x9A, "StoreGDB "], _
    [0x9B, "RecallGDB "], _
    [0x9C, "Line("], _
    [0x9D, "Vertical "], _
    [0x9E, "Pt-On("], _
    [0x9F, "Pt-Off("], _
    [0xA0, "Pt-Change("], _
    [0xA1, "Pxl-On("], _
    [0xA2, "Pxl-Off("], _
    [0xA3, "Pxl-Change("], _
    [0xA4, "Shade("], _
    [0xA5, "Circle("], _
    [0xA6, "Horizontal "], _
    [0xA7, "Tangent("], _
    [0xA8, "DrawInv "], _
    [0xA9, "DrawF "], _
    [0xAB, "rand"], _
    [0xAC, "π"], _
    [0xAD, "getKey"], _
    [0xAE, "'"], _
    [0xAF, "?"], _
    [0xB0, "­", "⁻"], _ ; invisible negative sign
    [0xB1, "int("], _
    [0xB2, "abs("], _
    [0xB3, "det("], _
    [0xB4, "identity("], _
    [0xB5, "dim("], _
    [0xB6, "sum("], _
    [0xB7, "prod("], _
    [0xB8, "not("], _
    [0xB9, "iPart("], _
    [0xBA, "fPart("], _
    [0xBC, "√("], _
    [0xBD, "√(", "³√("], _
    [0xBE, "ln("], _
    [0xBF, "^(", "e^("], _
    [0xC0, "log("], _
    [0xC1, "^(", "₁₀^("], _
    [0xC2, "sin("], _
    [0xC3, "sin(", "sin⁻¹("], _
    [0xC4, "cos("], _
    [0xC5, "cos(", "cos⁻¹("], _
    [0xC6, "tan("], _
    [0xC7, "tan(", "tan⁻¹("], _
    [0xC8, "sinh("], _
    [0xC9, "sinh(", "sinh⁻¹("], _
    [0xCA, "cosh("], _
    [0xCB, "cosh(", "cosh⁻¹("], _
    [0xCC, "tanh("], _
    [0xCD, "tanh(", "tanh⁻¹("], _
    [0xCE, "If "], _
    [0xCF, "Then"], _
    [0xD0, "Else"], _
    [0xD1, "While "], _
    [0xD2, "Repeat "], _
    [0xD3, "For("], _
    [0xD4, "End"], _
    [0xD5, "Return"], _
    [0xD6, "Lbl "], _
    [0xD7, "Goto "], _
    [0xD8, "Pause "], _
    [0xD9, "Stop"], _
    [0xDA, "IS>("], _
    [0xDB, "DS<("], _
    [0xDC, "Input "], _
    [0xDD, "Prompt "], _
    [0xDE, "Disp "], _
    [0xDF, "DispGraph"], _    ; space after?
    [0xE0, "Output("], _
    [0xE1, "ClrHome"], _
    [0xE2, "Fill("], _
    [0xE3, "SortA("], _
    [0xE4, "SortD("], _
    [0xE5, "DispTable"], _
    [0xE6, "Menu("], _
    [0xE7, "Send("], _
    [0xE8, "Get("], _
    [0xE9, "PlotsOn "], _
    [0xEA, "PlotsOff "], _
    [0xEB, "⌊", "ʟ"], _
    [0xEC, "Plot1("], _
    [0xED, "Plot2("], _
    [0xEE, "Plot3("], _
    [0xF0, "^"], _
    [0xF1, "√", "ˣ√"], _
    [0xF2, "1-Var Stats "], _
    [0xF3, "2-Var Stats "], _
    [0xF4, "LinReg(a+bx) "], _
    [0xF5, "ExpReg "], _
    [0xF6, "LnReg "], _
    [0xF7, "PwrReg "], _
    [0xF8, "Med-Med "], _
    [0xF9, "QuadReg "], _
    [0xFA, "ClrList "], _
    [0xFB, "ClrTable"], _
    [0xFC, "Histogram"], _
    [0xFD, "xyLine"], _
    [0xFE, "Scatter"], _
    [0xFF, "LinReg(ax+b) "], _
    [0x5C00, "[A]"], _
    [0x5C01, "[B]"], _
    [0x5C02, "[C]"], _
    [0x5C03, "[D]"], _
    [0x5C04, "[E]"], _
    [0x5C05, "[F]"], _
    [0x5C06, "[G]"], _
    [0x5C07, "[H]"], _
    [0x5C08, "[I]"], _
    [0x5C09, "[J]"], _
    [0x5D00, "L₁"], _
    [0x5D01, "L₂"], _
    [0x5D02, "L₃"], _
    [0x5D03, "L₄"], _
    [0x5D04, "L₅"], _
    [0x5D05, "L₆"], _
    [0x5E10, "Y₁"], _
    [0x5E11, "Y₂"], _
    [0x5E12, "Y₃"], _
    [0x5E13, "Y₄"], _
    [0x5E14, "Y₅"], _
    [0x5E15, "Y₆"], _
    [0x5E16, "Y₇"], _
    [0x5E17, "Y₈"], _
    [0x5E18, "Y₉"], _
    [0x5E19, "Y₀"], _
    [0x5E20, "X₁", "X₁ᴛ"], _
    [0x5E21, "Y₁", "Y₁ᴛ"], _
    [0x5E22, "X₂", "X₂ᴛ"], _
    [0x5E23, "Y₂", "Y₂ᴛ"], _
    [0x5E24, "X₃", "X₃ᴛ"], _
    [0x5E25, "Y₃", "Y₃ᴛ"], _
    [0x5E26, "X₄", "X₄ᴛ"], _
    [0x5E27, "Y₄", "Y₄ᴛ"], _
    [0x5E28, "X₅", "X₅ᴛ"], _
    [0x5E29, "Y₅", "Y₅ᴛ"], _
    [0x5E2A, "X₆", "X₆ᴛ"], _
    [0x5E2B, "Y₆", "Y₆ᴛ"], _
    [0x5E40, "r₁"], _
    [0x5E41, "r₂"], _
    [0x5E42, "r₃"], _
    [0x5E43, "r₄"], _
    [0x5E44, "r₅"], _
    [0x5E45, "r₆"], _
    [0x5E80, "u"], _    ; duplicated later? To check these
    [0x5E81, "v"], _    ; duplicated later? To check these
    [0x5E82, "w"], _    ; duplicated later? To check these
    [0x6000, "Pic1"], _
    [0x6001, "Pic2"], _
    [0x6002, "Pic3"], _
    [0x6003, "Pic4"], _
    [0x6004, "Pic5"], _
    [0x6005, "Pic6"], _
    [0x6006, "Pic7"], _
    [0x6007, "Pic8"], _
    [0x6008, "Pic9"], _
    [0x6009, "Pic0"], _
    [0x6100, "GDB1"], _
    [0x6101, "GDB2"], _
    [0x6102, "GDB3"], _
    [0x6103, "GDB4"], _
    [0x6104, "GDB5"], _
    [0x6105, "GDB6"], _
    [0x6106, "GDB7"], _
    [0x6107, "GDB8"], _
    [0x6108, "GDB9"], _
    [0x6109, "GDB0"], _
    [0x6201, "RegEQ"], _
    [0x6202, "n"], _    ; duplicated later? To check these
    [0x6203, "", "ẋ"], _
    [0x6204, "Σx"], _
    [0x6205, "Σx²"], _
    [0x6206, "Sx"], _
    [0x6207, "σx"], _
    [0x6208, "minX"], _
    [0x6209, "maxX"], _
    [0x620A, "minY"], _
    [0x620B, "maxY"], _
    [0x620C, "", "ȳ"], _
    [0x620D, "Σy"], _
    [0x620E, "Σy²"], _
    [0x620F, "Sy"], _
    [0x6210, "σy"], _
    [0x6211, "Σxy"], _
    [0x6212, "r"], _    ; duplicated later? To check these
    [0x6213, "Med"], _
    [0x6214, "Q₁", "Q1"], _
    [0x6215, "Q₃", "Q3"], _
    [0x6216, "a"], _    ; duplicated later? To check these
    [0x6217, "b"], _    ; duplicated later? To check these
    [0x6218, "c"], _    ; duplicated later? To check these
    [0x6219, "d"], _    ; duplicated later? To check these
    [0x621A, "e"], _    ; duplicated later? To check these
    [0x621B, "x₁"], _
    [0x621C, "x₂"], _
    [0x621D, "x₃"], _
    [0x621E, "y₁"], _
    [0x621F, "y₂"], _
    [0x6220, "y₃"], _
    [0x6221, "", "[recursiven]"], _
    [0x6222, "p"], _    ; duplicated later? To check these
    [0x6223, "z"], _    ; duplicated later? To check these
    [0x6224, "t"], _    ; duplicated later? To check these
    [0x6225, "χ²"], _
    [0x6226, "", "[|F]"], _
    [0x6227, "df", "[df]"], _
    [0x6228, "", "[ṗ]"], _
    [0x6229, "₁", "ṗ₁"], _
    [0x622A, "₂", "ṗ₂"], _
    [0x622B, "₁", "ẋ₁"], _
    [0x622C, "Sx₁"], _
    [0x622D, "n₁"], _
    [0x622E, "₂", "ẋ₂"], _
    [0x622F, "Sx₂"], _
    [0x6230, "n₂"], _
    [0x6231, "Sxp", "[Sxp]"], _
    [0x6232, "lower"], _
    [0x6233, "upper"], _
    [0x6234, "s"], _    ; duplicated later? To check these
    [0x6235, "r²"], _
    [0x6236, "R²"], _
    [0x6237, "[factordf]"], _    ; may need updating as per TI Connect CE
    [0x6238, "[factorSS]"], _    ; may need updating as per TI Connect CE
    [0x6239, "[factorMS]"], _    ; may need updating as per TI Connect CE
    [0x623A, "[errordf]"], _    ; may need updating as per TI Connect CE
    [0x623B, "[errorSS]"], _    ; may need updating as per TI Connect CE
    [0x623C, "[errorMS]"], _    ; may need updating as per TI Connect CE
    [0x6300, "ZXscl"], _
    [0x6301, "ZYscl"], _
    [0x6302, "Xscl"], _
    [0x6303, "Yscl"], _
    [0x6304, "u(Min)", "u(nMin)"], _
    [0x6305, "v(Min)", "v(nMin)"], _
    [0x6306, "Un-₁"], _
    [0x6307, "Vn-₁"], _
    [0x6308, "Zu(Min)", "Zu(nmin)"], _
    [0x6309, "Zv(Min)", "Zv(nmin)"], _
    [0x630A, "Xmin"], _
    [0x630B, "Xmax"], _
    [0x630C, "Ymin"], _
    [0x630D, "Ymax"], _
    [0x630E, "Tmin"], _
    [0x630F, "Tmax"], _
    [0x6310, "θmin"], _
    [0x6311, "θmax"], _
    [0x6312, "ZXmin"], _
    [0x6313, "ZXmax"], _
    [0x6314, "ZYmin"], _
    [0x6315, "ZYmax"], _
    [0x6316, "Zθmin"], _
    [0x6317, "Zθmax"], _
    [0x6318, "ZTmin"], _
    [0x6319, "ZTmax"], _
    [0x631A, "TblStart"], _
    [0x631B, "PlotStart"], _
    [0x631C, "ZPlotStart"], _
    [0x631D, "Max", "nMax"], _
    [0x631E, "ZMax", "ZnMax"], _
    [0x631F, "Min", "nMin"], _
    [0x6320, "ZMin", "ZnMin"], _
    [0x6321, "Tbl", "∆Tbl"], _
    [0x6322, "Tstep"], _
    [0x6323, "θstep"], _
    [0x6324, "ZTstep"], _
    [0x6325, "Zθstep"], _
    [0x6326, "X", "∆X"], _
    [0x6327, "Y", "∆Y"], _
    [0x6328, "XFact"], _
    [0x6329, "YFact"], _
    [0x632A, "TblInput"], _
    [0x632B, "Ś", "N"], _
    [0x632C, "I%"], _
    [0x632D, "PV"], _
    [0x632E, "PMT"], _
    [0x632F, "FV"], _
    [0x6330, "P/Y", "|P/Y"], _
    [0x6331, "C/Y", "|C/Y"], _
    [0x6332, "w(Min)", "w(nMin)"], _
    [0x6333, "Zw(Min)", "Zw(nMin)"], _
    [0x6334, "PlotStep"], _
    [0x6335, "ZPlotStep"], _
    [0x6336, "Xres"], _
    [0x6337, "ZXres"], _
    [0x7E00, "Sequential"], _
    [0x7E01, "Simul"], _
    [0x7E02, "PolarGC"], _
    [0x7E03, "RectGC"], _
    [0x7E04, "CoordOn"], _
    [0x7E05, "CoordOff"], _
    [0x7E06, "Connected"], _ ; was "Thick", not sure why
    [0x7E07, "Dot", "Dot-Thick"], _
    [0x7E08, "AxesOn "], _
    [0x7E09, "AxesOff"], _
    [0x7E0A, "GridOn"], _
    [0x7E0B, "GridOff"], _
    [0x7E0C, "LabelOn"], _
    [0x7E0D, "LabelOff"], _
    [0x7E0E, "Web"], _
    [0x7E0F, "Time"], _
    [0x7E10, "uvAxes"], _
    [0x7E11, "vwAxes"], _
    [0x7E12, "uwAxes"], _
    [0xAA00, "Str1"], _
    [0xAA01, "Str2"], _
    [0xAA02, "Str3"], _
    [0xAA03, "Str4"], _
    [0xAA04, "Str5"], _
    [0xAA05, "Str6"], _
    [0xAA06, "Str7"], _
    [0xAA07, "Str8"], _
    [0xAA08, "Str9"], _
    [0xAA09, "Str0"], _
    [0xBB00, "npv("], _
    [0xBB01, "irr("], _
    [0xBB02, "bal("], _
    [0xBB03, "ΣPrn("], _
    [0xBB04, "ΣInt("], _
    [0xBB05, "Nom(", "►Nom("], _
    [0xBB06, "Eff(", "►Eff("], _
    [0xBB07, "dbd("], _
    [0xBB08, "lcm("], _
    [0xBB09, "gcd("], _
    [0xBB0A, "randInt("], _
    [0xBB0B, "randBin("], _
    [0xBB0C, "sub("], _
    [0xBB0D, "stdDev("], _
    [0xBB0E, "variance("], _
    [0xBB0F, "inString("], _
    [0xBB10, "normalcdf("], _
    [0xBB11, "invNorm("], _
    [0xBB12, "tcdf("], _
    [0xBB13, "χ²cdf("], _
    [0xBB14, "cdf(", "Fcdf("], _
    [0xBB15, "binompdf("], _
    [0xBB16, "binomcdf("], _
    [0xBB17, "poissonpdf("], _
    [0xBB18, "poissoncdf("], _
    [0xBB19, "geometpdf("], _
    [0xBB1A, "geometcdf("], _
    [0xBB1B, "normalpdf("], _
    [0xBB1C, "tpdf("], _
    [0xBB1D, "χ²pdf("], _
    [0xBB1E, "pdf(", "Fpdf("], _
    [0xBB1F, "randNorm("], _
    [0xBB20, "tvm_Pmt"], _
    [0xBB21, "tvm_I%"], _
    [0xBB22, "tvm_PV"], _
    [0xBB23, "tvm_Ś", "tvm_N"], _
    [0xBB24, "tvm_FV"], _
    [0xBB25, "conj("], _
    [0xBB26, "real("], _
    [0xBB27, "imag("], _
    [0xBB28, "angle("], _
    [0xBB29, "cumSum("], _
    [0xBB2A, "expr("], _
    [0xBB2B, "length("], _
    [0xBB2C, "List(", "DeltaList("], _
    [0xBB2D, "ref("], _
    [0xBB2E, "rref("], _
    [0xBB2F, "Rect", "►Rect"], _
    [0xBB30, "Polar", "►Polar"], _
    [0xBB31, "", "e"], _
    [0xBB32, "SinReg "], _
    [0xBB33, "Logistic "], _
    [0xBB34, "LinRegTTest "], _
    [0xBB35, "ShadeNorm("], _
    [0xBB36, "Shade_t("], _
    [0xBB37, "Shadeχ²("], _
    [0xBB38, "Shade(", "ShadeF("], _
    [0xBB39, "Matrlist(", "Matr►list("], _
    [0xBB3A, "Listmatr(", "List►matr("], _
    [0xBB3B, "Z-Test("], _
    [0xBB3C, "T-Test "], _
    [0xBB3D, "2-SampZTest("], _
    [0xBB3E, "1-PropZTest("], _
    [0xBB3F, "2-PropZTest("], _
    [0xBB40, "χ²-Test("], _
    [0xBB41, "ZInterval "], _
    [0xBB42, "2-SampZInt("], _
    [0xBB43, "1-PropZInt("], _
    [0xBB44, "2-PropZInt("], _
    [0xBB45, "GraphStyle("], _
    [0xBB46, "2-SampTTest "], _
    [0xBB47, "2-SampTest ", "2-SampFTest"], _
    [0xBB48, "TInterval "], _
    [0xBB49, "2-SampTInt "], _
    [0xBB4A, "SetUpEditor "], _
    [0xBB4B, "Pmt_End"], _
    [0xBB4C, "Pmt_Bgn"], _
    [0xBB4D, "Real"], _
    [0xBB4E, "r^θ", "re^θi"], _
    [0xBB4F, "a+b", "a+bi"], _
    [0xBB50, "ExprOn"], _
    [0xBB51, "ExprOff"], _
    [0xBB52, "ClrAllLists"], _
    [0xBB53, "GetCalc("], _
    [0xBB54, "DelVar "], _
    [0xBB55, "EquString(", "Equ►String("], _
    [0xBB56, "StringEqu(", "String►Equ("], _
    [0xBB57, "Clear Entries"], _
    [0xBB58, "Select("], _
    [0xBB59, "ANOVA("], _
    [0xBB5A, "ModBoxplot"], _
    [0xBB5B, "NormProbPlot"], _
    [0xBB64, "G—T", "G-T"], _
    [0xBB65, "ZoomFit"], _
    [0xBB66, "DiagnosticOn"], _
    [0xBB67, "DiagnosticOff"], _
    [0xBB68, "Archive "], _
    [0xBB69, "UnArchive "], _
    [0xBB6A, "Asm("], _
    [0xBB6B, "AsmComp("], _
    [0xBB6C, "AsmPrgm"], _
    [0xBB6E, "Á"], _
    [0xBB6F, "À"], _
    [0xBB70, "Â"], _
    [0xBB71, "Ä"], _
    [0xBB72, "á"], _
    [0xBB73, "à"], _
    [0xBB74, "â"], _
    [0xBB75, "ä"], _
    [0xBB76, "É"], _
    [0xBB77, "È"], _
    [0xBB78, "Ê"], _
    [0xBB79, "Ë"], _
    [0xBB7A, "é"], _
    [0xBB7B, "è"], _
    [0xBB7C, "ê"], _
    [0xBB7D, "ë"], _
    [0xBB7F, "Ì"], _
    [0xBB80, "Î"], _
    [0xBB81, "Ï"], _
    [0xBB82, "í"], _
    [0xBB83, "ì"], _
    [0xBB84, "î"], _
    [0xBB85, "ï"], _
    [0xBB86, "Ó"], _
    [0xBB87, "Ò"], _
    [0xBB88, "Ô"], _
    [0xBB89, "Ö"], _
    [0xBB8A, "ó"], _
    [0xBB8B, "ò"], _
    [0xBB8C, "ô"], _
    [0xBB8D, "ö"], _
    [0xBB8E, "Ú"], _
    [0xBB8F, "Ù"], _
    [0xBB90, "Û"], _
    [0xBB91, "Ü"], _
    [0xBB92, "ú"], _
    [0xBB93, "ù"], _
    [0xBB94, "û"], _
    [0xBB95, "ü"], _
    [0xBB96, "Ç"], _
    [0xBB97, "ç"], _
    [0xBB98, "Ñ"], _
    [0xBB99, "ñ"], _
    [0xBB9A, "´"], _
    [0xBB9B, "|`"], _     ; may need updating as per TI Connect CE
    [0xBB9C, "¨"], _
    [0xBB9D, "¿"], _
    [0xBB9E, "¡"], _
    [0xBB9F, "α"], _
    [0xBBA0, "β"], _
    [0xBBA1, "γ"], _
    [0xBBA2, "", "Δ"], _
    [0xBBA3, "δ"], _
    [0xBBA4, "ε"], _
    [0xBBA5, "λ"], _
    [0xBBA6, "µ", "μ"], _
    [0xBBA7, "|π"], _     ; may need updating as per TI Connect CE
    [0xBBA8, "ρ"], _
    [0xBBA9, "Σ"], _
    [0xBBAB, "φ", "Φ"], _
    [0xBBAC, "Ω"], _
    [0xBBAD, "ṗ"], _
    [0xBBAE, "χ"], _
    [0xBBAF, "|F"], _    ; may need updating as per TI Connect CE
    [0xBBB0, "a"], _
    [0xBBB1, "b"], _
    [0xBBB2, "c"], _
    [0xBBB3, "d"], _
    [0xBBB4, "e"], _
    [0xBBB5, "f"], _
    [0xBBB6, "g"], _
    [0xBBB7, "h"], _
    [0xBBB8, "i"], _
    [0xBBB9, "j"], _
    [0xBBBA, "k"], _
    [0xBBBC, "l"], _
    [0xBBBD, "m"], _
    [0xBBBE, "n"], _
    [0xBBBF, "o"], _
    [0xBBC0, "p"], _
    [0xBBC1, "q"], _
    [0xBBC2, "r"], _
    [0xBBC3, "s"], _
    [0xBBC4, "t"], _
    [0xBBC5, "u"], _
    [0xBBC6, "v"], _
    [0xBBC7, "w"], _
    [0xBBC8, "x"], _
    [0xBBC9, "y"], _
    [0xBBCA, "z"], _
    [0xBBCB, "σ"], _
    [0xBBCC, "τ"], _
    [0xBBCD, "Í"], _
    [0xBBCE, "GarbageCollect"], _
    [0xBBCF, "~", "|~"], _
    [0xBBD1, "@"], _
    [0xBBD2, "#"], _
    [0xBBD3, "$"], _
    [0xBBD4, "&"], _
    [0xBBD5, "`"], _
    [0xBBD6, ";"], _
    [0xBBD7, "\"], _
    [0xBBD8, "|"], _
    [0xBBD9, "_"], _
    [0xBBDA, "%"], _
    [0xBBDB, "…"], _
    [0xBBDC, "∠"], _
    [0xBBDD, "ß"], _
    [0xBBDE, "", "ˣ"], _
    [0xBBDF, "", "ᴛ"], _
    [0xBBE0, "₀"], _
    [0xBBE1, "₁"], _
    [0xBBE2, "₂"], _
    [0xBBE3, "₃"], _
    [0xBBE4, "₄"], _
    [0xBBE5, "₅"], _
    [0xBBE6, "₆"], _
    [0xBBE7, "₇"], _
    [0xBBE8, "₈"], _
    [0xBBE9, "₉"], _
    [0xBBEA, "", "₁₀"], _
    [0xBBEB, "", "◄"], _
    [0xBBEC, "", "►"], _
    [0xBBED, "↑"], _
    [0xBBEE, "↓"], _
    [0xBBF0, "×"], _
    [0xBBF1, "∫"], _
    [0xBBF2, "", "bolduparrow"], _
    [0xBBF3, "", "bolddownarrow"], _
    [0xBBF4, "√"], _
    [0xBBF5, "Ŝ", "invertedequal"], _
    [0xEF00, "setDate("], _
    [0xEF01, "setTime("], _
    [0xEF02, "checkTmr("], _
    [0xEF03, "setDtFmt("], _
    [0xEF04, "setTmFmt("], _
    [0xEF05, "timeCnv("], _
    [0xEF06, "dayOfWk("], _
    [0xEF07, "getDtStr("], _
    [0xEF08, "getTmStr("], _
    [0xEF09, "getDate"], _
    [0xEF0A, "getTime"], _
    [0xEF0B, "startTmr"], _
    [0xEF0C, "getDtFmt"], _
    [0xEF0D, "getTmFmt"], _
    [0xEF0E, "isClockOn"], _
    [0xEF0F, "ClockOff"], _
    [0xEF10, "ClockOn"], _
    [0xEF11, "OpenLib("], _
    [0xEF12, "ExecLib"], _
    [0xEF13, "invT("], _
    [0xEF14, "χ²GOF-Test("], _
    [0xEF15, "LinRegTInt "], _
    [0xEF16, "Manual-Fit "], _
    [0xEF17, "ZQuadrant1"], _
    [0xEF18, "ZFrac12", "ZFrac1/2"], _
    [0xEF19, "ZFrac13", "ZFrac1/3"], _
    [0xEF1A, "ZFrac14", "ZFrac1/4"], _
    [0xEF1B, "ZFrac15", "ZFrac1/5"], _
    [0xEF1C, "ZFrac18", "ZFrac1/8"], _
    [0xEF1D, "ZFrac110", "ZFrac1/10"], _
    [0xEF1E, "mathprintbox"], _
    [0xEF2E, "", "⁄"], _
    [0xEF2F, "␣", "ᵤ"], _
    [0xEF30, "ndUnd", "►n⁄d◄►Un⁄d"], _
    [0xEF31, "FD", "►F◄►D"], _
    [0xEF32, "remainder("], _
    [0xEF33, "Σ("], _
    [0xEF34, "logBASE("], _
    [0xEF35, "randIntNoRep("], _
    [0xEF37, "MATHPRINT"], _
    [0xEF38, "CLASSIC"], _
    [0xEF39, "nd", "n⁄d"], _
    [0xEF3A, "Und", "Un⁄d"], _
    [0xEF3B, "AUTO", "[AUTO]"], _
    [0xEF3C, "DEC", "[DEC]"], _
    [0xEF3D, "FRAC", "[FRAC]"], _
	[0xEF3F, "STATWIZARD ON"], _
    [0xEF40, "STATWIZARD OFF"], _
    [0xEF41, "BLUE"], _
    [0xEF42, "RED"], _
    [0xEF43, "BLACK"], _
    [0xEF44, "MAGENTA"], _
    [0xEF45, "GREEN"], _
    [0xEF46, "ORANGE"], _
    [0xEF47, "BROWN"], _
    [0xEF48, "NAVY"], _
    [0xEF49, "LTBLUE"], _
    [0xEF4A, "YELLOW"], _
    [0xEF4B, "WHITE"], _
    [0xEF4C, "LTGREY"], _
    [0xEF4D, "MEDGREY"], _
    [0xEF4E, "GREY"], _
    [0xEF4F, "DARKGREY"], _
    [0xEF5A, "GridLine"], _
    [0xEF5B, "BackgroundOn"], _
    [0xEF6A, "DetectAsymOn"], _
    [0xEF6B, "DetectAsymOff"], _
    [0xEF64, "BackgroundOff"], _
    [0xEF65, "GraphColor("], _
    [0xEF67, "TextColor("], _
    [0xEF68, "Asm84CPrgm"], _
    [0xEF6C, "BorderColor"], _
    [0xEF73, "·", "tinydotplot"], _
    [0xEF74, "Thin"], _
    [0xEF75, "Dot-Thin"] _
]
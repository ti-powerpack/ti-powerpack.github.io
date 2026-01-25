# Strip Comments & Whitespace

There are three types of comments you can use with Powerpack, and all three will be removed from the compiled program.

```
// Here is a comment

"Here is another comment

/*
And here is a multi-line comment
*/
```

This allows you to use comments generously and not be afraid of increasing file size. Comments are invaluable when disabling certain sections of code, or when coming back to your program at later time and being able to determine why you coded something the way you did!

## Placing strings into Ans

There might be certain times that you want to place a string into Ans or another variable and not have it stripped out:

```
"Line 1			  // ❌ Will be removed
"Line 2"		  // Will be kept
"Line 3→Str1	  // Will be kept
"Line 4"→Str1	  // Will be kept
```

The above code will be compiled into this:

```
"Line 2
"Line 3→Str1
"Line 4→Str1
```

If a line of code contains a `"` closing quote or the `→STO` character, the line will not be stripped during compilation.

The [optimization step](ti-basic-optimization) that occurs later will remove any unnecessary closing quotes or brackets.
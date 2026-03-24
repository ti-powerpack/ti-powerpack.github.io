# Strip Comments & Whitespace

When I first started using TI Basic, two of my biggest frustrations were:

* Not being able to indent sections of code
* Not being able to easily document my code with comments  
  (or if I did, it would increase the file size!)

So I fixed it. With Powerpack, you can now use unlimited spaces, tabs and newlines, and comment your code as extensively as you like, and these will all be removed during compilation to keep your final program size small.

## Indent code and blank lines

Here's an example of what you can do in Powerpack:

```
// Say hello
If A=1:Then
    A+1→A
    Disp "Hello World"
End

Disp "Finished"
```

When running `Powerpack EXAMPLE.8xp`, it will remove the comments and unnecessary whitespace, and produce something like this:

```
If A=1
Then
A+1→A
Disp "Hello World
End
Disp "Finished
```

Powerpack removes all blank lines and whitespace at the *start* of a line.

::: tip
Be careful you don't leave spaces/tabs at the *end* of a line, as this will produce an error on your calculator.
:::

## Comments

There are three types of comments you can use with Powerpack, and all three will be removed from the compiled program.

```
// Here is a comment

"Here is another comment

/*
And here is a multi-line comment
*/
```

This allows you to use comments generously and not be afraid of increasing file size. Comments are invaluable when disabling certain sections of code, or when coming back to your program at later time and being able to determine why you coded something the way you did!

Strings that are used in a function, stored into a variable, or having a closing `"` double-quote will remain in the compiled program and *not* be stripped. See below.


## Edge case: placing strings into `Ans`

There might be certain times that you want to place a string into Ans or another variable and not have it stripped out. In such a case, be sure to put a closing double-quote character, or use the `→STO` character, like this:

```
"Line 1			  // ❌ This line will be removed by Powerpack
"Line 2"		  // Will be kept
"Line 3→Str1	  // Will be kept
"Line 4"→Str1	  // Will be kept
```

The above code will be compiled into this:

```txt
"Line 2
"Line 3→Str1
"Line 4→Str1
```

In summary: if a line of code contains a `"` closing quote or the `→STO` character, the line will not be stripped during compilation.

The [optimization step](ti-basic-optimization) that occurs later will remove any unnecessary closing quotes or brackets.
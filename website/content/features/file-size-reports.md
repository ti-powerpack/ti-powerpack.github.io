# File Size Reports

Keeping your program's file size small is important. Sometimes you may want to see which sections of code are consuming the most space in the program.

Every time `Powerpack` runs, it outputs a report that shows you the number of bytes used on each line of your program. Look for the file in the `Source Code as Text` subfolder underneath your main program.

Here's an example:

``` [Source Code as Text\YOURPROG.optimized.8xp-byte-counts]
   3 bytes: Goto A
   3 bytes: Lbl B
  16 bytes: Disp "Hello "+Ans
   2 bytes: End
   3 bytes: Lbl A
  11 bytes: "World
  16 bytes: For(X,­1,0):If X:Goto B:End
------------------
  54 bytes total
  68 bytes total (including header and program name: HELLO)
```

Not only can it help identify sections of code that use a lot of bytes, but if you track this file in [git version control](https://git-scm.com/learn) and later rewrite or refactor parts of your program, you can easily compare this file with your earlier versions to see if it uses more or less bytes, and which sections are to blame.
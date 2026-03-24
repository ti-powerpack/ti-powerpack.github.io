# Subroutines for TI Basic

Sometimes in TI Basic, you may need to run a section of code from multiple places in your program (and not have to repeat the code in multiple places).

If your subroutine is only short (1-3 lines), skip down to the section on [Short subroutines](#short-subroutines), below.


## Subroutines in Plain TI Basic

Prior to Powerpack, there were two ways of dealing with this in plain TI Basic:

### 1. Use labels and `Goto` statements

::: details

Labels and Goto statements can work in some cases, but if you're calling your subroutine from 2 or more other places, your code will need logic to know which label to return to. Example:

```
A=1         // Tell the subroutine to return to Lbl A when it's done
"World"     // Place some text into Ans
Goto X      // Run the subroutine
Lbl A       // Return here when done

A=2         // Tell the subroutine to return to Lbl A when it's done
"Everyone"  // Place some text into Ans
Goto X      // Run the subroutine
Lbl B       // Return here when done

Stop        // End of program

// Subroutine:
Lbl X
Disp "Hello " +Ans
If A=1:Goto A
If A=2:Goto B
```

You also need to be careful of calling `Goto` inside an `If` or `For` statement, as memory leaks can occur and eventually crash your program if it happens too much!

:::


### 2. Call the program itself (or a subprogram)

::: details

This approach has the program call itself (or a subprogram). You will need to set a variable to indicate that a subroutine should be run. Example:

``` [TEST.8xp]
// Subroutine:
If X=123:Then
Disp "HELLO "+Ans
Return
End

// Main program:
123→X          // Set a flag to trigger the subroutine
"WORLD"        // Place text into Ans
prgmTEST       // Call the program which runs the subroutine
0→X            // Clear the flag
```

:::

Both of the above methods can be somewhat confusing to read and maintain. There needed to be a better way!


## Subroutines with Powerpack

**Powerpack** introduces a third method --- subroutines. 

You define a subroutine like this:

```
Lbl A
  Disp "Hello "+Ans
End
```

And when you want it to run, you call it like this:

```
Call A using Y
```

The calculator will jump to label `A`, run the subroutine, overwrite a letter variable in the process (which in this case is `Y`), and then jump back to the original location in the code once the subroutine completes.

(You can also just type `Call A` whereby the variable `Y` will be used by default. However it's better to specify it directly so that it's clear which variable will be overwritten and you don't hit confusing bugs.)


### Can I pass parameters?

In some other languages, it's possible to pass parameters to a subroutine, like `SayHello("Everyone")`. This is ***NOT*** currently supported in Powerpack, although may be considered in a future version.

Instead, you need to store any data into `Ans`, variables (`A`, `B`, `C`, `Str1` etc.) or lists (`L₁`, `L₂`, `⌊MYLIST`) and then have the subroutine refer to those.

----

Here's a more detailed example where we give the subroutine a more readable name:

```
// While using aliases here is optional, giving our labels
// and subroutines useful names can make the program more readable
// Remember: the actual, underlying labels can only be 1 or 2
//           characters long
#define @Start A
#define @SayHello B

// Subroutines will run faster if they're located at the
// top of the program (since the calculator doesn't have
// to search as far to find them). But that means we'll
// need to skip over them to the start of our main program.
Goto @Start

// Here is our subroutine:
Lbl @SayHello
  Disp "Hello "+Ans
End  // Be sure to put an "End" statement at the end

// Our program starts here:
Lbl @Start
"World"                  // Put some text into Ans
Call @SayHello using X   // Run the subroutine

// More code can continue below...
```


## How it works

When the code is compiled, Powerpack replaces it with a for-loop trick, which turns the above code into the following code:

```
Goto A
Lbl B
Disp "Hello "+Ans
End
Lbl A
"World
For(X,-­1,0):If X:Goto B:End
```

1. The `Call` statement becomes a `For()` loop
2. The subroutine is called on the first iteration through the loop
3. The `End` statement at the end of the subroutine tells the calculator to jump back to the start of the `For()` loop
4. On the second iteration of the loop, nothing occurs (since `X` is now zero) and it simply moves on with the rest of the program

Using `Call` can make your program easier to maintain, but keep in mind that each call to a subroutine adds around 17 bytes to the program, so use thoughtfully.


## Short subroutines

For short subroutines of only 1-3 lines, you may prefer to use one of these more efficient methods:

* For formulas/calculations that can fit into a single statement, you can use a `Y` or `r` formula

  ```
  // Give each formula a useful name
  #define @Times100 Y₁      
  #define @Percentage r₁    

  // Define the formula(s)
  "X*100"→@Times100       
  "round(θ*100,1)"→@Percentage

  // Use the formulas in our program
  @Times100(123)→A          // Will equal 12300
  Disp @Times100(456)       // Will display 45600
  Disp @Percentage(.1234)   // Will display 12.3
  ```

  `Y` formulas take a single parameter `X`  
  `r` formulas take a single parameter `θ`

* Put the subroutine into an alias. Separate multiple lines using a colon `:` character.

  ```
  // Define the subroutine
  #define @SayHello Disp "HELLO "+Ans:Disp 1+2+3

  // Call it throughout the program
  @SayHello
  ```

  Note that each time the subroutine is used, it will cause the *full code* for the subroutine to be injected at that location, increasing file size.

* Place the subroutine into an external file and include it wherever needed

  ```
  // some code...
  #include "MySubroutine.8xp"  // subroutine code gets injected here
  // more code...
  #include "MySubroutine.8xp"  // subroutine code gets injected here
  // more code...
  ```

  As above, each time the `#include` is used, it will cause the *full code* of that file to be injected at that location, increasing file size.



## An alternative approach

Using [aliases](/features/aliases) we can make the "program call itself" approach more readable. It could look something like this:

``` [TEST.8xp]
// Create an easy-to-read name for our subroutine
#define @SayHello 123→X:prgmTEST

// @SayHello Subroutine:
If X=123:Then
  Disp "Hello "+Str1
  Return
End

// Start of main program
"WORLD"→Str1    // Store text in Str1 var
@SayHello       // Call the subroutine

// Reset the subroutine variable at end of program
0→X
```

**Pros:**

- Works well if you want to keep your subroutines in a *separate* program from your main program
- May potentially use less bytes than the for-loop trick, keeping file sizes slightly smaller

**Cons:**

- With this approach, you *cannot* use `Ans` for passing data into your subroutine --- use another variable instead
- It may potentially require more processing on the calculator to spawn another copy of the program, and thus be slightly slower
- Be sure to *reset the flag variable at the end of your program* --- otherwise running it might trigger your subroutine instead of the main program!

If reusing subroutines across multiple programs, consider placing your subroutines and/or `#define` statements into a separate file and [`#include`](/features/includes) those, for easy reuse.
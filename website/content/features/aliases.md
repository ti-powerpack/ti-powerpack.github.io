# Aliases & Descriptive Names

With Powerpack you can give your variables, [lists](#lists),  "[goto labels](#goto-labels)", [functions](#functions) and [other snippets](#other-code-snippets) a more descriptive name, which helps make your code clearer and more maintainable. 

Here are some examples:

```
// Give variables better names
#define @HighScore H
123→@HighScore
@HighScore+1→@HighScore
```

Everywhere your alias is used, it will be replaced with the text you define. This will be compiled to:

```
123→H
H+1→H
```

Not only is the original code more descriptive and easier to understand --- essential in longer programs that use many variables --- but also, if you later decide to change the letter used for that variable, you can update it in one place, and it will be updated in every place it's used.

By placing all your `#define` statements at the top of your program, it also provides a helpful list of which variable letters have been used, and you can ensure that you don't use the same letter again where it might clash and overwrite something you don't want!

```
#define @HighScore H
#define @Counter C
#define @Level L
```

## Guidelines for using aliases

* Aliases are basically a "find and replace". Powerpack searches through your code and replaces any mentions of an `@Alias` with its actual value.

* All aliases must start with the `@` character and then any combination of letters, numbers or `_` underscores. Examples:
  
  ```
  @MyVar
  @AnotherVar2
  @Highscore_1
  @Highscore_2
  ```

<!-- Case sensitive? TBC -->

* Aliases must be specified on a single line. If you want to put multiple commands into an alias, use the `:` colon character, like this:
     ```
     #define @MySnippet A→123:Disp A
     ```

<!-- * There may be some situations where you need to place an alias alongside other characters, where the name gets confusing... -->

* Using one alias inside another is not thoroughly tested or supported. Do so at your own risk!

<!-- NO LONGER TRUE.
* Avoid creating alias names that overlap with other alias names, for example `@MyVar` and `@MyVar2`. You may find that `@MyVar2` results in displaying the contents of `@MyVar` followed by the number `2`. 

  (If you define `@MyVar2` *first* it will likely get processed first and avoid the issue, but try to avoid this scenario to reduce unexpected side-effects.)
-->

* If you mistype an alias in your code, Powerpack will give you a warning that it does not exist.

* If you tend to use the same aliases across multiple files, you can place them in a separate file and use an [`#include`](includes).

* You can place a comment on the same line as your alias, and it will be stripped out prior to processing the alias.

  ```
  #define @MyAlias 123   // this works fine
  ```

* If your alias has any trailing whitespace (spaces at the end of the line), these are usually stripped out

----

Aliases are useful not only for simple variables, but other things too:

## Lists

```
// Give my list a better name
#define @HighScores ⌊H
{1,2,3}→@HighScores
Disp @HighScores(1)
```

This will be compiled to:

```
{1,2,3}→H
Disp ⌊H(1)
```

(You'll notice that the optimizer removed the `⌊` character from the first line, as in this situation the calculator knows it's a list, and the character is unnecessary.)


## Goto labels

```
// Give my labels a better name
#define @_Menu M
...
Lbl @_Menu
...
Goto @_Menu
```

This will be compiled to:

```
Lbl M
Goto M
```

Giving labels a name starting with an underscore can be a helpful way to differentiate them from other things, but this is completely optional.

## Functions

If you need to reuse a specific formula in several places within your program, you can store that formula in a `Y` or `r` variable and give that a descriptive name.


```
#define @RoundTo3Places Y₁      // Give formula a name
"round(X,3)"→@RoundTo3Places    // Define the formula
Disp @RoundTo3Places(1.12345)   // Use the formula wherever needed
```

Using an alias for the simple `round()` example above may be a little overkill, but if your formula becomes quite large and repeatedly used, this can prove very useful.

The code above will be compiled to:

```
"round(X,3→Y₁
Disp Y₁(1.12345
```

And should display the result as `1.123`

The closing quotes and brackets will be stripped by the optimizer since they're optional.

## Other code snippets

You can also place longer code snippets into an alias, like this:

```
#define @RunSubProgram 123→A:prgmSUBPROG:Disp A

// Run my sub program:
@RunSubProgram
```

This will be compiled to:

```
123→A:prgmSUBPROG:Disp A
```

This is useful when you need to repeat a snippet in multiple places and want to have a single place to manage it.

## Using aliases inside formulas

Sometimes you may need to use an alias inside a formula in a way that confuses Powerpack. Here's an example:

```
#define @MyVar A

1→@MyVar
2→B
Disp @MyVarB
```

You might expect this to multiply `@MyVar` × `B`, but Powerpack thinks you're referring to an alias called `@MyVarB`. To work around this situation, you can wrap your variable in <span v-pre>`{{ double curly braces }}`</span>, like this:

```
#define @MyVar A

1→@MyVar
2→B
Disp {{@MyVar}}B
```

The above code will be correctly compiled to:

```
1→A
2→B
Disp AB
```
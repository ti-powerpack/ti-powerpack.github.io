# Aliases

With Powerpack you can give your variables, [lists](#lists),  "[goto labels](#goto-labels)", [functions](#functions) and [other snippets](#other-code-snippets) a more descriptive name, which helps make your code clearer and more maintainable. 

Here are some examples:

```
// Give variables better names
#define @HighScore H
123→@HighScore
@HighScore+1→@HighScore
```

Everywhere your alias is used, it will be replaced with the text you define. This will be compiled to:

```java
123→H
H+1→H
```

Not only is the code more descriptive and easier to understand, but if you later decide to change the letter used for that variable, you can update it in one place, and it will be updated in every place it's used.

By placing all your `#define` statements at the top of your program, it also provides a helpful list of which variable letters have been used, and you can ensure that you don't use the same letter again where it might clash and overwrite something you don't want!

## Guidelines for using aliases

* Aliases are basically a "find and replace". Powerpack searches through your code and replaces any mentions of an `@Alias` with its actual value.

* All aliases must start with the `@` character and then a letter. Numbers may be included in the rest of the name, but not as the first character.

<!-- Case sensitive? TBC -->

* Aliases must be specified on a single line. If you want to put multiple commands into an alias, use the `:` colon character, like this:
     ```
     #define @MyCommand A→123:Disp A
     ```

<!-- * There may be some situations where you need to place an alias  -->

* Using one alias inside another is not thoroughly tested or supported. Do so at your own risk!

* If you mistype an alias in your code, Powerpack will give you a warning that it does not exist.

* If you tend to use the same aliases across multiple files, you can place them in a separate file and use an [`#include`](includes).

* If you alias has any trailing whitespace (spaces at the end of the line), these are usually stripped out

----

Aliases are useful not only for simple variables, but other things too:

## Lists

```java
// Give my list a better name
#define @HighScores ⌊H
{1,2,3}→@HighScores
Disp @HighScores(1)
```

This will be compiled to:

```java
{1,2,3}→H
Disp ⌊H(1)
```

(You'll notice that the optimizer removed the `⌊` character from the first line, as in this situation the calculator knows it's a list, and the character is unnecessary.)


## Goto labels

```java
// Give my labels a better name
#define @_Menu M
...
Lbl @_Menu
...
Goto @_Menu
```

This will be compiled to:

```java
Lbl M
Goto M
```

Giving labels a name starting with an underscore can be a helpful way to differentiate them from other things, but this is completely optional.

## Functions

If you need to reuse a specific formula in several places within your program, you can store that formula in a `Y` or `r` variable and give that a descriptive name.

Here is a simple example, but if your formula becomes quite large and repeatedly used, this can prove very useful:

```
#define @RoundTo3Places Y₁
"round(X,3)"→@RoundTo3Places
Disp @RoundTo3Places(1.12345)
```

This will be compiled to:

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
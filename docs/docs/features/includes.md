# Includes

You can "include" code from one 8XP file to be placed inside another. This can be useful for common snippets that you tend to repeat in multiple programs.

Here's an example:

``` [HelloWorld.8xp]
"World"→Str1
#include "SayHello.8xp"
```

``` [SayHello.8xp]
Disp "Hello "+Str1
```

`HelloWorld.8xp` would compile to:

```
"World→Str1
Disp "Hello "+Str1
```

Powerpack works equally well with 8XP binary programs and text-based TI Basic source code --- you can include binary files from text files and vice-versa.


## Including aliases

You can also use aliases defined in another file. Here is another way of structuring the above code:

``` [HelloWorld.8xp]
#include "SayHello.8xp"
"World"→Str1
@SayHello
```

``` [SayHello.8xp]
#define @SayHello Disp "Hello "+Str1
```


`HelloWorld.8xp` would then compile to the following code (same as the previous example):

```
"World→Str1
Disp "Hello "+Str1
```

----

All `#include` statements are performed prior to other features and optimizations. Powerpack then treats the included file as if it were part of the main file.

<!-- (except for stripping of comments, which is performed first) -- not actually true --> 
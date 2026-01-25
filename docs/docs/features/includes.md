# Includes

You can "include" another 8XP program to be placed inside another. This can be useful for common snippets that you tend to repeat in multiple programs.

Here's an example:

::: code-group
``` [SayHello.8xp]
Disp "Hello "+Str1
```
:::

::: code-group
``` [HelloWorld.8xp]
"World"→Str1
#include "SayHello.8xp"
```
:::

`HelloWorld.8xp` would compile to:

```
"World→Str1
Disp "Hello "+Str1
```

## Including aliases

You can also use aliases defined in another file. Here is another way of structuring the above code:

::: code-group
``` [SayHello.8xp]
#define @SayHello Disp "Hello "+Str1
```
:::

::: code-group
``` [HelloWorld.8xp]
#include "SayHello.8xp"
"World"→Str1
@SayHello
```
:::

`HelloWorld.8xp` would then compile to the following code (same as the previous example):

```
"World→Str1
Disp "Hello "+Str1
```

----

All `#include` directives are performed prior to other features and optimizations (except for stripping of comments, which is performed first), so you can otherwise treat the included file as if it were part of the main file.
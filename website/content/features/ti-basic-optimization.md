# Optimize Your 8XP Programs

**Powerpack** automatically optimizes your 8XP programs during processing, by removing unnecessary characters. Why?

* Keeps the file size small --- essential for squeezing programs into the limited RAM space on the calculator

* Keeps the programs running fast --- smaller programs typically run faster

----

Here are the optimizations that Powerpack does:

* Removes comments and whitespace (spaces, tabs, extra line returns) --- explained in detail [here](/features/strip-comments)

* Removes all closing brackets, braces, and quotes, which are not necessary. For example:

  ```
  123*(456+7)→X
  {1,2,3}→⌊Y
  "Hello"→Str1
  ```

  Will become:

  ```
  123*(456+7→X
  {1,2,3→Y
  "Hello→Str1
  ```  

* Removes the list character (⌊) in situations where it's optional

* Replaces statements like `X=0` with `not(X` when they appear at the end of a line --- they mean the same thing, but 1 byte less

* Removes line returns following `DelVar` statements, which are not necessary
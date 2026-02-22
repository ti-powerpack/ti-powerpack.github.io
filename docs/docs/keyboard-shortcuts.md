# TI Basic Keyboard Shortcuts

When coding in TI Connect CE (or any other editor) it can be a huge time-saver to insert special characters and commands using your keyboard.

[Espanso](http://espanso.org/) is a Windows application (not associated with Powerpack) that allows you to set up text replacement commands like this, so that every time you type:

```
;sto     it gets changed to "→"
;neq     it gets changed to "≠"
;l1      it gets changed to "L₁"
;lisABC  it gets changed to "⌊ABC"
;dms     it gets changed to "▶DMS"
```

etc.

You can fully customize the shortcuts and commands that you'd like to use.

## Sample Espanso configuration

After installing [Espanso](http://espanso.org/), you need to define the shortcuts that you'd like to use by editing  
`C:\Users\[USERNAME]\AppData\Roaming\espanso\match\base.yml`

You can use this example file to get started:

```yml [base.yml]
# espanso match file
# For a complete introduction, visit the official docs at:
# https://espanso.org/docs/

# You can use this file to define the base matches (aka snippets)
# that will be available in every application when using espanso.

# To position the cursor, use "$|$" in the replacement

# Matches are substitution rules: when you type the "trigger" 
# string it gets replaced by the "replace" string.
matches:

 #----------- COMMON MATH SYMBOLS -----------------
  - trigger: ";deg"
    replace: "°"
  - trigger: ";pi"
    replace: "π"
  - trigger: ";theta"
    replace: "θ"
  - trigger: ";neq"
    replace: "≠"
  - trigger: ";lte"
    replace: "≤"
  - trigger: ";gte"
    replace: "≥"

# ----------- TI CALC SPECIFIC --------------------
  - triggers: [";;", ";sto"]
    replace: "→"
  - trigger: ";neg"
    replace: "­"
  - trigger: ";lis"
    replace: "⌊"
  - trigger: ";dms"
    replace: "DMS"
  - trigger: ";l1"
    replace: "L₁"
  - trigger: ";l2"
    replace: "L₂"
  - trigger: ";l3"
    replace: "L₃"
  - trigger: ";l4"
    replace: "L₄"
  - trigger: ";l5"
    replace: "L₅"
  - trigger: ";l6"
    replace: "L₆"
  - trigger: ";y1"
    replace: "Y₁"
  - trigger: ";y2"
    replace: "Y₂"
  - trigger: ";y3"
    replace: "Y₃"
  - trigger: ";y4"
    replace: "Y₄"
  - trigger: ";y5"
    replace: "Y₅"
  - trigger: ";y6"
    replace: "Y₆"
  - trigger: ";r1"
    replace: "r₁"
  - trigger: ";r2"
    replace: "r₂"
  - trigger: ";r3"
    replace: "r₃"
  - trigger: ";r4"
    replace: "r₄"
  - trigger: ";r5"
    replace: "r₅"
  - trigger: ";r6"
    replace: "r₆"
```

----

By default, the keyboard shortcuts will be available in *ALL* applications. 

If this becomes annoying, you can limit some or all of them to a specific application (such as TI Connect CE) by creating two additional files:

```yaml [espanso/config/TI Basic.yml]
# Regex that defines the executables for which the shortcuts will enabled in
filter_exec: "TI Connect CE.exe"

# Specify matches which will be loaded, in addition to the standard ones
extra_includes:
  - ../match/_TI Basic.yml
```

```yaml [espanso/match/_TI Basic.yml]
matches:
  - triggers: ["#d"]
    replace: "#define @"
  - triggers: [">>",";;"]
    replace: "→"
```

Move any shortcuts from the main `match/base.yml` into `match/_TI Basic.yml` to apply it to only that specific application.
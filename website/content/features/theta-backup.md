# Creating a Backup Copy

On rare occasions, it's possible for a TI calculator to require a RAM reset, or even reset itself if it detects corruption. When this happens, all programs stored in RAM are wiped.

One way of protecting against loss of your program is to store a backup copy of it in the "Archive". This uses longer-term flash memory, not RAM.


## The "theta" backup version

When using Powerpack, you will find it generates a file named like this:

```
Compiled Programs\YOURPROG.optimized.theta.8xp
```

Powerpack generates this as a second copy of your compiled program. The source code is exactly the same but it has two tweaks:

1. The program metadata specifies that it should be saved to the "Archive" (flash memory) when copied to a calculator. TI Connect CE will respect this when doing the transfer.

2. The name has a `θ` character prefixed to the start. For example, if your program was called `MYPROG`, the theta version will be called `θMYPROG`. Programs named like this will always be sorted at the very end of the list when you press <kbd>PRGM</kbd>, keeping your commonly used programs at the top.

----

If you lose the main copy of your program and need to restore it from the theta copy:

1. Unarchive the theta copy  
   (via the `Unarchive` command, or via <kbd>MEM</kbd> > <kbd>2</kbd> > <kbd>7</kbd> > Find the program > Press <kbd>ENTER</kbd>)

2. Run the unarchived theta program

3. If you need to restore the original ***name*** of the program (without the `θ`), perhaps because the program is called by others (or itself), then you can do this by:

    1. Creating a new blank program on your calculator with the desired name

    2. When you're editing this program, press <kbd>RCL</kbd> > <kbd>PRGM</kbd> > Choose the `θ` version of your program. The source code will be copied into your new blank program.


## Alternate backup method

Alternatively, you can create a `GROUP` on the calculator which copies programs from RAM into something similar to a ZIP file. This "group" is stored in flash memory, so won't be lost during a RAM reset. Programs cannot be run from inside a group (they will not even appear in the `PRGM` menu), but you can extract the group at any time which will place all programs from the group back into RAM and back into the `PRGM` menu. It's an excellent way to backup multiple programs.

You can create groups (and "ungroup" them) on the calculator via:  
<kbd>2nd</kbd> > <kbd>MEM</kbd> > <kbd>8</kbd>
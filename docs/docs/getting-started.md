---
layout: doc
---

# Getting Started

Powerpack is designed for writing TI Basic 8XP programs which run on the following Texas Instruments calculators:

* TI-83 Plus
* TI-84 Plus (monochrome screen)
* TI-84 Plus SE (Silver Edition, monochrome screen)
* TI-84 Plus CSE (colour screen)
* TI-84 Plus CE (colour screen)

It will probably *not* work for 68k TI Basic or TI-Nspire Basic, which runs on the TI-89, TI-92, Voyage 200, and TI-Nspire.


## Requirements

* Computer with Microsoft Windows 7 or above — Powerpack is only tested on Microsoft Windows at the current time
* For writing code you'll need either [TI Connect CE](https://education.ti.com/en/software/details/en/CA9C74CAD02440A69FDC7189D7E1B6C2/swticonnectcesoftware) (Texas' recommended editor) or any plain text editor
* <Badge type="info" text="Optional" /> [WabbitEmu](http://wabbitemu.org/) is the recommended emulator for testing your 8XP programs on your computer, before transferring them to your calculator. You'll also need a [ROM image](https://web.archive.org/web/20240409191813/http://tiroms.weebly.com/) for your particular calculator.
* [TI Connect CE](https://education.ti.com/en/software/details/en/CA9C74CAD02440A69FDC7189D7E1B6C2/swticonnectcesoftware) for transferring your programs to the calculator

## Installing

[Download Powerpack.exe]() and place it in a folder of your choice. 

You may like to place it in the same folder as your 8XP programs, which can make using it easier, but this is optional.

## Ways of using Powerpack

Depending on your preferred workflow, there are several ways you can use Powerpack:

1. **Watch the current folder**: place `Powerpack.exe` in the same folder as your 8XP files and double-click it to run. It will monitor the current folder for any changes to 8XP or 8XPPP files, and as soon as it sees a modification, it will automatically process and create an optimized version of that `.8XP` file.

2. **Process specific files**: by dropping 8XP files onto `Powerpack.exe` (or specifying them on the command line) only those files will be processed and then `Powerpack.exe` will exit.

3. **Watch another folder**: by dropping any folder onto `Powerpack.exe` that folder will be watched for any changes to 8XP or 8XPPP files and compilation will happen automatically.

::: tip
You can also do a combination of the above by dropping both files and a folder onto `Powerpack.exe`. The files will be immediately processed, and then the folder will be watched for further changes.

Or you may like to setup a Windows shortcut or BAT file that specifies the files/folders to use, for example:

```
Powerpack.exe "My Programs\MYPROG.8XP" "My Programs"
```
:::
# Powerpack.exe Command Line Options

Depending on your preferred workflow, there are several ways you can use Powerpack:

1. **Watch the current folder**: place `Powerpack.exe` in the same folder as your 8XP files and double-click it to run. It will monitor the current folder for any changes to 8XP or 8XPPP files, and as soon as it sees a modification, it will automatically process that changed file.

2. **Process specific files**: by dropping 8XP files onto `Powerpack.exe` (or specifying them on the command line) only those files will be processed and then `Powerpack.exe` will exit.

3. **Watch another folder**: by dropping any folder onto `Powerpack.exe` that folder will be watched for any changes to 8XP or 8XPPP files.

::: tip
You can also do a combination of the above by dropping both files and a folder onto `Powerpack.exe`. The files will be immediately processed, and then the folder will be watched for further changes.
:::

## Command line examples

```
Powerpack.exe "Path\to\MYPROG.8XP"
Powerpack.exe "Path\to\MYPROG.8XP" "Path\to\MYPROG2.8XP"
Powerpack.exe "Path\to\MYPROG.8XP" "Path\to\MyFolder"
```

You may compile *multiple* files with Powerpack, but only a *single* folder can be watched for changes. If you happen to specify multiple folders, only the first one will be used.

## Other options

There are no other command line options as yet, but they will be coming soon!
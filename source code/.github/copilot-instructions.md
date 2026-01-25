# Copilot / AI agent instructions for Binary Optimization Script

Summary:
- This repo is an AutoIt-based toolchain for decompiling, optimizing, and recompiling TI-83/84 .8xp and .8xppp programs. The watcher compiles, sends files to Wabbitemu (emulator), and saves text snapshots used for version control, diffs and tests.

Quick architecture (big picture):
- `WatchFor8xpChanges.au3` (root): main watcher app. Compiles to an EXE and watches the parent folder by default. On file change it calls `OptimizeScriptWhenSaved()`.
- `Includes/WatchFolderForChangesBlocking.au3`: Windows DirectoryChange wrapper (blocking). Provides event de-dup and filtering.
- `Includes/Process8xpppFile.au3`: Orchestrates read -> decompile -> transform -> recompile -> write. Key functions: `Read8xpBinary()`, `ProcessBody()`, `Write8xpBinary()`.
- `Includes/OptimizeCode.au3`: Text-based optimizer. Regex-heavy, handles `#include`, `#define`, `#ifDefined/#ifNotDefined` processing and many domain-specific transformations.
- `Includes/Tokens.au3`: Canonical token mapping used for decompilation (binary -> text) and compilation (text -> binary). This file is authoritative for token handling.
- `Includes/Create Theta Version Functions.au3`: Produces `.theta.8xp` variants (used to store a backup copy of a program on the calculator) and sets the archive flag, which stores the program in Flash memory by default (instead of RAM).
- `Includes/Debug.au3`: Console logging helpers and test helpers (also contains `WinMergeCompare` using a hardcoded WinMerge path). For developer use only.
- `Tests/`: sample programs, expected outputs, and small test runners (e.g., `Run Full Test.au3`, `Test Optimizations.au3`).

Key developer workflows (how to run & validate):
- Compile-run watcher: open `WatchFor8xpChanges.au3` with SciTE and press F7 to build an EXE, then run it (F5); the script is intentionally designed to refuse running from uncompiled source because it needs a console window.
- Manual tests: run `Tests\Run Full Test.au3` or `Tests\Test Optimizations.au3` from SciTE (F5). They run decompile/compile cycles and launch WinMerge for comparing hex/text dumps.
- Debugging: use `Debug()` (console output). The watchers and tests write source snapshots to the hard-coded `Source Code as Text` folder (see `WatchOptions.sourceCodeIntoSubfolder` and `Process8xpppFile.au3`)—use these for diffs and VCS.

Project-specific conventions & important gotchas:
- Tokens: `Includes/Tokens.au3` is the single source of truth. When adding or changing tokens, ensure both decompilation and compilation behavior stay compatible. Two-byte tokens exist — check `Process8xpppFile.au3` for handling of 2-byte prefixes and ordering.
- #include handling: `OptimizeCode.ParseAndPerformIncludeStatements()` supports nested includes with a depth limit (20). Includes may be binary `.8xp` files or plain text files.
- Regex-driven optimization: `OptimizeCode.au3` relies on carefully ordered regex transforms. Small changes can cascade—update relevant tests in `Tests/Optimizations/` and `Tests/` when modifying these rules.
- Paths & folders: `Source Code as Text` and the `Compiled Programs` subfolder names are referenced in multiple places. Update all occurrences if renaming.
- Emulator & diff tools are external dependencies with hard-coded paths by default:
  - Wabbitemu path configured in `WatchFor8xpChanges.au3` (`$WatchOptions.pathToWabbitEmu`). Update if not installed at that location.
  - WinMerge is invoked via `Includes/Debug.au3::WinMergeCompare()` with a hard-coded path (`C:\Program Files (x86)\WinMerge\WinMergeU.exe`). Update as needed.
- Blocking watcher: `WatchFolderForChangesBlocking.au3` uses WinAPI and is blocking — usually run the watcher as a compiled EXE (console) so it can be managed by a parent app or manually killed.

Testing and verification guidance (concrete examples):
- When changing token behavior: add a test case under `Tests/Test Decompile` or `Tests/Full Test`. Use `Run Full Test.au3` to generate hex dumps and compare via WinMerge.
- When changing optimizations: update `Tests/Optimizations/output.expected.8xp-source` and run `Test Optimizations.au3`.
- To validate Include behavior: create nested include files used by an example in `Tests/Include Directive/` and run the relevant test.

Files to inspect first for most tasks:
- `WatchFor8xpChanges.au3` — watcher configuration and Wabbitemu interaction
- `Includes/Process8xpppFile.au3` — decompile/compile flow
- `Includes/OptimizeCode.au3` — optimization rules, includes and conditionals
- `Includes/Tokens.au3` — token map (update with care)
- `Includes/Debug.au3` — logging and test helpers (note WinMerge path)
- `Includes/Create Theta Version Functions.au3` — .theta generation
- `Tests/` — sample inputs and expectations

Guidance for AI contributions (what to do/not do):
- Avoid manual edits of token lists without adding tests: token list changes affect both de/compilation behavior and many tests.
- When adding features that touch file layout or folder names, search for the exact string (e.g., "Source Code as Text")—it's used in multiple places and must be updated everywhere.
- Be conservative with regex changes in `OptimizeCode.au3`. Add targeted test cases showing the before/after behavior.


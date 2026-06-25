# Powerpack Outputs

Every time you run `Powerpack.exe` to process/optimize your 8XP program, it will read the program source code and generate several files. 

Here's an explanation of each and what you might use them for:


Subfolder | File | Description
-|-|-
Compiled Programs | YOURPROG.optimized.8xp | The compiled and [optimized](/features/ti-basic-optimization) version of your program. This is the file you want to load onto your calculator and/or run in WabbitEmu.
&nbsp; | YOURPROG.optimized.theta.8xp | A [backup copy](/features/theta-backup) of the compiled and optimized program. Using this is completely optional.
Source Code as Text | YOURPROG.8xp-source | A copy of the [original source code in plain text](/features/decompile-8xp) (if the original file is an 8XP binary file). Useful for keeping track of changes in git / version control.
&nbsp; | YOURPROG.optimized.8xp-source | A [plain text version of the "optimized" code](/features/decompile-8xp), after Powerpack has processed it, where all comments and extraneous characters have been removed. Useful for git / version control.
&nbsp; | YOURPROG.optimized.8xp-byte-counts | A [file size report](/features/file-size-reports) showing the number of bytes used on each line. Useful for keeping track of file size with git / version control.

Future versions of Powerpack will allow you to specify whether or not to output these files, and to which locations. For now, they are all output in the above structure.

<style>
	.VPDoc td {
		line-height: 1.5;
	}
	.VPDoc td:nth-child(2) {
		font-family: monospace;
	}
	.VPDoc td:nth-child(odd) {
		font-size: 80%;
		/* line-height: 1.5; */
	}
</style>
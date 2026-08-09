import { describe, it, test, expect, vitest } from 'vitest'
import fs from 'fs';
import { runAutoItFunction, runAutoItFunctionDetailed, config } from '../../JS AutoIt Bridge'

import input from './Tests/transformations.input.txt?raw'
import expected from './Tests/transformations.expected.txt?raw'

// To run these tests, we compare two text files: `transformations.input.txt` and `transformations.expected.txt`. The first file contains the input code, and the second file contains the expected output after running the optimization function.

config.debug = true;

async function OptimizeCode(code, pathToFile = import.meta.filename) {
	let result = await runAutoItFunctionDetailed('Includes/OptimizeCode.au3', 'OptimizeCode', code, pathToFile);
	// console.log(result);
	return result;
}

function stripLeadingWhitespace(str) {
	return str.replace(/^\s+/gm, '').trim();
}

test('OptimizeCode.au3 > Optimize()', async () => {

	// console.log()
	
	// Read from file
	// let input = await vitest.import('./Tests/transformations.input.txt?raw')
	// let expected = await import(import.meta.resolve('./Tests/transformations.expected.txt'))

	// Run the optimization function
	let result = await OptimizeCode(input);

	// Dump the result if it doesn't match the expected output, for easier debugging
	if (result.result !== expected) {
		console.log(result)
	}

	expect(result.result, 'Output doesn\'t match `Tests/transformations.expected.txt`').toEqual(expected);

});
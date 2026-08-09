import { describe, it, test, expect } from 'vitest'
import { runAutoItFunctionDetailed, config } from '../../JS AutoIt Bridge'

config.debug = true;

async function RegexReplaceExceptWhen(text, exceptWhenRegex, matchRegex, replace) {
	let result = await runAutoItFunctionDetailed(
		'Includes/RegexExceptWhen.au3',
		'RegexReplaceExceptWhen',
		text, exceptWhenRegex, matchRegex, replace
	);
	return result;
}

async function RegexReplaceExceptInsideString(text, matchRegex, replace) {
	let result = await runAutoItFunctionDetailed(
		'Includes/RegexExceptWhen.au3',
		'RegexReplaceExceptInsideString',
		text, matchRegex, replace
	);
	return result;
}

test('RegexReplaceExceptWhen: replace colons with = except inside strings or AVOID lines', async () => {
	const source =
		'--- ALL COLONS REMOVED IN THESE LINES ---\r\n' +
		'Here is a colon:\r\n' +
		':this one\r\n' +
		'and this:and : this\r\n' +
		'And "this" one should:\r\n' +
		'""": something\r\n' +
		'\r\n' +
		'--- COLONS REMAIN INSIDE THE STRINGS ONLY ---\r\n' +
		'Replaced: "Not: replaced:", and ":...:" replaced again:\r\n' +
		'But "this one:" should not be matched\r\n' +  // Note: this line differs from the original because regex needs balanced quotes
		'Nor "this one: either"\r\n' +
		'Nor "this"":""""" or "this:"\r\n' +
		'AVOID: No colons should: be: replaced: on: this: line: ';

	// This does a custom regex replace, replacing colons with =, except when the line starts with AVOID or when the colon is inside a string.
	// (NOT using RegexReplaceExceptInsideString in this instance)
	const result = await RegexReplaceExceptWhen(
		source,
		'^AVOID.*|"([^"]|"")*?("|$)',
		':',
		'='
	);

	const expected =
		'--- ALL COLONS REMOVED IN THESE LINES ---\r\n' +
		'Here is a colon=\r\n' +
		'=this one\r\n' +
		'and this=and = this\r\n' +
		'And "this" one should=\r\n' +
		'""": something\r\n' +   // This colon is inside a string starting with """
		'\r\n' +
		'--- COLONS REMAIN INSIDE THE STRINGS ONLY ---\r\n' +
		'Replaced= "Not: replaced:", and ":...:" replaced again=\r\n' +
		'But "this one:" should not be matched\r\n' +
		'Nor "this one: either"\r\n' +
		'Nor "this"":""""" or "this:"\r\n' +
		'AVOID: No colons should: be: replaced: on: this: line: ';

	// console.log('=== TEST 1 CODE ===');
	// console.log(result.au3Code);
	// console.log('=== TEST 1 EXPECTED ===');
	// console.log(expected);

	expect(result.result).toEqual(expected);
});

test('RegexReplaceExceptInsideString: remove trailing ) except inside strings', async () => {
	const input =
		'RemoveTrailingBracket("x")\r\n' +
		'RemoveTrailingBracket("y","z")\r\n' +
		'DoNotRemoveTrailingBracket("Something 1()\r\n' +
		'RemoveTrailingBracket("a")';

	const result = await RegexReplaceExceptInsideString(input, '\\)$', '');

	const expected =
		'RemoveTrailingBracket("x"\r\n' +
		'RemoveTrailingBracket("y","z"\r\n' +
		'DoNotRemoveTrailingBracket("Something 1()\r\n' +  // trailing ) is part of unclosed string
		'RemoveTrailingBracket("a"';

	// console.log('=== TEST 2 ACTUAL RESULT ===');
	// console.log(result);
	// console.log('=== TEST 2 EXPECTED ===');
	// console.log(expected);

	expect(result.result).toEqual(expected);
});

test('RegexReplaceExceptInsideString: replace X with Y except inside strings', async () => {
	const input = 'XX("X","",X,"X""X"),';

	const result = await RegexReplaceExceptInsideString(input, 'X', 'Y');

	// All X outside strings become Y. X inside strings ("X", "X""X") stay as X.
	const expected = 'YY("X","",Y,"X""X"),';

	expect(result.result).toEqual(expected);
});
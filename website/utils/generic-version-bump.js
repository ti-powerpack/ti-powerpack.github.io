/**
 * This updater is used with the `commit-and-tag-version` utility.
 * It scans a text file for anything that looks like a semantic
 * version number prefixed with a `v`, `"`, or `'`
 * 
 * The following are examples of valid version numbers:
 *  - 1.0.0
 *  - 1.0.0-beta
 *  - 1.0.0-beta.1
 *  - 1.0.0-alpha.1.2
 */


// REGEX EXPLAINED:
// (?<=v|")(\d+\.\d+\.\d+(?:-[\w.\d]+)?)
// 
// Assert that the regex below can be matched, with the match ending at this position (positive lookbehind) «(?<=v|")»
//    Match either the regular expression below (attempting the next alternative only if this one fails) «v»
//       Match the character "v" literally «v»
//    Or match regular expression number 2 below (the entire group fails if this one fails to match) «"»
//       Match the character """ literally «"»
// Match the regular expression below and capture its match into backreference number 1 «(\d+\.\d+\.\d+(?:-[\w.\d]+)?)»
//    Match a single digit 0..9 «\d+»
//       Between one and unlimited times, as many times as possible, giving back as needed (greedy) «+»
//    Match the character "." literally «\.»
//    Match a single digit 0..9 «\d+»
//       Between one and unlimited times, as many times as possible, giving back as needed (greedy) «+»
//    Match the character "." literally «\.»
//    Match a single digit 0..9 «\d+»
//       Between one and unlimited times, as many times as possible, giving back as needed (greedy) «+»
//    Match the regular expression below «(?:-[\w.\d]+)?»
//       Between zero and one times, as many times as possible, giving back as needed (greedy) «?»
//       Match the character "-" literally «-»
//       Match a single character present in the list below «[\w.\d]+»
//          Between one and unlimited times, as many times as possible, giving back as needed (greedy) «+»
//          A word character (letters, digits, etc.) «\w»
//          The character "." «.»
//          A single digit 0..9 «\d»
//
// /g indicates that the regex should be applied globally to the entire string, rather than stopping after the first match.
const versionRegex = /(?<=v|"|')(\d+\.\d+\.\d+(?:-[\w.\d]+)?)/g;

export function readVersion(contents) {
	return contents.match(versionRegex)[0];
}

export function writeVersion(contents, newVersion) {
	return contents.replaceAll(versionRegex, newVersion);
}
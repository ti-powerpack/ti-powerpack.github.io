Steps to releasing a new version
================================

1. Test all code changes thoroughly

2. Commit to git

2. Run `npm run increment-version-and-changelog` to increment the version number. This will: 
   - Update the version number in `Powerpack.au3` and `package.json`
   - Update the changelog
   - Create a new git commit and tag based on the version number for the release

   Tweak changelog if necessary, then run `git commit --amend` to update the commit message with the final changelog.

3. Push the commit *and tag* to GitHub

4. Compile `Powerpack.au3` into `Powerpack.exe` using AutoIt3 (press F7 in SciTE). It should contain the new version number in the source code, which is printed in the console when the program is run.

5. Upload the new release to GitHub, choosing the new version tag, the release title as `Powerpack vX.X.X`, and upload the compiled `Powerpack.exe` as an asset. 

   Download links will automatically point to the latest release, so no need to update any links in the website.

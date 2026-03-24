---
layout: home
bodyClass: xxxxx

hero:
  name: TI Basic Powerpack
  text: Create TI Basic programs with powerful new features
  tagline: Powerpack assists with coding TI&#8209;Basic 8XP programs for TI&#8209;84+ calculators — compiling and compressing them to provide new features, trim file size, and make coding a more enjoyable experience.
  image: 
    src: /rocket.png
    alt: TI Basic PowerPack
  actions:
    - text: Download
      icon: vpi-arrow-down
      link: /download
    - theme: brand
      text: Read the guide
      link: /what-is-powerpack
    - theme: alt
      text: View on GitHub
      link: 

# Icons are from https://lucide.dev/icons/
features:
  - icon: //
      # dark: /dark-feature-icon.svg
      # light: /light-feature-icon.svg
    title: Strip comments, blank lines, and other unnecessary characters
    details: You can now add indents, spacing, and long descriptive comments throughout your program, keeping it easy to read and maintain, without worrying about increasing the final file size.
    link: /features/strip-comments
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-refresh-ccw-icon lucide-refresh-ccw"><path d="M21 12a9 9 0 0 0-9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/><path d="M3 12a9 9 0 0 0 9 9 9.75 9.75 0 0 0 6.74-2.74L21 16"/><path d="M16 16h5v5"/></svg>
    title: Auto-execute your program after every change
    details: Write some code, hit save, and watch the changes automatically execute inside WabbitEmu or your emulator of choice.
    link: /features/autorun
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-whole-word-icon lucide-whole-word"><circle cx="7" cy="12" r="3"/><path d="M10 9v6"/><circle cx="17" cy="12" r="3"/><path d="M14 7v8"/><path d="M22 17v1c0 .5-.5 1-1 1H3c-.5 0-1-.5-1-1v-1"/></svg>
    title: Create variable names longer than one character
    details: No more remembering what variables A, B and C represent. Use longer, descriptive names for your variables, without increasing file size.
    link: /features/aliases
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-whole-word-icon lucide-whole-word"><circle cx="7" cy="12" r="3"/><path d="M10 9v6"/><circle cx="17" cy="12" r="3"/><path d="M14 7v8"/><path d="M22 17v1c0 .5-.5 1-1 1H3c-.5 0-1-.5-1-1v-1"/></svg>
    title: Create label names longer than two characters
    details: You can use longer, descriptive names for labels too — when you want to jump between sections of your program — “<kbd>Goto @Menu</kbd>” instead of “<kbd>Goto M</kbd>”.
    link: /features/aliases
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-square-bottom-dashed-scissors-icon lucide-square-bottom-dashed-scissors"><line x1="5" y1="3" x2="19" y2="3"/><line x1="3" y1="5" x2="3" y2="19"/><line x1="21" y1="5" x2="21" y2="19"/><line x1="9" y1="21" x2="10" y2="21"/><line x1="14" y1="21" x2="15" y2="21"/><path d="M 3 5 A2 2 0 0 1 5 3"/><path d="M 19 3 A2 2 0 0 1 21 5"/><path d="M 5 21 A2 2 0 0 1 3 19"/><path d="M 21 19 A2 2 0 0 1 19 21"/><circle cx="8.5" cy="8.5" r="1.5"/><line x1="9.56066" y1="9.56066" x2="12" y2="12"/><line x1="17" y1="17" x2="14.82" y2="14.82"/><circle cx="8.5" cy="15.5" r="1.5"/><line x1="9.56066" y1="14.43934" x2="17" y2="7"/></svg>
    title: Create reusable snippets of code
    details: Have snippets of code that you'd like to reuse multiple times in your program? With Powerpack, create an "alias" and then refer to that as many times as you need. When it needs updating, do so from a single location.
    link: /features/aliases
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-file-input-icon lucide-file-input"><path d="M4 11V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2v-1"/><path d="M14 2v5a1 1 0 0 0 1 1h5"/><path d="M2 15h10"/><path d="m9 18 3-3-3-3"/></svg>
    title: Include other files
    details: |
      Put snippets of code in a separate file and include that in as many programs as necessary.
    link: /features/includes
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-file-braces-corner-icon lucide-file-braces-corner"><path d="M14 22h4a2 2 0 0 0 2-2V8a2.4 2.4 0 0 0-.706-1.706l-3.588-3.588A2.4 2.4 0 0 0 14 2H6a2 2 0 0 0-2 2v6"/><path d="M14 2v5a1 1 0 0 0 1 1h5"/><path d="M5 14a1 1 0 0 0-1 1v2a1 1 0 0 1-1 1 1 1 0 0 1 1 1v2a1 1 0 0 0 1 1"/><path d="M9 22a1 1 0 0 0 1-1v-2a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-2a1 1 0 0 0-1-1"/></svg>
    title: Decompile 8XP to text
    details: Each time a file is processed, a plain text version is output, allowing you to track a history of your code changes in source control tools like git.
    link: /features/decompile-8xp
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-combine-icon lucide-combine"><path d="M14 3a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1"/><path d="M19 3a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1"/><path d="m7 15 3 3"/><path d="m7 21 3-3H5a2 2 0 0 1-2-2v-2"/><rect x="14" y="14" width="7" height="7" rx="1"/><rect x="3" y="3" width="7" height="7" rx="1"/></svg>
    title: Compile text to 8XP
    details: TI Basic code can be written using TI-Connect (which saves in binary form) or in plain text — using VSCode or your favorite editor — enabling the use of AI coding assistants.
    link: /features/compile-to-8xp
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-list-tree-icon lucide-list-tree"><path d="M8 5h13"/><path d="M13 12h8"/><path d="M13 19h8"/><path d="M3 10a2 2 0 0 0 2 2h3"/><path d="M3 5v12a2 2 0 0 0 2 2h3"/></svg>
    title: Create subroutines and easily call them
    details: Previously, TI-Basic did not support subroutines, but with Powerpack you can now use them.
    link: /features/subroutines
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-file-digit-icon lucide-file-digit"><path d="M4 12V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.706.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2"/><path d="M14 2v5a1 1 0 0 0 1 1h5"/><path d="M10 16h2v6"/><path d="M10 22h4"/><rect x="2" y="16" width="4" height="6" rx="2"/></svg>
    title: Keep track of file size
    details: Powerpack not only keeps file sizes small, but also generates a report that shows the bytes used on each line of your program, as well as the final size. Using git, you can easily keep track of file size increases.
    link: /features/file-size-reports
    linkText: More
  - icon: <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-code-xml-icon lucide-code-xml"><path d="m18 16 4-4-4-4"/><path d="m6 8-4 4 4 4"/><path d="m14.5 4-5 16"/></svg>
    title: Open source
    details: Powerpack is open source, written in AutoIt3, a simple, free language similar to Visual Basic.
    #link: /features/
    #linkText: More

  
---

<style>
  /* body h1 + .text[class] {
    font-size: 2rem;
    line-height: 1.15;
  } */
  p.tagline[class] {
    line-height: 1.25;
  }
</style>

<script setup>
  // import VPButton from 'vitepress/dist/client/theme-default/components/VPButton.vue'
  // import VPDoc from 'vitepress/dist/client/theme-default/components/VPDoc.vue'
</script>

<!-- <VPButton text="xxx"></VPButton> -->

<!-- <div class="custom-container" style="margin-top: 32px; font-size: 85%">
  <hr>
  <p>TI Basic Powerpack is currently built-in AutoIt3 and is tested on Windows only. A Node.js version may come in future with support for Mac and Linux too.</p>
  <p></p>
</div> -->

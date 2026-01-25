---
layout: home

hero:
  name: TI Basic Powerpack 🚀
  text: Create TI Basic programs with powerful new features
  tagline: Powerpack is a Windows program that assists with coding TI-Basic 8XP programs for Texas TI-83 or TI-84 Plus calculators — compiling and compressing them to provide new features, trim file size, and make coding a more enjoyable experience.
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

features:
  - # icon: 🌛
      # dark: /dark-feature-icon.svg
      # light: /light-feature-icon.svg
    title: Strip comments, blank lines, and other unnecessary characters
    details: You can now add long descriptive comments and blank lines throughout your program, keeping it easy to read and maintain, without worrying about increasing the final file size.
  - title: Auto-execute your program after every change
    details: Write some code, hit save, and watch the changes automatically execute inside WabbitEmu or your emulator of choice.
  - title: Create variable names longer than one character
    details: No more remembering what variables A, B and C represent. Use longer, descriptive names for your variables, without increasing file size.
  - title: Create label names longer than two characters
    details: You can use longer, descriptive names for labels too — when you want to jump between sections of your program — “<kbd>Goto @Menu</kbd>” instead of “<kbd>Goto M</kbd>”.
  - title: Create reusable snippets of code
    details: Have snippets of code that you'd like to reuse multiple times in your program? In Powerpack you can create an "alias" and then refer to that as many times as you need. When it needs updating, do so from a single location.
  - title: Include other files
    details: |
      Put snippets of code in a separate file and include that in as many programs as necessary.

      <a href="x">Learn more</a>
    link: #
  - # icon: 🛠️
    title: Decompile 8XP to text
    details: Each time a file is processed, a plain text version can be output, allowing you to track a history of your code changes in source control tools like git.
    # details: Lorem ipsum...
  - # icon: 😎
    title: Compile text to 8XP
    details: Powerpack is designed to work with Texas' official TI-Connect CE software, but if you prefer to write your code in VSCode or another editor, that's supported too.
  # - title: Strips unnecessary characters
  - title: Create subroutines and easily call them
    details: Previously, TI-Basic did not support subroutines, but with Powerpack you can now use them.

  
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

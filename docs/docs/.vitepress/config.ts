// import { defineConfig } from 'vitepress';

// refer https://vitepress.vuejs.org/config/introduction for details
export default {
  lang: 'en-US',
  title: '🚀 TI Basic Powerpack',
  description: 'Vite & Vue powered static site generator.',
  cleanUrls: true,
  markdown: {
    typographer: true,	// enables curly quotes, ndashes, mdashes, (c) symbol
  },
  appearance: { initialValue: 'dark' },
  lastUpdated: true,
  themeConfig: {
    nav: [
      { text: 'Download', link: '/download' },
      { text: 'Guide', link: '/what-is-powerpack' },
      { text: 'Github', link: 'https://github.com/...' },

      // {
      //   text: 'Dropdown Menu',
      //   items: [
      //     { text: 'Item A', link: '/item-1' },
      //     { text: 'Item B', link: '/item-2' },
      //     { text: 'Item C', link: '/item-3' },
      //   ],
      // },

      // ...
    ],

    sidebar: [
      { text: 'What is Powerpack?', link: '/what-is-powerpack' },
      { text: 'Download', link: '/download' },
      { text: 'Getting Started', link: '/getting-started' },
      {
        text: 'Powerpack Features',
        items: [
          // { text: 'Example', link: '/example' },
          { text: 'Strip comments & whitespace', link: '/features/strip-comments' },
          { text: 'Auto-run your programs', link: '/features/autorun' },
          { text: 'Aliases & descriptive names', link: '/features/aliases' },
          { text: 'Includes', link: '/features/includes' },
          { text: 'Compile plain text to 8XP', link: '/features/compile-to-8xp' },
          { text: 'Decompile 8XP to plain text', link: '/features/decompile-8xp' },
          { text: 'Optimization', link: '/features/ti-basic-optimization' },
          { text: 'Subroutines', link: '/features/subroutines' },
          // ...
        ],
      },
      { text: 'Command line options', link: '/command-line-options' },
      { text: 'Source code on Github', link: '' },
    ],

    footer: {
      message: 'Released under the MIT License. <br> Powerpack is not affiliated with Texas Instruments. <br> This software enhances the functionality of TI’s existing tools.',
      copyright: '',
    },

    search: {
      provider: 'local',
    },
  },
  vite: {
    /* resolve: {
      alias: {
		// Examples of customising certain components and remapping where they are loaded from
        // './VPLink.vue': '/.vitepress/components/VPLink.vue',
        // './VPSidebarItem.vue': '/.vitepress/components/VPSidebarItem.vue',
      }
    }, */
    server: {
      host: true,  // listen on all interfaces, to allow mobile access
    },
    css: {
      preprocessorOptions: {
        scss: {
          // Example: Suppress warnings from third-party dependencies
          quietDeps: true,
          // Example: Silence specific deprecation warnings (e.g., for legacy @import usage)
          // silenceDeprecations: ['import', 'global-builtin'],

        }
	    }
	  }
  },
};

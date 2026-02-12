// import { defineConfig } from 'vitepress';
import { groupIconMdPlugin, groupIconVitePlugin } from 'vitepress-plugin-group-icons'

// refer https://vitepress.vuejs.org/config/introduction for details
export default {
  lang: 'en-US',
  title: 'TI Basic Powerpack',
  description: 'Vite & Vue powered static site generator.',
  cleanUrls: true,
  markdown: {
    typographer: true,	// enables curly quotes, ndashes, mdashes, (c) symbol
    config(md) {
      md.use(groupIconMdPlugin)
    },
  },
  appearance: { initialValue: 'dark' },
  lastUpdated: true,
  themeConfig: {
    logo: '/favicon-96x96.png',
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

    sidebarMenuLabel: 'Guide Menu',
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
      message: 'Released under the MIT License. <br> Powerpack is not affiliated with Texas Instruments.', //<br> This software enhances the functionality of TI’s existing tools.',
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
    plugins: [
      groupIconVitePlugin({
        customIcon: {
          '.8xp': {
            light: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-file-braces-icon lucide-file-braces"><path d="M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z"/><path d="M14 2v5a1 1 0 0 0 1 1h5"/><path d="M10 12a1 1 0 0 0-1 1v1a1 1 0 0 1-1 1 1 1 0 0 1 1 1v1a1 1 0 0 0 1 1"/><path d="M14 18a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-1a1 1 0 0 0-1-1"/></svg>',
            dark: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-file-braces-icon lucide-file-braces"><path d="M6 22a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h8a2.4 2.4 0 0 1 1.704.706l3.588 3.588A2.4 2.4 0 0 1 20 8v12a2 2 0 0 1-2 2z"/><path d="M14 2v5a1 1 0 0 0 1 1h5"/><path d="M10 12a1 1 0 0 0-1 1v1a1 1 0 0 1-1 1 1 1 0 0 1 1 1v1a1 1 0 0 0 1 1"/><path d="M14 18a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-1a1 1 0 0 0-1-1"/></svg>'
          },
        }
      }),
    ],
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

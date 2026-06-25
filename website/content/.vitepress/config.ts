// import { defineConfig } from 'vitepress';
import { groupIconMdPlugin, groupIconVitePlugin } from 'vitepress-plugin-group-icons'
import AutoImport from 'unplugin-auto-import/vite'
import fs from 'fs';

// refer https://vitepress.vuejs.org/config/introduction for details
export default {
  title: 'TI Basic Powerpack',
  description: 'Create TI Basic 8XP programs with powerful new features — compiling and compressing them to provide new features, trim file size, and make coding a more enjoyable experience.',
  cleanUrls: true,

  head: [
    // Social meta tags for better sharing on social media platforms
    ['meta', { property: 'og:image', content: 'https://ti-powerpack.github.io/social.jpg' }],
    ['meta', { property: 'og:image:width', content: '1586' }],
    ['meta', { property: 'og:image:height', content: '784' }],
    ['meta', { property: 'og:site_name', content: 'TI Basic Powerpack' }],
    ['meta', { name: 'twitter:image', content: 'https://ti-powerpack.github.io/social.jpg' }],
  ],

  markdown: {
    typographer: true,	// enables curly quotes, ndashes, mdashes, (c) symbol
    config(md) {
      md.use(groupIconMdPlugin)
    },
    languages: [JSON.parse(fs.readFileSync('content/.vitepress/ti-basic.tmLanguage2.json', 'utf-8'))],
    defaultHighlightLang: '8xp',
    /* shikiSetup(shiki) {

    } */
    // theme: 'github-dark',
  },

  appearance: { initialValue: 'dark' },
  // lastUpdated: true,
  lang: 'en-AU', // Use AU date format
  themeConfig: {
    logo: '/favicon-96x96.png',

    // Last updated date in footer, formatted as "3 Jan 2026"
    lastUpdated: { formatOptions: {
        forceLocale: true, // Ensure the date format follows "lang" setting, above
        day: 'numeric',   // "3" (not "03")
        month: 'short',   // "Jan", "Feb", etc.
        year: 'numeric',  // "2026"
    }},

    nav: [
      { text: 'Download', link: '/download' },
      { text: 'Guide', link: '/what-is-powerpack' },
      { text: 'Github', link: 'https://github.com/ti-powerpack/ti-powerpack.github.io' },

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
      { text: 'Powerpack Outputs', link: '/outputs' },
      {
        text: 'Powerpack Features',
        items: [
          // { text: 'Example', link: '/example' },
          { text: 'Strip Comments & Whitespace', link: '/features/strip-comments' },
          { text: 'Auto-Run Your Programs', link: '/features/autorun' },
          { text: 'Aliases & Descriptive Names', link: '/features/aliases' },
          { text: 'Includes', link: '/features/includes' },
          { text: 'Compile Plain Text To 8xp', link: '/features/compile-to-8xp' },
          { text: 'Decompile 8XP To Plain Text', link: '/features/decompile-8xp' },
          { text: 'Optimization', link: '/features/ti-basic-optimization' },
          { text: 'Subroutines', link: '/features/subroutines' },
          { text: 'File Size Reports', link: '/features/file-size-reports' },
          { text: 'Creating a Backup Copy', link: '/features/theta-backup' },
          // ...
        ],
      },
      { items: [
        { text: 'Command Line Options', link: '/command-line-options' },
        { text: 'Keyboard Shortcuts', link: '/keyboard-shortcuts' },
      ]},
      { text: 'Bugs & Feature Requests', link: 'https://github.com/ti-powerpack/ti-powerpack.github.io/issues?q=is%3Aissue' },
      { text: 'Source Code On Github', link: 'https://github.com/ti-powerpack/ti-powerpack.github.io' },
    ],

    footer: {
      message: 'Released under the Apache 2.0 License. <br> Powerpack is not affiliated with Texas Instruments.', //<br> This software enhances the functionality of TI’s existing tools.',
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
      AutoImport({
        imports: [ 'vitepress' ],
          /* {
            'vitepress': ['useData', 'useRouter', 'useRoute']
          }
        ], */
        vueTemplate: true,
        include: [/\.vue$/, /\.vue\?vue/, /\.md$/], // Auto-import in Vue and Markdown files
      }),
      groupIconVitePlugin({
        customIcon: {
          '.8xp': {
            light: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-square-chart-gantt-icon lucide-square-chart-gantt"><rect width="18" height="18" x="3" y="3" rx="2"/><path d="M9 8h7"/><path d="M8 12h6"/><path d="M11 16h5"/></svg>',
            dark: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#ccc" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="lucide lucide-square-chart-gantt-icon lucide-square-chart-gantt"><rect width="18" height="18" x="3" y="3" rx="2"/><path d="M9 8h7"/><path d="M8 12h6"/><path d="M11 16h5"/></svg>'
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

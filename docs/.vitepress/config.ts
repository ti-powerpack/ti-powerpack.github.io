// import { defineConfig } from 'vitepress';

// refer https://vitepress.vuejs.org/config/introduction for details
export default {
  lang: 'en-US',
  title: '🚀 TI Basic Powerpack',
  description: 'Vite & Vue powered static site generator.',
  appearance: 'dark',
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
        text: 'Features',
        items: [
          // { text: 'Example', link: '/example' },
          { text: 'Test', link: '/features/test' },

          // ...
        ],
      },
    ],

    // footer: {
    //   message: 'Released under the MIT License.',
    //   copyright: 'Copyright © 2019-present Evan You',
    // },

    search: {
      provider: 'local',
    },
  },
};

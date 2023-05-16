import { defineConfig } from 'vitepress';

// refer https://vitepress.vuejs.org/config/introduction for details
export default defineConfig({
  lang: 'en-US',
  title: '💪 TI Basic Powerpack',
  description: 'Vite & Vue powered static site generator.',
  appearance: 'dark',
  themeConfig: {
    nav: [
      { text: 'Download', link: '###' },
      { text: 'Guide', link: '###' },
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
      {
        text: 'Guide',
        items: [
          { text: 'Example', link: '/example' },
          { text: 'Page 2', link: '/more/page-2' },

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
});

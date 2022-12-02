module.exports = {
  title: 'Prestashop Cloud Services',
  description: '',
  theme: '',
  head: [
    ['link', { rel: "apple-touch-icon", sizes: "180x180", href: "/assets/images/favicons/apple-touch-icon.png"}],
    ['link', { rel: "icon", type: "image/png", sizes: "32x32", href: "/assets/images/favicons/favicon-32x32.png"}],
    ['link', { rel: "icon", type: "image/png", sizes: "16x16", href: "/assets/images/favicons/favicon-16x16.png"}],
    ['link', { rel: "manifest", href: "/assets/images/favicons/site.webmanifest"}],
    ['link', { rel: "mask-icon", href: "/assets/images/favicons/safari-pinned-tab.svg", color: "#3a0839"}],
    ['link', { rel: "shortcut icon", href: "/assets/images/favicons/favicon.ico"}],
    ['meta', { name: "msapplication-TileColor", content: "#011638"}],
    ['meta', { name: "msapplication-config", content: "/assets/images/favicons/browserconfig.xml"}],
    ['meta', { name: "theme-color", content: "#011638"}],
  ],
  themeConfig: {
    displayAllHeaders: true,
    sidebarDepth: 2,
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Introduction', link: '/0-introduction/' },
      { text: 'Overview', link: '/0-overview/' },
      { text: 'Preparing your Environment', link: '/1-preparing-your-environment/' },
      { text: 'SaaS app', link: '/2-saas-app/' },
      { text: 'Webhook Events', link: '/3-webhook-events/' },
      { text: 'Relationships', link: '/4-relationships/' },
      { text: 'API', link: '/5-api/' },
      { text: 'FAQ', link: '/6-faq/' }
    ],
    sidebar: [
      [ '/' ,'Home' ],
      [ '/0-introduction/', 'Introduction' ],
      [ '/0-overview/', 'Overview' ],
      [ '/1-preparing-your-environment/', 'Preparing your Environment' ],
      [ '/2-saas-app/', 'SaaS app' ],
      [ '/3-webhook-events/', 'Webhook Events' ],
      [ '/4-relationships/', 'Relationships' ],
      [ '/5-api/', 'API' ],
      [ '/6-faq/', 'FAQ' ]
    ]
  }
}

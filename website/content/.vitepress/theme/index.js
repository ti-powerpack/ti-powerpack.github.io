// .vitepress/theme/index.js
import DefaultTheme from 'vitepress/theme';
import 'virtual:group-icons.css'
import './custom.scss';

export default {
	extends: DefaultTheme,
	enhanceApp({ app }) { // app is the Vue 3 app instance from createApp()

		// Global properties:
		// Accessible in all pages via {{ propertyName }}
		app.config.globalProperties.downloadUrl = 'https://github.com/ti-powerpack/ti-powerpack.github.io/releases/latest/download/Powerpack.exe';

	}
}

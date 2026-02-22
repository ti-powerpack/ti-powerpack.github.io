import AutoComponents from 'unplugin-vue-components/vite'

export default {
  plugins: [
	// your plugin installation
	AutoComponents({
      dirs: [
		'components', 
		'../node_modules/vitepress/dist/client/theme-default/components/'
	  ],   // src/components is the default
	  /*
	  resolvers: [
    	// example of importing Vant
	    (componentName) => {	
   		   // where `componentName` is always CapitalCase
    	  if (componentName.startsWith('Van'))
    	    return { name: componentName.slice(3), from: 'vant' }
    	},
  	  ],
	  */
  	  include: [/\.(vue|md)($|\?)/],
      dumpComponentsInfo: true, // only for debug
    }),
  ]
}
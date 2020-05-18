const { environment } = require('@rails/webpacker')

// Automatically load jQuery to Webpack
const webpack = require('webpack')
environment.plugins.prepend('Provide',
	new webpack.ProvidePlugin({
		$: 'jquery',
		jQuery: 'jquery'
	})
)

module.exports = environment

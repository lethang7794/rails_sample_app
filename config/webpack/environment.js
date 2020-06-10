const { environment } = require('@rails/webpacker')

// Automatically load jQuery to Webpack
const webpack = require('webpack')
environment.plugins.prepend('Provide',
	new webpack.ProvidePlugin({
		$: 'jquery/src/jquery',
		jQuery: 'jquery/src/jquery'
	})
)

module.exports = environment

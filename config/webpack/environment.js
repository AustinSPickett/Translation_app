const { environment } = require('@rails/webpacker')


//every thing below this was added  to include bootstrap
//https://gorails.com/forum/install-bootstrap-with-webpack-with-rails-6-beta
const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}))
//////till here

module.exports = environment
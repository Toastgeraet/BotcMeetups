const path = require('path')
const webpackConfig = require('@nextcloud/webpack-vue-config')

webpackConfig.entry = {
  main: path.join(__dirname, 'src', 'main.ts'),
}

module.exports = webpackConfig
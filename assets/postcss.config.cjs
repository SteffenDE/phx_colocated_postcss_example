const path = require('path')

module.exports = {
  plugins: [
    require('postcss-import')({path: process.env.NODE_PATH.split(path.delimiter)}),
    require('./css/postcss-scope.cjs')({}),
  ],
}
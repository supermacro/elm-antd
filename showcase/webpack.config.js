const webpack = require('webpack')
const path = require("path");
const HtmlWebpackPlugin = require('html-webpack-plugin');

const SOURCE_DIR = path.join(__dirname, 'src')

// Copy the specified environment variables into an object we can pass to
// webpack's DefinePlugin
const copyArgs = (args) =>
  args.reduce(
    (acc, key) => ({
      // Create an object with the specified key
      ...acc,
      [`process.env.${key}`]: JSON.stringify(process.env[key]),
    }),
    {}
  )


const IS_PROD = process.env.NODE_ENV === 'production'
const IS_DEVELOPMENT = !IS_PROD


const commonConfig = {
  mode: IS_PROD
    ? 'production'
    : 'development',
  
  entry: {
    app: './src/index.js',
    sw: './src/sw.js'
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
    publicPath: '/',
  },

  module: {
    rules: [
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack-loader',
        options: {
          cache: false,
          // turns on the time-travelling debugger
          // this is a flag that is passed to elm make
          debug: IS_DEVELOPMENT,
          optimize: IS_PROD,
        }
      },
    ],
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: path.join(SOURCE_DIR, 'index.html'),
      minify: {
        collapseWhitespace: true,
        removeComments: true
      }
      // favicon: path.resolve('./static/favicon.png')
    }),
    new webpack.DefinePlugin({
      ...copyArgs([
        'NODE_ENV',
        'API',
        'APP_MODE',
        'FILE_SERVER_URL',
        'COMMIT_REF',
      ]),
    })
  ],
}

const developmentConfig = {
  devServer: {
    inline: true,
    stats: { colors: true },
    historyApiFallback: true
  },
}
  
  
module.exports = IS_DEVELOPMENT
  ? { ...commonConfig, ...developmentConfig }
  : commonConfig;

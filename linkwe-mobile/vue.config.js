const path = require('path')

const resolve = (dir) => {
  return path.join(__dirname, dir)
}

//读取npm指令 process.argv 获取⾃定义参数
let argvs = process.argv.filter((e) => e.includes('='))
for (const iterator of argvs) {
  let diyArg = iterator.split('=')
  process.env['VUE_APP_' + diyArg[0].slice(2)] = diyArg[1]
}
process.env.VUE_APP_ENV = process.env.VUE_APP_ENV || process.env.NODE_ENV
const env = require('./env')

process.env.VUE_APP_TITLE = require('./package.json').description

// 项目部署基础
// 默认情况下，我们假设你的应用将被部署在域的根目录下,
// 例如：https://www.my-app.com/
// 默认：'/'
// 如果您的应用程序部署在子路径中，则需要在这指定子路径
// 例如：https://www.my-app.com/my-app/
// 需要将它改为'/my-app/'

module.exports = {
  publicPath: env.BASE_URL || '/',
  outputDir: 'h5', // 打包名称
  // 打包时不生成.map文件
  productionSourceMap: false,
  // 如果你不需要使用eslint，把lintOnSave设为false即可
  lintOnSave: false,
  // 这里写你调用接口的基础路径，来解决跨域，如果设置了代理，那你本地开发环境的axios的baseUrl要写为 '' ，即空字符串
  devServer: {
    host: '0.0.0.0',
    port: 8082,
    // 自动打开浏览器
    open: true,
    proxy: {
      // detail: https://cli.vuejs.org/config/#devserver-proxy
      ['/api']: {
        target: env.BASE_API,
        changeOrigin: true,
        pathRewrite: {
          ['^/api']: '',
        },
      },
    },
    disableHostCheck: true,
  },
  pluginOptions: {
    'style-resources-loader': {
      preProcessor: 'less',
      patterns: [path.resolve(__dirname, './src/styles/varibles.less')],
    },
  },
  css: {
    loaderOptions: {
      less: {
        modifyVars: {
          // 直接覆盖变量
          // 或者可以通过 less 文件覆盖（文件路径为绝对路径）
          hack: `true; @import "${path.resolve(__dirname, './src/styles/varibles.less')}";`,
        },
      },
    },
  },

  configureWebpack: {
    resolve: {
      alias: {
        '@': resolve('src'),
      },
    },
  },
  chainWebpack(config) {
    // set svg-sprite-loader
    config.module
      .rule('svg')
      .exclude.add(resolve('src/assets/icons'))
      .end()
    config.module
      .rule('icons')
      .test(/\.svg$/)
      .include.add(resolve('src/assets/icons'))
      .end()
      .use('svg-sprite-loader')
      .loader('svg-sprite-loader')
      .options({
        symbolId: 'icon-[name]',
      })
      .end()
    config.plugin('preload').tap(() => [
      {
        rel: 'preload',
        // to ignore runtime.js
        fileBlacklist: [/\.map$/, /hot-update\.js$/, /runtime\..*\.js$/],
        include: 'initial',
      },
    ])

    config.when(process.env.NODE_ENV !== 'development', (config) => {
      config
        .plugin('ScriptExtHtmlWebpackPlugin')
        .after('html')
        .use('script-ext-html-webpack-plugin', [
          {
            // `runtime` must same as runtimeChunk name. default is `runtime`
            inline: /runtime\..*\.js$/,
          },
        ])
        .end()

      config.optimization.minimizer('terser').tap((options) => {
        options[0].terserOptions.compress.drop_console = true
        options[0].terserOptions.compress.drop_debugger = true
        return options
      })

      config.optimization.splitChunks({
        chunks: 'all',
        cacheGroups: {
          libs: {
            name: 'chunk-libs',
            test: /[\\/]node_modules[\\/]/,
            priority: 10,
            chunks: 'initial', // only package third parties that are initially dependent
          },
          elementUI: {
            name: 'chunk-vant', // split vant into a single package
            priority: 20, // the weight needs to be larger than libs and app or it will be packaged into libs or app
            test: /[\\/]node_modules[\\/]_?vant(.*)/, // in order to adapt to cnpm
          },
          commons: {
            name: 'chunk-commons',
            test: resolve('src/components'), // can customize your rules
            minChunks: 3, //  minimum common number
            priority: 5,
            reuseExistingChunk: true,
          },
        },
      })

      config.optimization.runtimeChunk('single')
    })
  },
}

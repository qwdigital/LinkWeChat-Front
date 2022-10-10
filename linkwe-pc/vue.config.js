'use strict'
const path = require('path')

function resolve(dir) {
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

process.env.VUE_APP_TITLE = env.SYSTEM_NAME_ALL
process.env.VUE_APP_PACKETTIME = new Date().toLocaleString()

// vue.config.js 配置说明
//官方vue.config.js 参考文档 https://cli.vuejs.org/zh/config/#css-loaderoptions
// 这里只列一部分，具体配置参考文档
module.exports = {
  // 部署生产环境和开发环境下的URL。
  // 默认情况下，Vue CLI 会假设你的应用是被部署在一个域名的根路径上
  // 例如 https://www.xx.cn/。如果应用被部署在一个子路径上，你就需要用这个选项指定这个子路径。例如，如果你的应用被部署在 https://www.xx.cn/admin/，则设置 baseUrl 为 /admin/。
  publicPath: env.BASE_URL || '/',
  // 在npm run build 或 yarn build 时 ，生成文件的目录名称（要和baseUrl的生产环境路径一致）（默认dist）
  outputDir: 'pc',
  // 用于放置生成的静态资源 (js、css、img、fonts) 的；（项目打包之后，静态资源会放在这个文件夹下）
  // assetsDir: 'static',
  // 是否开启eslint保存检测，有效值：ture | false | 'error'
  lintOnSave: process.env.NODE_ENV === 'development',
  // 如果你不需要生产环境的 source map，可以将其设置为 false 以加速生产环境构建。
  productionSourceMap: false,
  // webpack-dev-server 相关配置
  devServer: {
    host: '0.0.0.0',
    port: '80',
    // 自动打开浏览器
    open: true,
    proxy: {
      // detail: https://cli.vuejs.org/config/#devserver-proxy
      ['/api']: {
        target: env.DOMAIN,
        changeOrigin: true,
        pathRewrite: {
          ['^/api']: '',
        },
      },
    },
    disableHostCheck: true,
    // https: true,
  },
  css: {
    loaderOptions: {
      sass: {
        //依次导入的公用的scss变量，公用的scss混入，共用的默认样式
        prependData: `@import "./src/styles/variables.scss";`,
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
    // 修复HMR
    config.resolve.symlinks(true)
    // set svg-sprite-loader
    config.module.rule('svg').exclude.add(resolve('src/assets/icons')).end()
    config.module
      .rule('icons')
      .test(/\.svg$/)
      .include.add(resolve('src/assets/icons/svg'))
      .end()
      .use('svg-sprite-loader')
      .loader('svg-sprite-loader')
      .options({
        // icon symbolId, 文件目录结构  => 命名： svg本级下的svg直接使用文件名，eg： icon-文件名；svg子目录下的svg使用需要带上该子目录文件夹名 eg：icon-文件夹名-文件名
        // # src/icons/svg
        // - icon1.svg        => icon-icon1
        // - icon2.svg        => icon-icon2
        // - dir/icon1.svg    => icon-dir-icon1
        symbolId: (filePath) => {
          let split = filePath.includes('/') ? '/icons/svg' : '\\icons\\svg'
          let str = filePath.slice(filePath.lastIndexOf(split) + split.length, -4) // eg: '/ase/as
          return 'icon' + str.replace(/[\/\\]/g, '-') // icon-aa-ss
        },
        // symbolId: 'icon-[name]',
      })
      .end()

    config.when(process.env.NODE_ENV !== 'development', (config) => {
      // cdn
      if (env._ISCDN) {
        config.externals = {
          vue: 'vue',
          'element-ui': 'element-ui',
          'vue-router': 'vue-router',
          vuex: 'vuex',
          axios: 'axios',
        }
        const cdn = {
          // 访问https://unpkg.com/element-ui/lib/theme-chalk/index.css获取最新版本
          css: [
            '//cdn.bootcdn.net/ajax/libs/element-ui/2.15.7/theme-chalk/index.min.css',
            // '//unpkg.com/element-ui@2.15.7/lib/theme-chalk/index.css'
          ],
          js: [
            '//cdn.bootcdn.net/ajax/libs/vue/2.6.10/vue.runtime.min.js',
            '//cdn.bootcdn.net/ajax/libs/vue-router/3.5.3/vue-router.min.js',
            '//cdn.bootcdn.net/ajax/libs/vuex/3.1.0/vuex.min.js',
            '//cdn.bootcdn.net/ajax/libs/axios/0.26.0/axios.min.js',
            '//cdn.bootcdn.net/ajax/libs/element-ui/2.15.7/index.min.js',
            // '//unpkg.com/vue@2.6.10/dist/vue.runtime.min.js', // 访问https://unpkg.com/vue/dist/vue.min.js获取最新版本
            // '//unpkg.com/vue-router@3.5.3/dist/vue-router.min.js',
            // '//unpkg.com/vuex@3.1.0/dist/vuex.min.js',
            // '//unpkg.com/axios@0.26.0/dist/axios.min.js',
            // '//unpkg.com/element-ui@2.15.7/lib/index.js',
          ],
        }
        // 如果使用多页面打包，使用vue inspect --plugins查看html是否在结果数组中
        config.plugin('html').tap((args) => {
          // html中添加cdn
          args[0].cdn = cdn
          return args
        })
      }

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
        options[0].terserOptions.compress.drop_console = false
        options[0].terserOptions.compress.drop_debugger = false
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
            name: 'chunk-elementUI', // split elementUI into a single package
            priority: 20, // the weight needs to be larger than libs and app or it will be packaged into libs or app
            test: /[\\/]node_modules[\\/]_?element-ui(.*)/, // in order to adapt to cnpm
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

      config.plugin('preload').tap(() => [
        {
          rel: 'preload',
          // to ignore runtime.js
          fileBlacklist: [/\.map$/, /hot-update\.js$/, /runtime\..*\.js$/],
          include: 'initial',
        },
      ])

      // when there are many pages, it will cause too many meaningless requests
      config.plugins.delete('prefetch')

      env._ISGZIP &&
        config.plugin('compression').use('compression-webpack-plugin', [
          {
            filename: '[path].gz[query]',
            algorithm: 'gzip',
            test: /\.(js|css|json|txt|html|ico|svg)(\?.*)?$/i,
            threshold: 10240,
            minRatio: 0.8,
          },
        ])

      process.env.npm_config_report &&
        config
          .plugin('webpack-bundle-analyzer')
          .use(require('webpack-bundle-analyzer').BundleAnalyzerPlugin, [
            {
              analyzerMode: 'static',
            },
          ])
          .end()
    })
  },
}

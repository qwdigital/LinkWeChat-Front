import { fileURLToPath, URL } from 'node:url'
import { userInfo } from 'node:os'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'
import { createSvgIconsPlugin } from 'vite-plugin-svg-icons'
import vueJsx from '@vitejs/plugin-vue-jsx'

import AutoImport from 'unplugin-auto-import/vite' // 自动导入ref等api
// import Components from 'unplugin-vue-components/vite'
// import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

import rollupPluginVisualizer from 'rollup-plugin-visualizer'
import vitePluginCompression from 'vite-plugin-compression'
import vitePluginCdnImport, { autoComplete } from 'vite-plugin-cdn-import'
import { ViteImageOptimizer } from 'vite-plugin-image-optimizer'

// https://vitejs.dev/config/
export default defineConfig(async ({ command, mode }) => {
  // 根据当前工作目录中的 `mode` 加载 .env 文件
  // 设置第三个参数为 '' 来加载所有环境变量，而不管是否有 `VITE_` 前缀。
  // const env = loadEnv(mode, process.cwd(), '')
  // const { ENV, VITE_BASE, VITE_BASE_API } = env

  process.env.VUE_APP_ENV = mode
  let { env } = await import('./env.js')
  // let env = envs[mode]
  // console.log(1, import.meta.env) // undefined
  // console.log(0, env)
  // process.env.VITE_APP_TITLE = env.SYSTEM_NAME_ALL

  return {
    define: {
      'process.env.VUE_APP_ENV': JSON.stringify(mode),
      __PACK_DATETIME__: JSON.stringify(new Date().toLocaleString()),
      __PACK_USER__: JSON.stringify(userInfo().username),
      // __BASE_API__: JSON.stringify(env.BASE_API),
    },
    // 部署生产环境和开发环境下的URL。
    // 默认情况下，vite 会假设你的应用是被部署在一个域名的根路径上
    // 例如 https://www.admin.vip/。如果应用被部署在一个子路径上，你就需要用这个选项指定这个子路径。例如，如果你的应用被部署在 https://www.admin.vip/admin/，则设置 baseUrl 为 /admin/。
    // base: ENV === 'production' ? '/' : '/',
    base: env.BASE_URL || '/',

    resolve: {
      // https://cn.vitejs.dev/config/#resolve-alias
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url)),
        '/@': fileURLToPath(new URL('./src', import.meta.url)),
        '~': fileURLToPath(new URL('./src/components', import.meta.url)),
        // vue: '@vue/compat',
      },
      // https://cn.vitejs.dev/config/#resolve-extensions
      extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue'],
    },
    // vite 相关配置
    server: {
      port: { development: 1024, test: 1025 }[mode],
      host: true,
      open: true,
      proxy: {
        // https://cn.vitejs.dev/config/#server-proxy
        '/api': {
          target: env.BASE_API,
          changeOrigin: true,
          rewrite: (p) => p.replace(/^\/api/, ''),
        },
      },
    },
    // esbuild: {
    //   jsxFactory: 'h',
    //   jsxFragment: 'Fragment',
    //   include: 'render.js',
    //   exclude: '**/**.vue',
    // },
    build: {
      // outDir: 'pc',
      minify: 'terser',
      reportCompressedSize: false, // 启用/禁用 gzip 压缩大小报告
      // modulePreload: false, // { polyfill: false }
      // modulePreload: { polyfill: false },
      terserOptions: {
        compress: {
          //生产环境时移除console
          drop_console: mode == 'production',
          drop_debugger: mode == 'production',
        },
      },
      rollupOptions: {
        output: {
          assetFileNames: 'assets/[ext]/[name]-[hash][extname]',
          chunkFileNames: 'assets/js/[name]-[hash].js',
          manualChunks: (id) => {
            // 可以在这里打印看一下id的值，这里将node_modules中的包打包为 chunk-libs 文件
            // console.log(id)
            // if (
            //   id.includes('node_modules') &&
            //   (id.includes('@vue/dist/vue') || id.includes('pinia') || id.includes('vue-router'))
            // ) {
            //   return 'vue-modules'
            // } else
            if (id.includes('assets/icons/svg')) {
              return 'icons-svg'
            }
            // if (id.includes('benz-amr-recorder')) {
            //   return 'benz-amr-recorder'
            // } else if (id.includes('cos-js-sdk-v5')) {
            //   return 'cos-js-sdk-v5'
            // } else if (id.includes('aliyun-oss-sdk')) {
            //   return 'aliyun-oss-sdk'
            // } else if (id.includes('fabric')) {
            //   return 'fabric'
            // } else if (id.includes('echarts')) {
            //   return 'echarts'
            // } else if (id.includes('element-plus')) {
            //   return 'element-plus'
            // } else
            else if (['quill-image-resize-module', 'Quill'].some((e) => id.includes(e))) {
              return 'quill-image-resize-module'
            } else if (id.includes('node_modules')) {
              return id.split('node_modules/')[1].split('/')[0]
            }
            // else if (id.includes('src/components')) {
            //   return 'chunk-components'
            // }
            // else if (id.includes('views/')) {
            //   let first = id.split('views/')[1]
            //   if (first.includes('/')) {
            //     return first.match(/(\w+)\/(\w+)/)[0].replace('/', '-') // a/b/c...  a-b
            //   }
            //   return first.split('.')[0] //  a.vue  a
            // }
          },
        },
      },
    },
    plugins: [
      // '@vue/babel-plugin-jsx',
      vue({
        // template: {
        //   compilerOptions: {
        //     compatConfig: {
        //       MODE: 2,
        //     },
        //   },
        // },
        // reactivityTransform: true,
      }),
      createSvgIconsPlugin({
        iconDirs: [path.resolve(process.cwd(), 'src/assets/icons/svg')],
        symbolId: 'icon-[dir]-[name]',
      }),
      ViteImageOptimizer({
        png: {
          // https://sharp.pixelplumbing.com/api-output#png
          quality: 100,
        },
        jpeg: {
          quality: 100,
        },
        jpg: {
          quality: 100,
        },
      }),
      AutoImport({
        imports: [
          'vue',
          'vue-router',
          // {
          //   vuex: ['useStore'],
          // },
        ],
        // // 可以选择auto-import.d.ts生成的位置
        // dts: 'src/auto-import.d.ts',
        // resolvers: [ElementPlusResolver()],
      }),
      // Components({
      //   resolvers: [ElementPlusResolver()],
      // }),
      vueJsx({
        // include: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.vue'],
      }),
      vitePluginCompression({
        disable: !env._ISGZIP, // 是否禁用压缩，默认为 false
        threshold: 10000, // 启用压缩的文件大小限制，单位是字节，默认为 0, 对大于 10kb 的文件进行压缩
        // filter：过滤器，对哪些类型的文件进行压缩，默认为 ‘/.(js|mjs|json|css|html)$/i’
        // verbose: true：是否在控制台输出压缩结果，默认为 true
        // deleteOriginFile：压缩后是否删除原文件，默认为 false
        // algorithm：采用的压缩算法，默认是 gzip
        // ext：生成的压缩包后缀
      }),
      env._ISCDN &&
        vitePluginCdnImport({
          // prodUrl: 'https://unpkg.com/{name}@{version}/{path}',
          prodUrl: 'https://cdn.bootcdn.net/ajax/libs/{name}/{version}/{path}',
          modules: [
            // autoComplete('vue'),
            // autoComplete('axios'),

            {
              name: 'axios', // 包名
              var: 'axios', // 对应cdn包导出的变量，如jQuery导出的是$
              version: '1.4.0',
              path: 'axios.min.js',
            },
            {
              name: 'clipboard',
              var: 'ClipboardJS',
              version: '2.0.11',
              path: 'https://cdn.bootcdn.net/ajax/libs/clipboard.js/2.0.11/clipboard.min.js',
            },
            {
              name: 'jsencrypt',
              var: 'JSEncrypt',
              version: '3.3.2',
              path: 'jsencrypt.min.js',
            },
            {
              name: 'crypto-js',
              var: 'CryptoJS',
              version: '4.1.1',
              path: 'crypto-js.min.js',
            },
            {
              name: 'nprogress',
              var: 'NProgress',
              version: '0.2.0',
              path: 'nprogress.min.js',
              css: 'nprogress.min.css',
            },
            // {
            //   name: 'element-plus',
            //   var: 'ElementPlus',
            //   version: '2.3.6',
            //   path: 'dist/index.full.js',
            //   css: 'dist/index.css',
            // },
            // {
            //   name: '@element-plus/icons-vue',
            //   var: 'ElementPlusIconsVue',
            //   version: '2.1.0',
            //   path: 'dist/index.iife.min.js',
            // },
            {
              name: 'ali-oss',
              var: 'OSS',
              path: 'https://gosspublic.alicdn.com/aliyun-oss-sdk-6.17.1.min.js',
            },
            {
              name: 'echarts',
              var: 'echarts',
              version: '5.4.2',
              path: 'echarts.min.js',
            },
          ],
        }),
      process.env.npm_config_report &&
        rollupPluginVisualizer({
          emitFile: false, //使用 emitFile 生成文件。 属性为 true，打包后的分析文件会出现在打包好的文件包下；设置为 false ，则会出现在项目根目录下
          filename: 'report.html', //生成分析网页文件名
          open: false, //在默认用户代理中打开生成的文件
          gzipSize: true, //从源代码中收集 gzip 大小并将其显示在图表中
          // brotliSize: true, //从源代码中收集 brotli 大小并将其显示在图表中
        }),
    ],
    // optimizedeps: {
    //   esbuildoptions: {
    //     target: 'es2020',
    //   },
    // },
    // css: {
    //   preprocessorOptions: {
    //     scss: {
    //       additionalData: `@use "@/styles/element-var.scss" as *;`,
    //     },
    //   },
    // },
  }
})

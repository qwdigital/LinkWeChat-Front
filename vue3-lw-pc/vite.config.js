import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'
import { createSvgIconsPlugin } from 'vite-plugin-svg-icons'
import vueJsx from '@vitejs/plugin-vue-jsx'

import AutoImport from 'unplugin-auto-import/vite' // 自动导入ref等api
// import Components from 'unplugin-vue-components/vite'
// import { ElementPlusResolver } from 'unplugin-vue-components/resolvers'

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
  process.env.VITE_APP_TITLE = env.SYSTEM_NAME_ALL

  return {
    define: {
      'process.env.VUE_APP_ENV': JSON.stringify(mode),
      __PACK_DATETIME__: JSON.stringify(new Date().toLocaleString()),
      // __BASE_API__: JSON.stringify(env.BASE_API),
    },
    // 部署生产环境和开发环境下的URL。
    // 默认情况下，vite 会假设你的应用是被部署在一个域名的根路径上
    // 例如 https://www.admin.vip/。如果应用被部署在一个子路径上，你就需要用这个选项指定这个子路径。例如，如果你的应用被部署在 https://www.admin.vip/admin/，则设置 baseUrl 为 /admin/。
    // base: ENV === 'production' ? '/' : '/',
    base: env.BASE_URL || '/',
    // base:'/xdy/',
    build: {
      outDir: 'pc',
      minify: 'terser',
      terserOptions: {
        compress: {
          //生产环境时移除console
          drop_console: true,
          drop_debugger: true,
        },
      },
    },
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
      port: 1024,
      host: true,
      open: true,
      proxy: {
        // https://cn.vitejs.dev/config/#server-proxy
        '/api': {
          target: env.DOMAIN,
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

# 平台简介

本仓库为 LinkWeChat 的前端源码库，技术栈采用 [vue3](https://cn.vuejs.org/) [vite](https://cn.vitejs.dev/) [pinia](https://pinia.vuejs.org/zh/) [element-plus](https://element-plus.gitee.io/zh-CN/)

vue2 技术栈版本（处于维护状态）可切换至 master 分支查看，具体说明参见[更新日志](./RELEASES.md)中 v5.0.0 版本说明

具体项目说明及后端库请移步至 [LinkWeChat](https://gitee.com/LinkWeChat/link-wechat) 查看。

# 在线体验

开源演示地址：[http://demo.linkwechat.net/](http://demo.linkwechat.net/)

默认账号密码：lw，123456

目前支持两种方式体验：

1. 在首页扫码二维码申请加入测试企业，申请通过后即可扫码登录，体验系统的完整功能；
2. 点击账密登录并勾选演示账号登录即可在线体验后台系统，但不支持体验移动端相关功能；

**注意：演示环境已屏蔽管理权限和相关操作**

前端结构

```
├── vue3-lw-pc			// 后台管理端项目
    ├── public                     # 静态资源
    │   │── static                 # 用于绝对路径的非打包资源，公用基础css等
    │   │── favicon.ico            # favicon图标
    ├── src                        # 源代码
    │   ├── api                    # 所有后端接口请求
    │   ├── assets                 # 主题 字体 svg icons 等静态资源
    │   ├── components             # 全局公用组件
    │   ├── directive              # 全局指令
    │   ├── layout                 # 全局基础布局结构组件
    │   ├── router                 # 路由 权限管理等
    │   ├── stores                 # 全局 pinia store管理
    │   ├── styles                 # 全局样式
    │   ├── utils                  # 全局公用方法
    │   ├── views                  # 业务功能所有页面
    │   ├── App.vue                # 入口页面
    │   ├── config.js              # 全局配置文件
    │   ├── main.js                # 入口文件 加载组件 初始化等
    ├── babel.config.js            # babel-loader 配置
    ├── .env.js                    # 环境变量配置
    ├── index.html                 # html模板
    ├── jsconfig.json              # jsconfig 配置 快捷路径等
    ├── package.json               # package.json
    ├── vite.config.js             # vite 配置
├── linkwe-mobile		// 移动端项目包含移动工作台、任务宝、群裂变等H5
├── linkwe-uniapp		// uniapp短链小程序项目
```

# 安装与运行

**关于 Node，推荐 16.x 版本**

这里以 vue3-lw-pc 管理端项目运行示例

linkwe-mobile 项目与 vue3-lw-pc 架构基本雷同

linkwe-uniapp 只有一个活码识别页面，属于基础的 uniapp 项目

故，不做赘述

```sh
# 克隆项目
git clone https://gitee.com/LinkWeChat/link-we-chat-front.git

# 进入项目目录
cd LinkWeChat-Front/vue3-lw-pc

# 安装依赖
npm i --registry=https://registry.npmmirror.com

# 启动开发服务 npm run dev
# 启动测试服务 npm run test (后端接口为测试环境接口)

# 构建测试环境 npm run build:test
# 构建生产环境 npm run build
# 前端访问地址 http://localhost:1024
```

## [更新日志](./RELEASES.md)

![输入图片说明](https://gitee.com/LinkWeChat/link-wechat/raw/master/readme-pic/logo.png)

<div align="center">

[![star](https://gitee.com/LinkWeChat/link-wechat/badge/star.svg?theme=gvp)](https://gitee.com/LinkWeChat/link-wechat/stargazers)
[![fork](https://gitee.com/LinkWeChat/link-wechat/badge/fork.svg?theme=gvp)](https://gitee.com/LinkWeChat/link-wechat/members)
[![LinkWeChat](https://img.shields.io/badge/LinkWeChat-V5.0.2-brightgreen)](https://www.yuque.com/linkwechat/help/ci1n9p)
[![license](http://img.shields.io/badge/license-GPL%203.0-orange)](https://gitee.com/LinkWeChat/link-wechat/blob/master/LICENSE)
[![木兰社区](https://img.shields.io/badge/Mulan-incubating-blue)](https://portal.mulanos.cn//)

[项目手册](https://www.yuque.com/linkwechat/help) | [用户手册](https://docs.qq.com/pdf/DZUpLbEVZR3RLdmxO?) | [常见问题](https://www.yuque.com/linkwechat/help/qk5gl6) | [V5.x 功能清单](https://docs.qq.com/sheet/DZWNxelVoT2VSU1V6?tab=BB08J3)

</div>

---

**<p align="center">【📣 最近通知】还有什么想要产品/技术上友好的建议或意见，<a href="https://docs.qq.com/sheet/DZWxGU0JGVFRVdWZV" target="_blank">点击告诉我们~</a>一经采纳，将纳入开源贡献者并官网致谢，还会收到社区奖励的小礼品哦！~</p>**

**<p align="center">LinkWeChat V5.0 正式发布啦，即将全面接入 AI 大模型，更多能力逐步升级，欢迎大家提前体验！<a href="https://demo.linkwechat.net/" target="_blank">点击立即体验~</a></p>**

**<p align="center">LinkWeChat 采用前后端分离架构，具体项目说明及后端库请移步至 [LinkWeChat](https://gitee.com/LinkWeChat/link-wechat) 查看</p>**

**<p align="center">如果您觉得我们的开源项目很有帮助，请点击 :star: Star 支持 LinkWeChat 开源团队:heart:，您的支持，是我们最好的动力~</p>**

---

# 平台简介

本仓库为 [LinkWeChat](https://gitee.com/LinkWeChat/link-wechat) 的前端源码库，技术栈采用 [[vue3](https://cn.vuejs.org/) [vite](https://cn.vitejs.dev/) [pinia](https://pinia.vuejs.org/zh/) [element-plus](https://element-plus.gitee.io/zh-CN/)]，[前端技术手册](document/doc.md)。

vue2 技术栈版本（停止维护）可切换至 master-vue2 分支查看，具体说明参见[更新日志](./RELEASES.md)中 v5.0.0 版本说明

# 在线体验

开源演示地址：[https://demo.linkwechat.net/](https://demo.linkwechat.net/)

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
├── vue3-lw-mobile		// 移动端vue3项目，包含客服升级，AI助手等2024.01.01之后的移动端新功能
├── linkwe-mobile		// 移动端vue2项目，包含移动工作台、任务宝、群裂变等2024.01.01之前的功能
├── linkwe-uniapp		// uniapp短链小程序项目
```

# 安装与运行

**关于 Node，推荐 16.x 及以上版本**

这里以 vue3-lw-pc 管理端项目运行示例

linkwe-mobile、vue3-lw-mobile 项目与 vue3-lw-pc 架构基本雷同

linkwe-uniapp 只有一个活码识别页面，属于基础的 uniapp 项目

故，不做赘述

```sh
# 克隆项目
git clone https://gitee.com/LinkWeChat/link-we-chat-front.git

# 进入项目目录
cd link-we-chat-front/vue3-lw-pc

# 安装依赖（下面几种方式在不同的机器上，成功率不同，自行尝试）

# 方式一： npm 指定淘宝镜像
npm i --registry=https://registry.npmmirror.com

# 方式二： 使用 cnpm 安装
npm install -g cnpm --registry=https://registry.npmmirror.com
cnpm i

# 方式三： npm i 原始安装 国内推荐上述两种方式 DDDD(懂的都懂)
npm i

# 启动开发服务 npm run dev
# 启动测试服务 npm run test (后端接口为测试环境接口)

# 构建测试环境 npm run build:test
# 构建生产环境 npm run build
# 前端访问地址 http://localhost:1024
```

## [更新日志](./RELEASES.md)

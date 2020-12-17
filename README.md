<p></p>
<p></p>

<p align="center">
  <img alt="logo" src="https://images.gitee.com/uploads/images/2020/1203/143430_03205b51_1480777.png" width="120" style="margin-bottom: 0px;">
</p>
<h2 align="center">LinkWeChat —— 让每个企业都是私域流量营销专家</h2>

<div align="center">

![GVP Stars](http://img.shields.io/badge/GPV%20Stars-400+-yellow)
![GVP Forks](http://img.shields.io/badge/GPV%20Forks-150+-yellow)
![license](http://img.shields.io/badge/license-GPL%203.0-green)

</div>

<p></p>
<p></p>
<p></p>
<p></p>

### 平台简介

LinkWeChat，是一款基于企业微信的开源 SCRM 系统，为企业构建私域流量系统的综合解决方案，能显著提升企业社交运营效率。

![输入图片说明](https://images.gitee.com/uploads/images/2020/1130/232011_57bea01c_1480777.png "1.png")

#### 应用场景

泛零售、电商行业企业微信用户，提供多种工具、多渠道、多方式添加客户到企业微信好友，通过营销互动与客户标签管理等建立强连接。

#### 功能特性

![输入图片说明](https://images.gitee.com/uploads/images/2020/1130/232033_41bc0f37_1480777.png "2.png")

### 环境部署

#### 准备工作


```java
JDK >= 1.8 (推荐1.8版本)
Mysql >= 5.5.0 (推荐5.7版本)
Redis >= 3.0
Maven >= 3.0
Node >= 10
```

#### 运行系统

##### 后端运行


- 导入 `IDEA` 中 
- 创建数据库 `LW-vue` 并导入数据脚本
- 打开运行 `com.linkwechat.LinkWeChatApplication.java`

##### 前端运行


```bash
# 进入项目目录
cd linkwe-ui

# 安装依赖
npm install

# 强烈建议不要用直接使用 cnpm 安装，会有各种诡异的 bug，可以通过重新指定 registry 来解决 npm 安装速度慢的问题。
npm install --registry=https://registry.npm.taobao.org

# 本地开发 启动项目
npm  run serve
```

打开浏览器，输入 `http://localhost:80  `，默认账密为：`admin/123admin123` 。

若能正确展示登录页面，并能成功登录，菜单及页面展示正常，则表明环境搭建成功。

##### 必要配置

1、修改数据库连接

- 编辑 `resources` 目录下的 `application-druid.yml`
- `url` : 服务器地址
- `username` : 账号
- `password `: 密码


2、开发环境配置

- 编辑 `resources` 目录下的 `application.yml`
- `port` : 端口
- `context-path` : 部署路径

#### 部署系统

##### 后端部署


- `bin/package.bat` 在项目的目录下执行
- 然后会在项目下生成 ` target` 文件夹包含 `war`  或 `jar `（多模块生成在 `linkwe-admin`）
- `jar` 部署方式：使用命令行执行 `java –jar LinkWeChat.jar`
- `war` 部署方式：`pom.xml packaging` 修改为 `war`  放入 `tomcat` 服务器 `webapps`

##### 前端部署

当项目开发完毕，只需要运行一行命令就可以打包你的应用

```bash
# 打包正式环境
npm run build:prod

# 打包预发布环境
npm run build:stage
```

构建打包成功之后，会在根目录生成 `dist` 文件夹，里面就是构建打包好的文件，通常是 `.js` 、`.css`、`index.html` 等静态文件。

通常情况下 `dist` 文件夹的静态文件发布到你的 `nginx` 或者静态服务器即可，其中的 `index.html` 是后台服务的入口页面。

### 项目介绍

#### 文件结构

##### 后端结构

```
com.linkwechat     
├── common            // 工具类
│       └── annotation                    // 自定义注解
│       └── config                        // 全局配置
│       └── constant                      // 通用常量
│       └── core                          // 核心控制
│       └── enums                         // 通用枚举
│       └── exception                     // 通用异常
│       └── filter                        // 过滤器处理
│       └── utils                         // 通用类处理
├── framework         // 框架核心
│       └── aspectj                       // 注解实现
│       └── config                        // 系统配置
│       └── datasource                    // 数据权限
│       └── interceptor                   // 拦截器
│       └── manager                       // 异步处理
│       └── security                      // 权限控制
│       └── web                           // 前端控制
├── linkwe-generator   // 代码生成
├── linkwe-quartz      // 定时任务
├── linkwe-system      // 系统代码
├── linkwe-admin       // 后台服务
├── linkwe-ui          // 页面前端代码
├── linkwe--wecom      // 企业微信功能

```

##### 前端结构


```
├── build                      // 构建相关  
├── bin                        // 执行脚本
├── public                     // 公共文件
│   ├── favicon.ico            // favicon图标
│   └── index.html             // html模板
├── src                        // 源代码
│   ├── api                    // 所有请求
│   ├── assets                 // 主题 字体等静态资源
│   ├── components             // 全局公用组件
│   ├── directive              // 全局指令
│   ├── layout                 // 布局
│   ├── router                 // 路由
│   ├── store                  // 全局 store管理
│   ├── utils                  // 全局公用方法
│   ├── views                  // view
│   ├── App.vue                // 入口页面
│   ├── main.js                // 入口 加载组件 初始化等
│   ├── permission.js          // 权限管理
│   └── settings.js            // 系统配置
├── .editorconfig              // 编码格式
├── .env.development           // 开发环境配置
├── .env.production            // 生产环境配置
├── .env.staging               // 测试环境配置
├── .eslintignore              // 忽略语法检查
├── .eslintrc.js               // eslint 配置项
├── .gitignore                 // git 忽略项
├── babel.config.js            // babel.config.js
├── package.json               // package.json
└── vue.config.js              // vue.config.js
```


#### 核心技术

- 前端技术栈 `ES6`、`vue`、`vuex`、`vue-router`、`vue-cli`、`axios`、`element-ui`

- 后端技术栈 `SpringBoot`、`MyBatis-plus`、`Spring Security`、`Jwt`

#### 业务架构

![输入图片说明](https://images.gitee.com/uploads/images/2020/1130/232051_b320bf37_1480777.png "3.png")

#### 在线体验

演示地址：http://106.13.201.219/   

演示账号/密码：test/123456

#### 开发进度

![输入图片说明](https://images.gitee.com/uploads/images/2020/1109/094949_d2490571_409467.png "屏幕截图.png")

### 联系作者加入群

![输入图片说明](https://images.gitee.com/uploads/images/2020/1217/152441_79fbd2f6_409467.png "屏幕截图.png")

### 特别鸣谢

 感谢[RuoYi-Vue](https://gitee.com/y_project/RuoYi-Vue?_from=gitee_search)提供框架代码。


### 部分演示图，持续更新

![输入图片说明](https://images.gitee.com/uploads/images/2020/1014/092211_447d288e_409467.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1014/092227_74c199cf_409467.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1014/092322_df5e338b_409467.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1014/092306_99975664_409467.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1014/092338_503e44f7_409467.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1014/092358_e465cb54_409467.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1109/094122_dfd73b9e_409467.png "屏幕截图.png")
![输入图片说明](https://images.gitee.com/uploads/images/2020/1109/094154_e5052872_409467.png "屏幕截图.png")

### 版权声明

LinkWeChat开源版遵循[GPL-3.0](https://gitee.com/LinkWeChat/link-wechat/blob/master/LICENSE)开源协议发布，并提供免费使用，但不允许修改后和衍生的代码做为闭源的商业软件发布和销售！
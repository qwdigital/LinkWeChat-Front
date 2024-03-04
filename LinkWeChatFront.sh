#!/bin/bash

set -e

echo 'LinkWeChatFront.sh...'

cd $(dirname $0)

if ! command -v git &> /dev/null; then
    echo 请安装 Git
    exit
fi

# dr=${PWD##*/}
# if [[ ${dr} = 'link-we-chat-front' || ${dr} = 'linkwechat' ]]; then
#     echo 拉取项目...
#     git pull
#     echo 拉取完毕
# else
#     echo 拉取项目...
#     git clone https://gitee.com/LinkWeChat/link-we-chat-front.git
#     echo 拉取完毕
# fi

if ! command -v node &> /dev/null; then
    echo 请安装 Node.js
    exit
fi

icnpm() {
    if ! command -v cnpm &> /dev/null; then
        echo 安装cnpm...
        npm install -g cnpm --registry=https://registry.npmmirror.com
        echo cnpm已安装
    fi
}

# 打包pc端
cd vue3-lw-pc

# 提取当前文件(夹)名
project=$(basename $(pwd))

echo 当前项目${project}

if [ ! -d "$(pwd)/node_modules" ]; then
    icnpm
    echo 安装依赖...
    cnpm i
    echo 依赖已安装
fi

echo 打包 ${project} 生产环境...
npm run build
echo 打包 ${project} 完成

cd ..
if [ -d "$(pwd)/linkwe-mobile" ]; then
    # 打包vue2移动端
    cd linkwe-mobile

    project=$(basename $(pwd))

    echo 当前项目${project}

    if [ ! -d "$(pwd)/node_modules" ]; then
        icnpm
        echo 安装依赖...
        cnpm i
        echo 依赖已安装
    fi

    echo 打包 ${project} 生产环境...
    npm run build
    echo 打包 ${project} 完成
fi

cd ..
if [ -d "$(pwd)/vue3-lw-mobile" ]; then
    # 打包vue3移动端
    cd vue3-lw-mobile

    project=$(basename $(pwd))

    echo 当前项目${project}

    if [ ! -d "$(pwd)/node_modules" ]; then
        icnpm
        echo 安装依赖...
        cnpm i
        echo 依赖已安装
    fi

    echo 打包 ${project} 生产环境...
    npm run build
    echo 打包完成
fi

exit



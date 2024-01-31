#!/bin/bash

set -e

echo 'LinkWeChatFront.sh...'

cd $(dirname $0)

if ! command -v git &> /dev/null; then
    echo 请安装 Git
    exit
fi

if [ -d "$(pwd)/link-we-chat-front" ]; then
    echo 拉取项目...
    git pull
    echo 拉取完毕
else
    echo 拉取项目...
    git clone https://gitee.com/LinkWeChat/link-we-chat-front.git
    echo 拉取完毕
fi

if ! command -v node &> /dev/null; then
    echo 请安装 Node.js
    exit
fi

cnpm() {
    if ! command -v cnpm &> /dev/null; then
        echo 安装cnpm...
        npm install -g cnpm --registry=https://registry.npmmirror.com
        echo cnpm已安装
    fi
}

# 打包pc端
cd vue3-lw-pc

project=$(basename "$(dirname) $(pwd)")

echo 当前项目${project}

if [ ! -d "$(pwd)/node_modules" ]; then
    cnpm
    echo 安装依赖...
    cnpm i
    echo 依赖已安装
fi

echo 打包 ${project} 生产环境...
npm run build
echo 打包 ${project} 完成

cd ..
if [ ! -d "$(pwd)/linkwe-mobile" ]; then
    # 打包vue2移动端
    cd linkwe-mobile

    project=$(basename "$(dirname) $(pwd)")

    echo 当前项目${project}

    if [ ! -d "$(pwd)/node_modules" ]; then
        cnpm
        echo 安装依赖...
        cnpm i
        echo 依赖已安装
    fi

    echo 打包 ${project} 生产环境...
    npm run build
    echo 打包 ${project} 完成
fi

cd ..
if [ ! -d "$(pwd)/vue3-lw-mobile" ]; then
    # 打包vue3移动端
    cd vue3-lw-mobile

    project=$(basename "$(dirname) $(pwd)")

    echo 当前项目${project}

    if [ ! -d "$(pwd)/node_modules" ]; then
        cnpm
        echo 安装依赖...
        cnpm i
        echo 依赖已安装
    fi

    echo 打包 ${project} 生产环境...
    npm run build
    echo 打包完成
fi

exit



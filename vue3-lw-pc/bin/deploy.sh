#!/bin/bash

set -e

echo 部署生产环境

cd $(dirname $0)

if ! command -v git &> /dev/null; then
    echo 请安装 Git
    exit
fi

if ! command -v node &> /dev/null; then
    echo 请安装 Node.js
    exit
fi

cd ../../

echo 拉取项目...
git pull
echo 拉取完毕

cd vue3-lw-pc

if [ ! -d "$(pwd)/node_modules" ]; then
    if ! command -v cnpm &> /dev/null; then
        echo 安装cnpm...
        npm install -g cnpm --registry=https://registry.npmmirror.com
        echo cnpm已安装
    fi
    echo 安装依赖...
    cnpm i
    echo 依赖已安装
fi

deploy prod
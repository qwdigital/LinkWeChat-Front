#!/bin/bash

set -e

echo 部署开发环境

if ! command -v git &> /dev/null; then
    echo 请安装 Git
    exit
fi

if ! command -v node &> /dev/null; then
    echo 请安装 Node.js
    exit
fi

cd $(dirname $0)
cd ../

echo 拉取项目...
git pull
echo 拉取完毕

if [$1]; then
    cd $1 # 进入传参 项目
else
    cd vue3-lw-pc
fi

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

deploy dev

# npm run build:dev

# tar -czvf dist.tar.gz dist

# scp dist.tar.gz root@119.45.139.110:/usr/local/nginx/html/prod/pc
#     echo dist.tar.gz root@119.45.139.110:/usr/local/nginx/html/prod/pc

# ssh root@119.45.139.110
# echo root@119.45.139.110

# cd /usr/local/nginx/html/prod/pc
# echo /usr/local/nginx/html/prod/pc
# tar -xzvf ./dist.tar.gz --strip-components=1
# echo strip-components
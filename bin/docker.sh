#!/bin/bash

set -e

cd $(dirname $0)
cd ../

docker build --platform linux/amd64 -t linkwechat-front .

# docker run --name linkwechat-front -p 80:80 -d
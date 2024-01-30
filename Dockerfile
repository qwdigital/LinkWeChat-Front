FROM nginx:stable

# 设置工作目录
# WORKDIR /usr/share/nginx/html

# 将nginx配置文件复制到容器中
COPY ./document/nginx.docker.conf /etc/nginx/nginx.conf

# 将静态文件复制到容器中
COPY ./vue3-lw-pc/dist /etc/nginx/html/pc
COPY ./vue3-lw-mobile/dist /etc/nginx/html/m
COPY ./linkwe-mobile/dist /etc/nginx/html/h5

# 暴露端口
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"]

# docker build --platform linux/amd64 -t username/linkwechat-front:dev1 .
# docker login 私有仓库地址 -u 用户名 -p 密码
# docker tag 本地镜像ID 私有仓库地址/镜像名称:标签
# docker push 私有仓库地址/镜像名称:标签
# docker run -p 80:80 -d
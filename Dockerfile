# 使用Node.js 20及以上版本的官方镜像作为基础镜像
FROM node:20 AS build

# 设置工作目录
WORKDIR /app

# 安装Yarn
RUN npm install -g yarn

# 复制package.json和yarn.lock
COPY package.json yarn.lock ./

# 安装依赖
RUN yarn install

# 复制项目文件
COPY . .

# 构建项目
RUN yarn build

# 使用Nginx官方镜像作为基础镜像
FROM nginx:alpine

# 复制构建输出到Nginx的html目录
COPY --from=build /app/build /usr/share/nginx/html

# 复制自定义的Nginx配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"]

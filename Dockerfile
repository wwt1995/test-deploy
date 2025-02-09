# 使用Node.js 20及以上版本的官方镜像作为基础镜像
FROM node:20 AS build

# 设置工作目录
WORKDIR /app

# 安装Yarn
# RUN npm install -g yarn

# 复制package.json和yarn.lock
# COPY package.json yarn.lock ./
COPY package.json ./

# 安装依赖
RUN npm install

# 复制项目文件
COPY . .

# 构建项目
RUN npm run build

# 使用Nginx官方镜像作为基础镜像
FROM nginx:alpine

# 复制构建输出到Nginx的html目录
COPY --from=build /app/dist /usr/share/nginx/html

# 复制自定义的Nginx配置文件
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露端口
EXPOSE 80

# 启动Nginx
CMD ["nginx", "-g", "daemon off;"]

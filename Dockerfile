# 构建应用
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN [ ! -e ".env" ] && cp .env.example .env || true
RUN npm run build

# 最小化镜像
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
RUN npm install -g http-server

# 使用官方Nginx基础镜像
FROM nginx:latest

# 将网站源码复制到容器的/nginx/www目录
COPY . /usr/share/nginx/html

# 指定暴露的端口
EXPOSE 80

# 当容器启动时执行nginx服务器
CMD ["nginx", "-g", "daemon off;"]


# EXPOSE 12445
# CMD ["http-server", "dist", "-p", "12445"]
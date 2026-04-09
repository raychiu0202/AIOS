# AIOS 快速开始指南

## 1. 环境准备

### 1.1 基础环境
- **JDK 1.8+** (推荐 JDK 1.8.0_482)
- **Maven 3.9+** (推荐 3.9.14)
- **MySQL 5.7+** (推荐 8.0)
- **Redis 6.0+** (推荐 6.2)
- **Node.js 16+** (推荐 18+)

### 1.2 数据库配置
创建数据库并导入初始化脚本：

```sql
-- 创建数据库
CREATE DATABASE ry_vue DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 创建用户（如果不存在）
CREATE USER IF NOT EXISTS 'wms'@'localhost' IDENTIFIED BY 'Wms@2024';
GRANT ALL PRIVILEGES ON ry_vue.* TO 'wms'@'localhost';
FLUSH PRIVILEGES;

-- 导入SQL脚本
mysql -u wms -pWms@2024 ry_vue < /path/to/AIOS/sql/ry_vue_2026.01.sql
```

## 2. 项目启动

### 2.1 后端服务启动

#### 方式一：使用Maven命令
```bash
# 进入项目根目录
cd /Users/ray/Documents/projects/AIOS

# 编译项目（首次运行需要）
mvn clean compile -Dmaven.test.skip=true -f pom.xml

# 运行后端服务
mvn spring-boot:run -pl aios-server
```

#### 方式二：使用IDE
1. 使用 IDEA 或 VSCode 打开项目
2. 选择 `aios-server` 模块
3. 运行 `AiosApplication.java` 主类

#### 方式三：使用jar包
```bash
# 打包项目
mvn clean package -Dmaven.test.skip=true -f pom.xml

# 运行jar包
java -jar aios-server/target/aios-server.jar --spring.profiles.active=local
```

### 2.2 前端项目启动

#### 1. 克隆前端代码
```bash
# 如果有单独的前端项目
git clone https://github.com/YunaiV/AIOS-admin.git
cd AIOS-admin
```

#### 2. 安装依赖
```bash
# 使用npm
npm install

# 或使用yarn
yarn install
```

#### 3. 修改配置
```javascript
// 在 .env.development 文件中修改
VITE_APP_BASE_API = 'http://localhost:48080/admin-api'
```

#### 4. 启动开发服务器
```bash
# 开发模式
npm run dev

# 生产模式
npm run build
```

### 2.3 验证启动

访问以下地址验证服务是否正常运行：

- **后端API文档**：http://localhost:48080/doc.html
- **前端登录页面**：http://localhost:3000
- **后端健康检查**：http://localhost:48080/actuator/health

## 3. 默认账号

### 3.1 管理员账号
- **用户名**：admin
- **密码**：admin123
- **角色**：超级管理员

### 3.2 普通用户账号
- **用户名**：test
- **密码**：test123
- **角色**：普通用户

## 4. 配置说明

### 4.1 数据库配置
修改 `aios-server/src/main/resources/application-local.yaml`：

```yaml
spring:
  datasource:
    dynamic:
      datasource:
        master:
          url: jdbc:mysql://localhost:3306/ry_vue?useUnicode=true&characterEncoding=utf8&...
          username: wms
          password: Wms@2024
```

### 4.2 Redis配置
```yaml
spring:
  redis:
    host: 127.0.0.1
    port: 6379
    database: 0
```

### 4.3 端口配置
- **后端端口**：48080
- **前端端口**：3000
- **Redis端口**：6379
- **MySQL端口**：3306

## 5. 常用命令

### 5.1 Maven常用命令
```bash
# 清理编译文件
mvn clean

# 编译项目
mvn compile

# 打包项目
mvn package

# 安装到本地仓库
mvn install

# 跳过测试编译
mvn clean package -Dmaven.test.skip=true
```

### 5.2 Spring Boot命令
```bash
# 运行应用
mvn spring-boot:run

# 指定配置文件运行
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=dev"

# 后台运行
nohup mvn spring-boot:run > app.log 2>&1 &
```

## 6. 常见问题

### 6.1 端口被占用
```bash
# 查看端口占用
lsof -i :48080

# 杀死进程
kill -9 <PID>
```

### 6.2 数据库连接失败
- 检查MySQL服务是否启动
- 验证数据库用户名密码
- 检查数据库连接参数

### 6.3 Maven依赖下载慢
```bash
# 使用国内镜像
<mirror>
  <id>aliyunmaven</id>
  <mirrorOf>*</mirrorOf>
  <name>阿里云公共仓库</name>
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```

### 6.4 内存溢出
```bash
# 增加JVM内存
export MAVEN_OPTS="-Xms512m -Xmx1024m"
```

## 7. 开发建议

### 7.1 开发流程
1. 从主干创建新分支
2. 开发新功能
3. 提交代码并创建Pull Request
4. 代码审查后合并

### 7.2 代码规范
- 遵循阿里巴巴Java开发手册
- 使用代码格式化工具
- 编写单元测试
- 添加必要的注释

### 7.3 调试技巧
- 使用IDE调试功能
- 查看日志文件
- 使用Postman测试API
- 检查数据库SQL语句

## 8. 相关资源

- **GitHub仓库**：https://github.com/raychiu0202/AIOS
- **项目文档**：请参考项目README和各模块文档

---

*本文档最后更新时间：2026-04-08*
# ruoyi-vue-pro 项目概述

## 项目简介

**ruoyi-vue-pro** 是一个基于 Spring Boot + MyBatis Plus + Vue3 的快速开发平台，采用最新技术栈开发。该项目是原若依（RuoYi）框架的增强版，提供了更丰富的功能模块和更完善的开发体验。

### 项目特色

- 🚀 **企业级架构** - 基于 Spring Boot 2.7.18 和 Vue3 构建
- 🔧 **模块化设计** - 支持按需启用功能模块
- 📊 **多租户架构** - 内置多租户支持
- 🔒 **安全认证** - 基于 Sa-Token 的权限管理
- 📱 **响应式设计** - 支持 PC、移动端适配
- 🔧 **代码生成** - 自动生成前后端代码
- 📈 **数据可视化** - 内置积木报表
- 🔄 **工作流引擎** - 集成 Flowable 6
- 💬 **实时通讯** - 支持 WebSocket、消息队列
- 🤖 **AI 集成** - 支持多种 AI 平台接入

## 技术栈

### 后端技术
- **核心框架**：Spring Boot 2.7.18
- **ORM 框架**：MyBatis Plus 3.5.7
- **权限框架**：Sa-Token 1.37.0
- **多数据源**：Dynamic DataSource 3.6.1
- **缓存框架**：Redis
- **模板引擎**：Freemarker
- **连接池**：HikariCP
- **任务调度**：Quartz
- **消息队列**：RocketMQ、Kafka、RabbitMQ
- **文档生成**：Swagger / Knife4j

### 前端技术
- **核心框架**：Vue3
- **UI 框架**：Element Plus
- **状态管理**：Pinia
- **路由管理**：Vue Router 4
- **HTTP 客户端**：Axios
- **构建工具**：Vite
- **图表组件**：ECharts

### 开发工具
- **项目构建**：Maven 3.9+
- **版本控制**：Git
- **开发工具**：IDEA / VSCode
- **API 测试**：Postman / Apifox

## 项目结构

```
ruoyi-vue-pro/
├── yudao-dependencies/          # 依赖管理
├── yudao-framework/            # 核心框架
│   ├── yudao-common/           # 通用工具
│   ├── yudao-spring-boot-starter-biz-data-permission/  # 数据权限
│   ├── yudao-spring-boot-starter-biz-ip/               # IP解析
│   ├── yudao-spring-boot-starter-biz-tenant/           # 多租户
│   ├── yudao-spring-boot-starter-excel/               # Excel处理
│   ├── yudao-spring-boot-starter-job/                 # 定时任务
│   ├── yudao-spring-boot-starter-monitor/             # 监控
│   ├── yudao-spring-boot-starter-mq/                 # 消息队列
│   ├── yudao-spring-boot-starter-mybatis/             # MyBatis增强
│   ├── yudao-spring-boot-starter-protection/          # 安全防护
│   ├── yudao-spring-boot-starter-redis/               # Redis增强
│   ├── yudao-spring-boot-starter-security/            # 安全认证
│   ├── yudao-spring-boot-starter-test/                # 测试支持
│   └── yudao-spring-boot-starter-web/                 # Web增强
├── yudao-server/                # 主服务（启动入口）
├── yudao-module-system/        # 系统管理模块
├── yudao-module-infra/        # 基础设施模块
├── yudao-module-member/       # 会员模块
├── yudao-module-bpm/          # 工作流模块
├── yudao-module-report/       # 报表模块
├── yudao-module-mp/           # 公众号模块
├── yudao-module-pay/          # 支付模块
├── yudao-module-mall/         # 商城模块
├── yudao-module-crm/          # CRM模块
├── yudao-module-erp/          # ERP模块
├── yudao-module-iot/          # 物联网模块
└── yudao-module-mes/          # 制造执行系统模块
```

## 核心功能

### 1. 系统管理
- **用户管理**：用户信息、角色权限、部门管理
- **菜单管理**：动态菜单配置、权限控制
- **角色管理**：角色授权、数据权限
- **字典管理**：系统字典、业务字典
- **参数配置**：系统参数、业务配置
- **通知公告**：系统通知、公告管理
- **操作日志**：操作记录、日志查询
- **登录日志**：登录记录、异常监控
- **在线用户**：在线状态、踢人下线

### 2. 基础设施
- **文件管理**：文件上传、下载、预览
- **代码生成**：前后端代码自动生成
- **服务监控**：JVM监控、SQL监控、缓存监控
- **定时任务**：任务调度、执行日志
- **消息通知**：站内信、邮件、短信
- **API管理**：接口文档、接口测试
- **系统工具**：表单构建、代码生成、系统图标

### 3. 业务模块
- **会员管理**：会员信息、等级管理、标签管理
- **商城系统**：商品管理、订单管理、支付管理
- **CRM系统**：客户管理、商机管理、跟进记录
- **ERP系统**：采购管理、销售管理、库存管理
- **工作流**：流程设计、流程审批、任务处理
- **物联网**：设备管理、数据采集、规则引擎
- **报表系统**：数据报表、图表展示、数据导出

## 部署方式

### 开发环境
1. 确保已安装 JDK 1.8+、Maven 3.9+、MySQL 5.7+、Redis 6.0+
2. 修改数据库配置文件 `application-local.yaml`
3. 导入数据库脚本到 MySQL
4. 运行后端服务：`mvn spring-boot:run -pl yudao-server`
5. 启动前端服务：`npm install && npm run dev`

### 生产环境
1. 修改配置文件为生产环境配置
2. 打包后端服务：`mvn clean package -Dmaven.test.skip=true`
3. 构建前端项目：`npm run build`
4. 部署到服务器
5. 配置 Nginx 反向代理

## 开发指南

### 快速开始
1. 克隆项目代码
2. 配置数据库连接
3. 导入数据库脚本
4. 运行后端服务
5. 启动前端服务
6. 访问系统首页

### 开发规范
- 遵循 Spring Boot 开发规范
- 使用 MyBatis Plus 注解进行数据库操作
- 遵循 RESTful API 设计规范
- 统一异常处理和返回格式
- 使用代码生成器生成代码

### 扩展开发
- 继承基础模块进行功能扩展
- 使用注解进行权限控制
- 遵循模块化设计原则
- 保持代码风格一致

## 维护支持

### 问题反馈
- GitHub Issues：https://github.com/YunaiV/ruoyi-vue-pro/issues
- 官方文档：https://doc.iocoder.cn/ruoyi-vue-pro/
- 交流群：请参考官方文档获取群信息

### 更新日志
详见 `DOC_UPDATE_LOG.md`

---

*本文档最后更新时间：2026-04-08*
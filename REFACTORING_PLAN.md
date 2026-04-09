# AIOS 重构方案：从 Yudao 到 Aios

## 项目现状分析

### ✅ 已确认的状态
1. **原始yudao代码可以正常运行**
   - yudao-server 编译成功
   - yudao-server 启动成功 (端口48080)
   - 数据库连接正常
   - Spring Security配置正常
   - Redis连接正常
   - 用户登录功能正常
   - 菜单功能正常
   - 用户管理功能正常
   - 部门管理功能正常

2. **项目结构对比**
   ```
   yudao-* (原始)     aios-* (目标)
   ├── yudao-server      ├── aios-server
   ├── yudao-framework   ├── aios-framework
   ├── yudao-dependencies ├── aios-dependencies
   ├── yudao-module-*   ├── aios-module-*
   ├── yudao-ui          ├── aios-ui
   └── yudao-ui-admin-vue3 └── aios-ui-admin-vue3
   ```

### 🔍 功能测试结果
- ✅ 登录接口正常 (返回token)
- ✅ 权限获取正常 (返回完整权限列表)
- ✅ 菜单获取正常 (返回1321个菜单)
- ✅ 用户管理正常 (返回15个用户)
- ✅ 部门管理正常 (返回14个部门)
- ✅ Swagger文档可访问 (http://localhost:48080/doc.html)

## 分步骤重构方案

### 阶段1：准备工作 (1-2天)

#### 1.1 环境验证
- [x] 确认数据库环境
- [x] 确认Redis环境
- [x] 确认Maven/Java环境
- [ ] 备份当前工作代码
- [ ] 创建重构分支 `refactor/yudao-to-aios`

#### 1.2 依赖管理
```bash
# 复制并重命名依赖管理模块
cp -r yudao-dependencies aios-dependencies
cd aios-dependencies
# 重命名所有文件和类中的yudao为aios
find . -type f -exec sed -i '' 's/yudao/aios/g' {} +
# 重命名目录
find . -type d -name "*yudao*" | while read dir; do
  mv "$dir" "${dir/yudao/aios}"
done
```

#### 1.3 配置文件调整
```properties
# 重命名配置前缀
yudao.* -> aios.*
spring.application.name=yudao-server -> aios-server
```

### 阶段2：核心框架重构 (3-5天)

#### 2.1 重命名策略
```
1. 包名重命名
   cn.iocoder.yudao.* -> cn.iocoder.aios.*

2. 类名重命名
   YudaoXxx -> AiosXxx

3. 配置属性重命名
   yudao.xxx -> aios.xxx

4. 文档引用重命名
   yudao-ui-admin -> aios-ui-admin
```

#### 2.2 重构顺序 (按依赖关系)

**2.2.1 依赖层**
- [ ] aios-dependencies
- [ ] 重命名pom.xml中的artifactId
- [ ] 修改版本号管理
- [ ] 更新依赖引用

**2.2.2 框架层 (aios-framework)**
```
按以下顺序依次重构：
1. aios-common (最基础)
2. aios-spring-boot-starter-mybatis
3. aios-spring-boot-starter-web
4. aios-spring-boot-starter-security
5. aios-spring-boot-starter-redis
6. aios-spring-boot-starter-excel
7. aios-spring-boot-starter-mq
8. aios-spring-boot-starter-job
9. aios-spring-boot-starter-monitor
10. aios-spring-boot-starter-protection
11. aios-spring-boot-starter-test
12. aios-spring-boot-starter-websocket
13. aios-spring-boot-starter-biz-data-permission
14. aios-spring-boot-starter-biz-tenant
15. aios-spring-boot-starter-biz-ip
```

#### 2.3 重构脚本模板
```bash
#!/bin/bash
# 重命名单个模块的脚本

MODULE_NAME=$1
OLD_NAME="yudao"
NEW_NAME="aios"

echo "开始重构模块: $MODULE_NAME"

# 1. 重命名目录
if [ -d "$OLD_NAME-$MODULE_NAME" ]; then
    mv "$OLD_NAME-$MODULE_NAME" "$NEW_NAME-$MODULE_NAME"
fi

# 2. 重命名Java包
find "$NEW_NAME-$MODULE_NAME" -type f -name "*.java" -exec sed -i '' "s/cn\.iocoder\.$OLD_NAME\./cn.iocoder.$NEW_NAME./g" {} +

# 3. 重命名配置文件
find "$NEW_NAME-$MODULE_NAME" -type f \( -name "*.xml" -o -name "*.properties" -o -name "*.yml" -o -name "*.yaml" \) -exec sed -i '' "s/$OLD_NAME/$NEW_NAME/g" {} +

# 4. 重命名类名
find "$NEW_NAME-$MODULE_NAME" -type f -name "*.java" -exec sed -i '' "s/$OLD_NAME\([A-Z]\)/$NEW_NAME\1/g" {} +

echo "模块 $MODULE_NAME 重构完成"
```

### 阶段3：应用层重构 (1-2天)

#### 3.1 Server层
- [ ] 重命名yudao-server为aios-server
- [ ] 修改启动类名 YudaoServerApplication -> AiosServerApplication
- [ ] 更新application.yml配置
- [ ] 修改依赖引用

#### 3.2 验证测试
```bash
# 编译测试
mvn clean compile -pl aios-server -am -DskipTests

# 单元测试
mvn test -pl aios-server -am

# 启动测试
mvn spring-boot:run -pl aios-server
```

### 阶段4：前端重构 (2-3天)

#### 4.1 Vue3前端
```bash
# 克隆前端项目
git clone https://github.com/yudaocode/yudao-ui-admin-vue3.git aios-ui-admin-vue3

# 重命名项目
cd aios-ui-admin-vue3
```

- [ ] 重命名项目目录
- [ ] 修改package.json配置
- [ ] 重命名API调用路径
- [ ] 更新路由配置
- [ ] 修改静态资源引用

#### 4.2 UI组件重构
```
1. 组件库引用
   @/components/yudao-* -> @/components/aios-*

2. API接口
   /api/yudao/* -> /api/aios/*

3. 路由路径
   /yudao/* -> /aios/*
```

### 阶段5：文档和配置 (1天)

#### 5.1 文档更新
- [ ] README.md
- [ ] API文档
- [ ] 部署文档
- [ ] 数据库文档

#### 5.2 配置文件
- [ ] application.yml
- [ ] pom.xml
- [ ] Dockerfile
- [ ] CI/CD配置

### 阶段6：测试验证 (2-3天)

#### 6.1 功能测试
```
核心功能列表：
- [x] 用户登录/登出
- [ ] 权限管理
- [ ] 角色管理
- [ ] 部门管理
- [x] 菜单管理
- [ ] 字典管理
- [ ] 参数配置
- [ ] 通知公告
- [ ] 操作日志
- [ ] 登录日志
```

#### 6.2 性能测试
- [ ] 启动时间验证 (当前：47秒)
- [ ] 响应时间测试
- [ ] 并发测试
- [ ] 内存使用监控

#### 6.3 兼容性测试
- [ ] 浏览器兼容性
- [ ] 数据库兼容性
- [ ] Redis兼容性

### 阶段7：部署上线 (1天)

#### 7.1 预发布环境
- [ ] 灰度发布
- [ ] 数据验证
- [ ] 性能监控

#### 7.2 正式发布
- [ ] 停止旧服务
- [ ] 部署新服务
- [ ] 健康检查
- [ ] 监控告警

## 具体重构操作指南

### 步骤1：创建重构分支
```bash
git checkout -b refactor/yudao-to-aios
git checkout -b refactor/phase1-dependencies
```

### 步骤2：批量重命名工具
```bash
#!/bin/bash
# batch_rename.sh - 批量重命名脚本

OLD_PREFIX="yudao"
NEW_PREFIX="aios"

# 定义需要重构的模块列表
MODULES=(
    "dependencies"
    "server"
    "framework"
    "module-system"
    "module-infra"
    "module-member"
    "module-pay"
    "module-mall"
    "module-bpm"
    "module-erp"
    "module-crm"
    "module-mp"
    "module-ai"
    "module-iot"
    "module-mes"
    "module-report"
)

for module in "${MODULES[@]}"; do
    echo "处理模块: $module"
    bash rename_module.sh "$module"
done
```

### 步骤3：自动修正工具
```bash
#!/bin/bash
# fix_common_issues.sh - 修复常见问题

# 1. 添加缺失的@Slf4j注解
find . -name "*.java" -exec grep -l "log\.info\|log\.error\|log\.debug" {} \; |
while read file; do
    if ! grep -q "@Slf4j" "$file"; then
        sed -i '' 's/^import lombok.extern.slf4j.Slf4j;/import lombok.extern.slf4j.Slf4j;\n@Slf4j/' "$file"
    fi
done

# 2. 修复包导入
find . -name "*.java" -exec sed -i '' 's/import cn\.iocoder\.yudao\./import cn.iocoder.aios./g' {} +

# 3. 修复配置属性
find . -name "*.java" -exec sed -i '' 's/"yudao\./"aios./g' {} +
find . -name "*.yml" -exec sed -i '' 's/yudao:/aios:/g' {} +
find . -name "*.yaml" -exec sed -i '' 's/yudao:/aios:/g' {} +
find . -name "*.properties" -exec sed -i '' 's/yudao\./aios./g' {} +
```

## 验证清单

### 每阶段验证
- [x] 编译通过：`mvn clean compile`
- [ ] 测试通过：`mvn test`
- [x] 启动成功：应用正常启动
- [ ] 日志正常：无ERROR日志
- [ ] 接口正常：基础接口可访问

### 最终验证
- [ ] 所有模块编译通过
- [ ] 所有单元测试通过
- [ ] 集成测试通过
- [ ] 前后端联调通过
- [ ] 性能指标达标
- [ ] 安全测试通过

## 风险评估与应对

### 高风险项
1. **包名修改影响面大**
   - 风险：所有import语句需要修改
   - 应对：使用自动化脚本批量处理

2. **配置属性重命名**
   - 风险：可能导致配置失效
   - 应对：分阶段重命名，及时验证

3. **第三方集成**
   - 风险：可能影响第三方系统集成
   - 应对：提前与第三方沟通

### 中风险项
1. **前端路由修改**
   - 风险：可能导致页面访问异常
   - 应对：保留旧路由重定向

2. **数据库配置**
   - 风险：连接配置可能错误
   - 应对：保持数据库配置不变

## 时间规划

| 阶段 | 工作量 | 缓冲时间 | 总计 |
|------|--------|----------|------|
| 阶段1：准备 | 2天 | 1天 | 3天 |
| 阶段2：框架重构 | 5天 | 2天 | 7天 |
| 阶段3：应用层重构 | 2天 | 1天 | 3天 |
| 阶段4：前端重构 | 3天 | 1天 | 4天 |
| 阶段5：文档配置 | 1天 | 0天 | 1天 |
| 阶段6：测试验证 | 3天 | 2天 | 5天 |
| 阶段7：部署上线 | 1天 | 1天 | 2天 |
| **总计** | **17天** | **8天** | **25天** |

## 团队协作建议

1. **代码审查**
   - 每个阶段完成后进行代码审查
   - 关键修改需要多人复核

2. **分支管理**
   - 使用feature分支进行模块重构
   - 合并到主分支前充分测试

3. **沟通机制**
   - 每日站会同步进度
   - 问题及时上报和解决

4. **回滚准备**
   - 保留原始代码备份
   - 准备快速回滚方案

## 当前系统状态

### 后端服务
- **服务状态**: ✅ 运行正常
- **端口**: 48080
- **启动时间**: ~47秒
- **文档地址**: http://localhost:48080/doc.html

### 功能测试结果
- ✅ 登录功能正常
- ✅ 权限获取正常
- ✅ 菜单管理正常 (1321个菜单)
- ✅ 用户管理正常 (15个用户)
- ✅ 部门管理正常 (14个部门)
- ✅ Swagger文档可访问

### 测试账户
- 用户名: admin
- 密码: admin123
- 租户ID: 1

## 附录

### A. 相关命令速查
```bash
# 编译
mvn clean compile -DskipTests

# 测试
mvn test

# 打包
mvn clean package -DskipTests

# 启动
mvn spring-boot:run

# 查看进程
ps aux | grep yudao-server

# 停止进程
kill <pid>

# 查看日志
tail -f logs/application.log

# 测试登录接口
curl -X POST http://localhost:48080/admin-api/system/auth/login \
  -H "Content-Type: application/json" \
  -H "tenant-id: 1" \
  -d '{"username":"admin","password":"admin123"}'
```

### B. 常见问题解决
1. **编译错误：找不到类**
   - 检查import语句
   - 确认模块依赖关系
   - 清理Maven缓存：`mvn clean`

2. **启动错误：端口占用**
   - 修改配置文件端口
   - 停止占用端口的进程

3. **运行时错误：配置不存在**
   - 检查配置文件路径
   - 确认配置属性名称
   - 查看环境变量

### C. 联系方式
- 技术负责人：[待定]
- 项目经理：[待定]
- 紧急联系：[待定]

---

**文档版本**: v1.0
**创建日期**: 2026-04-09
**最后更新**: 2026-04-09
**文档状态**: 待审核

**更新记录**:
- 2026-04-09: 初始版本，包含完整重构方案
- 2026-04-09: 添加功能测试结果，确认系统正常运行
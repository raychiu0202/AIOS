# ruoyi-vue-pro 功能扩展开发指南

## 1. 开发环境准备

### 1.1 环境要求
- **IDE推荐**：IntelliJ IDEA 2024+ 或 VSCode
- **JDK版本**：1.8+
- **Maven版本**：3.9+
- **Node.js版本**：16+

### 1.2 开发环境配置

#### IDEA配置
1. 安装必备插件：
   - Lombok Plugin
   - Spring Boot
   - MyBatis Plugin
   - Maven Helper

#### VSCode配置
```json
{
    "java.compile.nullAnalysis.mode": "automatic",
    "maven.terminal.useJavaHome": true,
    "maven.terminal.customEnv": [
        {
            "name": "MAVEN_OPTS",
            "value": "-Xms512m -Xmx1024m"
        }
    ]
}
```

## 2. 项目结构详解

### 2.1 核心目录结构
```
ruoyi-vue-pro/
├── yudao-dependencies/          # 依赖管理 BOM
├── yudao-framework/            # 核心框架
│   ├── yudao-common/           # 通用工具类
│   ├── yudao-spring-boot-starter-*/  # 各种增强starter
├── yudao-server/               # 主启动模块
│   ├── src/main/java/cn/iocoder/yudao/server/
│   │   ├── RuoyiApplication.java  # 启动类
│   │   ├── config/               # 配置类
│   │   └── framework/            # 框架增强
├── yudao-module-*/             # 业务模块
└── sql/                        # 数据库脚本
```

### 2.2 模块说明

#### yudao-framework
框架核心模块，包含：
- 通用工具类
- 数据库增强
- 缓存增强
- 安全增强
- Web增强

#### yudao-module-system
系统管理模块，包含：
- 用户管理
- 角色管理
- 菜单管理
- 部门管理
- 字典管理
- 参数管理

#### yudao-module-infra
基础设施模块，包含：
- 文件管理
- 代码生成
- 服务监控
- 定时任务
- 系统通知

## 3. 创建新模块

### 3.1 模块创建步骤

#### 1. 创建模块目录
```bash
mkdir -p yudao-module-demo
mkdir -p yudao-module-demo/src/main/java/cn/iocoder/yudao/module/demo
mkdir -p yudao-module-demo/src/main/resources/mapper/demo
```

#### 2. 创建pom.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>cn.iocoder.boot</groupId>
        <artifactId>yudao</artifactId>
        <version>${revision}</version>
    </parent>
    <artifactId>yudao-module-demo</artifactId>
    <packaging>jar</packaging>
    
    <name>${project.artifactId}</name>
    <description>演示模块</description>
    
    <dependencies>
        <!-- 核心依赖 -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-framework</artifactId>
            <version>${revision}</version>
        </dependency>
        
        <!-- Web依赖 -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-web</artifactId>
            <version>${revision}</version>
        </dependency>
        
        <!-- 数据库依赖 -->
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-spring-boot-starter-mybatis</artifactId>
            <version>${revision}</version>
        </dependency>
    </dependencies>
</project>
```

#### 3. 更新父pom.xml
```xml
<modules>
    <!-- 其他模块 -->
    <module>yudao-module-demo</module>
</modules>
```

### 3.2 创建模块结构

#### 目录结构
```
yudao-module-demo/
├── src/main/java/cn/iocoder/yudao/module/demo/
│   ├── controller/
│   │   └── DemoController.java
│   ├── service/
│   │   ├── DemoService.java
│   │   └── impl/
│   │       └── DemoServiceImpl.java
│   ├── dal/
│   │   ├── dataobject/
│   │   │   └── DemoDO.java
│   │   └── mapper/
│   │       └── DemoMapper.java
│   ├── convert/
│   │   └── DemoConvert.java
│   └── enums/
│       └── DemoStatusEnum.java
├── src/main/resources/
│   └── mapper/
│       └── demo/
│           └── DemoMapper.xml
└── pom.xml
```

## 4. 实现CRUD功能

### 4.1 数据库表设计

#### SQL语句
```sql
CREATE TABLE demo (
    id BIGINT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL COMMENT '名称',
    status TINYINT NOT NULL DEFAULT 0 COMMENT '状态',
    create_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) COMMENT '演示表';
```

### 4.2 创建数据对象(DO)

```java
@TableName("demo")
public class DemoDO {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    @TableField(value = "name", insert = true, update = false)
    private String name;
    
    @TableField(value = "status", insert = true, update = true)
    private Integer status;
    
    @TableField(value = "create_time", fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    
    @TableField(value = "update_time", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
    
    // getters and setters
}
```

### 4.3 创建Mapper接口

```java
public interface DemoMapper extends BaseMapper<DemoDO> {
    
    @Select("SELECT * FROM demo WHERE name = #{name}")
    DemoDO selectByName(String name);
    
    @Update("UPDATE demo SET status = #{status} WHERE id = #{id}")
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
}
```

### 4.4 创建Service层

```java
@Service
public class DemoServiceImpl implements DemoService {
    
    @Autowired
    private DemoMapper demoMapper;
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long createDemo(DemoCreateReqVO reqVO) {
        DemoDO demo = DemoConvert.INSTANCE.convert(reqVO);
        demoMapper.insert(demo);
        return demo.getId();
    }
    
    @Override
    public DemoVO getDemo(Long id) {
        DemoDO demo = demoMapper.selectById(id);
        return DemoConvert.INSTANCE.convert(demo);
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateDemo(DemoUpdateReqVO reqVO) {
        DemoDO demo = DemoConvert.INSTANCE.convert(reqVO);
        demoMapper.updateById(demo);
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteDemo(Long id) {
        demoMapper.deleteById(id);
    }
}
```

### 4.5 创建Controller层

```java
@RestController
@RequestMapping("/demo")
@Tag(name = "管理", description = "Demo管理接口")
@RequiredArgsConstructor
public class DemoController {
    
    private final DemoService demoService;
    
    @PostMapping("/create")
    @Operation(summary = "创建Demo")
    @PreAuthorize("@ss.hasPermission('demo:create')")
    public Result<Long> createDemo(@Valid @RequestBody DemoCreateReqVO reqVO) {
        return Result.success(demoService.createDemo(reqVO));
    }
    
    @GetMapping("/get")
    @Operation(summary = "获得Demo")
    @PreAuthorize("@ss.hasPermission('demo:get')")
    public Result<DemoVO> getDemo(@RequestParam("id") Long id) {
        return Result.success(demoService.getDemo(id));
    }
    
    @PutMapping("/update")
    @Operation(summary = "更新Demo")
    @PreAuthorize("@ss.hasPermission('demo:update')")
    public Result<Boolean> updateDemo(@Valid @RequestBody DemoUpdateReqVO reqVO) {
        demoService.updateDemo(reqVO);
        return Result.success(true);
    }
    
    @DeleteMapping("/delete")
    @Operation(summary = "删除Demo")
    @PreAuthorize("@ss.hasPermission('demo:delete')")
    public Result<Boolean> deleteDemo(@RequestParam("id") Long id) {
        demoService.deleteDemo(id);
        return Result.success(true);
    }
}
```

## 5. 集成代码生成器

### 5.1 代码生成器配置

#### 数据库配置
```yaml
yudao:
  codegen:
    base-package: cn.iocoder.yudao.module.demo
    db-schemas: ry_vue
    front-type: 20
    vo-type: 10
    delete-batch-enable: true
    unit-test-enable: false
```

#### 生成代码
访问 `http://localhost:48080/admin-api/system/codegen/generate-code` 接口，传入表名。

### 5.2 生成结果
生成的代码包含：
- Controller层
- Service层
- Mapper层
- 数据对象
- 前端页面（Vue3 + Element Plus）

## 6. 权限控制

### 6.1 权限注解

#### 方法级权限
```java
@SaCheckPermission("demo:create")
public Result<Long> createDemo(...) { ... }

@SaCheckRole("admin")
public Result<Boolean> adminOnly() { ... }
```

#### 数据权限
```java
@DataPermission(enable = true, includeColumns = {"dept_id"})
public List<DemoVO> getDemoList(DemoPageReqVO reqVO) { ... }
```

### 6.2 自定义权限

#### 自定义注解
```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@SaCheckPermission(value = "demo:custom")
public @interface DemoPermission {
}
```

## 7. 多租户开发

### 7.1 启用多租户

#### 配置
```yaml
yudao:
  tenant:
    enable: true
```

#### 在Service中使用
```java
@Service
public class DemoService {
    
    public DemoVO getDemo(Long id) {
        // 自动获取当前租户ID
        Long tenantId = TenantContextHolder.getTenantId();
        // 查询数据
        return demoMapper.selectById(id);
    }
}
```

### 7.2 自定义租户处理

#### 实现租户拦截器
```java
@Component
public class TenantInterceptor implements Interceptor {
    
    @Override
    public Object intercept(Invocation invocation) throws Throwable {
        // 设置当前租户ID
        TenantContextHolder.setTenantId(getCurrentTenantId());
        try {
            return invocation.proceed();
        } finally {
            TenantContextHolder.clear();
        }
    }
}
```

## 8. 定时任务开发

### 8.1 使用@Scheduled

```java
@Component
public class DemoTask {
    
    @Scheduled(cron = "0 0 2 * * ?")
    public void dailyTask() {
        // 每天凌晨2点执行
        log.info("执行定时任务");
    }
    
    @Scheduled(fixedRate = 60000)
    public void fixedRateTask() {
        // 每分钟执行一次
        log.info("执行定时任务");
    }
}
```

### 8.2 动态任务

```java
@Service
public class DynamicTaskService {
    
    @Autowired
    private ScheduledTaskRegistrar taskRegistrar;
    
    public void addTask(String taskId, Runnable task) {
        ScheduledFuture<?> future = taskRegistrar.getScheduler().scheduleAtFixedRate(
            task, 0, 1, TimeUnit.MINUTES);
        taskRegistrar.addScheduledTask(taskId, future);
    }
}
```

## 9. 缓存使用

### 9.1 使用注解缓存

```java
@Service
public class DemoService {
    
    @Cacheable(cacheNames = "demo", key = "#id")
    public DemoVO getDemo(Long id) {
        return demoMapper.selectById(id);
    }
    
    @CacheEvict(cacheNames = "demo", key = "#id")
    public void updateDemo(DemoUpdateReqVO reqVO) {
        demoMapper.updateById(DemoConvert.INSTANCE.convert(reqVO));
    }
}
```

### 9.2 编程式缓存

```java
@Service
public class DemoService {
    
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    public DemoVO getDemoFromCache(Long id) {
        String key = "demo:" + id;
        DemoVO demo = (DemoVO) redisTemplate.opsForValue().get(key);
        if (demo == null) {
            demo = demoMapper.selectById(id);
            redisTemplate.opsForValue().set(key, demo, 30, TimeUnit.MINUTES);
        }
        return demo;
    }
}
```

## 10. 异常处理

### 10.1 自定义异常

```java
public class DemoException extends RuntimeException {
    
    public DemoException(String message) {
        super(message);
    }
    
    public DemoException(String message, Throwable cause) {
        super(message, cause);
    }
}
```

### 10.2 全局异常处理

```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(DemoException.class)
    public Result<Void> handleDemoException(DemoException e) {
        log.error("Demo异常", e);
        return Result.fail(e.getMessage());
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<Void> handleValidationException(MethodArgumentNotValidException e) {
        BindingResult bindingResult = e.getBindingResult();
        String message = bindingResult.getFieldError().getDefaultMessage();
        return Result.fail(message);
    }
}
```

## 11. 日志记录

### 11.1 使用SLF4J

```java
@Service
public class DemoService {
    
    private static final Logger logger = LoggerFactory.getLogger(DemoService.class);
    
    public void processDemo(DemoDO demo) {
        logger.info("处理Demo: {}", demo.getId());
        logger.debug("Debug日志");
        logger.warn("Warning日志");
        logger.error("Error日志", new RuntimeException("测试异常"));
    }
}
```

### 11.2 AOP日志记录

```java
@Aspect
@Component
public class LogAspect {
    
    private static final Logger logger = LoggerFactory.getLogger(LogAspect.class);
    
    @Around("@annotation(com.xlt.annotation.Log)")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();
        logger.info("开始执行: {}", joinPoint.getSignature());
        
        try {
            Object result = joinPoint.proceed();
            logger.info("执行完成: {}, 耗时: {}ms", 
                joinPoint.getSignature(), System.currentTimeMillis() - startTime);
            return result;
        } catch (Exception e) {
            logger.error("执行异常: {}", joinPoint.getSignature(), e);
            throw e;
        }
    }
}
```

## 12. 测试开发

### 12.1 单元测试

```java
@ExtendWith(MockitoExtension.class)
class DemoServiceTest {
    
    @Mock
    private DemoMapper demoMapper;
    
    @InjectMocks
    private DemoServiceImpl demoService;
    
    @Test
    void testCreateDemo() {
        DemoDO demo = new DemoDO();
        demo.setName("测试");
        
        when(demoMapper.insert(any())).thenReturn(1);
        
        Long id = demoService.createDemo(DemoConvert.INSTANCE.convert(demo));
        
        Assertions.assertNotNull(id);
        verify(demoMapper).insert(any());
    }
}
```

### 12.2 集成测试

```java
@SpringBootTest
@AutoConfigureMockMvc
class DemoControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    void testGetDemo() throws Exception {
        mockMvc.perform(get("/demo/get")
                .param("id", "1"))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$.code").value(0));
    }
}
```

## 13. 部署配置

### 13.1 打包配置

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <mainClass>cn.iocoder.yudao.server.RuoyiApplication</mainClass>
                <layout>JAR</layout>
                <excludes>
                    <exclude>
                        <groupId>org.projectlombok</groupId>
                        <artifactId>lombok</artifactId>
                    </exclude>
                </excludes>
            </configuration>
        </plugin>
    </plugins>
</build>
```

### 13.2 Docker配置

```dockerfile
FROM openjdk:8-jre-alpine
COPY target/yudao-server.jar app.jar
EXPOSE 48080
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

---

*本文档最后更新时间：2026-04-08*
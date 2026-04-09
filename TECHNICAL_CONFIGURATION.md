# AIOS 技术配置详解

## 1. 项目配置

### 1.1 主配置文件

#### application.yaml
主配置文件，定义项目基本配置和公共模块：

```yaml
spring:
  application:
    name: aios-server
  profiles:
    active: local
  main:
    allow-circular-references: true # 允许循环依赖

server:
  port: 48080
```

#### application-local.yaml
本地开发环境配置：

```yaml
server:
  port: 48080

# 数据库配置
spring:
  datasource:
    dynamic:
      primary: master
      datasource:
        master:
          url: jdbc:mysql://localhost:3306/ry_vue?...
          username: wms
          password: Wms@2024
        slave:
          url: jdbc:mysql://localhost:3306/ry_vue?...
          username: wms
          password: Wms@2024

# Redis配置
spring:
  redis:
    host: 127.0.0.1
    port: 6379
    database: 0
```

### 1.2 核心组件配置

#### MyBatis Plus配置
```yaml
mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
  global-config:
    db-config:
      id-type: NONE
      logic-delete-value: 1
      logic-not-delete-value: 0
    banner: false
  type-aliases-package: ${aios.info.base-package}.module.*.dal.dataobject
```

#### Sa-Token配置
```yaml
sa-token:
  token-name: Authorization
  timeout: 86400
  active-timeout: 86400
  dynamic-active-timeout: true
  is-concurrent: true
  is-share: false
  is-read-header: true
  is-read-cookie: false
  token-prefix: "Bearer"
  jwt-secret-key: abcdefghijklmnopqrstuvwxyz
```

#### Swagger配置
```yaml
springdoc:
  api-docs:
    enabled: true
    path: /v3/api-docs
  swagger-ui:
    enabled: true
    path: /swagger-ui
knife4j:
  enable: true
  setting:
    language: zh_cn
```

## 2. 数据库配置

### 2.1 数据源配置

#### 多数据源配置
```yaml
spring:
  datasource:
    dynamic:
      primary: master # 主数据源
      datasource:
        master:
          url: jdbc:mysql://localhost:3306/ry_vue
          username: wms
          password: Wms@2024
        slave:
          lazy: true
          url: jdbc:mysql://localhost:3306/ry_vue
          username: wms
          password: Wms@2024
```

#### 连接池配置
```yaml
spring:
  datasource:
    dynamic:
      druid:
        initial-size: 1
        min-idle: 1
        max-active: 20
        max-wait: 60000
        time-between-eviction-runs-millis: 60000
        min-evictable-idle-time-millis: 600000
        max-evictable-idle-time-millis: 1800000
        validation-query: SELECT 1 FROM DUAL
        test-while-idle: true
        test-on-borrow: false
        test-on-return: false
        pool-prepared-statements: true
        max-pool-prepared-statement-per-connection-size: 20
```

### 2.2 分页配置

#### 分页插件配置
```java
@Configuration
public class MybatisPlusConfig {

    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        // 添加分页插件
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
```

#### 分页查询示例
```java
@GetMapping("/list")
public Result<Page<UserVO>> list(UserPageReqVO reqVO) {
    // 分页查询
    Page<UserDO> page = userMapper.selectPage(reqVO.buildPage(), reqVO.build());
    return Result.success(UserConvert.INSTANCE.convertPage(page));
}
```

### 2.3 数据加密配置

#### 加密配置
```yaml
mybatis-encryptor:
  enable: true
  algorithm: AES
  encode: BASE64
  password: your-encryption-key
```

#### 加注解使用
```java
@EncryptedField
private String password;
```

## 3. 缓存配置

### 3.1 Redis配置

#### 基础配置
```yaml
spring:
  cache:
    type: REDIS
    redis:
      time-to-live: 1h
```

#### Redis配置类
```java
@Configuration
public class RedisConfig {

    @Bean
    public RedisTemplate<String, Object> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        
        // 设置key的序列化方式
        template.setKeySerializer(new StringRedisSerializer());
        // 设置value的序列化方式
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer());
        
        return template;
    }
}
```

#### 缓存使用示例
```java
@Service
public class UserService {

    @Cacheable(cacheNames = "user", key = "#id")
    public UserVO getUser(Long id) {
        return userMapper.selectById(id);
    }

    @CacheEvict(cacheNames = "user", key = "#id")
    public void deleteUser(Long id) {
        userMapper.deleteById(id);
    }
}
```

### 3.2 本地缓存配置

#### 本地缓存配置
```yaml
spring:
  cache:
    type: SIMPLE
    cache-names:
      - local_user
```

## 4. 安全配置

### 4.1 跨域配置

#### 跨域配置类
```java
@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOriginPatterns("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*")
                .allowCredentials(true)
                .maxAge(3600);
    }
}
```

### 4.2 防SQL注入

#### SQL注入防护
```yaml
xss:
  enabled: true
  excludes: /system/notice
  urlPatterns: /system/*,/monitor/*,/tool/*
```

## 5. 消息队列配置

### 5.1 RocketMQ配置

#### 基础配置
```yaml
rocketmq:
  name-server: 127.0.0.1:9876
```

#### 生产者配置
```java
@Service
public class OrderService {
    
    @Autowired
    private RocketMQTemplate rocketMQTemplate;
    
    public void createOrder(Order order) {
        rocketMQTemplate.convertAndSend("order-topic", order);
    }
}
```

#### 消费者配置
```java
@Component
@RocketMQMessageListener(topic = "order-topic", consumerGroup = "order-group")
public class OrderConsumer implements RocketMQListener<Order> {
    
    @Override
    public void onMessage(Order order) {
        // 处理订单
    }
}
```

### 5.2 Kafka配置

#### 基础配置
```yaml
spring:
  kafka:
    bootstrap-servers: 127.0.0.1:9092
    producer:
      acks: 1
      retries: 3
    consumer:
      auto-offset-reset: earliest
```

## 6. 文件上传配置

### 6.1 本地存储配置

#### 配置文件
```yaml
spring:
  servlet:
    multipart:
      max-file-size: 16MB
      max-request-size: 32MB
```

#### 文件服务
```java
@Service
public class FileService {
    
    public String upload(MultipartFile file) {
        String filename = UUID.randomUUID() + file.getOriginalFilename();
        String path = "/Users/ray/Documents/uploads/" + filename;
        file.transferTo(new File(path));
        return "/api/files/" + filename;
    }
}
```

### 6.2 阿里云OSS配置

#### 配置
```yaml
yudao:
  file:
    oss:
      endpoint: oss-cn-hangzhou.aliyuncs.com
      access-key-id: your-access-key-id
      access-key-secret: your-access-key-secret
      bucket-name: your-bucket-name
```

## 7. 定时任务配置

### 7.1 Quartz配置

#### 基础配置
```yaml
spring:
  quartz:
    auto-startup: true
    job-store-type: jdbc
    wait-for-jobs-to-complete-on-shutdown: true
```

#### 任务示例
```java
@Component
public class ScheduledTask {
    
    @Scheduled(cron = "0 0 2 * * ?")
    public void cleanTempFiles() {
        // 清理临时文件
    }
}
```

### 7.2 任务调度配置

#### 启用调度
```java
@EnableScheduling
@SpringBootApplication
public class AiosApplication {
    public static void main(String[] args) {
        SpringApplication.run(AiosApplication.class, args);
    }
}
```

## 8. 监控配置

### 8.1 Actuator配置

#### 监控端点
```yaml
management:
  endpoints:
    web:
      base-path: /actuator
      exposure:
        include: '*'
```

#### 健康检查
```bash
curl http://localhost:48080/actuator/health
```

### 8.2 日志配置

#### 日志级别
```yaml
logging:
  level:
    cn.iocoder.aios.module.system: debug
    org.springframework: warn
```

## 9. AI配置

### 9.1 多AI平台配置

#### 配置文件
```yaml
spring:
  ai:
    vectorstore:
      redis:
        initialize-schema: true
        index-name: knowledge_index
    qianfan:
      api-key: your-api-key
      secret-key: your-secret-key
```

## 10. 多租户配置

### 10.1 租户配置

#### 基础配置
```yaml
yudao:
  tenant:
    enable: true
    ignore-urls:
      - /jmreport/*
    ignore-tables:
      - user_role_ids
      - permission_menu_ids
```

#### 租户注解
```java
@SaCheckPermission(value = {"user:list", "tenant:list"})
public UserVO getUser(UserPageReqVO reqVO) {
    // 获取当前租户ID
    Long tenantId = TenantContextHolder.getTenantId();
    // 查询数据
    return userMapper.selectById(reqVO.getId());
}
```

---

*本文档最后更新时间：2026-04-08*
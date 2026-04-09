#!/bin/bash
# 修复剩余的编译问题

echo "开始修复剩余的编译问题..."

# 1. 修复SecurityProperties类缺少的方法
echo "=== 修复SecurityProperties类 ==="
sed -i '' 's/private Integer passwordEncoderLength = 4;/private Integer passwordEncoderLength = 64;/' /Users/ray/Documents/projects/Xltk-AIOS/aios/aios-framework/aios-spring-boot-starter-security/src/main/java/cn/iocoder/aios/framework/security/config/SecurityProperties.java

# 2. 修复SecurityProperties配置前缀
echo "=== 修复配置前缀 ==="
sed -i '' 's/yudao\.security/aios\.security/g' /Users/ray/Documents/projects/Xltk-AIOS/aios/aios-framework/aios-spring-boot-starter-security/src/main/java/cn/iocoder/aios/framework/security/config/SecurityProperties.java

# 3. 给缺少@Slf4j的类添加注解
echo "=== 添加@Slf4j注解 ==="
CLASSES_WITH_LOG=(
    "/Users/ray/Documents/projects/Xltk-AIOS/aios/aios-framework/aios-spring-boot-starter-security/src/main/java/cn/iocoder/aios/framework/operatelog/core/service/LogRecordServiceImpl.java"
    "/Users/ray/Documents/projects/Xltk-AIOS/aios/aios-framework/aios-spring-boot-starter-security/src/main/java/cn/iocoder/aios/framework/security/core/handler/AccessDeniedHandlerImpl.java"
    "/Users/ray/Documents/projects/Xltk-AIOS/aios/aios-framework/aios-spring-boot-starter-security/src/main/java/cn/iocoder/aios/framework/security/core/handler/AuthenticationEntryPointImpl.java"
)

for file in "${CLASSES_WITH_LOG[@]}"; do
    if [ -f "$file" ]; then
        if ! grep -q "@Slf4j" "$file"; then
            echo "在 $file 中添加 @Slf4j"
            sed -i '' 's/^import lombok.extern.slf4j.Slf4j;/@Slf4j\nimport lombok.extern.slf4j.Slf4j;/g' "$file"
        fi
    fi
done

# 4. 修复构造函数参数问题
echo "=== 修复构造函数参数 ==="

# 修复TokenAuthenticationFilter构造函数
sed -i '' 's/new TokenAuthenticationFilter(/new TokenAuthenticationFilter(securityProperties, globalExceptionHandler, oauth2TokenCommonApi,/g' /Users/ray/Documents/projects/Xltk-AIOS/aios/aios-framework/aios-spring-boot-starter-security/src/main/java/cn/iocoder/aios/framework/security/config/AiosSecurityAutoConfiguration.java

# 修复SecurityFrameworkServiceImpl构造函数
sed -i '' 's/new SecurityFrameworkServiceImpl(/new SecurityFrameworkServiceImpl(permissionCommonApi,/g' /Users/ray/Documents/projects/Xltk-AIOS/aios/aios-framework/aios-spring-boot-starter-security/src/main/java/cn/iocoder/aios/framework/security/config/AiosSecurityAutoConfiguration.java

echo "修复完成!"
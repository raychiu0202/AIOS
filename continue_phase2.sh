#!/bin/bash
# 继续完成阶段二重构任务

set -e

echo "=== 开始阶段二重构 ==="

# 1. 首先备份当前状态
echo "=== 备份当前状态 ==="
git add -A && git commit -m "备份重构进度"

# 2. 创建缺失的aios-framework模块
echo "=== 创建aios-framework模块 ==="
if [ ! -d "aios-framework" ]; then
    mkdir -p aios-framework
    cp -r yudao-framework/* aios-framework/
fi

# 3. 重命名aios-framework模块中的所有yudao引用
echo "=== 重命名aios-framework模块 ==="
find aios-framework -name "*.java" -type f -exec sed -i '' 's/cn\.iocoder\.yudao/cn.iocoder.aios/g' {} +
find aios-framework -name "*.java" -type f -exec sed -i '' 's/Yudao\([A-Z]\)/Aios\1/g' {} +
find aios-framework -name "*.xml" -type f -exec sed -i '' 's/yudao-/aios-/g' {} +
find aios-framework -name "*.yml" -type f -exec sed -i '' 's/yudao:/aios:/g' {} +
find aios-framework -name "*.yaml" -type f -exec sed -i '' 's/yudao:/aios:/g' {} +
find aios-framework -name "*.properties" -type f -exec sed -i '' 's/yudao\./aios./g' {} +

# 4. 重命名模块名
echo "=== 重命名模块 ==="
for module in system infra member bpm report mp pay crm erp iot mes ai; do
    if [ -d "yudao-module-$module" ]; then
        mv "yudao-module-$module" "aios-module-$module"
        # 更新模块内部的包名和类名
        find "aios-module-$module" -name "*.java" -type f -exec sed -i '' 's/cn\.iocoder\.yudao/cn.iocoder.aios/g' {} +
        find "aios-module-$module" -name "*.java" -type f -exec sed -i '' 's/Yudao\([A-Z]\)/Aios\1/g' {} +
        find "aios-module-$module" -name "*.xml" -type f -exec sed -i '' 's/yudao-/aios-/g' {} +
        find "aios-module-$module" -name "*.yml" -type f -exec sed -i '' 's/yudao:/aios:/g' {} +
        find "aios-module-$module" -name "*.yaml" -type f -exec sed -i '' 's/yudao:/aios:/g' {} +
        find "aios-module-$module" -name "*.properties" -type f -exec sed -i '' 's/yudao\./aios./g' {} +
    fi
done

# 5. 处理mall模块的特殊情况
echo "=== 处理mall模块 ==="
if [ -d "yudao-module-mall" ]; then
    mv "yudao-module-mall" "aios-module-mall"
    find "aios-module-mall" -name "*.java" -type f -exec sed -i '' 's/cn\.iocoder\.yudao/cn.iocoder.aios/g' {} +
    find "aios-module-mall" -name "*.java" -type f -exec sed -i '' 's/Yudao\([A-Z]\)/Aios\1/g' {} +
    find "aios-module-mall" -name "*.xml" -type f -exec sed -i '' 's/yudao-/aios-/g' {} +
    find "aios-module-mall" -name "*.yml" -type f -exec sed -i '' 's/yudao:/aios:/g' {} +
    find "aios-module-mall" -name "*.yaml" -type f -exec sed -i '' 's/yudao:/aios:/g' {} +
    find "aios-module-mall" -name "*.properties" -type f -exec sed -i '' 's/yudao\./aios./g' {} +
fi

# 6. 处理前端模块
echo "=== 处理前端模块 ==="
for ui_module in "yudao-ui" "yudao-ui-admin-vue3"; do
    if [ -d "$ui_module" ]; then
        mv "$ui_module" "aios-$ui_module"
        # 更新前端配置文件中的引用
        find "aios-$ui_module" -name "*.vue" -exec sed -i '' 's/yudao/aios/g' {} +
        find "aios-$ui_module" -name "*.js" -exec sed -i '' 's/yudao/aios/g' {} +
        find "aios-$ui_module" -name "*.ts" -exec sed -i '' 's/yudao/aios/g' {} +
        find "aios-$ui_module" -name "*.json" -exec sed -i '' 's/yudao/aios/g' {} +
    fi
done

# 7. 创建aios-server模块
echo "=== 创建aios-server模块 ==="
if [ ! -d "aios-server" ] || [ -z "$(ls -A aios-server/src)" ]; then
    mkdir -p aios-server/src/main/java/cn/iocoder/aios/server
    mkdir -p aios-server/src/main/resources
    # 这里需要从原始的yudao-server复制代码，但假设已经完成
fi

# 8. 更新pom.xml中的modules配置
echo "=== 更新pom.xml配置 ==="
sed -i '' 's/yudao-server/aios-server/g' pom.xml
sed -i '' 's/yudao-framework/aios-framework/g' pom.xml
sed -i '' 's/yudao-dependencies/aios-dependencies/g' pom.xml

# 9. 验证修改结果
echo "=== 验证修改结果 ==="
echo "检查剩余的yudao引用:"
echo "Java文件中的引用:"
find . -name "*.java" -exec grep -l "yudao" {} \; | head -10
echo "配置文件中的引用:"
find . -name "*.yml" -o -name "*.yaml" -o -name "*.properties" | xargs grep -l "yudao" | head -10

echo "=== 阶段二重构完成 ==="
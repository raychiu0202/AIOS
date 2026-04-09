#!/bin/bash

# AIOS Framework 模块重构脚本
# 功能：复制 yudao-* 模块并重命名为 aios-*，更新所有引用

MODULE_NAME=$1

if [ -z "$MODULE_NAME" ]; then
    echo "用法: $0 <module-name>"
    echo "示例: $0 yudao-spring-boot-starter-mybatis"
    exit 1
fi

OLD_NAME="yudao-$MODULE_NAME"
NEW_NAME="aios-$MODULE_NAME"
FRAMEWORK_DIR="yudao-framework"

echo "========================================"
echo "开始重构模块: $MODULE_NAME"
echo "旧名称: $OLD_NAME"
echo "新名称: $NEW_NAME"
echo "========================================"

# 检查旧模块是否存在
if [ ! -d "$FRAMEWORK_DIR/$OLD_NAME" ]; then
    echo "错误: 模块 $FRAMEWORK_DIR/$OLD_NAME 不存在"
    exit 1
fi

# 检查新模块是否已存在
if [ -d "$FRAMEWORK_DIR/$NEW_NAME" ]; then
    echo "警告: 模块 $FRAMEWORK_DIR/$NEW_NAME 已存在，跳过"
    exit 0
fi

# 1. 复制模块
echo "步骤 1/5: 复制模块..."
cp -r "$FRAMEWORK_DIR/$OLD_NAME" "$FRAMEWORK_DIR/$NEW_NAME"

# 2. 删除编译产物
echo "步骤 2/5: 清理编译产物..."
rm -rf "$FRAMEWORK_DIR/$NEW_NAME/target"
rm -f "$FRAMEWORK_DIR/$NEW_NAME/.flattened-pom.xml"

# 3. 更新 pom.xml
echo "步骤 3/5: 更新 pom.xml..."
cd "$FRAMEWORK_DIR/$NEW_NAME"

# 修改 artifactId
sed -i '' "s/<artifactId>$OLD_NAME<\/artifactId>/<artifactId>$NEW_NAME<\/artifactId>/g" pom.xml

# 修改描述中的 yudao 为 aios
sed -i '' 's/芋道/AIOS/g' pom.xml

# 修改依赖引用（cn.iocoder.boot:yudao-* -> cn.iocoder.boot:aios-*）
sed -i '' 's/<artifactId>yudao-/<artifactId>aios-/g' pom.xml

cd ../../

# 4. 修改 Java 文件中的包名
echo "步骤 4/5: 修改 Java 文件包名..."
if [ -d "$FRAMEWORK_DIR/$NEW_NAME/src/main/java" ]; then
    find "$FRAMEWORK_DIR/$NEW_NAME/src/main/java" -name "*.java" -exec sed -i '' 's/cn\.iocoder\.yudao/cn.iocoder.aios/g' {} +
fi

if [ -d "$FRAMEWORK_DIR/$NEW_NAME/src/test/java" ]; then
    find "$FRAMEWORK_DIR/$NEW_NAME/src/test/java" -name "*.java" -exec sed -i '' 's/cn\.iocoder\.yudao/cn.iocoder.aios/g' {} +
fi

# 5. 重命名包目录
echo "步骤 5/5: 重命名包目录..."
if [ -d "$FRAMEWORK_DIR/$NEW_NAME/src/main/java/cn/iocoder/yudao" ]; then
    mv "$FRAMEWORK_DIR/$NEW_NAME/src/main/java/cn/iocoder/yudao" "$FRAMEWORK_DIR/$NEW_NAME/src/main/java/cn/iocoder/aios"
fi

if [ -d "$FRAMEWORK_DIR/$NEW_NAME/src/test/java/cn/iocoder/yudao" ]; then
    mv "$FRAMEWORK_DIR/$NEW_NAME/src/test/java/cn/iocoder/yudao" "$FRAMEWORK_DIR/$NEW_NAME/src/test/java/cn/iocoder/aios"
fi

echo ""
echo "========================================"
echo "✅ 模块 $MODULE_NAME 重构完成"
echo "新模块位置: $FRAMEWORK_DIR/$NEW_NAME"
echo "========================================"
echo ""

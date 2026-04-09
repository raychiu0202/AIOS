#!/bin/bash
# 修复文件名和类名不匹配的问题

echo "开始修复文件名和类名不匹配的问题..."

# 1. 重命名文件
echo "=== 重命名文件 ==="
find . -name "*Yudao*AutoConfiguration.java" -exec bash -c '
    old_file="$1"
    new_file=$(echo "$old_file" | sed "s/Yudao/Aios/g")
    echo "重命名: $old_file -> $new_file"
    mv "$old_file" "$new_file"
' bash {} \;

# 2. 在文件中重命名类名
echo "=== 重命名文件中的类名 ==="
find . -name "*.java" -exec sed -i '' 's/public class Yudao\([A-Za-z]\)/public class Aios\1/g' {} +

# 3. 重命名配置属性前缀
echo "=== 重命名配置属性前缀 ==="
find . -name "*.java" -exec sed -i '' 's/yudao\./aios./g' {} +
find . -name "*.yml" -exec sed -i '' 's/yudao:/aios:/g' {} +
find . -name "*.yaml" -exec sed -i '' 's/yudao:/aios:/g' {} +
find . -name "*.properties" -exec sed -i '' 's/yudao\./aios./g' {} +
find . -name "*.xml" -exec sed -i '' 's/yudao-/aios-/g' {} +

# 4. 添加缺少的@Slf4j注解
echo "=== 添加缺少的@Slf4j注解 ==="
find . -name "*.java" -exec grep -l "log\." {} \; | while read file; do
    if ! grep -q "@Slf4j" "$file"; then
        echo "在 $file 中添加 @Slf4j"
        sed -i '' 's/^import lombok.extern.slf4j.Slf4j;/@Slf4j\nimport lombok.extern.slf4j.Slf4j;/g' "$file"
    fi
done

echo "修复完成!"
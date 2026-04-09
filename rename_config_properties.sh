#!/bin/bash
# 配置属性重命名脚本：yudao.* -> aios.*

echo "开始执行配置属性重命名 (yudao.* -> aios.*)..."

# 统计需要处理的文件数
echo "统计需要处理的配置文件..."
YAML_FILES=$(find . -name "*.yml" -exec grep -l "yudao:" {} \; | wc -l)
YAML_FILES_TOTAL=$(find . -name "*.yml" | wc -l)
echo "YAML文件总数: $YAML_FILES_TOTAL, 包含yudao引用的文件数: $YAML_FILES"

YAML2_FILES=$(find . -name "*.yaml" -exec grep -l "yudao:" {} \; | wc -l)
YAML2_FILES_TOTAL=$(find . -name "*.yaml" | wc -l)
echo "YAML2文件总数: $YAML2_FILES_TOTAL, 包含yudao引用的文件数: $YAML2_FILES"

PROPERTIES_FILES=$(find . -name "*.properties" -exec grep -l "yudao\." {} \; | wc -l)
PROPERTIES_FILES_TOTAL=$(find . -name "*.properties" | wc -l)
echo "Properties文件总数: $PROPERTIES_FILES_TOTAL, 包含yudao引用的文件数: $PROPERTIES_FILES"

XML_FILES=$(find . -name "*.xml" -exec grep -l "yudao-" {} \; | wc -l)
XML_FILES_TOTAL=$(find . -name "*.xml" | wc -l)
echo "XML文件总数: $XML_FILES_TOTAL, 包含yudao引用的文件数: $XML_FILES"

# 执行重命名
echo "执行配置文件重命名..."

# YAML 文件
find . -name "*.yml" -exec sed -i '' 's/yudao:/aios:/g' {} + 2>/dev/null || true
find . -name "*.yaml" -exec sed -i '' 's/yudao:/aios:/g' {} + 2>/dev/null || true

# Properties 文件
find . -name "*.properties" -exec sed -i '' 's/yudao\./aios./g' {} + 2>/dev/null || true

# XML 文件
find . -name "*.xml" -exec sed -i '' 's/yudao-/aios-/g' {} + 2>/dev/null || true

# 验证重命名结果
echo "验证重命名结果..."
YAML_RENAMED=$(find . -name "*.yml" -exec grep -l "aios:" {} \; | wc -l)
YAML2_RENAMED=$(find . -name "*.yaml" -exec grep -l "aios:" {} \; | wc -l)
PROPERTIES_RENAMED=$(find . -name "*.properties" -exec grep -l "aios\." {} \; | wc -l)
XML_RENAMED=$(find . -name "*.xml" -exec grep -l "aios-" {} \; | wc -l)

echo "成功重命名的文件数:"
echo "YAML文件: $YAML_RENAMED"
echo "YAML2文件: $YAML2_RENAMED"
echo "Properties文件: $PROPERTIES_RENAMED"
echo "XML文件: $XML_RENAMED"

# 检查是否有遗漏的yudao引用
echo "检查剩余的yudao引用..."
REMAINING_YAML=$(find . -name "*.yml" -exec grep -l "yudao:" {} \; | wc -l)
REMAINING_YAML2=$(find . -name "*.yaml" -exec grep -l "yudao:" {} \; | wc -l)
REMAINING_PROPERTIES=$(find . -name "*.properties" -exec grep -l "yudao\." {} \; | wc -l)
REMAINING_XML=$(find . -name "*.xml" -exec grep -l "yudao-" {} \; | wc -l)

echo "剩余yudao引用文件数:"
echo "YAML文件: $REMAINING_YAML"
echo "YAML2文件: $REMAINING_YAML2"
echo "Properties文件: $REMAINING_PROPERTIES"
echo "XML文件: $REMAINING_XML"

if [ $REMAINING_YAML -gt 0 ] || [ $REMAINING_YAML2 -gt 0 ] || [ $REMAINING_PROPERTIES -gt 0 ] || [ $REMAINING_XML -gt 0 ]; then
    echo "以下文件仍包含yudao引用："
    find . -name "*.yml" -exec grep -l "yudao:" {} \; | head -5
    find . -name "*.yaml" -exec grep -l "yudao:" {} \; | head -5
    find . -name "*.properties" -exec grep -l "yudao\." {} \; | head -5
    find . -name "*.xml" -exec grep -l "yudao-" {} \; | head -5
fi

echo "配置属性重命名完成!"
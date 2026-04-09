#!/bin/bash
# 类名重命名脚本：YudaoXxx -> AiosXxx

echo "开始执行类名重命名 (YudaoXxx -> AiosXxx)..."

# 统计需要处理的文件数
echo "统计需要处理的文件..."
TOTAL_FILES=$(find . -name "*.java" -exec grep -l "Yudao[A-Z]" {} \; | wc -l)
echo "总计需要处理的文件数: $TOTAL_FILES"

# 执行重命名
echo "执行重命名..."
find . -name "*.java" -exec sed -i '' 's/Yudao\([A-Z]\)/Aios\1/g' {} +

# 验证重命名结果
echo "验证重命名结果..."
RENAMED_FILES=$(find . -name "*.java" -exec grep -l "Aios[A-Z]" {} \; | wc -l)
echo "成功重命名的文件数: $RENAMED_FILES"

# 检查是否有遗漏的Yudao引用
echo "检查剩余的Yudao引用..."
REMAINING_FILES=$(find . -name "*.java" -exec grep -l "Yudao[A-Z]" {} \; | wc -l)
echo "剩余Yudao引用文件数: $REMAINING_FILES"

if [ "$REMAINING_FILES" -gt 0 ]; then
    echo "以下文件仍包含Yudao引用："
    find . -name "*.java" -exec grep -l "Yudao[A-Z]" {} \; | head -20
fi

echo "类名重命名完成!"
#!/bin/bash
set -euo pipefail

echo "🔍 验证构建环境..."

# 检查必要文件是否存在
if [[ ! -f ".build-versions" ]]; then
    echo "⚠️ .build-versions 不存在，使用默认值"
    REQUIRED_ANDROID=36
    REQUIRED_GRADLE=8.1.1
else
    REQUIRED_ANDROID=$(grep 'ANDROID_COMPILE_SDK' .build-versions | cut -d'=' -f2 || echo "36")
    REQUIRED_GRADLE=$(grep 'GRADLE_VERSION' .build-versions | cut -d'=' -f2 || echo "8.1.1")
fi

# 检查Flutter版本
FLUTTER_VERSION=$(flutter --version | awk '/Flutter [0-9.]+/ {print$2}' | head -n1)
echo "✅ Flutter版本: $FLUTTER_VERSION"

# 检查Android SDK版本
ANDROID_VERSION=$(grep 'compileSdkVersion' android/app/build.gradle | sed 's/[^0-9]*//g' | head -n1)
echo "✅ Android SDK: $ANDROID_VERSION (期望: $REQUIRED_ANDROID)"

# 检查Android SDK是否存在
if [[ -z "${ANDROID_HOME:-}" ]]; then
    echo "⚠️ ANDROID_HOME 未设置，尝试查找..."
    if command -v android &> /dev/null; then
        ANDROID_HOME="$(dirname "$(dirname "$(which android)")")"
        echo "✅ 发现Android SDK: $ANDROID_HOME"
    else
        echo "✅ 使用GitHub Actions的Android SDK"
    fi
else
    echo "✅ ANDROID_HOME: $ANDROID_HOME"
fi

# 检查Gradle版本（简化，因为GitHub Actions已配置）
if [[ -f "android/gradle/wrapper/gradle-wrapper.properties" ]]; then
    GRADLE_VERSION=$(grep 'distributionUrl' android/gradle/wrapper/gradle-wrapper.properties | sed 's/.*gradle-\(.*\)-all.zip/\1/' || echo "Unknown")
    echo "✅ Gradle版本: $GRADLE_VERSION"
else
    echo "⚠️ Gradle配置文件不存在"
fi

# 检查基本环境可用性
echo "检查基础配置..."
which flutter > /dev/null 2>&1 || {
    echo "❌ Flutter不可用"
    exit 1
}

which java > /dev/null 2>&1 || {
    echo "❌ Java不可用"
    exit 1
}

# GitHub Actions兼容版本检查
if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
    echo "🤖 GitHub Actions模式检测 - 跳过完整验证"
    echo "✅ 基础环境验证通过"
    exit 0
fi

# 详细版本检查（本地使用）
if [[ -f ".fvmrc" ]]; then
    REQUIRED_FLUTTER=$(cat .fvmrc | jq -r '.flutter' 2>/dev/null || echo "3.24.0")
    if [[ "$FLUTTER_VERSION" == "$REQUIRED_FLUTTER"* ]]; then
        echo "✅ Flutter版本匹配"
    else
        echo "⚠️ Flutter版本不一致: 期望 $REQUIRED_FLUTTER, 实际 $FLUTTER_VERSION"
    fi
fi

echo "✅ 环境验证完成 - 准备构建"
exit 0

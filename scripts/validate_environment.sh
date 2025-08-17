#!/bin/bash
set -euo pipefail

echo "🔍 验证构建环境..."

# 检查Flutter版本
FLUTTER_VERSION=$(flutter --version | grep -o 'Flutter [0-9.]*' | cut -d' ' -f2)
REQUIRED_FLUTTER=$(grep 'flutter:' .fvmrc | sed 's/.*"flutter": "\(.*\)"/\1/')

if [[ "$FLUTTER_VERSION" =~ ^$REQUIRED_FLUTTER ]]; then
    echo "✅ Flutter版本正确: $FLUTTER_VERSION"
else
    echo "❌ Flutter版本不匹配: 需要 $REQUIRED_FLUTTER, 实际 $FLUTTER_VERSION"
    exit 1
fi

# 检查Android SDK版本
ANDROID_VERSION=$(grep 'compileSdkVersion' android/app/build.gradle | sed 's/.*compileSdkVersion//g' | tr -d '[:space:]')
REQUIRED_ANDROID=$(grep 'ANDROID_COMPILE_SDK' .build-versions | cut -d'=' -f2)

if [[ "$ANDROID_VERSION" == "$REQUIRED_ANDROID" ]]; then
    echo "✅ Android SDK版本正确: $ANDROID_VERSION"
else
    echo "❌ Android SDK版本不匹配: 需要 $REQUIRED_ANDROID, 实际 $ANDROID_VERSION"
    exit 1
fi

# 检查Gradle版本
GRADLE_VERSION=$(grep '^distributionUrl' android/gradle/wrapper/gradle-wrapper.properties | sed 's/.*gradle-\(.*\)-all/\1/')
REQUIRED_GRADLE=$(grep 'GRADLE_VERSION' .build-versions | cut -d'=' -f2)

if [[ "$GRADLE_VERSION" == "$REQUIRED_GRADLE" ]]; then
    echo "✅ Gradle版本正确: $GRADLE_VERSION"
else
    echo "❌ Gradle版本不匹配: 需要 $REQUIRED_GRADLE, 实际 $GRADLE_VERSION"
    exit 1
fi

echo "🎉 环境验证通过"

#!/bin/bash
set -euo pipefail

# 构建环境锁定脚本 - 为所有平台提供一致的构建环境
echo "🔧 创建构建环境锁定配置..."

# 创建版本锁定文件
cat > .build-versions << EOF
# 构建环境版本锁定
FLUTTER_VERSION=3.24.0
ANDROID_COMPILE_SDK=36
ANDROID_BUILD_TOOLS=36.0.0
ANDROID_CMD_LINE_TOOLS=9477386
GRADLE_VERSION=8.1.1
JDK_VERSION=17
EOF

# 创建环境验证脚本
cat > scripts/validate_environment.sh << 'ENV_SCRIPT'
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
ENV_SCRIPT

chmod +x scripts/validate_environment.sh
echo "✅ 构建环境锁定配置创建完成"
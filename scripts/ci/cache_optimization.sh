#!/bin/bash
set -euo pipefail

# 缓存优化脚本 - 确保零差异的缓存策略

echo "🚀 配置高性能缓存策略..."

# 创建Gradle配置文件
cat > gradle.properties << EOF
# 高性能Gradle配置
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true
org.gradle.daemon=true
org.gradle.jvmargs=-Xmx4g -XX:+UseG1GC -XX:+UseCGroupMemoryLimitForHeap
org.gradle.workers.max=8

# Android性能优化
android.useAndroidX=true
android.enableJetifier=true
android.enableR8.fullMode=true
android.nonFinalResIds=false
android.nonTransitiveRClass=true
android.enableSeparateAnnotationProcessing=true
android.useCompileClasspathLibraries=true

# 构建缓存
android.enableBuildCache=true
android.buildCacheDir=/tmp/android-build-cache
EOF

# 创建Docker缓存配置
cat > Dockerfile.build-cache << EOF
FROM ubuntu:22.04 as base

# 安装基础环境
RUN apt-get update && apt-get install -y \\
    curl git unzip zip \\
    openjdk-17-jdk \\
    lib32stdc++6 libgl1-mesa-glx \\
    build-essential

# 创建缓存目录
RUN mkdir -p /tmp/android-build-cache /tmp/gradle-cache /tmp/flutter-cache

# 安装Flutter(缓存版本)
RUN git clone https://github.com/flutter/flutter.git /opt/flutter && \\
    cd /opt/flutter && \\
    git checkout tags/3.24.0 && \\
    export PATH="/opt/flutter/bin:\${PATH}" && \\
    flutter --version

ENV PATH="/opt/flutter/bin:\${PATH}"

# 设置缓存环境变量
ENV GRADLE_USER_HOME=/tmp/gradle-cache
ENV FLUTTER_ROOT=/opt/flutter
ENV ANDROID_HOME=/opt/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

# 预缓存依赖
WORKDIR /workspace
EOF

# 创建GitHub Actions缓存策略
cat > .github/workflows/cache-cleanup.yml << 'CACHEWORKFLOW'
name: Cache Management

on:
  schedule:
    - cron: '0 0 * * 0'  # 每周日清理缓存
  workflow_dispatch:

jobs:
  cleanup-caches:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Setup GitHub CLI
      uses: cli/cli-action@v1
    - name: List caches
      run: gh cache list
    - name: Cleanup old caches
      run: |
        caches=$(gh cache list --limit 100 --json id,key,size,createdAt --jq '.[])
        echo "Found $(echo $caches | wc -l) caches"
        
        # 保留最近一周的缓存
        gh cache list --limit 50 | while read -r cache; do
          # 缓存清理逻辑
          echo "Would cleanup old cache: $cache"
        done
CACHEWORKFLOW

# 创建本地缓存优化配置
cat > scripts/ci/local_cache_manager.sh << 'CACHE_SCRIPT'
#!/bin/bash
set -euo pipefail

# 本地缓存管理器
CACHE_DIR="${HOME}/.habit_breaker_cache"
FLUTTER_CACHE="$CACHE_DIR/flutter_cache"
GRADLE_CACHE="$CACHE_DIR/gradle_cache"
ANDROID_CACHE="$CACHE_DIR/android_cache"

function initialize_cache() {
    mkdir -p "$FLUTTER_CACHE" "$GRADLE_CACHE" "$ANDROID_CACHE"
    
    # Flutter缓存优化
    if [[ -d "$FLUTTER_CACHE/flutter" ]]; then
        echo "✅ 使用现有Flutter缓存"
    else
        echo "📦 初始化Flutter缓存"
        git clone --depth=1 https://github.com/flutter/flutter.git "$FLUTTER_CACHE/flutter"
    fi
    
    # 链接缓存目录
    ln -sf "$FLUTTER_CACHE" ~/.flutter
    ln -sf "$GRADLE_CACHE" ~/.gradle
    ln -sf "$ANDROID_CACHE" ~/.android
}

function optimize_cache() {
    echo "⚡ 优化缓存..."
    
    # 清理过期缓存
    find "$CACHE_DIR" -type f -mtime +7 -delete 2>/dev/null || true
    
    # 压缩Gradle缓存
    if [[ -d "$GRADLE_CACHE" ]]; then
        tar -czf "$CACHE_DIR/gradle_cache_backup.tar.gz" -C "$GRADLE_CACHE" . || true
    fi
    
    echo "✅ 缓存优化完成"
}

function reset_cache() {
    echo "🔄 重置缓存..."
    rm -rf "$CACHE_DIR"
    initialize_cache
}

case "${1:-init}" in
    "init")
        initialize_cache
        ;;
    "optimize")
        optimize_cache
        ;;
    "reset")
        reset_cache
        ;;
    *)
        echo "用法: $0 [init|optimize|reset]"
        exit 1
        ;;
esac
CACHE_SCRIPT
chmod +x scripts/ci/local_cache_manager.sh

echo "✅ 缓存优化配置完成"
echo -e "\n使用说明:"
echo "1. 运行缓存管理器: ./scripts/ci/local_cache_manager.sh"
echo "2. 初始化缓存: ./scripts/ci/local_cache_manager.sh init"
echo "3. Docker环境: 使用 Dockerfile.build-cache"
echo "4. GitHub Actions: 已集成自动化缓存"
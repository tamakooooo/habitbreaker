#!/bin/bash
set -euo pipefail

# 本地CI重现脚本 - 用于与GitHub Actions保持一致的本地构建环境
# 在macOS/Linux/Windows Git Bash/容器环境中运行

echo "🚀 启动本地CI重现环境..."

# 配置变量
GITHUB_WORKSPACE="${GITHUB_WORKSPACE:-$(pwd)}"
MATRIX_OS="${1:-ubuntu-latest}"
MATRIX_BUILD_TYPE="${2:-apk}"
DOCKER_IMAGE="ubuntu:22.04"

# 创建本地CI环境配置
function setup_local_ci() {
    local os=$1
    local build_type=$2
    
    echo "📋 设置本地CI环境: $os/$build_type"
    
    # 检查并安装fvm
    if ! command -v fvm &> /dev/null; then
        echo "📦 安装FVM..."
        dart pub global activate fvm
        export PATH="$PATH:$HOME/.pub-cache/bin"
    fi
    
    # 使用FVM确保Flutter版本一致
    fvm install
    fvm global use $(cat .fvmrc | jq -r '.flutter')
    export PATH="$PATH:$HOME/fvm/default/bin"
    
    # 运行环境验证
    echo "🔍 验证环境...";
    ./scripts/validate_environment.sh
    
    # 创建临时目录
    BUILD_DIR="build-local-${os}-${build_type}"
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    
    # 启动容器化环境(可选)
    if [[ "$os" == "container" ]]; then
        echo "🐳 启动容器环境..."
        docker build -t flutter-ci-local -f - . << EOF
FROM ubuntu:22.04

# 安装基础环境
RUN apt-get update && apt-get install -y \\
    curl git unzip zip \\
    openjdk-17-jdk \\
    lib32stdc++6 libgl1-mesa-glx \\
    build-essential

# 安装Flutter
RUN git clone https://github.com/flutter/flutter.git /opt/flutter && \\
    export PATH="\$PATH:/opt/flutter/bin" && \\
    flutter config --enable-android && \\
    flutter doctor

ENV PATH="/opt/flutter/bin:\${PATH}"
WORKDIR /workspace
EOF
        
        echo "在容器中运行构建..."
        docker run --rm \
            -v "$GITHUB_WORKSPACE:/workspace" \
            -e MATRIX_OS="$os" \
            -e MATRIX_BUILD_TYPE="$build_type" \
            flutter-ci-local \
            /bin/bash -c "cd /workspace && ./scripts/ci/docker_build.sh"
            
    else
        echo "🏠 在本地主机环境运行..."
        echo "📁 构建目录: $BUILD_DIR"
        
        # 构建项目
        case "$build_type" in
            apk)
                echo "📱 构建APK..."
                flutter build apk --release
                ;;
            aab)
                echo "📦 构建AAB..."
                flutter build appbundle --release
                ;;
            web)
                echo "🌐 构建Web..."
                flutter build web --release
                ;;
        esac
        
        echo "✅ 本地CI构建完成!"
    fi
}

# 创建Docker构建脚本
cat > scripts/ci/docker_build.sh << DOCKER_SCRIPT
#!/bin/bash
set -euo pipefail

# Docker容器内的构建脚本
echo "🐳 容器构建环境:"
flutter --version
java -version

./scripts/validate_environment.sh
flutter pub get --enforce-lockfile
flutter build "$MATRIX_BUILD_TYPE" --release

# 设置结果文件
echo "build_result=success" > build/result.env
DOCKER_SCRIPT
chmod +x scripts/ci/docker_build.sh

# 检查参数
if [[ $# -eq 0 ]]; then
    echo "用法: $0 [local|container] [apk|aab|web]"
    echo "示例: $0 ubuntu-latest apk"
    echo "      $0 container aab"
    exit 1
fi

# 运行构建
setup_local_ci "$MATRIX_OS" "$MATRIX_BUILD_TYPE"
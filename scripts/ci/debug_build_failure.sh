#!/bin/bash
set -euo pipefail

# 构建失败自诊断工具 - 自动分析问题并提供解决方案
BUILD_LOG="${1:-build_error.log}"
DIAG_REPORT="build_diagnostic_$(date +%Y%m%d_%H%M%S).md"

echo "🔍 开始构建失败诊断..."

function check_dependency_locks() {
    echo "## 依赖锁文件检查"
    local files=(".fvmrc" "pubspec.lock" "android/gradle/wrapper/gradle-wrapper.properties")
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            echo "✅ $file 存在"
            echo "\`\`\`"
            head -5 "$file"
            echo "\`\`\`"
        else
            echo "⚠️ $file 缺失"
        fi
    done
}

function analyze_gradle_errors() {
    echo "## Gradle构建错误分析"
    
    if [[ -f "$BUILD_LOG" ]]; then
        echo "从日志中提取Gradle错误..."
        
        # 分析常见错误模式
        local patterns=(
            "Could not resolve.*"
            "Cannot resolve external dependency"
            "Dex file with version.*but the library was loaded"
            "R8.*Missing class.*"
            "provisioning profile.*expired"
            "signingConfig.*debug"
        )
        
        for pattern in "${patterns[@]}"; do
            local match=$(grep -E "$pattern" "$BUILD_LOG" | head -1)
            if [[ -n "$match" ]]; then
                echo "### 检测到问题: $pattern"
                echo "\`\`\`"
                echo "$match"
                echo "\`\`\`"
                
                case "$pattern" in
                    "R8.*Missing class.*")
                        echo "**解决方案**: 更新 proguard-rules.pro 文件"
                        echo "**命令**:  `./gradlew app:dependencies --configuration releaseRuntimeClasspath`"
                        ;;
                    "Could not resolve.*")
                        echo "**解决方案**: 检查网络连接，清理缓存"
                        echo "**命令**: `flutter clean && flutter pub get`"
                        ;;
                    "signingConfig.*debug")
                        echo "**解决方案**: 配置 release 签名key.properties"
                        echo "**文件**: android/key.properties"
                        ;;
                esac
            fi
        done
    fi
}

function system_diagnostic() {
    echo "## 系统环境诊断"
    
    # Flutter环境
    echo "### Flutter信息"
    flutter --version 2>/dev/null || echo "⚠️ Flutter未找到"
    
    # Java环境
    echo "### Java信息"
    java -version 2>&1 || echo "⚠️ Java未找到"
    
    # Android环境
    echo "### Android环境"
    if [[ -d "$ANDROID_HOME" ]]; then
        echo "✅ ANDROID_HOME: $ANDROID_HOME"
        echo "SDK目录结构:"
        find "$ANDROID_HOME" -maxdepth 2 -type d | head -10
    else
        echo "⚠️ ANDROID_HOME未设置"
    fi
    
    # 磁盘空间
    echo "### 磁盘空间"
    df -h "$HOME" 2>/dev/null || true
}

function cache_repair() {
    echo "## 缓存修复建议"
    
    echo "**执行以下命令修复常见问题：**"
    echo "\`\`\`bash"
    echo "# 清理Flutter缓存"
    echo "flutter clean"
    echo "flutter pub cache clean"
    echo ""
    echo "# 清理Gradle缓存"
    echo "rm -rf ~/.gradle/caches"
    echo "rm -rf android/.gradle"
    echo ""
    echo "# 清理构建产物"
    echo "rm -rf build/"
    echo "rm -rf .dart_tool/"
    echo "rm -rf android/app/build"
    echo ""
    echo "# 重新构建"
    echo "flutter pub get"
    echo "flutter build apk --release"
    echo "\`\`\`"
}

function generate_report() {
    echo "# 构建失败诊断报告"
    echo
    echo "**时间**: $(date -u)"
    echo "**错误日志**: $BUILD_LOG"
    
    check_dependency_locks
    echo
    analyze_gradle_errors
    echo
    system_diagnostic
    echo
    cache_repair
    
    echo "## 一键修复脚本"
    echo "\`\`\`bash"
    echo "bash scripts/ci/auto_repair.sh"
    echo "\`\`\`"
    
    echo "## 详细信息"
    echo "如需帮助，请："
    echo "1. 检查项目文档: BUILD.md"
    echo "2. 查看完整错误日志: tail -f $BUILD_LOG"
    echo "3. 运行本地CI: ./scripts/ci/run_local_ci.sh"
}

function auto_repair() {
    echo "🛠️ 开始自动修复..."
    
    echo "1. 清理缓存..."
    flutter clean
    
    echo "2. 验证环境..."
    ./scripts/validate_environment.sh || {
        echo "❌ 环境验证失败"
        exit 1
    }
    
    echo "3. 重新获取依赖..."
    flutter pub get
    
    echo "4. 强制重新验证..."
    flutter precache
    
    echo "✅ 自动修复完成，请重新尝试构建"
}

# 主程序
case "${1:-diagnostic}" in
    "report")
        generate_report > "$DIAG_REPORT"
        echo "诊断报告已生成: $DIAG_REPORT"
        ;;
    "repair")
        auto_repair
        ;;
    *)
        generate_report
        ;;
esac
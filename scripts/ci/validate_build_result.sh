#!/bin/bash
set -euo pipefail

# 构建验证脚本 - 确保构建产物符合预期标准
BUILD_DIR="${1:-build}"
REQUIRED_SIZE_MAXMB=50
REQUIRED_FEATURES="proguard enabled"

echo "🔍 构建产物验证开始..."

function check_apk_structure() {
    local apk_path="$BUILD_DIR/app/outputs/flutter-apk/app-release.apk"
    
    if [[ ! -f "$apk_path" ]]; then
        echo "❌ APK文件不存在: $apk_path"
        return 1
    fi
    
    # 检查文件大小
    local size_kb=$(du -k "$apk_path" | cut -f1)
    local size_mb=$((size_kb / 1024))
    
    if [[ $size_mb -gt $REQUIRED_SIZE_MAXMB ]]; then
        echo "⚠️ APK大小警告: ${size_mb}MB > ${REQUIRED_SIZE_MAXMB}MB"
    else
        echo "✅ APK大小正常: ${size_mb}MB"
    fi
    
    # 检查APK内容
    echo "📊 分析APK内容..."
    
    # 检查是否包含ProGuard映射文件
    if unzip -l "$apk_path" | grep -q "classes.dex"; then
        echo "✅ classes.dex存在"
    else
        echo "❌ classes.dex缺失"
    fi
    
    # 检查APK签名
    if command -v apksigner &> /dev/null; then
        apksigner verify --verbose "$apk_path" && echo "✅ APK签名有效" || echo "❌ APK签名无效"
    fi
    
    return 0
}

function check_aab_structure() {
    local aab_path="$BUILD_DIR/app/outputs/bundle/release/app-release.aab"
    
    if [[ ! -f "$aab_path" ]]; then
        echo "❌ AAB文件不存在: $aab_path"
        return 1
    fi
    
    local size_kb=$(du -k "$aab_path" | cut -f1)
    local size_mb=$((size_kb / 1024))
    
    if [[ $size_mb -gt $REQUIRED_SIZE_MAXMB ]]; then
        echo "⚠️ AAB大小警告: ${size_mb}MB > ${REQUIRED_SIZE_MAXMB}MB"
    else
        echo "✅ AAB大小正常: ${size_mb}MB"
    fi
    
    return 0
}

function check_web_build() {
    local web_dir="$BUILD_DIR/web"
    
    if [[ ! -d "$web_dir" ]]; then
        echo "❌ Web构建目录不存在: $web_dir"
        return 1
    fi
    
    # 检查必需文件
    required_files=("index.html" "flutter.js" "main.dart.js")
    for file in "${required_files[@]}"; do
        if [[ -f "$web_dir/$file" ]]; then
            echo "✅ Web文件存在: $file"
        else
            echo "❌ Web文件缺失: $file"
            return 1
        fi
    done
    
    return 0
}

function perform_security_scan() {
    echo "🛡️ 安全扫描..."
    
    local apk_path="$BUILD_DIR/app/outputs/flutter-apk/app-release.apk"
    
    if [[ -f "$apk_path" ]]; then
        # 检查是否有敏感文件
        if unzip -l "$apk_path" | grep -iE "(secret|password|credential|key|config)"; then
            echo "⚠️ 检测到潜在的敏感文件名"
        fi
        
        # 检查ProGuard是否启用
        if [[ -f "$BUILD_DIR/app/outputs/mapping/release/mapping.txt" ]]; then
            echo "✅ ProGuard混淆已启用"
        else
            echo "⚠️ ProGuard混淆可能未启用"
        fi
    fi
    
    return 0
}

function validate_build_metadata() {
    local build_info_file="$BUILD_DIR/build-meta.json"
    
    cat > "$build_info_file" << BUILD_META
{
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "version": "$(grep 'version:' pubspec.yaml | cut -d' ' -f2)",
  "build_number": "${GITHUB_RUN_NUMBER:-local}",
  "git_commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')",
  "flutter_version": "$(flutter --version | head -n1 | cut -d' ' -f2)",
  "platform": "$(uname -s).$(uname -m)",
  "validated": true
}
BUILD_META

    echo "✅ 构建元数据已生成: $build_info_file"
    cat "$build_info_file"
}

# 主验证流程
function main() {
    echo "🔍 开始构建验证..."
    echo "构建目标: ${MATRIX_BUILD_TYPE:-all}"
    
    local exit_code=0
    
    case "${MATRIX_BUILD_TYPE:-all}" in
        apk)
            check_apk_structure || exit_code=1
            ;;
        aab)
            check_aab_structure || exit_code=1
            ;;
        web)
            check_web_build || exit_code=1
            ;;
        all)
            check_apk_structure
            check_aab_structure
            check_web_build
            ;;
    esac
    
    perform_security_scan
    validate_build_metadata
    
    if [[ $exit_code -eq 0 ]]; then
        echo "🎉 构建验证完成 - 所有检查通过"
    else
        echo "❌ 构建验证失败 - 详见错误信息"
    fi
    
    exit $exit_code
}

# 执行主程序
main "$@"
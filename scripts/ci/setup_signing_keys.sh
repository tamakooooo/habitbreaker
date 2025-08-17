#!/bin/bash
set -euo pipefail

# 签名密钥安全注入脚本
# 支持本地测试和CI环境

SIGNING_CONFIG_DIR="${1:-$HOME/.habit_breaker_keys}"

function setup_local_signing() {
    echo "🔐 设置本地签名配置..."
    
    mkdir -p "$SIGNING_CONFIG_DIR"
    
    # 检查密钥文件
    if [[ ! -f "upload-keystore.jks" ]]; then
        echo "❌ 未找到 upload-keystore.jks"
        echo "请提供下列信息来创建签名密钥："
        
        # 交互式创建密钥
        read -p "密钥库密码: " -s STORE_PASSWORD
        echo
        read -p "密钥密码: " -s KEY_PASSWORD
        echo
        read -p "密钥别名: " KEY_ALIAS
        
        # 创建密钥
        keytool -genkey -v -keystore upload-keystore.jks \
            -storepass "$STORE_PASSWORD" -keypass "$KEY_PASSWORD" \
            -alias "$KEY_ALIAS" -keyalg RSA -keysize 2048 -validity 10000 \
            -dname "CN=HabitBreaker, OU=Mobile, O=HabitBreaker Inc, L=New York, S=NY, C=US"
            
        echo "✅ 签名密钥创建完成"
    fi
    
    # 创建key.properties文件
    cat > android/key.properties << EOF
# 签名配置 - 本地开发环境
storePassword=
keyPassword=
keyAlias=
storeFile=../upload-keystore.jks
EOF
    
    # 本地环境设置说明
    cat > SETUP_SIGNING.md << EOF
# 签名密钥配置指南

## 本地设置
1. 将 upload-keystore.jks 文件放置在项目根目录
2. 创建或更新 android/key.properties 文件
3. 可以使用以下命令：
   ```bash
   ./scripts/ci/setup_signing_keys.sh local
   ```

## GitHub Actions 设置
将你的签名密钥添加到GitHub Secrets：

\`\`\`bash
# 编码密钥文件
base64 -w 0 upload-keystore.jks > keystore.b64

# 添加到你的GitHub Secrets
KEYSTORE_BASE64=<keystore.b64的内容>
KEYSTORE_PASSWORD=<你的密钥库密码>
KEY_PASSWORD=<你的密钥密码>
KEY_ALIAS=<你的密钥别名>
\`\`\`

## 验证签名
\`\`\`bash
./scripts/ci/verify_signing.sh
\`\`\`
EOF

    echo "✅ 本地签名配置完成"
}

function setup_ci_signing() {
    echo "🤖 CI环境签名配置..."
    
    if [[ -n "${GH_TOKEN:-}" ]]; then
        # GitHub Actions环境
        if [[ -n "${KEYSTORE_BASE64:-}" ]]; then
            echo "$KEYSTORE_BASE64" | base64 -d > android/app/upload-keystore.jks
            cat > android/key.properties << CI_EOF
# CI环境签名配置
storePassword=${KEYSTORE_PASSWORD}
keyPassword=${KEY_PASSWORD}
keyAlias=${KEY_ALIAS}
storeFile=upload-keystore.jks
CI_EOF
            echo "✅ CI签名配置完成"
        else
            echo "⚠️ 未配置签名密钥，使用debug签名"
        fi
    fi
}

function verify_signing() {
    echo "🔍 验证签名配置..."
    
    if [[ -f "android/key.properties" && -f "upload-keystore.jks" ]]; then
        echo "✅ 签名配置存在"
        return 0
    else
        echo "❌ 签名配置不完整"
        return 1
    fi
}

# 主逻辑
case "${1:-help}" in
    "local")
        setup_local_signing
        ;;
    "ci")
        setup_ci_signing "$2"
        ;;
    "verify")
        verify_signing
        ;;
    *)
        echo "用法: $0 [local|ci|verify]"
        echo "  local  - 设置本地签名"
        echo "  ci     - 设置CI环境签名"
        echo "  verify - 验证签名配置"
        exit 1
        ;;
esac
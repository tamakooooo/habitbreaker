# Habits Breaker App 零差异构建指南

## 🎯 项目特色

- **零差异构建**: 本地与GitHub Actions构建完全一致
- **环境锁定**: Flutter版本、SDK版本、依赖全部锁定
- **智能缓存**: 跨平台共享构建缓存，加速构建
- **安全签名**: 密钥安全注入，支持CI/CD自动发布
- **自诊断**: 自动检测和修复常见构建问题

## 🚀 快速开始

### 1. 一键设置环境

```bash
# 初始化构建环境
./scripts/ci/build_environment_lock.sh

# 验证环境
./scripts/validate_environment.sh
```

### 2. 本地CI重现

```bash
# 本地模拟Ubuntu + APK构建
./scripts/ci/run_local_ci.sh ubuntu-latest apk

# 容器化构建
./scripts/ci/run_local_ci.sh container aab

# 本地缓存管理
./scripts/ci/local_cache_manager.sh init
```

### 3. 签名配置

```bash
# 生成本地调试签名
./scripts/ci/setup_signing_keys.sh local

# 验证签名配置
./scripts/ci/setup_signing_keys.sh verify
```

## 🔧 构建命令

### CI/CD构建 (与GitHub Actions一致)

```bash
# 标准构建
flutter build apk --release
flutter build appbundle --release
flutter build web --release

# 带验证的构建
./scripts/ci/validate_build_result.sh
```

### 调试构建问题

```bash
# 调试模式
./scripts/ci/debug_build_failure.sh

# 生成详细报告
./scripts/ci/debug_build_failure.sh report > diagnostic.md

# 自动修复
./scripts/ci/debug_build_failure.sh repair
```

## ⚙️ 环境配置

### 版本锁定 (.fvmrc)
```json
{"flutter": "3.24.0"}
```

### 构建版本 (.build-versions)
```
FLUTTER_VERSION=3.24.0
ANDROID_COMPILE_SDK=36
ANDROID_BUILD_TOOLS=36.0.0
GRADLE_VERSION=8.1.1
JDK_VERSION=17
```

## 🔐 GitHub仓库设置

### 必需 Secrets
在GitHub仓库 -> Settings -> Secrets and variables -> Actions 添加：

- `KEYSTORE_BASE64`: Base64编码的密钥库文件
- `KEYSTORE_PASSWORD`: 密钥库密码
- `KEY_PASSWORD`: 密钥密码
- `KEY_ALIAS`: 密钥别名

### 主分支保护规则
1. 在 GitHub 仓库 -> Settings -> Branches
2. 创建规则：
   - 分支名称模式: `main`
   - 必需状态检查:
     - ✅ env-lock
     - ✅ test
     - ✅ build-matrix (ubuntu-latest, apk)
     - ✅ build-matrix (ubuntu-latest, aab)
     - ✅ build-matrix (macos-latest, apk)

## 📦 构建产物

### 本地构建
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`
- Web: `build/web/`

### GitHub Actions下载
1. 访问 Actions 页面
2. 选择对应构建运行
3. 下载构建产物

## 🐛 常见问题解决

### 缓存问题
```bash
# 缓存重置
./scripts/ci/local_cache_manager.sh reset

# Docker容器清理
docker system prune -a
```

### 依赖版本冲突
```bash
# 强制重新解析依赖
flutter clean
flutter pub get --enforce-lockfile
```

### 环境问题
```bash
# 环境一致性检查
./scripts/validate_environment.sh

# 生成环境报告
flutter doctor -v > flutter_env.txt
```

## 🔄 一键本地CI

### 完整本地CI流程
```bash
# 安装一次性依赖
npm install -g @actions/core
npm install -g @actions/github

# 运行完整CI验证 (模拟所有GitHub Actions作业)
./scripts/ci/run_local_ci.sh local all

# 容器化验证 (模拟GitHub Actions环境)
./scripts/ci/run_local_ci.sh container all
```

## 👥 团队协作规范

### 开发工作流
1. 创建功能分支
2. 提交前本地CI验证
3. 创建PR触发完整构建
4. 通过所有检查后才能合并

### 发布流程
1. 合并到main分支
2. 触发自动构建和发布
3. 版本标签: v1.x.x-build.${BUILD_NUMBER}

## 📋 监控和警报

项目包含以下自动化监控：
- ✅ 构建时间趋势
- ✅ APK大小监控
- ✅ 依赖安全扫描
- ✅ 构建失败自动通知

---
**维护指南**: 定期检查 [BUILD-TROUBLESHOOTING.md](BUILD-TROUBLESHOOTING.md) 获取更新的疑难解答
# 主分支保护规则配置

## GitHub仓库设置

### 必需设置的分支保护规则

1. 在 GitHub 仓库 -> Settings -> Branches -> Add rule
2. 分支名称模式: `main`
3. 启用所有选项:
   - ✅ Require a pull request before merging
   - ✅ Require approvals (设置 2 个审核人)
   - ✅ Dismiss stale PR approvals when new commits are pushed
   - ✅ Require review from code owners
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Require linear history

### 必需的状态检查

添加以下状态检查为必需：

```
✅ env-lock
✅ test
✅ build-matrix (ubuntu-latest, apk)
✅ build-matrix (ubuntu-latest, aab)
✅ build-matrix (ubuntu-latest, web)
✅ build-matrix (macos-latest, apk)
✅ build-matrix (windows-latest, apk)
✅ validate-build-result
```

### 限制合并规则

- 只有管理员可以绕过
- 禁止强制推送
- 禁止删除主分支

## 构建状态徽章

在 README.md 中添加以下徽章：

```markdown
![Flutter CI](https://github.com/your-org/habit_breaker_app/workflows/Flutter%20CI%2FCD/badge.svg)
![Flutter version](https://img.shields.io/badge/Flutter-3.24.0-blue.svg)
```

## 自动化部署标签

### 发布标签规则

- 主分支构建成功 -> 创建预发布版本
- 合并主分支PR -> 自动创建发布版本
- 版本标签格式: v1.0.0-build.${BUILD_NUMBER}

### 构建触发条件

1. **Pull Request**: 触发完整测试和构建矩阵
2. **Push to main**: 包含签名和发布
3. **Push to develop**: 仅测试和基本构建
4. **Manual trigger**: 允许维护者手动触发
# Claude Code 快捷启动器

一个用于快速启动和配置 Claude Code 的 Windows 工具集，支持多种启动方式。

## ✨ 特性

- 🚀 **快捷启动** - PowerShell 中直接输入 `claude` 命令
- 📁 **智能目录** - 自动在当前项目目录启动 Claude Code
- 💻 **命令行集成** - 在任意目录直接启动，无需导航
- ⚙️ **智能配置管理** - 多级配置文件优先级，完善的验证机制
- 🔧 **增强WSL集成** - 多重shell环境初始化，完善的依赖检查
- 🛠️ **智能路径转换** - 支持多种路径格式，UNC路径检测
- ⚡ **快速响应** - 即时启动，无需手动文件管理
- 🔍 **详细错误诊断** - 完善的故障排除指导和恢复建议
- 🛡️ **安全可靠** - 防重复执行，完善的异常处理

## 📋 系统要求

- Windows 10/11
- PowerShell 5.0+
- WSL2 (Windows Subsystem for Linux 2) - 推荐版本
- Node.js LTS 版本 (推荐 v18.0+ 或 v20.0+)

## 🚀 快速开始

### 前置检查

在开始安装前，请确认您的环境满足以下条件：

```powershell
# 检查 PowerShell 版本
$PSVersionTable.PSVersion

# 检查 WSL 状态
wsl --status

# 检查 WSL 版本
wsl --list --verbose
```

### 1. 复制配置文件

下载本项目，将以下文件复制到 PowerShell 配置目录：

**目标目录**：`C:\Users\[用户名]\Documents\WindowsPowerShell\`

**需要复制的文件**：
- `Microsoft.PowerShell_profile.ps1` → PowerShell 配置文件
- `.env.example` → 环境变量配置模板

### 2. 配置 API 信息

将 `.env.example` 重命名为 `.env`，并配置以下必要信息：

```bash
# 必填项 - 从 https://console.anthropic.com 获取
ANTHROPIC_AUTH_TOKEN=sk-ant-api03-your-api-key-here

# 可选项 - 自定义 API 端点
ANTHROPIC_BASE_URL=https://api.anthropic.com

# 可选项 - 指定 Node.js 版本
NODE_VERSION=20.17.0
```

**配置说明**：
- `ANTHROPIC_AUTH_TOKEN`：必填，您的 Claude API 密钥
- `ANTHROPIC_BASE_URL`：可选，默认使用官方 API 端点
- `NODE_VERSION`：可选，未设置时使用 NVM 当前版本

### 3. 安装 Claude Code

**方法一：自动化安装（推荐）**
```powershell
# 重新加载 PowerShell Profile
. $PROFILE

# 运行安装检查（脚本会自动安装依赖）
claude --setup
```

**方法二：手动安装**
在 WSL 中执行：
```bash
# 安装 NVM（如果未安装）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc

# 安装 Node.js LTS 版本
nvm install --lts
nvm use --lts

# 安装 Claude Code
npm install -g claude-code
```

**方法三：通过 Cursor IDE**
如果您已安装 Cursor，可以直接在 Cursor 中输入：
```
帮我安装 https://www.anthropic.com/claude-code
```

### 4. 验证安装

```powershell
# 验证配置是否正确
claude --version

# 测试 API 连接
claude --test-api
```

安装成功后，您应该看到：
- Claude Code 版本信息
- API 连接状态：✅ 连接成功

## 🎯 使用方法

### 基本启动
```powershell
# 在任意项目目录中启动 Claude Code
claude

# 显示版本信息
claude --version

# 显示帮助信息
claude --help
```

### 高级选项
```powershell
# 使用指定配置文件启动
claude --config "path\to\.env"

# 指定工作目录启动
claude --working-directory "C:\path\to\project"

# 调试模式启动（显示详细日志）
claude --debug

# 测试 API 连接
claude --test-api

# 运行安装检查和环境诊断
claude --setup
```

### 常用场景
```powershell
# 在新项目中快速开始
cd "C:\path\to\new\project"
claude

# 临时使用不同的 API 配置
claude --config "C:\path\to\production\.env"

# 故障排除模式
claude --debug --test-api
```

## 📁 项目结构

```
claude-code-launcher/
├── Microsoft.PowerShell_profile.ps1    # PowerShell 配置文件（增强版）
├── .env.example                        # 环境变量配置模板
├── README.md                           # 项目说明文档
├── LICENSE                             # MIT 开源许可证
└── .gitignore                          # Git 忽略文件配置
```

## ⚙️ 配置说明

### 配置文件位置

配置文件按以下优先级加载：
1. **项目级配置**：当前目录的 `.env` 文件
2. **用户级配置**：`$HOME\.claude\.env` 文件
3. **系统级配置**：PowerShell Profile 目录的 `.env` 文件

### 完整配置选项

创建 `.env` 文件并根据需要配置以下选项：

```bash
# === 必填配置 ===
# Claude API 认证令牌
ANTHROPIC_AUTH_TOKEN=sk-ant-api03-your-api-key-here

# === 可选配置 ===
# API 基础 URL（默认：https://api.anthropic.com）
ANTHROPIC_BASE_URL=https://api.anthropic.com

# Node.js 版本（默认：使用 NVM 当前版本）
NODE_VERSION=20.17.0

# Claude Code 启动端口（默认：3000）
CLAUDE_PORT=3000

# 工作目录（默认：当前目录）
WORKING_DIRECTORY=C:\path\to\your\project

# 日志级别（默认：info，可选：debug, info, warn, error）
LOG_LEVEL=info

# 网络代理设置（如果需要）
HTTP_PROXY=http://proxy.company.com:8080
HTTPS_PROXY=http://proxy.company.com:8080

# WSL 分发版本（默认：自动检测）
WSL_DISTRO=Ubuntu-22.04
```

### 环境变量说明

| 变量名 | 类型 | 默认值 | 说明 |
|--------|------|--------|------|
| `ANTHROPIC_AUTH_TOKEN` | 必填 | 无 | Claude API 认证令牌 |
| `ANTHROPIC_BASE_URL` | 可选 | `https://api.anthropic.com` | API 服务端点 |
| `NODE_VERSION` | 可选 | NVM 当前版本 | 指定 Node.js 版本 |
| `CLAUDE_PORT` | 可选 | `3000` | Claude Code 服务端口 |
| `WORKING_DIRECTORY` | 可选 | 当前目录 | 默认工作目录 |
| `LOG_LEVEL` | 可选 | `info` | 日志详细程度 |
| `WSL_DISTRO` | 可选 | 自动检测 | WSL 发行版名称 |

### 配置验证

使用以下命令验证您的配置：

```powershell
# 检查配置文件是否正确加载
claude --config-check

# 测试 API 连接
claude --test-api

# 显示当前配置信息
claude --show-config
```

### 网络环境配置

**企业网络/代理环境**：
```bash
# 在 .env 文件中添加代理配置
HTTP_PROXY=http://proxy.company.com:8080
HTTPS_PROXY=http://proxy.company.com:8080
NO_PROXY=localhost,127.0.0.1,.local
```

**防火墙配置**：
确保以下端口可以访问：
- `443` (HTTPS) - 用于 Claude API 通信
- `3000` (或自定义端口) - Claude Code 本地服务

## 🔧 故障排除

### 快速诊断

如果遇到问题，请首先运行综合诊断：

```powershell
# 运行完整的环境检查
claude --setup --verbose

# 或者逐步检查各个组件
claude --test-api          # 测试 API 连接
claude --config-check      # 检查配置文件
claude --env-check         # 检查环境变量
```

### 问题分类及解决方案

#### 🚫 权限和策略问题

**问题**: PowerShell 执行策略限制
```
错误: 无法加载文件 Microsoft.PowerShell_profile.ps1，因为在此系统上禁止运行脚本
```

**解决方案**:
```powershell
# 方法1: 修改执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 方法2: 解除文件限制
# 右键点击 Microsoft.PowerShell_profile.ps1 → 属性 → 解除阻止
```

#### 🐧 WSL 环境问题

**问题**: WSL 未安装或版本过旧
```powershell
# 检查 WSL 状态
wsl --status
wsl --list --verbose
```

**解决方案**:
```powershell
# 安装或升级到 WSL2
wsl --install
wsl --set-default-version 2

# 如果 WSL 无响应
wsl --shutdown
wsl --unregister Ubuntu  # 然后重新安装发行版
```

#### 📦 Node.js 和包管理问题

**问题**: Node.js 或 Claude Code 未找到
```bash
# 在 WSL 中检查 Node.js 环境
which node
node --version
which claude-code
```

**解决方案**:
```bash
# 重新安装 NVM 和 Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc

# 清理并重新安装
nvm uninstall node  # 卸载所有版本
nvm install --lts   # 安装最新 LTS
nvm use --lts

# 重新安装 Claude Code
npm uninstall -g claude-code
npm install -g claude-code

# 如果权限问题，使用 sudo
sudo npm install -g claude-code
```

#### 🔑 API 和认证问题

**问题**: API 密钥无效或连接失败
```powershell
# 测试 API 连接
claude --test-api --debug
```

**解决方案**:
```bash
# 检查 .env 文件格式
cat .env | grep -E "ANTHROPIC_AUTH_TOKEN|ANTHROPIC_BASE_URL"

# 确保没有额外空格或引号
# 正确格式: ANTHROPIC_AUTH_TOKEN=sk-ant-api03-...
# 错误格式: ANTHROPIC_AUTH_TOKEN="sk-ant-api03-..." 或有前后空格
```

**获取新的 API 密钥**:
1. 访问 [Anthropic Console](https://console.anthropic.com)
2. 登录您的账户
3. 导航到 API Keys 部分
4. 创建新的 API 密钥
5. 复制并更新 `.env` 文件

#### 🌐 网络和代理问题

**问题**: 企业网络或代理阻止连接
```powershell
# 测试网络连接
Test-NetConnection -ComputerName api.anthropic.com -Port 443
```

**解决方案**:
```bash
# 在 .env 文件中配置代理
HTTP_PROXY=http://proxy.company.com:8080
HTTPS_PROXY=http://proxy.company.com:8080
NO_PROXY=localhost,127.0.0.1,.local

# 在 WSL 中设置代理
export http_proxy=http://proxy.company.com:8080
export https_proxy=http://proxy.company.com:8080
```

#### 📂 路径和目录问题

**问题**: 路径转换失败或工作目录错误
```powershell
# 测试路径转换
wsl wslpath -u "C:\Users\username"
wsl pwd
```

**解决方案**:
```powershell
# 手动指定工作目录
claude --working-directory "C:\path\to\your\project"

# 检查当前目录
Get-Location
Set-Location "C:\correct\path"
```

#### 🔧 高级故障排除

**问题**: Claude Code 服务启动失败
```bash
# 在 WSL 中检查进程
ps aux | grep claude
netstat -tulpn | grep 3000  # 检查端口占用
```

**解决方案**:
```bash
# 杀死占用端口的进程
sudo fuser -k 3000/tcp

# 使用不同端口启动
CLAUDE_PORT=3001 claude-code

# 检查系统资源
free -h
df -h
```

### 📋 完整重置指南

如果所有方法都失败，可以执行完整重置：

```powershell
# 1. 清理 PowerShell Profile
Remove-Item $PROFILE -Force
Remove-Item "C:\Users\$env:USERNAME\Documents\WindowsPowerShell\.env" -Force

# 2. 重置 WSL
wsl --shutdown
wsl --unregister Ubuntu

# 3. 重新开始安装流程
# 按照快速开始部分重新配置
```

### 🆘 获取帮助

如果问题仍然存在：

1. **收集诊断信息**:
   ```powershell
   claude --setup --verbose > claude-debug.log 2>&1
   ```

2. **检查日志文件**:
   - Windows: `%APPDATA%\claude\logs\`
   - WSL: `~/.claude/logs/`

3. **提交问题报告时包含**:
   - 操作系统版本
   - PowerShell 版本
   - WSL 版本和发行版
   - Node.js 版本
   - 错误消息和日志文件
   - 已尝试的解决方案

## 🤝 贡献

欢迎提交 Issues 和 Pull Requests！

**贡献流程**：
1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

**问题报告**：
- 使用 Issue 模板
- 提供详细的环境信息
- 包含重现步骤和错误日志

## 📈 版本历史

- **v1.0.0** - 初始版本发布
- **v1.1.0** - 增加多环境配置支持
- **v1.2.0** - 优化 WSL 集成和错误处理
- **v1.3.0** - 添加网络代理支持和高级诊断功能

## 📚 相关资源

- [Claude Code 官方文档](https://github.com/anthropics/claude-code)
- [Anthropic API 文档](https://docs.anthropic.com)
- [WSL 安装指南](https://docs.microsoft.com/windows/wsl/install)
- [NVM 使用指南](https://github.com/nvm-sh/nvm)
- [PowerShell Profile 配置](https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_profiles)

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- [Claude Code](https://github.com/anthropics/claude-code) - 官方 Claude 代码编辑器
- [Anthropic](https://www.anthropic.com) - Claude AI 平台
- [NVM](https://github.com/nvm-sh/nvm) - Node.js 版本管理工具
- 所有贡献者和用户的反馈

---

**📧 联系方式**: 如有问题或建议，请通过 GitHub Issues 联系我们。

**⭐ 如果这个项目对您有帮助，请给个 Star！** 
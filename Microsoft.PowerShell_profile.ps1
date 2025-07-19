# Claude Code 快捷启动函数
# 终极修复版本 - 解决Claude Code参数问题

# 防止重复执行的全局变量
if (-not $global:ClaudeExecuting) {
    $global:ClaudeExecuting = $false
}

function claude {
    param(
        [string]$ConfigPath = "",
        [string]$WorkingDirectory = ""
    )
    
    # 防止死循环 - 检查是否已在执行
    if ($global:ClaudeExecuting) {
        Write-Host " Claude 正在执行中，请等待完成" -ForegroundColor Yellow
        return
    }
    
    try {
        $global:ClaudeExecuting = $true
        Write-Host "=== Claude Code 快捷启动 ===" -ForegroundColor Green
        
        # 获取当前工作目录
        $currentPath = if ($WorkingDirectory) { 
            $WorkingDirectory 
        } else { 
            (Get-Location).Path 
        }
        
        Write-Host "当前工作目录: $currentPath" -ForegroundColor Cyan
    
        # 确定配置文件路径
        $envPaths = @()
        if ($ConfigPath) {
            if (Test-Path $ConfigPath) {
                $envPaths += $ConfigPath
            } else {
                Write-Host " 指定的配置文件不存在: $ConfigPath" -ForegroundColor Red
                return
            }
        } else {
            $envPaths += "$currentPath\.env"
            $envPaths += "$PSScriptRoot\.env"
            $envPaths += "$env:USERPROFILE\.claude\.env"
        }
        
        $configFound = $false
        $selectedConfigPath = ""
        foreach ($envPath in $envPaths) {
            if (Test-Path $envPath) {
                Write-Host "使用配置文件: $envPath" -ForegroundColor Yellow
                $configFound = $true
                $selectedConfigPath = $envPath
                break
            }
        }
        
        if (-not $configFound) {
            Write-Host " 未找到配置文件！" -ForegroundColor Red
            Write-Host "请创建 .env 文件或参考 .env.example" -ForegroundColor Yellow
            return
        }
        
        # 读取环境变量
        $envVars = @{}
        try {
            Get-Content $selectedConfigPath -Encoding UTF8 | ForEach-Object {
                $line = $_.Trim()
                if ($line -and $line -notmatch '^#' -and $line -match '^([A-Za-z_][A-Za-z0-9_]*)=(.*)') {
                    $key = $matches[1].Trim()
                    $value = $matches[2].Trim()
                    if ($value -match '^"(.*)"' -or $value -match "^'(.*)'$") {
                        $value = $matches[1]
                    }
                    $envVars[$key] = $value
                    Write-Host "  读取变量: $key" -ForegroundColor Gray
                }
            }
            
            if (-not $envVars.ContainsKey('ANTHROPIC_AUTH_TOKEN') -or $envVars['ANTHROPIC_AUTH_TOKEN'] -eq 'your-api-token-here') {
                Write-Host " 请在 .env 文件中设置有效的 ANTHROPIC_AUTH_TOKEN" -ForegroundColor Red
                return
            }
            
            Write-Host " 配置加载成功" -ForegroundColor Green
            
        } catch {
            Write-Host " 配置文件读取失败: $($_.Exception.Message)" -ForegroundColor Red
            return
        }
        
        # 路径转换
        $wslPath = ""
        if ($currentPath -match '^([A-Za-z]):(.*)') {
            $drive = $matches[1].ToLower()
            $path = $matches[2] -replace '\\', '/'
            $wslPath = "/mnt/$drive$path"
            Write-Host "WSL路径: $wslPath" -ForegroundColor Cyan
        }
        
        Write-Host "启动WSL环境..." -ForegroundColor Yellow
        
        # 分步执行，确保每一步都正确
        Write-Host "1. 检查WSL环境..." -ForegroundColor Gray
        $envCheck = wsl bash -l -c "source ~/.bashrc && export NVM_DIR=~/.nvm && source ~/.nvm/nvm.sh && echo 'Node:' && node --version && echo 'Claude:' && claude --version" 2>&1 | Where-Object { 
            $_ -notmatch "检测到 localhost 代理配置" -and 
            $_ -notmatch "NAT 模式下的 WSL 不支持 localhost 代理"
        }
        
        Write-Host $envCheck
        
        # 如果环境检查通过，则启动Claude
        if ($envCheck -match "Node:" -and $envCheck -match "Claude:") {
            Write-Host "2. 环境检查通过，启动Claude Code..." -ForegroundColor Green
            
            # 构建启动命令 - 关键修复：使用正确的Claude Code启动方式
            $startCommand = "source ~/.bashrc && export NVM_DIR=~/.nvm && source ~/.nvm/nvm.sh"
            
            # 添加环境变量
            foreach ($key in $envVars.Keys) {
                $value = $envVars[$key]
                $startCommand += " && export $key='$value'"
            }
            
            # 切换目录
            if ($wslPath) {
                $startCommand += " && cd '$wslPath'"
            }
            
            # 使用指定Node.js版本
            if ($envVars.ContainsKey('NODE_VERSION')) {
                $startCommand += " && nvm use " + $envVars['NODE_VERSION']
            }
            
            # 启动Claude Code - 使用交互模式而不是直接调用
            $startCommand += " && echo ' 正在启动Claude Code...' && exec claude"
            
            Write-Host "3. 启动命令构建完成，正在执行..." -ForegroundColor Gray
            
            # 执行启动命令 - 使用交互式终端
            wsl bash -l -c $startCommand
        } else {
            Write-Host " 环境检查失败" -ForegroundColor Red
            Write-Host "请确保在WSL中已安装Node.js和Claude Code" -ForegroundColor Yellow
            Write-Host ""
            Write-Host " 快速修复建议:" -ForegroundColor Cyan
            Write-Host "  1. 安装Node.js: wsl bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && source ~/.bashrc && nvm install --lts'" -ForegroundColor Gray
            Write-Host "  2. 安装Claude Code: wsl bash -c 'npm install -g claude-code'" -ForegroundColor Gray
        }
        
    } catch {
        Write-Host " 启动失败: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host " 故障排除建议:" -ForegroundColor Cyan
        Write-Host "  1. 检查WSL状态: wsl -l -v" -ForegroundColor Gray
        Write-Host "  2. 验证Node.js: wsl bash -l -c 'source ~/.bashrc && node --version'" -ForegroundColor Gray
        Write-Host "  3. 验证Claude: wsl bash -l -c 'source ~/.bashrc && claude --version'" -ForegroundColor Gray
        Write-Host "  4. 重启WSL: wsl --shutdown" -ForegroundColor Gray
    } finally {
        $global:ClaudeExecuting = $false
    }
}

Write-Host "Claude Code 快捷启动已配置完成！" -ForegroundColor Green
Write-Host " 使用方法：" -ForegroundColor Cyan
Write-Host "  claude                                    # 在当前目录启动" -ForegroundColor Gray
Write-Host "  claude -ConfigPath .env                   # 使用指定配置文件" -ForegroundColor Gray
Write-Host "  claude -WorkingDirectory 'C:\path\to\project'  # 指定工作目录" -ForegroundColor Gray
Write-Host "  请先创建 .env 文件并配置 API 信息" -ForegroundColor Yellow

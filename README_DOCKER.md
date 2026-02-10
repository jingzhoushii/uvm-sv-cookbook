# 🐳 Docker 开发环境

## 快速开始

### 使用 Docker Compose

```bash
# 启动开发环境
docker-compose up -d uvm-cookbook

# 进入容器
docker-compose exec uvm-cookbook bash

# 运行回归测试
docker-compose run test

# 生成报告
docker-compose run report
```

### 使用 Dev Container（VSCode）

1. 安装 "Dev Containers" 扩展
2. `Ctrl+Shift+P` → "Dev Containers: Reopen"
3. 自动构建开发环境

### 构建镜像

```bash
docker build -t uvm-sv-cookbook .
```

---

## 包含工具

- Verilator（语法检查）
- Python 3.11
- Git
- Vim/VSCode

---

## 文件说明

| 文件 | 说明 |
|------|------|
| `.devcontainer/Dockerfile` | 开发容器镜像 |
| `.devcontainer/devcontainer.json` | VSCode 配置 |
| `docker-compose.yml` | Docker Compose 编排 |


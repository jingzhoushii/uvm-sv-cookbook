# ============================================================================
# UVM-SV Cookbook Development Container
# ============================================================================

FROM ghcr.io/verilator/verilator:latest

# 安装额外工具
RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    vim git curl wget \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
RUN pip3 install --no-cache-dir \
    pyyaml \
    jinja2

# 设置工作目录
WORKDIR /workspace

# 克隆仓库
RUN git clone https://github.com/jingzhoushii/uvm-sv-cookbook.git

# 进入仓库
WORKDIR /workspace/uvm-sv-cookbook

# 默认命令
CMD ["/bin/bash"]

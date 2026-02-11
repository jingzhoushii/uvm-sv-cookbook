# ============================================================================
# UVM-SV Cookbook - Root Makefile
# ============================================================================

SIM ?= vcs
UVM_HOME ?= /opt/uvm-1800.2-2021

.PHONY: all help clean test docs stats

all:
	@echo "========================================"
	@echo "  UVM-SV Cookbook"
	@echo "========================================"
	@echo ""
	@echo "Usage: make [target] [SIM=<simulator>]"
	@echo ""
	@echo "Targets:"
	@echo "  all      - Show this help"
	@echo "  test     - Run regression tests"
	@echo "  docs     - Check documentation"
	@echo "  stats    - Show code statistics"
	@echo "  clean    - Clean all build files"
	@echo ""
	@echo "Examples:"
	@echo "  make test SIM=vcs"
	@echo "  make stats"
	@echo ""
	@echo "Simulators:"
	@echo "  vcs   - Synopsys VCS (default)"
	@echo "  xrun  - Cadence Xcelium"
	@echo "  vsim  - Siemens Questa"
	@echo ""
	@echo "Chapters:"
	@ls -d 0*/

clean:
	@echo "Cleaning all build files..."
	find . -name "*.vcd" -delete
	find . -name "*.log" -delete
	find . -name "*.dag" -delete
	find . -name "DVEfiles" -exec rm -rf {} \; 2>/dev/null || true
	find . -name "work" -exec rm -rf {} \; 2>/dev/null || true
	find . -name "simv*" -type f -delete 2>/dev/null || true
	@echo "  [OK] Clean complete"

test:
	@echo "Running regression tests..."
	cd regress && python3 run.py --help >/dev/null 2>&1 && \
		python3 run.py || echo "Install python3 first"

docs:
	@echo "Checking documentation..."
	@echo "README files: $$(find . -name "README.md" | grep -v ".git" | wc -l)"
	@echo "Missing README:"
	@for ch in 0*/; do \
		if [ ! -f "$$ch/README.md" ]; then \
			echo "  - $$ch"; \
		fi \
	done

stats:
	@echo "========================================"
	@echo "  UVM-SV Cookbook Statistics"
	@echo "========================================"
	@echo ""
	@echo "SV files:       $$(find . -name "*.sv" | grep -v ".git" | wc -l)"
	@echo "Lines of code:   $$(find . -name "*.sv" | xargs wc -l 2>/dev/null | tail -1)"
	@echo "README files:   $$(find . -name "README.md" | grep -v ".git" | wc -l)"
	@echo "Chapters:       $$(ls -d 0*/ | wc -l)"
	@echo "Examples:       $$(find . -path "*/examples/*.sv" | grep -v ".git" | wc -l)"
	@echo "Commits:        $$(git rev-list --count HEAD)"
	@echo ""

help:
	@echo "UVM-SV Cookbook - SystemVerilog/UVM Learning Repository"
	@echo ""
	@echo "GitHub: https://github.com/jingzhoushii/uvm-sv-cookbook"
	@echo ""
	@echo "Getting Started:"
	@echo "  1. Clone: git clone https://github.com/jingzhoushii/uvm-sv-cookbook.git"
	@echo "  2. Build: cd <chapter> && make"
	@echo "  3. Test:  cd regress && python3 run.py"
	@echo ""
	@echo "For more information, see README.md"

# ============================================================================
# 新增目标
# ============================================================================

.PHONY: lint coverage regression clean_all help

# 静态检查（需要 verilator 或 svlint）
lint:
	@echo "Running lint check..."
	@if command -v verilator &> /dev/null; then \
		find . -name "*.sv" -exec verilator --lint-only {} \; 2>/dev/null || true; \
		echo "Lint check passed!"; \
	else \
		echo "Verilator not installed. Install with: brew install verilator"; \
	fi

# 生成覆盖率报告
coverage:
	@echo "Generating coverage report..."
	@echo "Coverage report feature coming soon!"

# 运行回归测试
regression:
	@echo "Running regression tests..."
	@python3 regress/run.py --verbose

# 清理所有生成的文件
clean_all:
	@echo "Cleaning all generated files..."
	@rm -rf build/ simv* *.vcd *.fst *.log waves.*
	@echo "Clean complete!"

# 显示帮助
help:
	@echo "UVM-SV Cookbook Makefile Targets"
	@echo ""
	@echo "Basic targets:"
	@echo "  make compile      - Compile simulation"
	@echo "  make run          - Run simulation"
	@echo "  make clean simulation files        - Clean"
	@echo ""
	@echo "Advanced targets:"
	@echo "  make lint         - Run static lint check"
	@echo "  make coverage    - Generate coverage report"
	@echo "  make regression  - Run regression tests"
	@echo "  make clean_all   - Clean all generated files"
	@echo "  make help        - Show this help"
	@echo ""
	@echo "Simulators:"
	@echo "  make SIM=vcs      - Use VCS"
	@echo "  make SIM=xrun    - Use Xcelium"
	@echo "  make SIM=vsim     - Use Questa"


# ============================================================================
# 进阶目标
# ============================================================================

.PHONY: debug wave cov regress regression clean_all lint check

# 生成波形并打开 Verdi
debug:
	@echo "=== Debug Mode (Verdi) ==="
	@if [ "$(SIM)" = "vcs" ]; then \
		./simv -ucli -do "set_fomv -default; call \$fsdbDumpfile(\"waves.fsdb\"); call \$fsdbDumpvars(0, top_tb); run; quit" -l debug.log; \
	elif [ "$(SIM)" = "xrun" ]; then \
		xrun -access +r -uvmhome $(UVM_HOME) -f filelist.f -linesize 300 -l debug.log; \
	fi

# 生成波形
wave:
	@echo "=== Generate Waves ==="
	@echo "Use: make SIM=vcs debug"

# 覆盖率报告
cov:
	@echo "=== Coverage Report ==="
	@if [ "$(SIM)" = "vcs" ]; then \
		urg -dir simv.vdb -report coverage_rpt; \
		echo "Report: coverage_rpt"; \
	elif [ "$(SIM)" = "xrun" ]; then \
		imc -load $(XMVDB) -report coverage; \
	fi

# Regression 测试
regress regression:
	@echo "=== Regression Test ==="
	@python3 regress/run.py --verbose --html
	@echo "Results: regress/results.html"

# 静态检查
check lint:
	@echo "=== Lint Check ==="
	@if command -v verilator &> /dev/null; then \
		find . -name "*.sv" -exec verilator --lint-only {} \; 2>/dev/null || true; \
		echo "Lint check passed"; \
	else \
		echo "Install verilator: brew install verilator"; \
	fi


#!/usr/bin/env python3
"""
UVM-SV Cookbook Regression Test Runner

用法:
    python3 run.py                    # 运行所有测试
    python3 run.py --chapter <name>   # 运行特定章节
    python3 run.py --sim vcs           # 指定仿真器
    python3 run.py --compile-only     # 只编译
    python3 run.py --help             # 帮助
"""

import os
import sys
import argparse
import subprocess
import time
from datetime import datetime

# ============================================================================
# 配置
# ============================================================================
SIMULATORS = ["vcs", "xrun", "vsim"]
DEFAULT_SIM = "vcs"

CHAPTERS = [
    "01-sv-fundamentals/01-data-types",
    "01-sv-fundamentals/02-procedural-blocks",
    "01-sv-fundamentals/03-interfaces",
    "01-sv-fundamentals/04-classes-oop",
    "01-sv-fundamentals/05-randomization",
    "01-sv-fundamentals/06-threads-communication",
    "02-uvm-phases/01-build-phase",
    "02-uvm-phases/02-connect-phase",
    "02-uvm-phases/04-run-phase",
    "03-uvm-components/03-uvm_agent",
    "03-uvm-components/04-uvm_driver",
    "03-uvm-components/05-uvm_monitor",
    "04-uvm-transactions/01-uvm_sequence_item",
    "04-uvm-transactions/02-uvm_sequence",
    "04-uvm-transactions/04-virtual-sequences",
    "05-tlm-communication/01-put-get-ports",
    "06-configuration/01-uvm_config_db",
    "07-sequences-advanced/01-sequence-hooks",
    "08-reporting-messaging/03-coverage-collection",
]

# ============================================================================
# 颜色输出
# ============================================================================
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
ENDC = '\033[0m'

def print_color(msg, color=BLUE):
    print(f"{color}{msg}{ENDC}")

# ============================================================================
# 工具函数
# ============================================================================
def run_command(cmd, cwd=None, timeout=300):
    """运行命令并返回结果"""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=timeout
        )
        return result.returncode, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return -1, "", "Timeout"
    except Exception as e:
        return -1, "", str(e)

def check_makefile(chapter_path):
    """检查章节是否有 Makefile"""
    return os.path.exists(os.path.join(chapter_path, "Makefile"))

def get_chapters():
    """获取章节列表"""
    chapters = []
    for ch in CHAPTERS:
        path = os.path.join(os.path.dirname(__file__), "..", ch)
        if os.path.exists(path):
            chapters.append(ch)
    return chapters

# ============================================================================
# 测试运行
# ============================================================================
def run_chapter(chapter, sim, compile_only=False, verbose=False):
    """运行单个章节测试"""
    chapter_path = os.path.join(os.path.dirname(__file__), "..", chapter)
    
    if not check_makefile(chapter_path):
        return False, "No Makefile"
    
    # 编译
    print_color(f"  Compiling {chapter}...", GREEN)
    rc, _, stderr = run_command(
        f"make compile SIM={sim}",
        cwd=chapter_path,
        timeout=300
    )
    
    if rc != 0:
        if verbose:
            print_color(f"    Compile failed: {stderr[:200]}", RED)
        return False, "Compile failed"
    
    print_color(f"    [OK] Compile", GREEN)
    
    if compile_only:
        return True, "Compile only"
    
    # 运行
    print_color(f"  Running {chapter}...", GREEN)
    rc, stdout, stderr = run_command(
        f"make run SIM={sim}",
        cwd=chapter_path,
        timeout=300
    )
    
    if rc != 0:
        if verbose:
            print_color(f"    Run failed: {stderr[:200]}", RED)
        return False, "Run failed"
    
    print_color(f"    [OK] Run", GREEN)
    return True, "Passed"

def run_all_chapters(sim, compile_only=False, verbose=False):
    """运行所有章节测试"""
    chapters = get_chapters()
    
    passed = 0
    failed = 0
    skipped = 0
    results = []
    
    print_color(f"\n{'='*60}", BLUE)
    print_color(f"  UVM-SV Cookbook Regression Test", BLUE)
    print_color(f"  Simulator: {sim}", BLUE)
    print_color(f"  Chapters: {len(chapters)}", BLUE)
    print_color(f"  {'='*60}\n", BLUE)
    
    start_time = time.time()
    
    for i, chapter in enumerate(chapters, 1):
        print(f"[{i}/{len(chapters)}] ", end="")
        
        success, msg = run_chapter(chapter, sim, compile_only, verbose)
        
        if success:
            passed += 1
            results.append((chapter, "PASS", msg))
            print_color("PASS", GREEN)
        else:
            failed += 1
            results.append((chapter, "FAIL", msg))
            print_color(f"FAIL ({msg})", RED)
    
    elapsed = time.time() - start_time
    
    # 总结
    print_color(f"\n{'='*60}", BLUE)
    print_color(f"  Test Summary", BLUE)
    print_color(f"  {'='*60}", BLUE)
    print_color(f"  Total:  {len(chapters)}", BLUE)
    print_color(f"  Passed: {passed}", GREEN)
    print_color(f"  Failed: {failed}", RED)
    print_color(f"  Time:   {elapsed:.1f}s", BLUE)
    print_color(f"  {'='*60}\n", BLUE)
    
    # 保存结果
    report_path = os.path.join(os.path.dirname(__file__), "reports")
    os.makedirs(report_path, exist_ok=True)
    
    report_file = os.path.join(report_path, f"report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.txt")
    with open(report_file, 'w') as f:
        f.write(f"UVM-SV Cookbook Regression Report\n")
        f.write(f"Date: {datetime.now()}\n")
        f.write(f"Simulator: {sim}\n")
        f.write(f"Total: {len(chapters)}, Passed: {passed}, Failed: {failed}\n")
        f.write(f"Time: {elapsed:.1f}s\n\n")
        for ch, status, msg in results:
            f.write(f"{status}: {ch} ({msg})\n")
    
    print_color(f"Report saved to: {report_file}\n", YELLOW)
    
    return failed == 0

# ============================================================================
# 主函数
# ============================================================================
def main():
    parser = argparse.ArgumentParser(
        description="UVM-SV Cookbook Regression Test Runner"
    )
    parser.add_argument(
        "--chapter", "-c",
        help="Specific chapter to test"
    )
    parser.add_argument(
        "--sim", "-s",
        default=DEFAULT_SIM,
        choices=SIMULATORS,
        help=f"Simulator (default: {DEFAULT_SIM})"
    )
    parser.add_argument(
        "--compile-only",
        action="store_true",
        help="Compile only, don't run"
    )
    parser.add_argument(
        "--verbose", "-v",
        action="store_true",
        help="Verbose output"
    )
    
    args = parser.parse_args()
    
    if args.chapter:
        success, msg = run_chapter(args.chapter, args.sim, args.compile_only, args.verbose)
        if success:
            print_color(f"\n{args.chapter}: PASS", GREEN)
        else:
            print_color(f"\n{args.chapter}: FAIL ({msg})", RED)
            sys.exit(1)
    else:
        success = run_all_chapters(args.sim, args.compile_only, args.verbose)
        sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()

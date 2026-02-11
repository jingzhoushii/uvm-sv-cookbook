#!/usr/bin/env python3
"""
Mini SoC Complete Regression System
"""

import os
import subprocess
import sys
import yaml
import json
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor

class RegressionRunner:
    def __init__(self, config="regress_full.yaml"):
        with open(config, 'r') as f:
            self.config = yaml.safe_load(f)
        
        self.results = {}
        self.log_dir = f"logs_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        os.makedirs(self.log_dir, exist_ok=True)
    
    def compile(self):
        """编译仿真"""
        print("=== Compiling ===")
        result = subprocess.run(["make", "compile"], capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Compilation FAILED:\n{result.stderr}")
            return False
        print("Compilation PASSED")
        return True
    
    def run_test(self, test):
        """运行单个测试"""
        print(f"  Running: {test}")
        env = os.environ.copy()
        env["UVM_TESTNAME"] = test
        env["WAVES"] = "0"
        
        log_file = f"{self.log_dir}/{test}.log"
        result = subprocess.run(
            ["./simv"],
            capture_output=True,
            text=True,
            env=env,
            timeout=600
        )
        
        with open(log_file, 'w') as f:
            f.write(result.stdout)
            f.write(result.stderr)
        
        passed = result.returncode == 0
        return (test, passed, log_file)
    
    def run_suite(self, suite_name):
        """运行测试套件"""
        suite = self.config['suites'][suite_name]
        results = {}
        
        print(f"\n{'='*50}")
        print(f"Suite: {suite_name}")
        print(f"{'='*50}")
        
        # 并发运行测试
        with ThreadPoolExecutor(max_workers=4) as executor:
            futures = {executor.submit(self.run_test, test): test for test in suite['tests']}
            for future in futures:
                test, passed, log_file = future.result()
                results[test] = {'passed': passed, 'log': log_file}
                status = "PASS" if passed else "FAIL"
                print(f"  {test}: {status}")
        
        self.results[suite_name] = results
        return results
    
    def generate_report(self):
        """生成 HTML 报告"""
        timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        
        total = 0
        passed = 0
        failed = 0
        
        html = f"""<!DOCTYPE html>
<html>
<head>
    <title>Mini SoC Regression Report</title>
    <style>
        body {{ font-family: Arial; margin: 20px; background: #f5f5f5; }}
        .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 10px; }}
        .suite {{ margin: 20px 0; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }}
        .pass {{ color: green; font-weight: bold; }}
        .fail {{ color: red; font-weight: bold; }}
        table {{ width: 100%; border-collapse: collapse; margin-top: 10px; }}
        th, td {{ padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }}
        th {{ background: #f8f9fa; }}
        .summary {{ background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white; padding: 20px; border-radius: 10px; margin-top: 20px; }}
    </style>
</head>
<body>
    <div class="header">
        <h1>🚀 Mini SoC Regression Report</h1>
        <p>Generated: {timestamp}</p>
    </div>
"""
        
        for suite_name, results in self.results.items():
            suite = self.config['suites'][suite_name]
            html += f"""
    <div class="suite">
        <h2>{suite_name}: {suite['description']}</h2>
        <table>
            <tr><th>Test</th><th>Status</th><th>Log</th></tr>
"""
            for test, result in results.items():
                status = "✅ PASS" if result['passed'] else "❌ FAIL"
                cls = "pass" if result['passed'] else "fail"
                total += 1
                if result['passed']: passed += 1
                else: failed += 1
                html += f'<tr><td>{test}</td><td class="{cls}">{status}</td><td><a href="{result["log"]}">Log</a></td></tr>\n'
            html += "</table></div>\n"
        
        pass_rate = (passed / total * 100) if total > 0 else 0
        html += f"""
    <div class="summary">
        <h2>📊 Summary</h2>
        <p>Total: {total} | Passed: {passed} | Failed: {failed}</p>
        <p>Pass Rate: {pass_rate:.1f}%</p>
        <p>Status: {'✅ ALL PASSED' if failed == 0 else '❌ SOME FAILED'}</p>
    </div>
</body>
</html>
"""
        
        report_file = f"{self.log_dir}/report.html"
        with open(report_file, 'w') as f:
            f.write(html)
        
        print(f"\n{'='*50}")
        print(f"Report: {report_file}")
        print(f"Total: {total}, Passed: {passed}, Failed: {failed}")
        print(f"Pass Rate: {pass_rate:.1f}%")
        
        return failed == 0
    
    def run(self, mode="smoke"):
        """运行回归"""
        print(f"{'='*50}")
        print(f"  Mini SoC Regression: {mode}")
        print(f"{'='*50}")
        
        # 编译
        if not self.compile():
            return False
        
        # 运行套件
        for suite in self.config['modes'][mode]['suites']:
            self.run_suite(suite)
        
        # 生成报告
        return self.generate_report()

if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "ci"
    runner = RegressionRunner()
    success = runner.run(mode)
    sys.exit(0 if success else 1)

#!/usr/bin/env python3
"""
Mini SoC Industrial Regression System
=================================
支持:
- 多模式运行 (CI/Daily/Nightly/Weekly/Release)
- 并发执行
- 自动覆盖率合并
- HTML 报告生成
- 质量门禁检查
"""

import os
import subprocess
import sys
import yaml
import json
import argparse
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed
import shutil

class IndustrialRegression:
    def __init__(self, config="regress_industrial.yaml"):
        with open(config, 'r') as f:
            self.config = yaml.safe_load(f)
        
        self.timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        self.log_dir = f"logs_{self.timestamp}"
        self.cov_dir = f"cov_{self.timestamp}"
        os.makedirs(self.log_dir, exist_ok=True)
        os.makedirs(self.cov_dir, exist_ok=True)
        
        self.results = {}
        self.total_tests = 0
        self.passed_tests = 0
        self.failed_tests = 0
    
    def compile(self):
        """编译仿真"""
        print("="*60)
        print("  Compiling...")
        print("="*60)
        
        result = subprocess.run(
            ["make", "compile"],
            capture_output=True,
            text=True,
            timeout=600
        )
        
        if result.returncode != 0:
            print(f"❌ Compilation FAILED")
            print(result.stderr)
            return False
        
        print("✅ Compilation PASSED")
        return True
    
    def run_test(self, test_name):
        """运行单个测试"""
        print(f"  ▶ {test_name}")
        
        env = os.environ.copy()
        env["UVM_TESTNAME"] = test_name
        
        log_file = f"{self.log_dir}/{test_name}.log"
        cov_file = f"{self.cov_dir}/{test_name}.vdb"
        
        result = subprocess.run(
            ["./simv", "-coverage", "-covfile", f"+covfile={test_name}.ucd"],
            capture_output=True,
            text=True,
            env=env,
            timeout=600
        )
        
        # 保存日志
        with open(log_file, 'w') as f:
            f.write(result.stdout)
            f.write(result.stderr)
        
        passed = result.returncode == 0
        return test_name, passed, log_file
    
    def run_suite(self, suite_name):
        """运行测试套件"""
        suite = self.config['suites'][suite_name]
        parallel = suite.get('parallel', 1)
        tests = suite['tests']
        
        print(f"\n{'='*60}")
        print(f"  Suite: {suite_name}")
        print(f"  Tests: {len(tests)}, Parallel: {parallel}")
        print("="*60)
        
        results = {}
        
        # 并发执行
        with ThreadPoolExecutor(max_workers=parallel) as executor:
            futures = {executor.submit(self.run_test, test): test for test in tests}
            
            for future in as_completed(futures):
                test_name, passed, log_file = future.result()
                results[test_name] = {
                    'passed': passed,
                    'log': log_file
                }
                
                status = "✅ PASS" if passed else "❌ FAIL"
                print(f"  {test_name}: {status}")
                
                self.total_tests += 1
                if passed:
                    self.passed_tests += 1
                else:
                    self.failed_tests += 1
        
        self.results[suite_name] = results
        return results
    
    def generate_html_report(self):
        """生成 HTML 报告"""
        
        # 计算覆盖率
        cov_files = [f for f in os.listdir(self.cov_dir) if f.endswith('.vdb')]
        
        html = f"""<!DOCTYPE html>
<html>
<head>
    <title>Mini SoC Industrial Regression Report</title>
    <style>
        body {{
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }}
        .container {{
            background: white;
            border-radius: 20px;
            padding: 30px;
            max-width: 1400px;
            margin: 0 auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }}
        h1 {{
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 2.5em;
        }}
        .summary {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }}
        .card {{
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }}
        .card h3 {{
            margin: 0;
            font-size: 3em;
            color: #667eea;
        }}
        .card p {{
            margin: 10px 0 0;
            color: #666;
        }}
        .pass {{ background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); }}
        .fail {{ background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%); }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }}
        th, td {{
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }}
        th {{
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }}
        tr:hover {{ background: #f5f5f5; }}
        .status {{
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
        }}
        .status.pass {{
            background: #38ef7d;
            color: white;
        }}
        .status.fail {{
            background: #f45c43;
            color: white;
        }}
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Mini SoC Industrial Regression Report</h1>
        <p>Generated: {self.timestamp}</p>
        
        <div class="summary">
            <div class="card">
                <h3>{self.total_tests}</h3>
                <p>Total Tests</p>
            </div>
            <div class="card pass">
                <h3>{self.passed_tests}</h3>
                <p>Passed</p>
            </div>
            <div class="card fail">
                <h3>{self.failed_tests}</h3>
                <p>Failed</p>
            </div>
            <div class="card">
                <h3>{self.passed_tests*100/self.total_tests:.1f}%</h3>
                <p>Pass Rate</p>
            </div>
        </div>
        
        <h2>📊 Results by Suite</h2>
        <table>
            <tr><th>Suite</th><th>Tests</th><th>Passed</th><th>Failed</th><th>Status</th></tr>
"""
        
        for suite, results in self.results.items():
            suite_tests = len(results)
            suite_passed = sum(1 for r in results.values() if r['passed'])
            suite_failed = suite_tests - suite_passed
            pass_rate = suite_passed/suite_tests*100
            status = "✅ PASS" if pass_rate == 100 else "⚠️ PARTIAL"
            html += f'<tr><td>{suite}</td><td>{suite_tests}</td><td>{suite_passed}</td><td>{suite_failed}</td><td>{status}</td></tr>\n'
        
        html += """
        </table>
        
        <h2>📝 Test Details</h2>
        <table>
            <tr><th>Test</th><th>Suite</th><th>Status</th><th>Log</th></tr>
"""
        
        for suite, results in self.results.items():
            for test, result in results.items():
                status = "PASS" if result['passed'] else "FAIL"
                cls = "pass" if result['passed'] else "fail"
                html += f'<tr><td>{test}</td><td>{suite}</td><td><span class="status {cls}">{status}</span></td><td><a href="{result["log"]}">Log</a></td></tr>\n'
        
        html += """
        </table>
    </div>
</body>
</html>
"""
        
        report_file = f"{self.log_dir}/report.html"
        with open(report_file, 'w') as f:
            f.write(html)
        
        return report_file
    
    def check_quality_gates(self, mode):
        """检查质量门禁"""
        goals = self.config['quality_gates']
        pass_rate = self.passed_tests * 100 / self.total_tests if self.total_tests > 0 else 0
        
        required_rate = goals.get(f'{mode}_pass_rate', 100)
        
        print(f"\n{'='*60}")
        print(f"  Quality Gate Check")
        print(f"  Required: {required_rate}%")
        print(f"  Actual: {pass_rate:.1f}%")
        print("="*60)
        
        if pass_rate >= required_rate:
            print("✅ Quality Gate PASSED")
            return True
        else:
            print("❌ Quality Gate FAILED")
            return False
    
    def run(self, mode="ci"):
        """运行回归"""
        print("="*60)
        print(f"  Mini SoC Industrial Regression: {mode.upper()}")
        print("="*60)
        
        # 编译
        if not self.compile():
            return False
        
        # 运行套件
        for suite in self.config['modes'][mode]:
            self.run_suite(suite)
        
        # 生成报告
        report_file = self.generate_html_report()
        
        # 检查质量门禁
        gate_passed = self.check_quality_gates(mode)
        
        # 总结
        print(f"\n{'='*60}")
        print(f"  SUMMARY")
        print(f"  Total: {self.total_tests}")
        print(f"  Passed: {self.passed_tests}")
        print(f"  Failed: {self.failed_tests}")
        print(f"  Report: {report_file}")
        print("="*60)
        
        return gate_passed

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--mode', default='ci', choices=['ci', 'daily', 'nightly', 'weekly', 'release'])
    args = parser.parse_args()
    
    runner = IndustrialRegression()
    success = runner.run(args.mode)
    sys.exit(0 if success else 1)

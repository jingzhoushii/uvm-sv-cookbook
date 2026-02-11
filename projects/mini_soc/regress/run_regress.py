#!/usr/bin/env python3
"""
Mini SoC Regression Runner
"""

import os
import subprocess
import sys
import yaml
from datetime import datetime

class RegressionRunner:
    def __init__(self, config_file="regress.yaml"):
        with open(config_file, 'r') as f:
            self.config = yaml.safe_load(f)
        
        self.results_dir = f"results_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
        os.makedirs(self.results_dir, exist_ok=True)
    
    def compile(self):
        """Compile simulation"""
        print("=== Compiling ===")
        result = subprocess.run(
            ["make", "compile"],
            capture_output=True,
            text=True
        )
        return result.returncode == 0
    
    def run_test(self, test_name):
        """Run single test"""
        print(f"  Running: {test_name}")
        env = os.environ.copy()
        env["UVM_TESTNAME"] = test_name
        
        result = subprocess.run(
            ["./simv"],
            capture_output=True,
            text=True,
            env=env,
            timeout=600
        )
        return result.returncode == 0
    
    def run_suite(self, suite_name):
        """Run test suite"""
        suite = self.config['suites'][suite_name]
        results = {}
        
        print(f"\n=== Suite: {suite_name} ===")
        for test in suite['tests']:
            passed = self.run_test(test)
            results[test] = passed
            status = "PASS" if passed else "FAIL"
            print(f"  {test}: {status}")
        
        return results
    
    def generate_report(self, results):
        """Generate HTML report"""
        html = f"""
<!DOCTYPE html>
<html>
<head>
    <title>Mini SoC Regression Report</title>
    <style>
        body {{ font-family: Arial; margin: 20px; }}
        table {{ border-collapse: collapse; width: 100%; }}
        th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
        th {{ background-color: #4CAF50; color: white; }}
        .pass {{ background-color: #90EE90; }}
        .fail {{ background-color: #FFB6C1; }}
    </style>
</head>
<body>
    <h1>Mini SoC Regression Report</h1>
    <p>Generated: {datetime.now()}</p>
    <table>
        <tr><th>Test</th><th>Status</th></tr>
"""
        for suite, tests in results.items():
            for test, passed in tests.items():
                status = "PASS" if passed else "FAIL"
                cls = "pass" if passed else "fail"
                html += f'<tr><td>{test}</td><td class="{cls}">{status}</td></tr>\n'
        
        html += """
    </table>
</body>
</html>
"""
        with open(f"{self.results_dir}/report.html", 'w') as f:
            f.write(html)
        print(f"\nReport: {self.results_dir}/report.html")
    
    def run(self, mode="smoke"):
        """Run regression"""
        print(f"=== Mini SoC Regression: {mode} ===")
        
        # Compile
        if not self.compile():
            print("Compilation FAILED")
            return False
        
        # Run suite
        suite = self.config['modes'][mode]['suites']
        all_results = {}
        for s in suite:
            all_results[s] = self.run_suite(s)
        
        # Report
        self.generate_report(all_results)
        
        return True

if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "smoke"
    runner = RegressionRunner()
    runner.run(mode)

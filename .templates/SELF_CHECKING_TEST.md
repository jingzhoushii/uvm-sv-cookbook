# Self-Checking Test 规范

## 自动判断 Pass/Fail

```systemverilog
class my_test extends uvm_test;
    bit test_passed = 1;
    
    // 在 scoreboard 中检查
    virtual function void check_result(transaction exp, transaction act);
        if (exp.data != act.data) begin
            `uvm_error("MISMATCH", $sformatf("Exp: %0h, Act: %0h", exp.data, act.data))
            test_passed = 0;
        end
    endfunction
    
    // 报告结果
    virtual function void report_phase(uvm_phase phase);
        if (test_passed)
            `uvm_info("TEST_RESULT", "PASSED", UVM_LOW)
        else
            `uvm_fatal("TEST_RESULT", "FAILED")
    endfunction
endclass
```

## 退出码规则

- 0: PASSED
- 1: FAILED


# 性能基准测试

## 性能测试框架

```systemverilog
class perf_test extends uvm_test;
    int transaction_count = 100000;
    time start_time, end_time;
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        start_time = $time;
        run_sequences();
        end_time = $time;
        report_performance();
        phase.drop_objection(this);
    endtask
    
    function void report_performance();
        real throughput = transaction_count / ((end_time - start_time) * 1ns);
        `uvm_info("PERF", $sformatf("Throughput: %0.2f txn/us", throughput), UVM_LOW)
    endfunction
endclass
```


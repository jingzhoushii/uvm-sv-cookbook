# 🤖 自动报告机制

## uvm_subscriber 自动报告

```mermaid
graph TD
    A[uvm_subscriber] --> B[write() 方法]
    B --> C[覆盖率收集]
    C --> D[report_phase]
    D --> E[自动输出]
```

## 基本结构

```systemverilog
class auto_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(auto_coverage)
    
    covergroup cg;
        // 覆盖组定义
        ADDR: coverpoint tr.addr;
        DATA: coverpoint tr.data;
    endgroup
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new();
    endfunction
    
    // 自动收集
    virtual function void write(T t);
        void'(cg.sample());
    endfunction
    
    // 报告方法
    virtual function void report();
        real cov = cg.get_inst_coverage();
        `uvm_info("COV", 
            $sformatf("Coverage: %0.1f%%", cov), UVM_LOW)
    endfunction
endclass
```

## 多覆盖组报告

```systemverilog
class multi_coverage extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(multi_coverage)
    
    // 多个覆盖组
    trans_coverage trans_cov;
    reg_coverage reg_cov;
    cross_coverage cross_cov;
    
    // 分析端口
    uvm_analysis_export#(bus_trans) analysis_export;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        trans_cov = new("trans_cov", this);
        reg_cov = new("reg_cov", this);
        cross_cov = new("cross_cov", this);
        analysis_export = new("analysis_export", this);
    endfunction
    
    virtual function void write(T t);
        trans_cov.write(t);
        reg_cov.write(t);
        cross_cov.write(t);
    endfunction
    
    virtual function void report();
        real trans_c = trans_cov.get_coverage();
        real reg_c = reg_cov.get_coverage();
        real cross_c = cross_cov.get_coverage();
        real overall = (trans_c + reg_c + cross_c) / 3;
        
        `uvm_info("=" * 40, "", UVM_LOW)
        `uvm_info("COV_REPORT", "Coverage Summary", UVM_LOW)
        `uvm_info("COV_REPORT", 
            $sformatf("Transaction: %0.1f%%", trans_c), UVM_LOW)
        `uvm_info("COV_REPORT", 
            $sformatf("Register: %0.1f%%", reg_c), UVM_LOW)
        `uvm_info("COV_REPORT", 
            $sformatf("Cross: %0.1f%%", cross_c), UVM_LOW)
        `uvm_info("COV_REPORT", 
            $sformatf("Overall: %0.1f%%", overall), UVM_LOW)
        `uvm_info("=" * 40, "", UVM_LOW)
    endfunction
endclass
```

## 覆盖率数据库

```systemverilog
class coverage_db extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(coverage_db)
    
    // 覆盖组实例
    bus_coverage bus_cov;
    uart_coverage uart_cov;
    dma_coverage dma_cov;
    
    // 全局覆盖率
    static real global_coverage = 0;
    static int sample_count = 0;
    
    // 分析导出
    uvm_analysis_export#(bus_trans) bus_in;
    uvm_analysis_export#(uart_trans) uart_in;
    uvm_analysis_export#(bus_trans) dma_in;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        bus_cov = new("bus_cov", this);
        uart_cov = new("uart_cov", this);
        dma_cov = new("dma_cov", this);
        
        bus_in = new("bus_in", this);
        uart_in = new("uart_in", this);
        dma_in = new("dma_in", this);
    endfunction
    
    virtual function void write(T t);
        bus_cov.write(t);
        sample_count++;
    endfunction
    
    // UART 回调
    virtual function void write_uart(uvm_tlm_analysis_port#(uart_trans) port,
                                      uart_trans t);
        uart_cov.write(t);
    endfunction
    
    virtual function void report();
        real bus_c = bus_cov.get_coverage();
        real uart_c = uart_cov.get_coverage();
        real dma_c = dma_cov.get_coverage();
        global_coverage = (bus_c + uart_c + dma_c) / 3;
        
        `uvm_info("DB_REPORT", 
            $sformatf("Samples: %0d", sample_count), UVM_LOW)
        `uvm_info("DB_REPORT", 
            $sformatf("Bus: %0.1f%%", bus_c), UVM_LOW)
        `uvm_info("DB_REPORT", 
            $sformatf("UART: %0.1f%%", uart_c), UVM_LOW)
        `uvm_info("DB_REPORT", 
            $sformatf("DMA: %0.1f%%", dma_c), UVM_LOW)
        `uvm_info("DB_REPORT", 
            $sformatf("Global: %0.1f%%", global_coverage), UVM_LOW)
    endfunction
endclass
```

## 覆盖率导出

```systemverilog
class coverage_exporter extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(coverage_exporter)
    
    // 当前覆盖率
    real current_cov = 0;
    
    // 覆盖率历史
    real history[100];
    int history_idx = 0;
    
    virtual function void write(T t);
        current_cov = calculate_coverage();
        save_history();
    endfunction
    
    function real calculate_coverage();
        // 计算当前覆盖率
        return $urandom_range(60, 90);
    endfunction
    
    function void save_history();
        history[history_idx] = current_cov;
        history_idx = (history_idx + 1) % 100;
    endfunction
    
    // 导出覆盖率数据
    function void export_coverage(output real cov);
        cov = current_cov;
    endfunction
    
    // 导出历史数据
    function void export_history(output real hist[100]);
        foreach (hist[i]) hist[i] = history[i];
    endfunction
endclass
```

## HTML 报告生成

```systemverilog
class html_coverage_report extends uvm_subscriber#(bus_trans);
    `uvm_component_utils(html_coverage_report)
    
    string report_file = "coverage_report.html";
    int trans_count = 0;
    
    virtual function void write(T t);
        trans_count++;
    endfunction
    
    virtual function void report();
        generate_html_report();
    endfunction
    
    function void generate_html_report();
        int fd = $fopen(report_file, "w");
        
        $fdisplay(fd, "<html>");
        $fdisplay(fd, "<head>");
        $fdisplay(fd, "<title>Coverage Report</title>");
        $fdisplay(fd, "<style>");
        $fdisplay(fd, "body { font-family: Arial; }");
        $fdisplay(fd, ".cov { background: #667eea; color: white; }");
        $fdisplay(fd, "</style>");
        $fdisplay(fd, "</head>");
        $fdisplay(fd, "<body>");
        $fdisplay(fd, "<h1>Coverage Report</h1>");
        $fdisplay(fd, "<p>Transactions: %0d</p>", trans_count);
        $fdisplay(fd, "<div class='cov'>Coverage: %0.1f%%</div>", 
            get_coverage());
        $fdisplay(fd, "</body>");
        $fdisplay(fd, "</html>");
        
        $fclose(fd);
        `uvm_info("HTML", $sformatf("Report: %s", report_file), UVM_LOW)
    endfunction
    
    function real get_coverage();
        return 85.5;  // 示例值
    endfunction
endclass
```

## 覆盖率收集器集成

```systemverilog
// ==========================================
// 完整的覆盖率环境
// ==========================================
class coverage_env extends uvm_env;
    `uvm_component_utils(coverage_env)
    
    // Agent
    bus_agent bus_agt;
    uart_agent uart_agt;
    dma_agent dma_agt;
    
    // 覆盖率收集器
    bus_coverage bus_cov;
    uart_coverage uart_cov;
    dma_coverage dma_cov;
    
    // 覆盖率报告器
    coverage_reporter cov_reporter;
    
    virtual function void build_phase(uvm_phase phase);
        bus_agt = bus_agent::type_id::create("bus_agt", this);
        uart_agt = uart_agent::type_id::create("uart_agt", this);
        dma_agt = dma_agent::type_id::create("dma_agt", this);
        
        bus_cov = bus_coverage::type_id::create("bus_cov", this);
        uart_cov = uart_coverage::type_id::create("uart_cov", this);
        dma_cov = dma_coverage::type_id::create("dma_cov", this);
        cov_reporter = coverage_reporter::type_id::create(
            "cov_reporter", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        // 连接分析端口
        bus_agt.monitor.ap.connect(bus_cov.analysis_export);
        bus_agt.monitor.ap.connect(cov_reporter.bus_in);
        uart_agt.monitor.ap.connect(uart_cov.analysis_export);
        uart_agt.monitor.ap.connect(cov_reporter.uart_in);
        dma_agt.monitor.ap.connect(dma_cov.analysis_export);
        dma_agt.monitor.ap.connect(cov_reporter.dma_in);
    endfunction
    
    virtual function void report_phase(uvm_phase phase);
        // 报告覆盖率
        cov_reporter.report();
    endfunction
endclass
```

## 最佳实践

| 实践 | 说明 |
|------|------|
| 统一报告格式 | 使用相同的报告结构 |
| 设置目标 | 明确覆盖率目标 |
| 分阶段报告 | 每个测试后输出 |
| 历史记录 | 跟踪覆盖率变化 |

## 常见问题

| 问题 | 解决方案 |
|------|----------|
| 报告不完整 | 检查所有覆盖组 |
| 覆盖率丢失 | 使用数据库存储 |
| 报告格式差 | 使用 HTML/JSON |

## 进阶阅读

- [完整示例](../examples/)
- [寄存器覆盖率](03-reg-coverage/)

# 06-final-phase - UVM 结束阶段

## 📚 知识点

- **final_phase** 执行时机
- **资源清理**
- **关闭文件句柄**
- **与操作系统交互**

## 📖 背景知识

仿真完全结束后执行，用于：

1. 关闭打开的文件
2. 清理动态分配的资源
3. 生成最终报告

## 📝 关键代码

```systemverilog
virtual function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    
    // 关闭文件
    if (log_file != null) begin
        $fclose(log_file);
    end
    
    // 打印最终统计
    $display("Simulation completed at %0t", $time);
endfunction
```

---

**快速导航**: [返回根目录](../../README.md) | [上一章节](../05-report-phase)

# Rate-Controlled Sequences - 流控型序列模型

## 概述

工业级序列模型，包含信用控制、速率限制、流量整形等。

## 序列类型

| 类型 | 说明 |
|------|------|
| credit-based | 基于信用的流量控制 |
| rate-controlled | 速率限制序列 |
| traffic-shaping | 流量整形 |

## 代码示例

### Rate-Limited Sequence
```systemverilog
class rate_limit_seq extends base_seq;
    time min_gap;
    
    task body();
        forever begin
            `uvm_do(req)
            #(min_gap);
        end
    endtask
endclass
```


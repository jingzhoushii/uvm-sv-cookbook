# 常用断言示例

## 1. 握手断言
```systemverilog
assert property (@(posedge clk)
    req |-> ##[1:3] ack);
```

## 2. FIFO 满断言
```systemverilog
assert property (@(posedge clk)
    (wr_en && (count == DEPTH)) |-> !wr_en);
```

## 3. 状态机断言
```systemverilog
assert property (@(posedge clk)
    (state == IDLE) |-> req || (state == IDLE));
```


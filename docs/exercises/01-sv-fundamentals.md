# 📝 SV 基础练习题

## Level 1：基础（10 题）

### 练习 1：数据类型转换
将以下整数转换为指定类型：
```systemverilog
int i = 100;
bit [7:0] b;
logic [7:0] l;

// 转换为 bit [7:0]
b = i[7:0];

// 转换为 logic
l = i[7:0];
```

### 练习 2：数组操作
创建动态数组，插入 10 个随机数，排序后打印。

### 练习 3：结构体
定义包含以下字段的结构体：
```systemverilog
typedef struct {
    bit [31:0] addr;
    bit [31:0] data;
    bit        rw;
    time        timestamp;
} bus_transaction_t;
```

### 练习 4：枚举类型
定义包含 IDLE, READ, WRITE 三种状态的枚举。

### 练习 5：类继承
创建基类 `animal`，派生类 `dog` 和 `cat`。

---

## Level 2：进阶（5 题）

### 练习 6：随机化约束
实现带约束的 Transaction：
- addr 在 0~100 范围
- data 不能为 0 或 FFFF_FFFF
- read:write = 1:2 比例

### 练习 7：覆盖率
创建包含 addr/data 交叉覆盖的覆盖率组。

### 练习 8：Mailbox
实现生产者-消费者模型。

### 练习 9：Semaphore
实现 3 个进程互斥访问共享资源。

### 练习 10：Interface
定义包含时钟、复位、valid/ready 的总线接口。

---

## Level 3：综合（3 题）

### 练习 11：FIFO 验证
用 SV 实现同步 FIFO 的验证代码。

### 练习 12：FSM 验证
实现序列检测器（检测 101 序列）。

### 练习 13：Scoreboard
实现 Reference Model + Scoreboard 比较。


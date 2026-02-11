# Transaction Pooling

## 对象池模式

复用 transaction 对象，避免频繁分配内存。

```systemverilog
class txn_pool extends uvm_object;
    trans free_list[$];
    
    function trans get();
        if (free_list.size() > 0)
            return free_list.pop_front();
        return trans::type_id::create("new");
    endfunction
    
    function void put(trans t);
        free_list.push_back(t);
    endfunction
endclass
```


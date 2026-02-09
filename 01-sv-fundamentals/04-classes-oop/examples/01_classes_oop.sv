// ============================================================
// File: 01_classes_oop.sv
// Description: SystemVerilog 面向对象示例
// ============================================================

`timescale 1ns/1ps

module classes_oop_demo;
    
    // 1. 基础类
    class Animal;
        string name;
        int age;
        
        function new(string n, int a);
            name = n;
            age = a;
        endfunction
        
        virtual function void speak();
            $display("Animal makes sound");
        endfunction
        
        function void print();
            $display("%s is %0d years old", name, age);
        endfunction
    endclass
    
    // 2. 继承
    class Dog extends Animal;
        string breed;
        
        function new(string n, int a, string b);
            super.new(n, a);
            breed = b;
        endfunction
        
        // 重写父类方法
        virtual function void speak();
            $display("Woof! Woof!");
        endfunction
        
        function void fetch();
            $display("%s is fetching", name);
        endfunction
    endclass
    
    // 3. 抽象类
    abstract class Shape;
        int x, y;
        
        pure virtual function int get_area();
    endclass
    
    class Rectangle extends Shape;
        int width, height;
        
        function new(int xx, int yy, int w, int h);
            x = xx;
            y = yy;
            width = w;
            height = h;
        endfunction
        
        virtual function int get_area();
            return width * height;
        endfunction
    endclass
    
    // 4. 静态变量
    class Counter;
        static int count = 0;
        int id;
        
        function new();
            id = ++count;
        endfunction
        
        static function void print_count();
            $display("Total counters created: %0d", count);
        endfunction
    endclass
    
    // 测试
    Animal a;
    Dog d;
    Rectangle r;
    Counter c1, c2;
    
    initial begin
        $display("========================================");
        $display("  Classes & OOP Demo");
        $display("========================================");
        $display("");
        
        // 基础类
        $display("--- 基础类 ---");
        a = new("Generic Animal", 5);
        a.print();
        a.speak();
        
        // 继承
        $display("");
        $display("--- 继承 ---");
        d = new("Buddy", 3, "Golden Retriever");
        d.print();
        $display("Breed: %s", d.breed);
        d.speak();
        d.fetch();
        
        // 抽象类
        $display("");
        $display("--- 抽象类 ---");
        r = new(0, 0, 10, 5);
        $display("Rectangle area: %0d", r.get_area());
        
        // 静态变量
        $display("");
        $display("--- 静态变量 ---");
        c1 = new();
        c2 = new();
        Counter.print_count();
        $display("c1 id=%0d, c2 id=%0d", c1.id, c2.id);
        
        $display("");
        $display("========================================");
        $display("  Demo Complete!");
        $display("========================================");
        $finish;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, classes_oop_demo);
    end
    
endmodule

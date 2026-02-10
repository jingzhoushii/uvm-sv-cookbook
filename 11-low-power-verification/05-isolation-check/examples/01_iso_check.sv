`timescale 1ns/1ps
class iso_check extends uvm_component;
    `uvm_component_utils(iso_check) bit iso_en, data_in, data_out;
    function new(string n,uvm_component p);super.new(n,p);endfunction
    task check();
        if (!iso_en) begin
            data_out = data_in ? 1'bZ : 1'b0; // Clamp low
            `uvm_info("ISO",$sformatf("iso_en=%b data_out=%b",iso_en,data_out),UVM_LOW)
        end
    endtask
endclass
module tb; initial begin iso_check c; c=new("c",null); c.iso_en=0; c.data_in=1; c.check(); #100; $finish; end initial $dumpfile("dump.vcd"); $dumpvars(0,tb); endmodule

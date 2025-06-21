module adder #(parameter NUM = 2 )
(
    input  logic [NUM-1:0] a,
    input  logic [NUM-1:0] b,
    output logic [NUM-1:0] sum
);
assign sum = a + b;

endmodule

module SRAM
(
   input logic [7:0]address,
   input logic [7:0]data_in,
   input logic write_en,
   input logic read_en,
   input logic clk,
   output logic [7:0]data_out
);
logic [7:0] memory [0:255];
always_ff@ (posedge clk) begin
    if(write_en) memory[address] <= data_in;
    if(read_en) data_out <= memory[address];
end
endmodule

module counter #(parameter COUNT_MAX = 100)
(
    input logic clk,
    input logic rst_n,
    output logic busy,
    output logic [5:0] count
);
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        count <= 0;
        busy <=0;
    end
    else if (count < COUNT_MAX)begin
        count <= count + 1;
        busy <= 1;
    end
    else if (count == COUNT_MAX) begin
        busy <=0;
        count <= 0;
    end

end

endmodule

interface my_if;
    logic clk;
    logic rst_n;
endinterface

// Testbench for the modules
module tb;

my_if if_tb();

//just a testbench for the mentioned modules above.

//test
//second commit
endmodule
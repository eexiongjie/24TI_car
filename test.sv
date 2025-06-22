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

module adder_pipeline #(parameter NUM = 3)
(
    input logic [7:0]data_i[0:7],
    input logic clk,
    input logic valid_i,
    input logic reset_n
    output logic [10:0]data_o,
    output logic valid_o
);
logic [7:0]data_i_tmp[0:7];
logic [8:0] sum_partial_one[0:3];
logic [9:0] sum_partial_two[0:1];
logic [2:0]valid_tmp;
logic [10:0]data_o_tmp;

always_ff @(posedge clk or negedge reset_n)begin
    if (!reset_n) valid_tmp <= 3'b0;
    else if (valid_i) begin
        data_i_tmp <= data_i;
        valid_tmp <= {valid_tmp[1:0],1'b1};
    end
    else begin
        valid_tmp <= {valid_tmp[1:0],1'b0};
    end
end
assign valid_o = valid_tmp[2];

always_ff @(posedge clk)begin
    sum_partial_one[0] <= data_i_tmp[0] + data_i_tmp[1];
    sum_partial_one[1] <= data_i_tmp[2] + data_i_tmp[3];
    sum_partial_one[2] <= data_i_tmp[4] + data_i_tmp[5];
    sum_partial_one[3] <= data_i_tmp[6] + data_i_tmp[7];

    sum_partial_two[0] <= sum_partial_one[0] + sum_partial_one[1];
    sum_partial_two[1] <= sum_partial_one[0] + sum_partial_one[1];

    data_o_tmp <= sum_partial_two[0] + sum_partial_two[1];

end
assign data_o = valid_o ? data_o_tmp : 11'bz;

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
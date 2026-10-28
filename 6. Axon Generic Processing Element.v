`timescale 1ns/1ps
// Generic Axon PE with Bi-directional Dataflow
module Axon_Generic_PE #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] in_data, // Data Input from adjacent PE
    input [DATA_WIDTH-1:0] in_w, // Input Weight from adjacent PE
    input [DATA_WIDTH-1:0] in_diag, // Input along Principle Diagonal
    input [ACC_WIDTH-1:0] in_acc, // Partial Sum from adjacent PE
    output [DATA_WIDTH-1:0] out_data, // Data Output
    output [DATA_WIDTH-1:0] out_w, // Weight Output
    output [ACC_WIDTH-1:0] out_psum, // Partial Sum Output
    // Global Control Signals
    input clk, rst, // FF Control Signals
    input sel1, sel2, // Mux Selections
    input EN_data, EN_w// Enable Loads
);  
    reg [DATA_WIDTH-1:0] reg_data, reg_w; // Internal Registers
    wire [DATA_WIDTH- 1:0] mux1, mux2; // Muxes for Data and Weights respectively
    wire [ACC_WIDTH- 1:0] sum, prod; // Local Sum and Product

    assign mux1 = (sel1) ? in_diag : in_data;
    assign mux2 = (sel2) ? in_diag : in_w;

    assign prod = (reg_data == 0 || reg_w == 0) ? {ACC_WIDTH{1'b0}} : (reg_data * reg_w); // Zero Gating applied
    assign sum = prod + in_acc;

    always @(posedge clk) begin
        if (rst) begin // Reset 
            reg_data <= 0; 
            reg_w <= 0; 
        end 
        else begin // Registers values from Mux if Enable is 1
            if (EN_data) reg_data <= mux1;
            if (EN_w) reg_w <= mux2;
        end
    end
    
    assign out_data = reg_data;
    assign out_w = reg_w;
    assign out_psum = sum; 

endmodule


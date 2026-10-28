`include "Axon_PE.v"
module Axon_16x16 #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16
) (
    input clk, rst,
    
    // Individual In_Data Ports
    input [DATA_WIDTH-1:0] in_data0,  in_data1,  in_data2,  in_data3,
    input [DATA_WIDTH-1:0] in_data4,  in_data5,  in_data6,  in_data7,
    input [DATA_WIDTH-1:0] in_data8,  in_data9,  in_data10, in_data11,
    input [DATA_WIDTH-1:0] in_data12, in_data13, in_data14, in_data15,

    // Individual In_W (Weights) Ports
    input [DATA_WIDTH-1:0] in_w0,  in_w1,  in_w2,  in_w3,
    input [DATA_WIDTH-1:0] in_w4,  in_w5,  in_w6,  in_w7,
    input [DATA_WIDTH-1:0] in_w8,  in_w9,  in_w10, in_w11,
    input [DATA_WIDTH-1:0] in_w12, in_w13, in_w14, in_w15,

    // Individual In_Diag (Diagonal) Ports
    input [DATA_WIDTH-1:0] in_diag0,  in_diag1,  in_diag2,  in_diag3,
    input [DATA_WIDTH-1:0] in_diag4,  in_diag5,  in_diag6,  in_diag7,
    input [DATA_WIDTH-1:0] in_diag8,  in_diag9,  in_diag10, in_diag11,
    input [DATA_WIDTH-1:0] in_diag12, in_diag13, in_diag14, in_diag15,

    // Individual In_Acc (Accumulator) Ports
    input [ACC_WIDTH-1:0] in_acc0,  in_acc1,  in_acc2,  in_acc3,
    input [ACC_WIDTH-1:0] in_acc4,  in_acc5,  in_acc6,  in_acc7,
    input [ACC_WIDTH-1:0] in_acc8,  in_acc9,  in_acc10, in_acc11,
    input [ACC_WIDTH-1:0] in_acc12, in_acc13, in_acc14, in_acc15,

    input sel1, sel2, EN_data, EN_w,

    // Individual Out_Acc (Output) Ports
    output [ACC_WIDTH-1:0] out_acc0,  out_acc1,  out_acc2,  out_acc3,
    output [ACC_WIDTH-1:0] out_acc4,  out_acc5,  out_acc6,  out_acc7,
    output [ACC_WIDTH-1:0] out_acc8,  out_acc9,  out_acc10, out_acc11,
    output [ACC_WIDTH-1:0] out_acc12, out_acc13, out_acc14, out_acc15
);

    // Group discrete inputs into flat vectors inside the module for loop readability
    wire [(16*DATA_WIDTH)-1:0] flat_data = {in_data15, in_data14, in_data13, in_data12, in_data11, in_data10, in_data9, in_data8, in_data7, in_data6, in_data5, in_data4, in_data3, in_data2, in_data1, in_data0};
    wire [(16*DATA_WIDTH)-1:0] flat_w    = {in_w15, in_w14, in_w13, in_w12, in_w11, in_w10, in_w9, in_w8, in_w7, in_w6, in_w5, in_w4, in_w3, in_w2, in_w1, in_w0};
    wire [(16*DATA_WIDTH)-1:0] flat_diag = {in_diag15, in_diag14, in_diag13, in_diag12, in_diag11, in_diag10, in_diag9, in_diag8, in_diag7, in_diag6, in_diag5, in_diag4, in_diag3, in_diag2, in_diag1, in_diag0};
    wire [(16*ACC_WIDTH)-1:0]  flat_acc  = {in_acc15, in_acc14, in_acc13, in_acc12, in_acc11, in_acc10, in_acc9, in_acc8, in_acc7, in_acc6, in_acc5, in_acc4, in_acc3, in_acc2, in_acc1, in_acc0};

    // Internal 2D wire matrices for interconnect routing
    wire [DATA_WIDTH-1:0] w_wire [0:16][0:15]; 
    wire [ACC_WIDTH-1:0]  a_wire [0:16][0:15]; 

    // Capture outputs from the internal grid structure
    wire [(16*ACC_WIDTH)-1:0] flat_out_acc;
    assign {out_acc15, out_acc14, out_acc13, out_acc12, out_acc11, out_acc10, out_acc9, out_acc8, out_acc7, out_acc6, out_acc5, out_acc4, out_acc3, out_acc2, out_acc1, out_acc0} = flat_out_acc;

    genvar r, c;
    generate
        // Connect inputs and outputs to internal boundary wires
        for (c = 0; c < 16; c = c + 1) begin : col_init
            assign w_wire[0][c] = flat_w[(c*DATA_WIDTH) +: DATA_WIDTH];
            assign a_wire[0][c] = flat_acc[(c*ACC_WIDTH) +: ACC_WIDTH];
            assign flat_out_acc[(c*ACC_WIDTH) +: ACC_WIDTH] = a_wire[16][c];
        end

        // Scale loop structure for 256 PEs
        for (r = 0; r < 16; r = r + 1) begin : rows
            for (c = 0; c < 16; c = c + 1) begin : cols
                
                wire [DATA_WIDTH-1:0] current_data = flat_data[(r*DATA_WIDTH) +: DATA_WIDTH];
                wire [DATA_WIDTH-1:0] diag_slice   = flat_diag[(r*DATA_WIDTH) +: DATA_WIDTH];
                wire [DATA_WIDTH-1:0] current_diag = (r == c) ? diag_slice : {DATA_WIDTH{1'b0}};

                Axon_PE #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .ACC_WIDTH(ACC_WIDTH)
                ) PE (
                    .clk(clk), .rst(rst),
                    .in_data(current_data),          
                    .in_w(w_wire[r][c]),           
                    .in_diag(current_diag),        
                    .in_acc(a_wire[r][c]),         
                    .sel1(sel1), .sel2(sel2),
                    .EN_data(EN_data), .EN_w(EN_w),
                    .out_w(w_wire[r+1][c]),        
                    .out_psum(a_wire[r+1][c])      
                );
            end
        end
    endgenerate

endmodule
    

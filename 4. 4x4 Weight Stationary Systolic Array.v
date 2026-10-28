// 4x4 Weight Stationary Systolic Array 
// Module PE if from PE_WS.v
module Sys_Arr_4x4 #(
    parameter DATA_WIDTH = 8, parameter ACC_WIDTH = 16, parameter N = 4 // for NxN Array
) (
    input wire rst, clk, w_load_en,  
    input wire [DATA_WIDTH- 1:0] in_w [0:N-1][0:N-1], 
    input wire [DATA_WIDTH- 1:0] in_data [0:N-1], // West
    input wire [ACC_WIDTH- 1:0] in_acc [0:N-1], // North
    output wire [DATA_WIDTH- 1:0] out_data [0:N-1], // East
    output wire [ACC_WIDTH- 1:0] out_acc [0:N-1] // South
);
    wire [DATA_WIDTH- 1:0] inter_data [0:N-1][0:N];
    wire [ACC_WIDTH- 1:0] inter_acc [0:N][0:N-1];
    genvar r, c;
    // Input Data
    generate
        for (r = 0; r < N; r = r + 1) begin : input_left
            assign inter_data [r][0] = in_data[r];
        end
    endgenerate
    // Input Accumulation
    generate 
        for (c = 0; c < N; c = c + 1) begin : input_north
            assign inter_acc [0][c] = in_acc[c];
        end
    endgenerate
    // Output Data
    generate
        for (r = 0; r < N; r = r + 1) begin : output_right
            assign out_data [r] = inter_data[r][N];
        end
    endgenerate
    // Output Accumulation
    generate 
        for (c = 0; c < N; c = c + 1) begin : output_south
            assign out_acc [c] = inter_acc [N][c];
        end
    endgenerate

    // PE Instantiation
    generate
        for (r = 0; r < N; r = r + 1) begin : row_operation
            for (c = 0; c < N; c = c + 1) begin : col_operation
                PE #(
                    .DATA_WIDTH(DATA_WIDTH),
                    .ACC_WIDTH (ACC_WIDTH)
                ) 
                pe_inst (
                    .clk(clk), .rst(rst), .w_load_en(w_load_en), // Control Signals
                    .in_w(in_w[r][c]), // Weight input 
                    // Data: comes from left, passes right
                    .in_data(inter_data[r][c]),
                    .out_data(inter_data[r][c+1]),
                    // Accumulator: comes from above, passes down
                    .in_acc(inter_acc[r][c]),
                    .out_acc(inter_acc[r+1][c])
                );
            end
        end
    endgenerate

endmodule

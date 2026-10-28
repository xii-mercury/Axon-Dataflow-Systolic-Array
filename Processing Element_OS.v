// PE: Multiply Accumulate (MAC) Unit 
module PE #(                                     // '#()' for scalability
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16                     // UPDATED: Reduced to 16-bit per guide's instruction
) (
    input wire rst, clk,                         // Control Signals
    input wire [DATA_WIDTH- 1:0] in_w, in_data,  // 8-bit Input Signals
    output reg [DATA_WIDTH- 1:0] out_w,          // 16-bit Input Signals
    output reg [DATA_WIDTH- 1:0] out_data,       // 8-bit Output Signal
    output wire [ACC_WIDTH- 1:0] out_acc          // 16-bit Output Signal
);
    // Stationary Partial Sum Register
    reg [ACC_WIDTH- 1:0] acc_reg;    
    // Internal wire to hold the product from the exact multiplier
    wire [15:0] mult_out;

    // Instantiating the Exact Multiplier Module
    exact mult_inst (
        .a(in_data),
        .b(in_w),
        .y(mult_out)
    ); //mult_out is obtained as the output here
    
    assign out_acc = acc_reg;
    
    always @(posedge clk) begin
        if (rst) begin                  
            acc_reg <= 0;
            out_data <= 0;
            out_w <= 0;
        end
        else begin
            out_data <= in_data;                 
            out_w <= in_w;
            acc_reg <= acc_reg + mult_out;
        end
    end
endmodule

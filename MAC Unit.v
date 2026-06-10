// PE: Multiply Accumulate (MAC) Unit 
module PE #(                                     // '#()' for scalability
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 32
) (
    input wire reset, clk, w_load_en,             // Control Signals
    input wire [DATA_WIDTH- 1:0] in_w, in_data,   // 8-bit Input Signals
    input wire [ACC_WIDTH- 1:0] in_acc,           // 32-bit Input Signals
    output reg [DATA_WIDTH- 1:0] out_data,        // 8-bit Output Signal
    output reg [ACC_WIDTH- 1:0] out_acc           // 32-bit Output Signal
);
    // Internal Registers 
    reg [DATA_WIDTH- 1:0] w_reg;
    reg [ACC_WIDTH- 1:0] acc_reg;

    always @(posedge clk) begin
        // Outputs as well as Internal ACC register to be reset to 0
        if (reset) begin                  
            acc_reg <= 0;
            out_data <= 0;
            out_acc <= 0;
        end
        else begin
            out_data <= in_data;
            if (w_load_en) begin
                w_reg <= in_w;
            end            
            out_acc <= (in_data * w_reg) + in_acc;
        end
    end
endmodule

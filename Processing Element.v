// PE: Multiply Accumulate (MAC) Unit 
module PE #(                                     // '#()' for scalability
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16                     // UPDATED: Reduced to 16-bit per guide's instruction
) (
    input wire rst, clk, w_load_en,              // Control Signals
    input wire [DATA_WIDTH- 1:0] in_w, in_data,  // 8-bit Input Signals
    input wire [ACC_WIDTH- 1:0] in_acc,          // 16-bit Input Signals
    output reg [DATA_WIDTH- 1:0] out_data,       // 8-bit Output Signal
    output reg [ACC_WIDTH- 1:0] out_acc          // 16-bit Output Signal
);
    // Internal Register for Stationary Weight
    reg [DATA_WIDTH- 1:0] w_reg;    
    // Internal wire to hold the product from the exact multiplier
    wire [15:0] mult_out;

    // Instantiating the Exact Multiplier Module
    exact mult_inst (
        .a(in_data),
        .b(w_reg),
        .y(mult_out)
    ); //mult_out is obtained as the output here

    always @(posedge clk) begin
        if (rst) begin                  
            w_reg <= 0;
            out_data <= 0;
            out_acc <= 0;
        end
        else begin
            out_data <= in_data;
            if (w_load_en) begin
                w_reg <= in_w;
            end           
            out_acc <= mult_out + in_acc;
        end
    end
endmodule

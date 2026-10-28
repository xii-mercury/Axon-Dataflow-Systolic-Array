// Axon Systolic Array Implementation
module Axon_Unified_PE #(
    parameter DATA_WIDTH = 8,
    parameter ACC_WIDTH = 16,
    parameter USE_PIPELINE = 1,  // 0 = no pipeline, 1 = 1-stage, 2 = 2-stage
    parameter USE_DSP = 1 // Use DSP blocks for multiply
) (
    input clk, input rst, // Global Control Signals
    input [2:0] in_data, // Data input
    input [2:0] in_w, // Weight input
    input [2:0] in_ctrl, // Principle-diagonal Feeding for Axon Architecture
    input [14:0] in_acc, // accumulator input
    input sel1, input sel2, input sel3, input sel4, // Selector in each mux
    input EN_data, input EN_w, input EN_psum, // Enable loads {shall send signal ahead only if EN = 1}
    output [DATA_WIDTH- 1:0] out_w, // Weight Output in case of WS Dataflow
    output [ACC_WIDTH- 1:0] out_psum // Psum output in case of OS Dataflow
);
    (*preserve*) reg [2:0] reg_data ; // Internal register for Input Data
    (*preserve*) reg [2:0] reg_w; // Internal register for Weight
    (*preserve*) reg [ACC_WIDTH- 1:0] reg_psum ; //Partial Sum {(8+8) 16 bits}
    wire [2:0] mux1, mux2;
    wire [ACC_WIDTH- 1:0] mux3, prod, sum;
    reg [ACC_WIDTH-1:0] pipe_mult, pipe_add; // Pipeline registers
    assign mux1 = (sel1) ? in_ctrl : in_data; // sel1 = {1: in_diag :: 0: in_data}
    assign mux2 = (sel2) ? in_ctrl : in_w; // sel2 = {1: in_diag :: 0: in_w}
    // (*use_dsp48= "yes" *)
    assign prod = reg_data * reg_w; // Multiplier output
    assign mux3 = (sel3) ? reg_psum : in_acc; // sel3 = {1: reg_psum :: 0: acc_in}
    assign sum = prod + mux3; // Adder output    
    
    always @(posedge clk or posedge rst) begin // Sequential logic with reduced fanout
        if (rst) begin  // Resets all internal registers to 0
            {reg_data, reg_w, reg_psum} <= 'b0;
            if (USE_PIPELINE > 0) {pipe_mult, pipe_add} <= 'b0;
        end else begin
            if (EN_data) reg_data <= mux1; // mux1 output 
            if (EN_w) reg_w <= mux2; // mux2 output
            if (EN_psum) reg_psum <= sum; // Partial Sum
        end
    end
    /*assign out_w = reg_w; // Weight Output for Weight Stationary Dataflow
    assign out_psum = (sel4) ? sum : reg_psum; // where sum is live data and psum is registered data
    //assign out_psum = mux4; // Output for Output Stationary Dataflow */
    wire [ACC_WIDTH-1:0] selected_sum = (USE_PIPELINE == 2) ? pipe_add : 
                                        (USE_PIPELINE == 1) ? pipe_mult + mux3 : sum;
                                        
    assign out_psum = sel4 ? selected_sum : reg_psum;
    assign out_w = reg_w;
        
endmodule

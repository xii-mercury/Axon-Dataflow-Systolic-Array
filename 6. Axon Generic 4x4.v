// Generic Scalable Axon Array
module Axon_Generic_4x4 #(
    parameter N = 16, // THis is the Scaling Parameter
    DATA_WIDTH = 8, ACC_WIDTH = 16
)(
    input clk, rst, EN_data, EN_w, sel1, sel2,
    input [DATA_WIDTH*N- 1:0] in_data,
    input [DATA_WIDTH*N- 1:0] in_w,
    input [ACC_WIDTH*N- 1:0] in_acc,
    input [DATA_WIDTH*N- 1:0] in_diag,
    output reg out_single,
    output reg out_valid
);
    reg [ACC_WIDTH*N-1:0] out_reg;
    reg [6:0] bit_counter;
    wire [DATA_WIDTH-1:0] int_w [0:N][0:N-1];
    wire [DATA_WIDTH-1:0] int_data [0:N-1][0:N];
    wire [ACC_WIDTH-1:0] int_acc [0:N][0:N-1];
    wire [DATA_WIDTH-1:0] w_out_pe [0:N-1][0:N-1];
    wire [DATA_WIDTH-1:0] data_out_pe [0:N-1][0:N-1];

    genvar k;
    generate
        for (k = 0; k < N; k = k + 1) begin
            assign int_w[0][k] = in_w[k*DATA_WIDTH +: DATA_WIDTH]; // Internal wires carrying weights
        end
    endgenerate

    generate
        for (k = 0; k < N; k = k + 1) begin
            assign int_data[k][0] = in_data[k*DATA_WIDTH +: DATA_WIDTH]; // Internal Data carrying wires
        end
    endgenerate

    generate
        for (k = 0; k < N; k = k + 1) begin
            assign int_acc[0][k] = in_acc[k*ACC_WIDTH +: ACC_WIDTH]; // Internal Wires carrying Accumulator Input
        end
    endgenerate

    generate
        for (k = 0; k < N; k = k + 1) begin 
            assign int_data[k][N] = {DATA_WIDTH{1'b0}}; // Assigning 0 to unused Rows
        end
        for (k = 0; k < N; k = k + 1) begin 
            assign int_w[N][k] = {DATA_WIDTH{1'b0}}; // Assigning 0 to unused Columns
        end
    endgenerate

    // PE Instantiation
    genvar i, j;
    generate
        for (i = 0; i < N; i = i + 1) begin : ROW
            for (j = 0; j < N; j = j + 1) begin : COL
                wire is_diag = (i == j);

                Axon_Generic_PE #(DATA_WIDTH, ACC_WIDTH) inst_sys_arr (
                    .clk(clk), .rst(rst),
                    .EN_data(EN_data), .EN_w(EN_w),
                    .sel1(is_diag), .sel2(is_diag),
                    .in_w( (i >= j) ? int_w[i][j] : int_w[i+1][j] ),       
                    .in_data( (j >= i) ? int_data[i][j] : int_data[i][j+1] ), 
                    .in_acc(int_acc[i][j]),
                    .in_diag(in_diag[i*DATA_WIDTH +: DATA_WIDTH]),
                    .out_w(w_out_pe[i][j]),       // FIX: plain net only
                    .out_data(data_out_pe[i][j]), // FIX: plain net only
                    .out_psum(int_acc[i+1][j])
                );

                if (i >= j) begin // Lower Half Triangle Weight Flow
                    assign int_w[i+1][j] = w_out_pe[i][j];
                end else begin // UHT Weight Flow
                    assign int_w[i][j]   = w_out_pe[i][j];
                end

                if (j >= i) begin // Upper Half Triangle Data Flow
                    assign int_data[i][j+1] = data_out_pe[i][j];
                end else begin // LHT Data FLow
                    assign int_data[i][j]   = data_out_pe[i][j];
                end
            end
        end
    endgenerate

    integer x;
    always @(posedge clk) begin
        if (rst) begin // Reset output registers and bit-counter
            out_reg <= 0;
            out_single <= 0;
            out_valid <= 0;
            bit_counter <= 0;
        end else begin
            for (x = 0; x < N; x = x + 1) begin
                out_reg[x*ACC_WIDTH +: ACC_WIDTH] <= int_acc[N][x];
            end

            if (bit_counter < 64) begin
                out_single <= out_reg[bit_counter];
                out_valid <= 1;
                bit_counter <= bit_counter + 1;
            end else begin
                out_valid <= 0;
                bit_counter <= 0;
            end
        end
    end

endmodule

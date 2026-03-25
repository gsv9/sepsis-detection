`timescale 1ns / 1ps

module lr_accelerator_axi (

    input clk,
    input rst,

    // AXI registers (coming from AXI slave)
    input [31:0] slv_reg0,
    input [31:0] slv_reg1,
    input [31:0] slv_reg2,
    input [31:0] slv_reg3,
    input [31:0] slv_reg4,
    input [31:0] slv_reg5,
    input [31:0] slv_reg6,
    input [31:0] slv_reg7,
    input [31:0] slv_reg8,
    input [31:0] slv_reg9,
    input [31:0] slv_reg10,
    input [31:0] slv_reg11,

    // outputs back to AXI
    output reg [31:0] slv_reg12,
    output reg [31:0] slv_reg13
);

//////////////////////////////////////////////////
// Internal signals
//////////////////////////////////////////////////

wire signed [15:0] HR     = slv_reg0[15:0];
wire signed [15:0] O2Sat  = slv_reg1[15:0];
wire signed [15:0] Temp   = slv_reg2[15:0];
wire signed [15:0] Resp   = slv_reg3[15:0];
wire signed [15:0] SBP    = slv_reg4[15:0];

wire signed [15:0] W0     = slv_reg5[15:0];
wire signed [15:0] W1     = slv_reg6[15:0];
wire signed [15:0] W2     = slv_reg7[15:0];
wire signed [15:0] W3     = slv_reg8[15:0];
wire signed [15:0] W4     = slv_reg9[15:0];

wire signed [31:0] bias   = slv_reg10;

wire start = slv_reg11[0];

wire signed [31:0] z_out;
wire done;

//////////////////////////////////////////////////
// Instantiate your accelerator
//////////////////////////////////////////////////

acc_sep uut (
    .clk(clk),
    .rst(rst),
    .start(start),

    .HR(HR),
    .O2Sat(O2Sat),
    .Temp(Temp),
    .Resp(Resp),
    .SBP(SBP),

    .W0(W0),
    .W1(W1),
    .W2(W2),
    .W3(W3),
    .W4(W4),

    .bias(bias),

    .z_out(z_out),
    .done(done)
);

//////////////////////////////////////////////////
// Output register logic
//////////////////////////////////////////////////

always @(posedge clk) begin
    if (rst) begin
        slv_reg12 <= 0;
        slv_reg13 <= 0;
    end 
    else begin

        // Clear DONE when new start comes
        if (start) begin
            slv_reg13 <= 0;
        end

        // Capture result when computation finishes
        if (done) begin
            slv_reg12 <= z_out;
            slv_reg13 <= 1;
        end

    end
end

endmodule
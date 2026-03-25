`timescale 1ns / 1ps

module tb_lr_accelerator_axi;

reg clk;
reg rst;

// AXI registers (inputs)
reg [31:0] slv_reg0;
reg [31:0] slv_reg1;
reg [31:0] slv_reg2;
reg [31:0] slv_reg3;
reg [31:0] slv_reg4;
reg [31:0] slv_reg5;
reg [31:0] slv_reg6;
reg [31:0] slv_reg7;
reg [31:0] slv_reg8;
reg [31:0] slv_reg9;
reg [31:0] slv_reg10;
reg [31:0] slv_reg11;

// outputs
wire [31:0] slv_reg12;
wire [31:0] slv_reg13;

// DUT
lr_accelerator_axi dut (
    .clk(clk),
    .rst(rst),

    .slv_reg0(slv_reg0),
    .slv_reg1(slv_reg1),
    .slv_reg2(slv_reg2),
    .slv_reg3(slv_reg3),
    .slv_reg4(slv_reg4),
    .slv_reg5(slv_reg5),
    .slv_reg6(slv_reg6),
    .slv_reg7(slv_reg7),
    .slv_reg8(slv_reg8),
    .slv_reg9(slv_reg9),
    .slv_reg10(slv_reg10),
    .slv_reg11(slv_reg11),

    .slv_reg12(slv_reg12),
    .slv_reg13(slv_reg13)
);

//////////////////////////////////////////////////
// Clock
//////////////////////////////////////////////////
always #5 clk = ~clk;

//////////////////////////////////////////////////
// Test sequence
//////////////////////////////////////////////////
initial begin
    clk = 0;
    rst = 1;

    // Initialize all registers
    slv_reg0 = 0;
    slv_reg1 = 0;
    slv_reg2 = 0;
    slv_reg3 = 0;
    slv_reg4 = 0;
    slv_reg5 = 0;
    slv_reg6 = 0;
    slv_reg7 = 0;
    slv_reg8 = 0;
    slv_reg9 = 0;
    slv_reg10 = 0;
    slv_reg11 = 0;

    #20;
    rst = 0;

    //////////////////////////////////////////////////
    // Provide inputs
    //////////////////////////////////////////////////

    slv_reg0  = 16'd80;   // HR
    slv_reg1  = 16'd95;   // O2Sat
    slv_reg2  = 16'd37;   // Temp
    slv_reg3  = 16'd20;   // Resp
    slv_reg4  = 16'd120;  // SBP

    slv_reg5  = 16'd2;    // W0
    slv_reg6  = 16'd3;    // W1
    slv_reg7  = 16'd4;    // W2
    slv_reg8  = 16'd5;    // W3
    slv_reg9  = 16'd6;    // W4

    slv_reg10 = 32'd10;   // bias

    #20;

    //////////////////////////////////////////////////
    // Start signal
    //////////////////////////////////////////////////
    slv_reg11 = 1;

    #10;
    slv_reg11 = 0;

    //////////////////////////////////////////////////
    // Wait for done
    //////////////////////////////////////////////////
    wait(slv_reg13 == 1);

    #10;

    $display("=================================");
    $display("OUTPUT z_out = %d", slv_reg12);
    $display("DONE = %d", slv_reg13);
    $display("=================================");

    #20;
    $finish;
end

endmodule
module tb;

reg clk;
reg rst;
reg start;

reg signed [15:0] HR;
reg signed [15:0] O2Sat;
reg signed [15:0] Temp;
reg signed [15:0] Resp;
reg signed [15:0] SBP;

reg signed [15:0] W0;
reg signed [15:0] W1;
reg signed [15:0] W2;
reg signed [15:0] W3;
reg signed [15:0] W4;

reg signed [31:0] bias;

wire signed [31:0] z_out;
wire done;


acc_sep dut(
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


initial clk = 0;
always #5 clk = ~clk;


initial begin

    rst = 1;
    start = 0;

    W0 = 3;
    W1 = 0;
    W2 = 79;
    W3 = 9;
    W4 = -1;

    bias = -3237;

    #20 rst = 0;

    // TEST 1
    HR = 95; O2Sat = 98; Temp = 38; Resp = 22; SBP = 110;

    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    wait(done);
    $display("TEST1 z_out = %d (Expected 138)", z_out);

    #20;

    // TEST 2
    HR = 100; O2Sat = 97; Temp = 37; Resp = 20; SBP = 120;

    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    wait(done);
    $display("TEST2 z_out = %d (Expected 46)", z_out);

    #20;

    // TEST 3
    HR = 85; O2Sat = 96; Temp = 39; Resp = 25; SBP = 105;

    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    wait(done);
    $display("TEST3 z_out = %d (Expected 219)", z_out);

    #20;

    // TEST 4
    HR = 110; O2Sat = 99; Temp = 36; Resp = 18; SBP = 130;

    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    wait(done);
    $display("TEST4 z_out = %d (Expected -31)", z_out);

    #20;

    // TEST 5
    HR = 90; O2Sat = 95; Temp = 38; Resp = 24; SBP = 115;

    @(posedge clk);
    start = 1;
    @(posedge clk);
    start = 0;

    wait(done);
    $display("TEST5 z_out = %d (Expected 136)", z_out);

    #20;

    $finish;

end

endmodule
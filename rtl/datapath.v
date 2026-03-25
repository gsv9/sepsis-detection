module datapath(

    input clk,
    input rst,
    input acc_clear,
    input acc_enable,
    input z_valid,

    input signed [15:0] feature,
    input signed [15:0] weight,
    input signed [31:0] bias,

    output reg signed [31:0] z_out
);

wire signed [31:0] product;
reg signed [31:0] acc;

assign product = feature * weight;

always @(posedge clk) begin
    if(rst || acc_clear)
        acc <= 0;
    else if(acc_enable)
        acc <= acc + product;
end

always @(posedge clk) begin
    if(rst)
        z_out <= 0;
    else if(z_valid)
        z_out <= acc + bias;
end

endmodule
module layer1_mac(

input clk,
input rst,
input valid_in,

input signed [7:0] feature0,
input signed [7:0] feature1,
input signed [7:0] feature2,
input signed [7:0] feature3,
input signed [7:0] feature4,

input signed [7:0] w0,
input signed [7:0] w1,
input signed [7:0] w2,
input signed [7:0] w3,
input signed [7:0] w4,

input signed [15:0] bias,

output reg signed [31:0] neuron_out,
output reg valid_out

);

wire signed [15:0] m0;
wire signed [15:0] m1;
wire signed [15:0] m2;
wire signed [15:0] m3;
wire signed [15:0] m4;

assign m0 = feature0 * w0;
assign m1 = feature1 * w1;
assign m2 = feature2 * w2;
assign m3 = feature3 * w3;
assign m4 = feature4 * w4;

wire signed [31:0] sum;

assign sum = m0 + m1 + m2 + m3 + m4;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        neuron_out <= 0;
        valid_out <= 0;
    end
    else if(valid_in)
    begin
        neuron_out <= sum + bias;
        valid_out <= 1;
    end
    else 
    valid_out<=0;
end

endmodule

module weight_rom(

input clk,
input [2:0] neuron_index,

output reg signed [7:0] w0,
output reg signed [7:0] w1,
output reg signed [7:0] w2,
output reg signed [7:0] w3,
output reg signed [7:0] w4,

output reg signed [15:0] bias

);

reg signed [7:0] W1 [0:7][0:4];
reg signed [15:0] B1 [0:7];

initial begin

$readmemh("W1.txt", W1);
$readmemh("B1.txt", B1);

end

always @(posedge clk) begin

    w0 <= W1[neuron_index][0];
    w1 <= W1[neuron_index][1];
    w2 <= W1[neuron_index][2];
    w3 <= W1[neuron_index][3];
    w4 <= W1[neuron_index][4];

    bias <= B1[neuron_index];

end

endmodule
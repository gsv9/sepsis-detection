module top_module(

input clk,
input rst,
input start,

input signed [7:0] feature0,
input signed [7:0] feature1,
input signed [7:0] feature2,
input signed [7:0] feature3,
input signed [7:0] feature4,

output sepsis_detected,
output done

);

//////////////////////////////////////////////////////
//// FSM signals
//////////////////////////////////////////////////////

wire [2:0] neuron_index;
wire layer_select;
wire valid_l1;
wire valid_l2;

fsm_control fsm(

.clk(clk),
.rst(rst),
.start(start),

.neuron_index(neuron_index),
.layer_select(layer_select),
.valid_l1(valid_l1),
.valid_l2(valid_l2),
.done(done)

);

//////////////////////////////////////////////////////
//// Weight ROM
//////////////////////////////////////////////////////

wire signed [7:0] w0,w1,w2,w3,w4;
wire signed [7:0] w2_weight;
wire signed [15:0] bias;

weight_rom rom(

.clk(clk),
.neuron_index(neuron_index),
.layer_select(layer_select),

.w0(w0),
.w1(w1),
.w2(w2),
.w3(w3),
.w4(w4),

.w_out(w2_weight),
.bias(bias)

);

//////////////////////////////////////////////////////
//// Layer1 MAC
//////////////////////////////////////////////////////

wire signed [31:0] l1_out;
wire valid_l1_out;

layer1_mac l1(

.clk(clk),
.rst(rst),
.valid_in(valid_l1),

.feature0(feature0),
.feature1(feature1),
.feature2(feature2),
.feature3(feature3),
.feature4(feature4),

.w0(w0),
.w1(w1),
.w2(w2),
.w3(w3),
.w4(w4),

.bias(bias),

.neuron_out(l1_out),
.valid_out(valid_l1_out)

);
wire signed [31:0] relu_out;
//////////////////////////////////////////////////////
//// ReLU
//////////////////////////////////////////////////////
relu_activation(
.in_data(l1_out),
.out_data(relu_out));


//////////////////////////////////////////////////////
//// Hidden neuron buffer
//////////////////////////////////////////////////////

reg signed [31:0] h_reg [0:7];

always @(posedge clk)
begin
    if(valid_l1_out)
        h_reg[neuron_index] <= relu_out;
end

//////////////////////////////////////////////////////
//// Layer2 input
//////////////////////////////////////////////////////

wire signed [31:0] h;

assign h = h_reg[neuron_index];

//////////////////////////////////////////////////////
//// Layer2 MAC
//////////////////////////////////////////////////////

wire signed [31:0] y_out;
wire valid_l2_out;

layer2_mac l2(

.clk(clk),
.rst(rst),
.valid_in(valid_l2),

.neuron_index(neuron_index),

.h(h),
.weight(w2_weight),
.bias(bias),

.y_out(y_out),
.valid_out(valid_l2_out)

);

//////////////////////////////////////////////////////
//// Decision unit
//////////////////////////////////////////////////////

decision_unit(

.y_out(y_out),
.sepsis(sepsis_detected)

);

endmodule

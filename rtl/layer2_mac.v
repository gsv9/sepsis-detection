module layer2_mac(

input clk,
input rst,
input valid_in,

input [2:0] neuron_index,      // from FSM

input signed [31:0] h,         // hidden neuron from buffer
input signed [7:0] weight,     // W2 weight from ROM
input signed [15:0] bias,      // B2

output reg signed [31:0] y_out,
output reg valid_out

);

reg signed [31:0] accumulator;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        accumulator <= 0;
        y_out <= 0;
        valid_out <= 0;
    end

    else if(valid_in)
    begin

        // accumulate partial sum
        accumulator <= accumulator + h * weight;

        // last neuron
        if(neuron_index == 3'd7)
        begin
            y_out <= accumulator + h * weight + bias;
            accumulator <= 0;
            valid_out <= 1;
        end
        else
            valid_out <= 0;

    end

end

endmodule

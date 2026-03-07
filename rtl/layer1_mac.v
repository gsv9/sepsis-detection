module layer1_mac(

input clk,
input rst,
input valid_in,

input signed [7:0] feature0,
input signed [7:0] feature1,
input signed [7:0] feature2,
input signed [7:0] feature3,
input signed [7:0] feature4,

input signed [7:0] weight,
input signed [15:0] bias,

output reg signed [31:0] neuron_out,
output reg [2:0] neuron_index,
output reg valid_out

);

reg signed [31:0] accumulator;
reg [2:0] feature_count;
reg [2:0] neuron_count;

wire signed [7:0] feature_mux;

assign feature_mux =
    (feature_count==0) ? feature0 :
    (feature_count==1) ? feature1 :
    (feature_count==2) ? feature2 :
    (feature_count==3) ? feature3 :
                         feature4;

always @(posedge clk or posedge rst)
begin

    if(rst)
    begin
        accumulator <= 0;
        feature_count <= 0;
        neuron_count <= 0;
        valid_out <= 0;
    end

    else if(valid_in)
    begin

        accumulator <= accumulator + feature_mux * weight;

        if(feature_count == 4)
        begin
            neuron_out <= accumulator + bias;
            neuron_index <= neuron_count;
            valid_out <= 1;

            accumulator <= 0;
            feature_count <= 0;
            neuron_count <= neuron_count + 1;
        end

        else
        begin
            feature_count <= feature_count + 1;
            valid_out <= 0;
        end

    end

end

endmodule
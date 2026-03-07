module layer2_mac(

input clk,
input rst,
input valid_in,

input signed [31:0] h0,
input signed [31:0] h1,
input signed [31:0] h2,
input signed [31:0] h3,
input signed [31:0] h4,
input signed [31:0] h5,
input signed [31:0] h6,
input signed [31:0] h7,

input signed [7:0] weight,
input signed [15:0] bias,

output reg signed [31:0] y_out,
output reg valid_out

);

reg signed [31:0] accumulator;
reg [2:0] feature_count;

wire signed [31:0] h_mux;

assign h_mux =
(feature_count==0)? h0 :
(feature_count==1)? h1 :
(feature_count==2)? h2 :
(feature_count==3)? h3 :
(feature_count==4)? h4 :
(feature_count==5)? h5 :
(feature_count==6)? h6 :
                    h7;

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        accumulator <= 0;
        feature_count <= 0;
        valid_out <= 0;
    end
    else if(valid_in)
    begin
        accumulator <= accumulator + h_mux * weight;

        if(feature_count == 7)
        begin
            y_out <= accumulator + bias;
            accumulator <= 0;
            feature_count <= 0;
            valid_out <= 1;
        end
        else
        begin
            feature_count <= feature_count + 1;
            valid_out <= 0;
        end
    end
end

endmodule
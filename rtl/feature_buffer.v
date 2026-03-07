module feature_buffer (
    input wire clk,
    input wire reset,
    input wire valid_in,

    input  signed [7:0] feature_in0,
    input  signed [7:0] feature_in1,
    input  signed [7:0] feature_in2,
    input  signed [7:0] feature_in3,
    input  signed [7:0] feature_in4,

    output reg signed [7:0] feature_out0,
    output reg signed [7:0] feature_out1,
    output reg signed [7:0] feature_out2,
    output reg signed [7:0] feature_out3,
    output reg signed [7:0] feature_out4,

    output reg valid_out
);

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        feature_out0 <= 0;
        feature_out1 <= 0;
        feature_out2 <= 0;
        feature_out3 <= 0;
        feature_out4 <= 0;
        valid_out <= 0;
    end
    else begin
        if (valid_in) begin
            feature_out0 <= feature_in0;
            feature_out1 <= feature_in1;
            feature_out2 <= feature_in2;
            feature_out3 <= feature_in3;
            feature_out4 <= feature_in4;
            valid_out <= 1'b1;
        end
        else begin
            valid_out <= 1'b0;
        end
    end
end

endmodule
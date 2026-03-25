module acc_sep(

    input clk,
    input rst,
    input start,

    // features
    input signed [15:0] HR,
    input signed [15:0] O2Sat,
    input signed [15:0] Temp,
    input signed [15:0] Resp,
    input signed [15:0] SBP,

    // weights
    input signed [15:0] W0,
    input signed [15:0] W1,
    input signed [15:0] W2,
    input signed [15:0] W3,
    input signed [15:0] W4,

    input signed [31:0] bias,

    output signed [31:0] z_out,
    output done
);

// control signals
wire [2:0] index;
wire acc_clear;
wire acc_enable;
wire z_valid;

// selected feature/weight
reg signed [15:0] feature_sel;
reg signed [15:0] weight_sel;
always @(*) begin
    case(index)

        3'd0: begin
            feature_sel = HR;
            weight_sel = W0;
        end

        3'd1: begin
            feature_sel = O2Sat;
            weight_sel = W1;
        end

        3'd2: begin
            feature_sel = Temp;
            weight_sel = W2;
        end

        3'd3: begin
            feature_sel = Resp;
            weight_sel = W3;
        end

        3'd4: begin
            feature_sel = SBP;
            weight_sel = W4;
        end

        default: begin
            feature_sel = 0;
            weight_sel = 0;
        end

    endcase
end
controlpath control_unit(

    .clk(clk),
    .rst(rst),
    .start(start),

    .index(index),
    .acc_clear(acc_clear),
    .acc_enable(acc_enable),
    .z_valid(z_valid),
    .done(done)
);
datapath datapath_unit(

    .clk(clk),
    .rst(rst),

    .acc_clear(acc_clear),
    .acc_enable(acc_enable),
    .z_valid(z_valid),

    .feature(feature_sel),
    .weight(weight_sel),
    .bias(bias),

    .z_out(z_out)
);
endmodule
module decision_unit(
input signed [31:0] y_out,
output reg sepsis
);

parameter THRESHOLD = 32'sd15;

always @(*) begin
    if (y_out > THRESHOLD)
        sepsis = 1;
    else
        sepsis = 0;
end

endmodule

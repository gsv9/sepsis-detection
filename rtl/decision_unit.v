module decision_unit(

input signed [31:0] y_in,
output reg sepsis_detected

);

always @(*)
begin
    if(y_in > 0)
        sepsis_detected = 1;
    else
        sepsis_detected = 0;
end

endmodule
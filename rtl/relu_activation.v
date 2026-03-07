module relu_activation(

input  signed [31:0] in_data,
output signed [31:0] out_data

);

assign out_data = (in_data < 0) ? 0 : in_data;

endmodule
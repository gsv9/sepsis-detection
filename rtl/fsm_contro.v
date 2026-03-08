module fsm_control(

input clk,
input rst,
input start,

output reg [2:0] neuron_index,
output reg layer_select,
output reg valid_l1,
output reg valid_l2,
output reg done

);

reg [1:0] state, next_state;

parameter IDLE   = 2'd0;
parameter LAYER1 = 2'd1;
parameter LAYER2 = 2'd2;
parameter DONE   = 2'd3;

////////////////////////////////////////////////
//// State Register
////////////////////////////////////////////////

always @(posedge clk or posedge rst)
begin
    if(rst)
        state <= IDLE;
    else
        state <= next_state;
end

////////////////////////////////////////////////
//// Next State Logic
////////////////////////////////////////////////

always @(*)
begin
    case(state)

    IDLE:
        if(start)
            next_state = LAYER1;
        else
            next_state = IDLE;

    LAYER1:
        if(neuron_index == 3'd7)
            next_state = LAYER2;
        else
            next_state = LAYER1;

    LAYER2:
        if(neuron_index == 3'd7)
            next_state = DONE;
        else
            next_state = LAYER2;

    DONE:
        next_state = IDLE;

    endcase
end

////////////////////////////////////////////////
//// Output Logic
////////////////////////////////////////////////

always @(posedge clk or posedge rst)
begin
    if(rst)
    begin
        neuron_index <= 0;
        valid_l1 <= 0;
        valid_l2 <= 0;
        done <= 0;
    end

    else
    begin

        case(state)

        IDLE:
        begin
            neuron_index <= 0;
            valid_l1 <= 0;
            valid_l2 <= 0;
            done <= 0;
        end

        LAYER1:
        begin
            valid_l1 <= 1;
            valid_l2 <= 0;
            layer_select <= 0;
            neuron_index <= neuron_index + 1;
        end

        LAYER2:
        begin
            valid_l1 <= 0;
            valid_l2 <= 1;
            layer_select <= 1;
            neuron_index <= neuron_index + 1;
        end

        DONE:
        begin
            valid_l1 <= 0;
            valid_l2 <= 0;
            done <= 1;
        end

        endcase
    end
end

endmodule

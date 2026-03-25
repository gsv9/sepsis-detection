module controlpath(

    input clk,
    input rst,
    input start,

    output reg [2:0] index,
    output reg acc_clear,
    output reg acc_enable,
    output reg z_valid,
    output reg done
);

reg [3:0] state;

parameter IDLE = 0,
          MAC0 = 1,
          MAC1 = 2,
          MAC2 = 3,
          MAC3 = 4,
          MAC4 = 5,
          BIAS = 6,
          DONE = 7;

always @(posedge clk) begin
    if(rst)
        state <= IDLE;
    else begin
        case(state)

        IDLE:
            if(start)
                state <= MAC0;

        MAC0: state <= MAC1;
        MAC1: state <= MAC2;
        MAC2: state <= MAC3;
        MAC3: state <= MAC4;
        MAC4: state <= BIAS;
        BIAS: state <= DONE;
        DONE: state <= IDLE;

        endcase
    end
end


always @(*) begin

    index = 0;
    acc_clear = 0;
    acc_enable = 0;
    z_valid = 0;
    done = 0;

    case(state)

    IDLE:
        acc_clear = 1;

    MAC0: begin
        index = 0;
        acc_enable = 1;
    end

    MAC1: begin
        index = 1;
        acc_enable = 1;
    end

    MAC2: begin
        index = 2;
        acc_enable = 1;
    end

    MAC3: begin
        index = 3;
        acc_enable = 1;
    end

    MAC4: begin
        index = 4;
        acc_enable = 1;
    end

    BIAS:
        z_valid = 1;

    DONE:
        done = 1;

    endcase

end

endmodule
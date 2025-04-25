module lfsr(
    input  logic clk,
    input  logic reset,
    output logic [2:0] rand_val
);

    logic [2:0] oof;
    logic temp;
    logic [2:0] ct;
    logic [2:0] inct;
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
        begin
            oof <= 3'b001;
            ct =  0;  
            inct = 1;
        end
        else begin
//            lfsr[0] <= lfsr[2];
//            lfsr[1] <= lfsr[0];
//            lfsr[2] <= lfsr[1] ^ lfsr[2];
              temp = oof[2];
              oof[2] = oof[1];
              oof[1] = oof[0];
              oof[0] = temp ^ oof[2];
              ct+=1;
              if (ct ==0)
              begin
                inct = (inct+1)&7;
                if (inct==0)
                begin
                    inct=1;
                end
                oof = inct;
              end
              
//            oof = oof*oof*oof + oof*oof + oof +1;
        end
    end

    assign rand_val = oof; 
endmodule
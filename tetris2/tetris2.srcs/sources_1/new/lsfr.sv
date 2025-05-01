module lfsr(
    input  logic clk,
    input  logic reset,
    output logic [2:0] rand_val
);

    logic [14:0] lfsr_reg;
    logic [14:0] temp;
    logic [2:0] ct;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
        begin
            lfsr_reg <= 15'd1;
            temp = 0 ;
//            ct =  0;  
//            inct = 1;
        end
        else begin
//            lfsr[0] <= lfsr[2];
//            lfsr[1] <= lfsr[0];
//            lfsr[2] <= lfsr[1] ^ lfsr[2];
//            temp = 0 ;
            temp = ((lfsr_reg >>> 14) ^ (lfsr_reg >>> 13)) & 1;
            lfsr_reg = ((lfsr_reg<<1)|temp);
              
//            oof = oof*oof*oof + oof*oof + oof +1;
        end
    end
    always_comb
    begin
        if(lfsr_reg[2:0])
        begin
            rand_val = lfsr_reg[2:0];
        end
        else if(lfsr_reg[5:3])
        begin
            rand_val = lfsr_reg[5:3];
        end
        else if(lfsr_reg[8:6])
        begin
            rand_val = lfsr_reg[8:6];
        end
        else if(lfsr_reg[11:9])
        begin
            rand_val = lfsr_reg[11:9];
        end
        else if(lfsr_reg[15:13])
        begin
            rand_val = lfsr_reg[15:13];
        end
        else
        begin
            ct = (ct+1)&7;
            if (ct == 0 )
            begin
                ct = 1;
            end
            rand_val = ct;
        end
        
    end
    
endmodule
module lfsr(
    input  logic clk,
    input  logic reset,
    output logic [2:0] rand_val
);

    logic [14:0] lfsr_reg;
    logic [2:0] rand_out;
    logic [2:0] ct;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_reg <= 15'd1;
            ct       <= 3'd1;
        end else begin
            // Polynomial taps: x^15 + x^14 + 1
            logic feedback;
            feedback   = lfsr_reg[14] ^ lfsr_reg[13];
            lfsr_reg   <= {lfsr_reg[13:0], feedback};

            // Update counter if needed
            if (rand_out == 0) begin
                ct <= (ct == 3'd7) ? 3'd1 : ct + 1;
            end
        end
    end

    always_comb begin
        if (lfsr_reg[2:0] != 0)
            rand_out = lfsr_reg[2:0];
        else if (lfsr_reg[5:3] != 0)
            rand_out = lfsr_reg[5:3];
        else if (lfsr_reg[8:6] != 0)
            rand_out = lfsr_reg[8:6];
        else if (lfsr_reg[11:9] != 0)
            rand_out = lfsr_reg[11:9];
        else if (lfsr_reg[14:12] != 0)
            rand_out = lfsr_reg[14:12];
        else
            rand_out = ct;
    end

    assign rand_val = rand_out;

endmodule

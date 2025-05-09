module song_rom (
    input  logic        clk,
    input  logic [3:0]  addr,
    output logic [6:0]  note1,
    output logic [6:0]  note2,
    output logic [6:0]  note3
);
    // Each note is a phase increment for NCOs
    typedef struct packed {
        logic [6:0] n1, n2, n3;
    } note_triple_t;

    note_triple_t rom [0:15];

    initial begin
        rom[0]  = '{7'h34, 7'h00, 7'h00};
        rom[1]  = '{7'h36, 7'h00, 7'h00};
        rom[2]  = '{7'h38, 7'h00, 7'h00};
        rom[3]  = '{7'h39, 7'h00, 7'h00};
        rom[4]  = '{7'h3B, 7'h00, 7'h00};
        rom[5]  = '{7'h41, 7'h00, 7'h00};
        rom[6]  = '{7'h43, 7'h00, 7'h00};
        rom[7]  = '{7'h44, 7'h00, 7'h00};
        rom[8]  = '{7'h00, 7'h00, 7'h00};
        rom[9]  = '{7'h00, 7'h00, 7'h00};
        rom[10] = '{7'h00, 7'h00, 7'h00};
        rom[11] = '{7'h00, 7'h00, 7'h00};
        rom[12] = '{7'h00, 7'h00, 7'h00};
        rom[13] = '{7'h00, 7'h00, 7'h00};
        rom[14] = '{7'h00, 7'h00, 7'h00};
        rom[15] = '{7'h00, 7'h00, 7'h00};
    end
    
    assign note1 = rom[addr].n1;
    assign note2 = rom[addr].n2;
    assign note3 = rom[addr].n3;

endmodule

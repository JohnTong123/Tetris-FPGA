`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 12:57:48 AM
// Design Name: 
// Module Name: fall
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fall(
    input logic [31:0] game_states[200], 
    output falling
    );
    
    logic [189:0] temp_fall;
    genvar i;
    generate 
        for (i = 0 ; i < 190; i++)
        begin
            assign temp_fall[i] = (game_states[i][3] ^ game_states[i+10][3]);
        end
    endgenerate
    
    assign falling =|temp_fall;
    
    
endmodule

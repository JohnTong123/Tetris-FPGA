`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/18/2025 12:29:40 AM
// Design Name: 
// Module Name: game_state
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


module game_state(
    input  logic [9:0] drawX,
    input logic  [9:0] drawY,
    input logic [31:0] keycode,
    input logic game_clk,
    output logic [3:0] data_out
    );
    
    
    
    logic [3:0] game_states[200];
    logic [8:0] counter;
    logic [15:0] game_clock;
    assign game_clock = 25000;
    logic clk_good;
    logic animate;
    logic force_drop;
    logic fast_drop;
    assign animate = force_drop|clk_good|fast_drop;
    
    logic fall;
    
    always_ff @(posedge game_clk)
    begin
        if (counter > game_clock)
        begin
            counter = 0 ;
            clk_good = 1;
        end
        else 
        begin
            clk_good = 0;
        end
        counter = counter + 1;
    end
    
    
    
    always_comb 
    begin
        
    end
    
    
    
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 11:30:41 AM
// Design Name: 
// Module Name: game_states
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


module game_states #(
parameter integer DATA_WIDTH = 4
)
(
    input logic game_clk,
    input logic clk,
    input logic [9:0] DrawX,
    input logic [9:0] DrawY,
    input logic [31:0] keycode,
    input logic reset,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic [25:0] counter,
    output logic [3:0] gs,
    output logic [7:0] debug
    );

logic progress;
logic [DATA_WIDTH-1:0] game_states[200];
logic [19:0] dels;
logic spawn;
logic [7:0] game_address;

logic [25:0] ct;
assign counter = ct;
assign gs[0] = game_speed;
assign gs[1] = spawn ;
assign debug = game_states[4];
logic game_speed;
logic empty;

assign game_address = (DrawX>>>4) + 10 *  (DrawY>>>4);
assign data_out = game_states[game_address];
assign gs[2] = empty;





always_ff @(posedge game_speed or posedge reset)
begin
    if (reset)
    begin
        for(int i = 0 ; i < 200 ; i++)
        begin
            game_states[i] = 0;
        end
        empty = 1;
    end
    else
    begin
        if (spawn)
        begin
            for (int i = 0 ; i < 200; i= i+1)
            begin
                game_states[i][3] = 0;
            end
            game_states[4] = 4'b1001;
            game_states[5] = 4'b1001;
            game_states[6] = 4'b1001;
            game_states[7] = 4'b1001;
            empty = 0;
        end
        else
        begin
    //        gs[2] = empty;
            for (int i = 199; i >9; i= i-1)
            begin
                if (game_states[i-10]&8)
                begin
                    game_states[i] = game_states[i-10];
                    game_states[i-10]=0;
                end
            end
            
        end
    end
end

always_ff @(negedge game_speed or posedge reset)
begin
    if (reset)
    begin
        spawn = 0 ;
    end
    else
    begin
        spawn = 0;
        
        for (int i = 0 ; i < 190; i= i+1)
        begin
            if ((game_states[i][3] ==1) && (game_states[i+10][3] ==0) && (game_states[i+10][2:0]&7))
            begin
                spawn=1;
            end
        end
        for(int i = 190 ; i < 200; i++)
        begin
            if (game_states[i][3] == 1)
            begin
                spawn = 1;
            end
        end
        
        if (empty)
        begin
            spawn = 1;
        end
    end
    
end

always_ff @(posedge game_clk or posedge reset)
begin
    if (reset)
    begin
        game_speed = 0;
        ct = 0 ;
    end
    else
    begin
    
        if (ct == 6250000)
        begin
            game_speed ^=1;
            ct = 0 ;
        end
        else
        begin
            ct=ct+1;
        end
            
    end
     
end
    
    




endmodule

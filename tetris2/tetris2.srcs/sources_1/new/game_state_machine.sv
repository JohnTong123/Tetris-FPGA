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


module game_state_machine #(
parameter integer DATA_WIDTH = 3
)
(
    input logic game_clk,
    input logic clk,
    input logic [9:0] DrawX,
    input logic [9:0] DrawY,
    input logic [31:0] keycode,
    input logic reset,
    output logic [DATA_WIDTH-1:0] data_out,
//    output logic [25:0] counter,
    output logic [3:0] gs,
//    output logic [7:0] debug
    output int score
    );

logic progress;
logic [DATA_WIDTH-1:0] game_states[200];
logic [19:0] dels;
logic [7:0] game_address;


// blocks and future blocks
logic [7:0] coords[4]; 
logic [2:0] block;
logic [2:0] random_block;
logic [1:0] rotation;
logic [7:0] center;

rotate_block rotate_block(
        .center(center),
        .block(block),
        .rotation(rotation),
        .coords(coords)
);

int Score;
assign score = Score;

lfsr lfsr(
    .clk(game_clk),
    .reset(reset),
    .rand_val(random_block)
);

assign game_address = (DrawX>>>4) + 10 *  (DrawY>>>4);
always_comb
begin
    data_out = game_states[game_address];
    for (int i = 0 ; i < 4; i=i+1)
    begin
        if (coords[i] == 10+game_address)
        begin
            data_out = block;
        end
    end
end

//assign data_out = game_states[game_address] | (());
//assign gs[2] = empty;



logic update_board_state ; 
logic update_board_vars; 
logic [25:0] clock_count;
logic [25:0] cap;

assign cap = 6250000;


always_ff @(posedge game_clk or posedge reset) // game clock
begin
    if (reset)
    begin
        update_board_state = 0;
        clock_count = 0 ;
        update_board_vars = 0 ;

    end
    else
    begin
        clock_count +=1;
        if (clock_count == cap)
        begin
            clock_count = 0 ;
            update_board_state = 1;
        end
        else
        begin
            update_board_state = 0;
        end
        if (clock_count == cap>>1)
        begin
            update_board_vars = 1;
        end
        else
        begin
            update_board_vars = 0;
        end
    end
end



//board changes
logic spawn;
logic start_game;
logic l;



always_ff @(posedge game_clk or posedge reset) // determine how to change the board like spawning
begin
    if (reset)
    begin
        spawn = 0 ;
        start_game = 1;
    end
    else if (update_board_vars)
    begin
        spawn = 0;
        if (start_game)
        begin
            spawn |= 1;
            start_game = 0 ;
        end
        for (int i = 0 ; i < 4; i= i+1)
        begin
            if ((coords[i] > 199) ||  (game_states[coords[i]] !==0))
            begin
                spawn|=1;
            end
        end
    end
end

//keycode detection



//board updating
logic spawn;
logic start_game;
logic res_center;
logic l;



always_ff @(posedge game_clk or posedge reset) // determine how to change the board like spawning
begin
    if (reset)
    begin
        spawn = 0 ;
        start_game = 1;
    end
    else if (update_board_vars)
    begin
        spawn = 0;
        if (start_game)
        begin
            spawn |= 1;
            start_game = 0 ;
        end
        for (int i = 0 ; i < 4; i= i+1)
        begin
            if ((coords[i] > 199) ||  (game_states[coords[i]] !==0))
            begin
                spawn|=1;
            end
        end
    end
end






endmodule
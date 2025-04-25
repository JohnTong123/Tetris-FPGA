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
    output logic [3:0] gs
//    output logic [7:0] debug
    );

logic progress;
(* ram_style = "block" *) logic [DATA_WIDTH-1:0] game_states[200];
logic [19:0] dels;
logic spawn;
logic [7:0] game_address;

logic [25:0] ct;
assign counter = ct;
assign gs[0] = spawn;
//assign gs[1] = spawn ;
//assign debug = game_states[4];
logic game_speed;
logic empty;
logic [2:0] random_block;

lfsr lfsr(
    .clk(game_speed),
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


logic keypress;
assign keypress = 0 ;
logic [7:0] center;
logic [2:0] block;
logic [1:0] rotation;

logic [7:0] coords[4];
logic [7:0] random_coords[4];
logic [2:0] r;

rotate_block rotate_block(
        .center(center),
        .block(block),
        .rotation(rotation),
        .coords(coords)
);

rotate_block rotate_block2(
        .center(3),
        .block(random_block),
        .rotation(0), 
        .coords(random_coords)
);


always_ff @(posedge game_speed or posedge reset)
begin
    if (reset)
    begin
        for(int i = 0 ; i < 200 ; i++)
        begin
            game_states[i] = 0;
        end
        empty = 1;
        spawn = 0;
        center = 3;
        rotation = 0 ;
        block = 0;
        
    end
    else
    begin
        if (game_speed)
        begin
            spawn = 0;
            if (empty)
            begin
                spawn |= 1;
                empty = 0 ;
            end
            for (int i = 0 ; i < 4; i= i+1)
            begin
                if ((coords[i] > 199) ||  (game_states[coords[i]] !==0))
                begin
                    spawn|=1;
                end
            end
            if (spawn)
            begin
                for (int i = 0 ; i < 4; i= i+1)
                begin
                    if (coords[i]>=10)
                    begin
                        game_states[coords[i]-10] = block;
                    end
                end
                center = 3;
                rotation = 0 ;
                
                block = random_block;
                for (int i = 0 ; i < 4; i= i+1)
                begin
                    if (random_coords[i]>=10)
                    begin
                        if(game_states[random_coords[i]-10] !==0)
                        begin
                            block = 0;
                        end
                        
                    end
                end
            end
            else
            begin
        //        gs[2] = empty;
                center+=10;
            end
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
    
        if (ct == 3125000)
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

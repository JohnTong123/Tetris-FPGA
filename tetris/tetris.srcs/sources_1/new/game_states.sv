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
    output logic [3:0] gs,
//    output logic [7:0] debug
    output int score
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
logic cant_shift;

int Score;
assign score = Score;

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
logic [13:0] key_count;
logic [31:0] past_key;
logic [7:0] center;

logic [2:0] block;
logic [1:0] rotation;

logic [7:0] coords[4];
logic [7:0] random_coords[4];
logic [2:0] r;


logic center_left;
logic center_right;
logic center_down;
logic res_center;

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
        res_center = 1;
        rotation = 0 ;
        block = 0;
        cant_shift = 0;
        center_down = 0;
        Score = 0;
    end
    else 
    begin
        res_center = 0 ;
        center_down= 0 ;
        Score = Score + 1;
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
//                center = 3;
                res_center = 1;
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
                center_down = 1;
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
    
always_ff @(posedge game_clk or posedge reset)
begin
    if (reset)
    begin
        past_key = keycode;
        key_count = 0 ;
        keypress = 0 ;
        center_left = 0 ;
        center_right = 0 ;
    end
    else
    begin
        center_left = 0;
        center_right = 0;
        if(past_key == keycode && past_key !== 0)
        begin
            
            if (key_count & (1<<13))
            begin
                if (keypress == 0)
                begin
                    
                    keypress=1;
                    cant_shift = 0 ;
                    if (keycode == 8'h50)
                    begin
                        for (int i = 0 ; i < 4; i= i+1)
                        begin
                            if (coords[i]%10 == 0)
                            begin
                                cant_shift = 1;
                            end
                            else if (coords[i]>=10)
                            begin
                                if (game_states[coords[i]-11] !== 0)
                                begin
                                    cant_shift = 1;
                                end
                            end
                        end
                        if(cant_shift == 0)
                        begin
                            center_left=1;
                        end
                    end
                    else if (keycode == 8'h4F)
                    begin
                        for (int i = 0 ; i < 4; i= i+1)
                        begin
                            if (coords[i]%10 == 9)
                            begin
                                cant_shift = 1;
                            end
                            else if (coords[i]>=10)
                            begin
                                if (game_states[coords[i]-9] !== 0)
                                begin
                                    cant_shift = 1;
                                end
                            end
                        end
                        if(cant_shift == 0 )
                        begin
                            center_right=1;
                        end
                    end
                end
            end
            else
            begin
                key_count+=1 ;
                keypress = 0 ;
            end
        end
        else
        begin
            key_count = 0 ;
            keypress = 0 ;
        end
        
        
        
        past_key = keycode;
    end
    
end
logic rc;
logic cd;
logic cl;
logic cr;
always_ff @(posedge game_clk )
begin
    if (res_center)
    begin
        if (rc==0)
        begin
            center=3;
            rc = 1;
        end
    end
    else
    begin
        rc=0;
    end
    
    if (center_down)
    begin
        if ((ct == 10) && (game_speed))
        begin
            center+=10;
            cd=1;
        end
    end
    else
    begin
        cd=0;
    end
    
    if (center_left)
    begin
        if(cl==0)
        begin
            center-=1;
            cl=1;
        end
    end
    else
    begin
        cl=0;
    end
    if (center_right)
    begin
        if(cr==0)
        begin
            cr=1;
            center+=1;
        end
    end
    else
    begin
        cr=0;
    end
end

endmodule
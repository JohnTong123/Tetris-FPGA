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
    output logic [31:0] score,
    input [2:0] switches,
    output logic end_game 
//    input real  heuristic [3:0]
    );

logic [3:0] heuristic;
assign heuristic = 4'b0001;
logic progress;
logic [DATA_WIDTH-1:0] game_states[200];
logic [19:0] dels;
logic [7:0] game_address;


// blocks and future blocks
logic [7:0] coords[4]; 
logic [7:0] spawn_coords[4]; 
logic [4:0] hard_drop_dist; 
logic [7:0] stored_coords[4]; 

logic [7:0] rotation0_coords[4]; 
logic [7:0] rotation1_coords[4]; 
logic [7:0] rotation2_coords[4]; 
logic [7:0] rotation3_coords[4]; 

logic [2:0] block;
logic [2:0] random_block;
logic [2:0] next_block;

logic [2:0] stored_block;

logic [1:0] rotation;
logic [7:0] center;

rotate_block curr_block(
        .center(center),
        .block(block),
        .rotation(rotation),
        .coords(coords)
);

rotate_block rotate1(
        .center(0),
        .block(next_block),
        .rotation(0),
        .coords(rotation0_coords)
);

rotate_block rotate2(
        .center(0),
        .block(next_block),
        .rotation(0),
        .coords(rotation1_coords)
);

rotate_block rotate3(
        .center(0),
        .block(next_block),
        .rotation(1),
        .coords(rotation2_coords)
);

rotate_block rotate4(
        .center(0),
        .block(next_block),
        .rotation(3),
        .coords(rotation3_coords)
);



logic[31:0] Score;
assign score = Score;

lfsr lfsr(
    .clk(game_clk),
    .reset(reset),
    .rand_val(random_block)
);


logic [7:0] relative_coord;
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
        clock_count = 0 ;
        update_board_vars = 0 ;

    end
    else
    begin
        clock_count +=1;
        if (clock_count == cap)
        begin
            clock_count = 0 ;
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
        update_board_state = 0;
    end
    else if (update_board_vars)
    begin
        spawn = 0;
        if (start_game)
        begin
            spawn = 1;
            start_game = 0 ;
        end
        for (int i = 0 ; i < 4; i= i+1)
        begin
            if ((coords[i] > 199) ||  (game_states[coords[i]] !=0))
            begin
                spawn=1;
            end
        end
        update_board_state =1;
    end
    else
    begin
        update_board_state =0;
    end
end

//keycode detection



//board updating

logic center_down;
logic [19:0] in_row;
logic create_block;

always_ff @(posedge game_clk or posedge reset) // determine how to change the board like spawning
begin
    if (reset)
    begin
        center_down = 0;
        in_row= 0  ;
        Score = 0 ;
        create_block=0;
        for(int i = 0 ; i < 200; i++)
        begin
            game_states[i] = 0;
        end
    end
    else if (update_board_state)
    begin
        if (spawn)
        begin
            in_row= 0  ;
            for (int i = 0 ; i < 4; i= i+1)
            begin
                if (coords[i]>=10)
                begin
                    game_states[coords[i]-10] = block;
                end
            end
            
            for (int i = 0 ; i < 20; i= i+1)
            begin
                in_row[i] = 1;
                for(int j = 10*i; j<10*(i+1); j++)
                begin
                    if (game_states[j]==0)
                    begin
                        in_row[i] = 0 ;
                    end
                end
            end
            
            for (int i = 0 ; i < 20; i= i+1)
            begin
                if (in_row[i])
                begin
                    Score+=1;
                    for (int j = i*10+9 ; j >9; j= j-1)
                    begin
                        game_states[j] = game_states[j-10];
                    end
                    game_states[0]=  0;
                    game_states[1]=  0;
                    game_states[2]=  0;
                    game_states[3]=  0;
                    game_states[4]=  0;
                    game_states[5]=  0;
                    game_states[6]=  0;
                    game_states[7]=  0;
                    game_states[8]=  0;
                    game_states[9]=  0;
                    
                end
            end        
            center_down = 0 ;
            create_block =1;
        end
        else
        begin
            in_row= 0  ;
            center_down = 1;
            create_block = 0;
        end
        
    end
    else
    begin
        in_row =0;
        center_down = 0 ;
        create_block = 0;
    end
    
end

// updating piece

logic end_game;
logic can_swap;
logic [3:0] max_center;
logic [1:0] max_rot;
logic [4:0] hard_drop_dist;
logic good_rotate;

logic [11:0] curr_board_score;
logic [11:0] max_board_score;

logic [4:0] height_on_board[9:0];
logic [7:0] holes;
logic [4:0] completions;

always_ff @(posedge game_clk or posedge reset) // update piece
begin
    if (reset)
    begin
        center = 3;
        block = 0;
        rotation = 0 ;
        next_block = random_block;
        end_game = 0;
        can_swap = 1;
        max_center = 0 ;
        max_rot = 0 ;
        max_board_score= 2000 ;
        curr_board_score = 2000 ;
    end
    else if(create_block)
    begin
        can_swap = 1;
        for(int i = 0 ; i < 4; i++)
        begin
            if(stored_coords[i] > 9 && game_states[stored_coords[i]-10] !=0)
            begin
                end_game =1 ;
            end
        end
        if (end_game)
        begin
            block = 0;
        end
        else
        begin
            max_board_score=  0 ;
            max_rot = 0 ;
            max_center = 0 ;
            center = 0;
            rotation = 0 ;
            
            block = next_block;
            for(int k = 0 ; k < 10 ; k ++)
            begin
                curr_board_score = 2000 ;
                completions = 0;
                holes = 0;
                for(int i = 0 ; i < 10; i++)
                begin
                    height_on_board[i] = 0;
                end
                good_rotate = 1;
                hard_drop_dist = 20;
                for(int j = 0 ; j < 4 ; j++)
                begin
                    if (20- (coords[j]/10) < hard_drop_dist)
                    begin
                        hard_drop_dist = 20- (rotation0_coords[j]/10);
                    end 
                end 
                for(int i = 0 ;i < 20; i++)
                begin
                   for(int j = 0 ; j < 4 ; j++)
                   begin
                        if (k+rotation0_coords[j] + i*10 < 200)
                        begin
                            if(game_states[k+rotation0_coords[j]+i*10]!=0 && hard_drop_dist > i)
                            begin
                                hard_drop_dist = i;
                            end
                        end 
                   end 
                end
                
                for(int i = 0 ; i < 4; i++)
                begin
                    if (rotation0_coords[i]%10<k)
                    begin
                        good_rotate = 0;
                    end
                end
                if(good_rotate)
                begin
                    for(int i = 19;  i >0 ; i--)
                    begin
                        
                    end
                end
            end
            
            next_block = random_block;

        end
    end
    else if (center_down)
    begin
        center = center + 10;
    end
end


endmodule
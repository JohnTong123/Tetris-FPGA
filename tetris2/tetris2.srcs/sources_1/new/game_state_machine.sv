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
    output logic drop,
    output logic finished,
    output logic starter
    );

logic progress;
logic [DATA_WIDTH-1:0] game_states[200];
logic [19:0] dels;
logic [7:0] game_address;

assign drop = spawn;
assign finished = end_game;
// blocks and future blocks
logic [7:0] coords[4]; 
logic [7:0] spawn_coords[4]; 
logic [4:0] hard_drop_dist; 
logic [7:0] stored_coords[4]; 

logic [7:0] rotation_coords[4]; 
logic [7:0] rotationc_coords[4]; 

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

rotate_block spawn_block(
        .center(3),
        .block(next_block),
        .rotation(0),
        .coords(spawn_coords)
);


rotate_block rotated_block(
        .center(center),
        .block(block),
        .rotation((rotation+1)&3),
        .coords(rotation_coords)
);

rotate_block rotatedc_block(
        .center(center),
        .block(block),
        .rotation((rotation-1)&3),
        .coords(rotationc_coords)
);

rotate_block store_block(
        .center(3),
        .block(stored_block),
        .rotation(0),
        .coords(stored_coords)
);
//rotate_block rotate_block(
//        .center(center),
//        .block(block),
//        .rotation(rotation),
//        .coords(coords)
//);

logic[31:0] Score;
assign score = Score;


lfsr lfsr(
    .clk(game_clk),
    .reset(reset),
    .rand_val(random_block)
);

logic start_screen;
assign starter = start_screen;
always_ff @(posedge game_clk or posedge reset) // game clock
begin
    if (reset)
    begin
        start_screen = 1;
    end
    else
    begin
        if(start_key)
        begin
            start_screen &=0;
        end
    end
end

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
    if ((DrawX>10'd179) && (DrawX<10'd244) && (DrawY>10'd99)&& (DrawY<10'd164))
    begin
        relative_coord = ((DrawX-180)>>>4) + 10 *  ((DrawY-100)>>>4);
        data_out = 0;
        for(int i = 0 ; i < 4 ; i++)
        begin
            if((stored_coords[i]-3) == relative_coord)
            begin
                data_out = stored_block;
            end
        end
    end
    else if ((DrawX>10'd179) && (DrawX<10'd244) && (DrawY>10'd9)&& (DrawY<10'd74))
    begin
        relative_coord = ((DrawX-180)>>>4) + 10 *  ((DrawY-10)>>>4);
        data_out = 0 ;
        for(int i = 0 ; i < 4 ; i++)
        begin
            if((spawn_coords[i]-3) == relative_coord)
            begin
                data_out = next_block;
            end
        end
    end
end

//assign data_out = game_states[game_address] | (());
//assign gs[2] = empty;



logic update_board_state ; 
logic update_board_vars; 
logic [25:0] clock_count;
logic [25:0] cap;


logic upd;
always_ff @(posedge game_clk or posedge reset) // game clock
begin
    if (reset | start_key)
    begin
        cap = 6250000;
        upd = 0 ;
    end
    else
    begin
       if(upd == 0)
       begin
            if(speed_down == 1)
            begin
                upd = 1;
                cap+=500000;
            end
            else if (speed_up == 1)
            begin
                upd = 1;
                cap-=500000;
            end
       end 
       else
       begin
            if(speed_down == 0 && speed_up == 0)
            begin
                upd = 0 ;
            end
       end
    end
end


always_ff @(posedge game_clk or posedge reset) // game clock
begin
    if (reset | start_key)
    begin
        clock_count = 0 ;
        update_board_vars = 0 ;

    end
    else
    begin
        clock_count +=1;
        if (clock_count >= cap)
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
    if (reset | start_key)
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
    if (reset | start_key)
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
always_ff @(posedge game_clk or posedge reset) // update piece
begin
    if (reset | start_key)
    begin
        center = 3;
        block = 0;
        rotation = 0 ;
        next_block = random_block;
        end_game = 0;
        can_swap = 1;
        stored_block = 0;
    end
    else if(create_block)
    begin
        can_swap = 1;
        for(int i = 0 ; i < 4; i++)
        begin
            if(spawn_coords[i] > 9 && game_states[spawn_coords[i]-10] !=0)
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
            center = 3;
            rotation = 0 ;
            block = next_block;
            next_block = random_block;
        end
    end
    else if (center_down)
    begin
        center = center + 10;
    end
    else if (left_key)
    begin
        center -=1;
    end
    else if (right_key)
    begin
        center +=1;
    end
    else if (cw_key)
    begin
        rotation  = (rotation+1)&3;
    end
    else if (ccw_key)
    begin
        rotation  = (rotation-1)&3;
    end
    else if (st_key)
    begin
        can_swap = 0;
        if (stored_block !=0)
        begin
            for(int i = 0 ; i < 4; i++)
            begin
                if(stored_coords[i] > 9 && game_states[stored_coords[i]-10] !=0)
                begin
                    end_game =1 ;
                end
            end
        end
        if (end_game)
        begin
            block = 0;
        end
        else
        begin
            center = 3;
            if (stored_block ==0)
            begin
                stored_block = block;
                next_block = random_block;
            end
            else
            begin
                block =block ^ stored_block;
    //            stored_block = block;
                stored_block = block^stored_block;
                block = block^stored_block;
            end
            rotation = 0 ;
        end
    end
    else if(sp_key)
    begin
        center = center + 10* hard_drop_dist;
    end
end


// left keycode
logic [13:0] left_count;
logic left_key;
logic left_temp;

always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        left_count = 0 ;
        left_key = 0 ;
    end
    else
    begin
       if (keycode == 8'h50)
       begin
            
            if(left_count&(1<<11))
            begin
                if (left_count&(1<<13))
                begin
                    left_key = 0 ;
                end
                else
                begin
                    left_temp = 1 ;
                    for (int i = 0 ; i < 4; i= i+1)
                    begin
                        if (coords[i]%10 == 0)
                        begin
                            left_temp = 0;
                        end
                        else if (coords[i]>=10)
                        begin
                            if (game_states[coords[i]-11] != 0)
                            begin
                                left_temp = 0;
                            end
                        end
                    end
                    left_count[13] = 1;
                    
                    left_key = left_temp;
                end
            end
            else
            begin
                left_count+=1;
            end
       end
       else
       begin
            left_key = 0 ;
            left_count = 0 ;
       end
       
    end
end


// right keycode
logic [13:0] right_count;
logic right_key;
logic right_temp;

always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        right_count = 0 ;
        right_key = 0 ;
    end
    else
    begin
       if (keycode == 8'h4F)
       begin
            
            if(right_count&(1<<11))
            begin
                if (right_count&(1<<13))
                begin
                    right_key = 0 ;
                end
                else
                begin
                    right_temp = 1 ;
                    for (int i = 0 ; i < 4; i= i+1)
                    begin
                        if (coords[i]%10 == 9)
                        begin
                            right_temp = 0;
                        end
                        else if (coords[i]>=10)
                        begin
                            if (game_states[coords[i]-9] != 0)
                            begin
                                right_temp = 0;
                            end
                        end
                    end
                    right_count[13] = 1;
                    right_key = right_temp;
                end
            end
            else
            begin
                right_count+=1;
            end
       end
       else
       begin
            right_key = 0 ;
            right_count = 0 ;
       end
       
    end
end

//rotato
logic [13:0] cw_count  ;
logic cw_key ;
logic cw_temp;

always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        cw_count = 0 ;
        cw_key = 0 ;
        cw_temp = 0 ;
    end
    else
    begin
       if (keycode == 8'h1B)
       begin
            
            if(cw_count&(1<<11))
            begin
                if (cw_count&(1<<13))
                begin
                    cw_key = 0 ;
                end
                else
                begin
                    cw_temp = 1 ;
                    
                    for (int i = 0 ; i < 4; i= i+1)
                    begin
                        if(rotation_coords[i] >199)
                        begin
                            cw_temp = 0;
                        end
                        else if(rotation_coords[i]>10 && game_states[rotation_coords[i]-10]!=0)
                        begin
                            cw_temp = 0 ;
                        end
                        else if (rotation_coords[i]%10<center%10)
                        begin
                            cw_temp = 0;
                        end
                    end
                    cw_count[13] = 1;
                    cw_key = cw_temp;
                end
            end
            else
            begin
                cw_count+=1;
            end
       end
       else
       begin
            cw_key = 0 ;
            cw_count = 0 ;
       end
       
    end
end

logic [13:0] ccw_count ;
logic ccw_key ;
logic ccw_temp;

always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        ccw_count = 0 ;
        ccw_key = 0 ;
        ccw_temp = 0 ;
    end
    else
    begin
       if (keycode == 8'h1D )
       begin
            
            if(ccw_count&(1<<11))
            begin
                if (ccw_count&(1<<13))
                begin
                    ccw_key = 0 ;
                end
                else
                begin
                    ccw_temp = 1 ;
                    
                    for (int i = 0 ; i < 4; i= i+1)
                    begin
                        if(rotationc_coords[i] >199)
                        begin
                            ccw_temp = 0;
                        end
                        else if(rotationc_coords[i]>10 && game_states[rotationc_coords[i]-10]!=0)
                        begin
                            ccw_temp = 0 ;
                        end
                        else if (rotationc_coords[i]%10<center%10)
                        begin
                            ccw_temp = 0;
                        end
                    end
                    ccw_count[13] = 1;
                    ccw_key = ccw_temp;
                end
            end
            else
            begin
                ccw_count+=1;
            end
       end
       else
       begin
            ccw_key = 0 ;
            ccw_count = 0 ;
       end
       
    end
end

// update storage
logic [13:0] st_count ;
logic st_key ;
logic st_temp;
//logic first_st;
//assign st_key = 0 ;
always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        st_count = 0 ;
        st_key = 0 ;
        st_temp = 0 ;
//        first_st =1;
    end
    else
    begin
       if (keycode == 8'h06 )
       begin
            
            if(st_count&(1<<11))
            begin
                if (st_count&(1<<13))
                begin
                    st_key = 0 ;
                end
                else
                begin
                    st_temp = 1 ;
                    
//                    if(stored_block==0)
//                    begin
//                        st_temp= 0;
//                    end
                    if(can_swap==0)
                    begin
                        st_temp= 0;
                    end
                    st_count[13] = 1;
                    st_key = st_temp;
                end
            end
            else
            begin
                st_count+=1;
            end
       end
       else
       begin
            st_key = 0 ;
            st_count = 0 ;
       end
       
    end
end

// harddrop
logic [13:0] sp_count ;
logic sp_key;

always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        sp_count = 0 ;
        sp_key = 0 ;
    end
    else
    begin
       if (keycode == 8'h2C || switches[0])
       begin
            
            if(sp_count&(1<<11))
            begin
                if (sp_count&(1<<13))
                begin
                    sp_key = 0 ;
                end
                else
                begin
                    
                    sp_count[13] = 1;
                    sp_key = 1;
                end
            end
            else
            begin
                sp_count+=1;
            end
       end
       else
       begin
            sp_key = 0 ;
            sp_count = 0 ;
       end
       
    end
end

always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        hard_drop_dist = 0 ;
    end
    else
    begin
        hard_drop_dist = 20;
        for(int j = 0 ; j < 4 ; j++)
        begin
            if (20- (coords[j]/10) < hard_drop_dist)
            begin
                hard_drop_dist = 20- (coords[j]/10);
            end 
        end 
        for(int i = 0 ;i < 20; i++)
        begin
           for(int j = 0 ; j < 4 ; j++)
           begin
                if (coords[j] + i*10 < 200)
                begin
                    if(game_states[coords[j]+i*10]!=0 && hard_drop_dist > i)
                    begin
                        hard_drop_dist = i;
                    end
                end 
           end 
        end
    end
end



logic [13:0] speed_up_ct;
logic speed_up;
always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        speed_up_ct = 0 ;
        speed_up = 0 ;
    end
    else
    begin
       if (keycode == 8'h0f || switches[1] )
       begin
            
            if(speed_up_ct&(1<<11))
            begin
                if (speed_up_ct&(1<<13))
                begin
                    speed_up = 0 ;
                end
                else
                begin
                    
                    speed_up_ct[13] = 1;
                    speed_up = 1;
                end
            end
            else
            begin
                speed_up_ct+=1;
            end
       end
       else
       begin
            speed_up = 0 ;
            speed_up_ct = 0 ;
       end
       
    end
end

logic [13:0] speed_down_ct;
logic speed_down;
always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        speed_down_ct = 0 ;
        speed_down = 0 ;
    end
    else
    begin
       if (keycode == 8'h0e  )
       begin
            
            if(speed_down_ct&(1<<11))
            begin
                if (speed_down_ct&(1<<13))
                begin
                    speed_down = 0 ;
                end
                else
                begin
                    
                    speed_down_ct[13] = 1;
                    speed_down = 1;
                end
            end
            else
            begin
                speed_down_ct+=1;
            end
       end
       else
       begin
            speed_down = 0 ;
            speed_down_ct = 0 ;
       end
       
    end
end



logic [13:0] start_ct;
logic start_key;
always_ff @(posedge game_clk or posedge reset) // update key
begin
    if (reset)
    begin
        start_ct = 0 ;
        start_key = 0 ;
    end
    else
    begin
       if (keycode == 8'h16 |switches[2] )
       begin
            
            if(start_ct&(1<<11))
            begin
                if (start_ct&(1<<13))
                begin
                    start_key = 0 ;
                end
                else
                begin
                    
                    start_ct[13] = 1;
                    start_key = 1;
                end
            end
            else
            begin
                start_ct+=1;
            end
       end
       else
       begin
            start_key = 0 ;
            start_ct = 0 ;
       end
       
    end
end




endmodule
//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//                                                                       --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper (
    input  logic [9:0] DrawX, DrawY,
    input logic [2:0] state,
    input [31:0] score,
    output logic [3:0]  Red, Green, Blue ,
    input finished);

	 logic [9:0] font_addr;
	 logic [7:0] font_data;
	 
	 font_rom font(
	   .addr(font_addr),
	   .data(font_data)
	   );

    always_comb
    begin:RGB_Display
        if (finished)
            if ( ((DrawX<10'd160) && (DrawY<10'd192)&& (DrawY>10'd128)))
            begin
               if(DrawX < 32) font_addr = 464;
                else if(DrawX < 40) font_addr = 208;
                else if(DrawX < 48) font_addr = 400;
                else if(DrawX < 56) font_addr = 448;
                else if(DrawX < 64) font_addr = 240;
                else if(DrawX < 72) font_addr = 160;
                
                else if(DrawX < 80) font_addr = ((score/10000) % 10) << 4;
                else if(DrawX < 88) font_addr = ((score/1000) % 10) << 4;
                else if(DrawX < 96) font_addr = ((score/100) % 10) << 4;
                else if(DrawX < 104) font_addr = ((score/10) % 10) << 4;
                else if(DrawX < 112) font_addr = ((score) % 10) << 4;
                else if(DrawX < 120) font_addr = 0  << 4;
                else if(DrawX < 128) font_addr = 0 << 4;
            
                font_addr = font_addr + DrawY - 152;
            
                if (font_data[7 - (DrawX % 8)])
                begin
                    Red = 4'h0;
                    Green = 4'h0;
                    Blue = 4'h0;
                end else begin
                    Red = 4'hf; 
                    Green = 4'hf;
                    Blue = 4'hf;
                end
            end
            else if ((DrawX<10'd160) && (DrawY<10'd320))
            begin
                if(state ==0)
                begin
                    Red = 4'h0;
                    Green = 4'h0;
                    Blue = 4'h0;
                end
                else
                begin
                    Red = 4'h8;
                    Green = 4'h8;
                    Blue = 4'h8;
                end
            end
            else
            begin
                Red = 4'h1; 
                Green = 4'h1;
                Blue = 4'h1;
            end
        else if (((DrawX>10'd179) && (DrawX<10'd244) && (DrawY>10'd99)&& (DrawY<10'd164))||((DrawX>10'd179) && (DrawX<10'd244) && (DrawY>10'd9)&& (DrawY<10'd74))||((DrawX<10'd160) && (DrawY<10'd320))) 
        begin 
             case (state[2:0] )
             3'b000:
                begin
                Red = 4'h0;
                Green = 4'h0;
                Blue = 4'h0;
                end
              3'b001:
                begin
                Red = 4'h5;
                Green = 4'hf;
                Blue = 4'hf;
                end
              3'b010:
                begin
                Red = 4'h0;
                Green = 4'h0;
                Blue = 4'hf;
                end
              3'b011:
                begin
                Red = 4'hf;
                Green = 4'h5;
                Blue = 4'h0;
                end
              3'b100:
                begin
                Red = 4'hf;
                Green = 4'hf;
                Blue = 4'h5;
                end
              3'b101:
                begin
                Red = 4'h0;
                Green = 4'hf;
                Blue = 4'h0;
                end
              3'b110:
                begin
                Red = 4'h5;
                Green = 4'h0;
                Blue = 4'h5;
                end
              3'b111:
                begin
                Red = 4'hf;
                Green = 4'h0;
                Blue = 4'h0;
                end

              endcase
        end
        else if (((DrawX >= 10'd24) && (DrawX<10'd128) && (DrawY>=10'd340) && (DrawY < 10'd356))) begin 
            if(DrawX < 32) font_addr = 464;
            else if(DrawX < 40) font_addr = 208;
            else if(DrawX < 48) font_addr = 400;
            else if(DrawX < 56) font_addr = 448;
            else if(DrawX < 64) font_addr = 240;
            else if(DrawX < 72) font_addr = 160;
            
            else if(DrawX < 80) font_addr = ((score/10000) % 10) << 4;
            else if(DrawX < 88) font_addr = ((score/1000) % 10) << 4;
            else if(DrawX < 96) font_addr = ((score/100) % 10) << 4;
            else if(DrawX < 104) font_addr = ((score/10) % 10) << 4;
            else if(DrawX < 112) font_addr = ((score) % 10) << 4;
            else if(DrawX < 120) font_addr = 0  << 4;
            else if(DrawX < 128) font_addr = 0 << 4;
        
            font_addr = font_addr + DrawY - 340;
        
             if (font_data[7 - (DrawX % 8)])
                begin
                    Red = 4'hf;
                    Green = 4'hf;
                    Blue = 4'hf;
                end else begin
                    Red = 4'h1; 
                    Green = 4'h1;
                    Blue = 4'h1;
                end
        end
        else begin 
            Red = 4'h1; 
            Green = 4'h1;
            Blue = 4'h1;
        end      
    end 
    
endmodule

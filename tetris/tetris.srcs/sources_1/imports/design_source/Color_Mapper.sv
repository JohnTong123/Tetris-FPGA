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


module  color_mapper ( input  logic [9:0] DrawX, DrawY, input logic [3:0] state,
                       output logic [3:0]  Red, Green, Blue );
    
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*BallS, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
       )

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 120 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
  

    
    
    always_comb
    begin
        
    end
    always_comb
    begin:RGB_Display
        if (((DrawX<10'd160) && (DrawY<10'd320))) begin 
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
              
//            Red = 4'hf;
//            Green = 4'h7;
//            Blue = 4'h0;
              endcase
        end       
        else begin 
            Red = 4'hf - DrawX[9:6]; 
            Green = 4'hf - DrawX[9:6];
            Blue = 4'hf - DrawX[9:6];
        end      
    end 
    
endmodule

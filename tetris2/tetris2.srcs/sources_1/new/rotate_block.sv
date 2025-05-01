`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2025 10:29:44 PM
// Design Name: 
// Module Name: rotate_block
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


module rotate_block(
        input  [7:0] center,
        input  [2:0] block,
        input  [1:0] rotation,
        output [7:0] coords[4]
    );
    logic [7:0] coords[4];
    always_comb begin
        
        case(block)
            3'd1:
            begin
                case(rotation)
                    2'd0:
                    begin
                        coords[0] = center+10;
                        coords[1] = center+11;
                        coords[2] = center+12;
                        coords[3] = center+13;
                    end
                    2'd1:
                    begin
                        coords[0] = center + 2;
                        coords[1] = center + 12;
                        coords[2] = center+22;
                        coords[3] = center+32;
                    end
                    2'd2:
                    begin
                        coords[0] = center + 20;
                        coords[1] = center + 21;
                        coords[2] = center+22;
                        coords[3] = center+23;
                    end
                    2'd3:
                    begin
                        coords[0] = center + 1;
                        coords[1] = center + 11;
                        coords[2] = center+21;
                        coords[3] = center+31;
                    end
                endcase
            end
            3'd2:
            begin
                case(rotation)
                    2'd0:
                    begin
                        coords[0] = center;
                        coords[1] = center+10;
                        coords[2] = center+11;
                        coords[3] = center+12;
                    end
                    2'd1:
                    begin
                        coords[0] = center + 1;
                        coords[1] = center + 2;
                        coords[2] = center+11;
                        coords[3] = center+21;
                    end
                    2'd2:
                    begin
                        coords[0] = center + 10;
                        coords[1] = center + 11;
                        coords[2] = center+12;
                        coords[3] = center+22;
                    end
                    2'd3:
                    begin
                        coords[0] = center + 1;
                        coords[1] = center + 11;
                        coords[2] = center+21;
                        coords[3] = center+20;
                    end
                endcase
            end
            3'd3:
            begin
                case(rotation)
                    2'd0:
                    begin
                        coords[0] = center+10;
                        coords[1] = center+11;
                        coords[2] = center+12;
                        coords[3] = center+2;
                    end
                    2'd1:
                    begin
                        coords[0] = center + 1;
                        coords[1] = center + 11;
                        coords[2] = center+21;
                        coords[3] = center+22;
                    end
                    2'd2:
                    begin
                        coords[0] = center + 10;
                        coords[1] = center + 11;
                        coords[2] = center+12;
                        coords[3] = center+20;
                    end
                    2'd3:
                    begin
                        coords[0] = center ;
                        coords[1] = center + 1;
                        coords[2] = center+11;
                        coords[3] = center+21;
                    end
                endcase
            end
            3'd4:
            begin
                coords[0] = center+1;
                coords[1] = center+2;
                coords[2] = center+11;
                coords[3] = center+12;
            end
            3'd5:
            begin
                case(rotation)
                    2'd0:
                    begin
                        coords[0] = center+1;
                        coords[1] = center+2;
                        coords[2] = center+10;
                        coords[3] = center+11;
                    end
                    2'd1:
                    begin
                        coords[0] = center + 1;
                        coords[1] = center + 11;
                        coords[2] = center+12;
                        coords[3] = center+22;
                    end
                    2'd2:
                    begin
                        coords[0] = center + 11;
                        coords[1] = center + 12;
                        coords[2] = center+20;
                        coords[3] = center+21;
                    end
                    2'd3:
                    begin
                        coords[0] = center ;
                        coords[1] = center + 10;
                        coords[2] = center+11;
                        coords[3] = center+21;
                    end
                endcase
            end
            3'd6:
            begin
                case(rotation)
                    2'd0:
                    begin
                        coords[0] = center+1;
                        coords[1] = center+10;
                        coords[2] = center+11;
                        coords[3] = center+12;
                    end
                    2'd1:
                    begin
                        coords[0] = center + 1;
                        coords[1] = center + 11;
                        coords[2] = center+12;
                        coords[3] = center+21;
                    end
                    2'd2:
                    begin
                        coords[0] = center + 10;
                        coords[1] = center + 11;
                        coords[2] = center+12;
                        coords[3] = center+21;
                    end
                    2'd3:
                    begin
                        coords[0] = center + 1;
                        coords[1] = center + 11;
                        coords[2] = center+10;
                        coords[3] = center+21;
                    end
                endcase
            end
            3'd7:
            begin
                case(rotation)
                    2'd0:
                    begin
                        coords[0] = center;
                        coords[1] = center+1;
                        coords[2] = center+11;
                        coords[3] = center+12;
                    end
                    2'd1:
                    begin
                        coords[0] = center + 2;
                        coords[1] = center + 11;
                        coords[2] = center+12;
                        coords[3] = center+21;
                    end
                    2'd2:
                    begin
                        coords[0] = center + 10;
                        coords[1] = center + 11;
                        coords[2] = center+21;
                        coords[3] = center+22;
                    end
                    2'd3:
                    begin
                        coords[0] = center + 1;
                        coords[1] = center + 10;
                        coords[2] = center+11;
                        coords[3] = center+20;
                    end
                endcase
            end
            
            
            default: 
            begin
                coords[0] = 0;
                coords[1] = 0 ;
                coords[2] = 0;
                coords[3] = 0;
            end
            
            
        endcase
    end
endmodule
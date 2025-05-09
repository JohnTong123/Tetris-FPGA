//-------------------------------------------------------------------------
//    mb_usb_hdmi_top.sv                                                 --
//    Zuofu Cheng                                                        --
//    2-29-24                                                            --
//                                                                       --
//                                                                       --
//    Spring 2024 Distribution                                           --
//                                                                       --
//    For use with ECE 385 USB + HDMI                                    --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------
`timescale 1ns / 1ps

module mb_usb_hdmi_top # (
    parameter integer C_S_AXI_DATA_WIDTH	= 3
)
(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB,
    input logic [2:0] switches,
    output logic audio_out_r,
    output logic audio_out_l
);
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY, ballxsig, ballysig, ballsizesig;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    logic finished;
    logic drop;
    logic [31:0] score;
    
    assign reset_ah = reset_rtl_0;
    logic [2:0] dout;
//    logic [25:0] counter;
    logic [3:0] gs;
//    logic [7:0] oof;
    game_state_machine game 
    (
        .game_clk(clk_25MHz),
        .clk(clk_25MHz),
        .DrawX(drawX),
        .DrawY(drawY),
        .keycode(keycode0_gpio),
        .reset(reset_ah),
        .data_out(dout),
//        .counter(counter),
        .gs(gs),
//        .debug(oof)
        .score(score),
        .switches(switches),
        .finished(finished),
        .drop(drop)
        );
//    logic [C_S_AXI_DATA_WIDTH-1:0] game_states[200];
    
//    assign game_states[0] = 4'h0;
//    assign game_states[1] = 4'd1;
///    assign game_states[2] = 4'd2;
//    assign game_states[3] = 4'd3;
//    assign game_states[4] = 4'd4;
//    assign game_states[5] = 4'd5;
//    assign game_states[6] = 4'd6;
//    assign game_states[7] = 4'd7;
//    assign game_states[20] = 4'd4;
//    assign game_states[120] = 4'd6;
//    assign game_states[79] = 4'd7;
    
    
//    logic [7:0] game_address;
//    always_comb
//    begin
//        game_address = (drawX>>>4) + 10 *  (drawY>>>4);
//    end
    
    //Keycode HEX drivers
    hex_driver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({0,4'd1,0,0}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    hex_driver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({0, 0, 0, 0}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    ml_block mb_block_i (
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

    
    //Ball Module
//    ball ball_instance(
//        .Reset(reset_ah),
//        .frame_clk(vsync),                    //Figure out what this should be so that the ball will move
//        .keycode(keycode0_gpio[7:0])    //Notice: only one keycode connected to ball by default
//    );
    
    //Color Mapper Module   
    color_mapper color_instance(
        .DrawX(drawX),
        .DrawY(drawY),
        .state(dout),
        .score(score),
        .Red(red),
        .Green(green),
        .Blue(blue),
        .finished(finished)
    );
    
    top_module sound(
    .clk(Clk),
    .rst(reset_ah),
    .btn(drop),
    .audio_out_l(audio_out_l),
    .audio_out_r(audio_out_r)
    );
    
endmodule
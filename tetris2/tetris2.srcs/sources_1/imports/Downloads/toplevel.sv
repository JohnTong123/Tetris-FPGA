`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2025 12:04:45 AM
// Design Name: 
// Module Name: toplevel
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


module top_module (
    input  logic        clk,
    input  logic        rst,
    input  logic        btn,
    output logic        audio_out
);
    // Beat Generator
    
    logic clk_1mhz;
    logic [6:0] clkdiv_cnt;
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            clkdiv_cnt <= 0;
            clk_1mhz <= 0;
        end else if (clkdiv_cnt == 49) begin
            clkdiv_cnt <= 0;
            clk_1mhz <= ~clk_1mhz;
        end else begin
            clkdiv_cnt <= clkdiv_cnt + 1;
        end
    end
    
    logic [18:0] clk_beat_cnt;
    logic [3:0] beat_addr;

    always_ff @(posedge clk_1mhz or posedge rst) begin
        if (rst) begin
            clk_beat_cnt <= 0;
            beat_addr <= 0;
        end else if (clk_beat_cnt == 400_000 - 1) begin // 1MHz / 2.5Hz = 400k
            clk_beat_cnt <= 0;
            beat_addr <= beat_addr + 1;
        end else begin
            clk_beat_cnt <= clk_beat_cnt + 1;
        end
    end

    // Note ROM
    logic [6:0] note1, note2, note3;

    song_rom song (
        .clk(clk),
        .addr(beat_addr),
        .note1(note1),
        .note2(note2),
        .note3(note3)
    );
    
    logic [23:0] phase1, phase2, phase3;
    
    phase_lut phases (
        .note1(note1),
        .note2(note2),
        .note3(note3),
        .phase1(phase1),
        .phase2(phase2),
        .phase3(phase3)
    );

    // NCOs for Triangle Waves

    logic [23:0] wave1, wave2, wave3, wave4;

    nco osc1 (.clk(clk_1mhz), .rst(rst), .phase_inc(phase1), .wave_out(wave1));
    nco osc2 (.clk(clk_1mhz), .rst(rst), .phase_inc(phase2), .wave_out(wave2));
    nco osc3 (.clk(clk_1mhz), .rst(rst), .phase_inc(phase3), .wave_out(wave3));
    nco osc4 (.clk(clk_1mhz), .rst(rst), .phase_inc(btn ? 23'd4389 : 23'd0), .wave_out(wave4)); // Fixed pitch tone when button held

    logic [25:0] mix;
    logic [8:0] pwm_val;

    always_comb begin
        mix = wave1 + wave2 + wave3 + wave4;
        pwm_val = mix[25:18]; // scale to 8-bit
    end

    pwm pwm_gen (
        .clk(clk),
        .rst(rst),
        .value(pwm_val),
        .pwm_out(audio_out)
    );
endmodule
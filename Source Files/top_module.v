`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2022 00:41:25
// Design Name: 
// Module Name: top_module
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


module top_module(clk,rst,opp,pause,cathodes,anodes);
    input clk,rst,opp,pause;
    output [7:0] cathodes;
    output [3:0] anodes;
    reg [7:0] digits [3:0];
    reg[4:0] cnt_hori;
    reg cnt_vert;
    wire clk_1Hz;
    clockDivider divide2(clk, rst, clk_1Hz);
    wire [7:0] leftUp = 8'b01111001, rightUp = 8'b00111101, leftDown = 8'b11100101, rightDown = 8'b11001101, OFF = 8'b11111111;
    integer i;
    always @(posedge clk_1Hz) begin
        if (rst) begin
            for(i = 0; i < 4; i = i + 1) digits[i] <= 8'b11111111;
            cnt_hori <= 0; cnt_vert <= 0;
        end
        else begin
            if (pause) begin
                cnt_hori <= cnt_hori; cnt_vert <= cnt_vert;
            end
            else begin
                if (cnt_vert == 0) begin
                    if (cnt_hori == 2) cnt_vert <= 1;
                    else cnt_hori <= (cnt_hori + 1) % 3;
                end
                else if (cnt_vert == 1) begin
                    if (cnt_hori == 0) cnt_vert <= 0;
                    else cnt_hori <= (cnt_hori + 2) % 3;
                end
            end
        end
        for (i = 0; i < 3; i = i + 1) 
            if (i == cnt_hori) begin
                digits[i] <= (cnt_vert ? (opp ? rightDown : leftDown) : (opp ? rightUp : leftUp));
                digits[i + 1] <= (cnt_vert ? (opp ? leftDown : rightDown) : (opp ? leftUp : rightUp));
            end
        for (i = 0; i < 4; i = i + 1) if (i != cnt_hori && i != cnt_hori + 1) digits[i] <= OFF;
        
    end
    digitSwitcher s(clk,rst,digits[opp ? 0 : 3],digits[opp ? 1 : 2],digits[opp ? 2 : 1],digits[opp ? 3 : 0],cathodes,anodes);
endmodule

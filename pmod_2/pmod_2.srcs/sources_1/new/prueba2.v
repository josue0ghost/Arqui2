`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 19:37:39
// Design Name: 
// Module Name: top
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


module top(
    input pmod,
    output led
    );
recibir_senal recibir_senal(.pmod_sign(pmod), .led_sign(led));
endmodule

module recibir_senal(
    input pmod_sign,
    output led_sign
);
    assign led_sign = pmod_sign;
endmodule


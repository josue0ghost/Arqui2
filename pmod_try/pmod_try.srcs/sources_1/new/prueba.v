`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 03:03:46
// Design Name: 
// Module Name: prueba
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


module prueba(
    input switch,
    output leds,
    input pmod,
    output led
    );
    
    send_signal send_signal(.switch_signal(switch), .pmod_signal(leds));
endmodule

module send_signal(
    input switch_signal,
    output pmod_signal
    );
    
    assign pmod_signal = switch_signal;
    
endmodule



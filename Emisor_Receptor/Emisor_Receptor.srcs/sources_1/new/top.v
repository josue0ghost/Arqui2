`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2019 16:43:52
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
    input [2:0] pmod,    
    output [3:0] anode,
    output [6:0] seg,
    output reg [2:0] leds
    );
    
    reg [12:0] numero;
    
    reg p1, p2, p3;
    
    always @ (pmod)
    begin
        if(pmod[0] == 1'b0)
        begin
            p1 <= 1'b1;
            leds[0] <= 1'b1;
            p3 <= 1'b0;
            leds[2] <= 1'b0;
        end
        
        if(pmod[2] == 1'b0)
        begin
            p3 <= 1'b1;
            leds[2] <= 1'b1;
            p1 <= 1'b0;
            leds[0] <= 1'b0;
        end
        
        if(pmod[1] == 1'b0)
        begin
            leds[1] <= 1'b1;
            if(p1)
            begin
                numero = numero + 1;
                p1 <= 1'b0;
                leds[0] <= 1'b0;
                leds[1] <= 1'b0;
                leds[2] <= 1'b0;
            end
            else if(p3)
            begin
                numero = numero - 1;
                p3 <= 1'b0;
                leds[0] <= 1'b0;
                leds[1] <= 1'b0;
                leds[2] <= 1'b0;
            end
        end
    end
//    wire [12:0] numero;
//    wire suma, resta;
//    wire a, c;
    
//    assign_regs assign_regs(.a(pmod[0]), .c(pmod[2]), .areg(a), .creg(c));
//    ands ands(.a(a), .b(pmod[1]), .c(c), .suma(suma), .resta(resta));
//    up up(.suma(suma), .resta(resta), .numero(numero));
    show show(.number(numero), .anode(anode), .seg(seg));
endmodule

module assign_regs(
    input a, c,
    output reg areg, creg
    );
    
    always @ (a, c)
    begin
        if(a)
        begin
            #10 areg <= a;
            #10 creg <= 1'b0;
        end
        else if(c)
        begin
            #10 areg <= 1'b0;
            #10 creg <= c;
        end
    end
endmodule

module ands(
    input a, b, c,
    output reg suma, resta
    );
    always @(b)
    begin
        if(a & b)
        begin
            #10 suma <= a;
            #10 resta <= 1'b0;
        end
        if(c & b)
        begin          
            #10 resta <= 1'b1;
            #10 suma <= 1'b0;          
        end
    end
endmodule

module up (
    input suma, resta,
    output reg [12:0] numero
    );
    
    always @ (posedge(suma), posedge(resta))
        begin
            if (resta == 1'b1)
            begin
                numero = numero - 1;
//                nsuma <= ~suma;
            end
            if (suma == 1'b1)
            begin
                numero = numero + 1;
//                nresta <= ~resta;
            end
        end
endmodule

module cuenta(
    input [2:0] pmod,
    output reg [12:0] count
    );
    reg a;
    reg b;
    reg c;
    
    always @(posedge pmod)
    begin
        if (pmod[0])
            begin
            #10 a = 1'b1;
            #10 c = 1'b0;
            end
        if (pmod[1])
            #10 b = 1'b1;
        if(a & b)
            begin
            #10 count = count + 13'b1;
            #10 a = 1'b0;
            #10 b = 1'b0;
            #10 c = 1'b0;
            end
        if(c & b)
            begin
            #10 count = count - 13'b1;
            #10 a = 1'b0;
            #10 b = 1'b0;
            #10 c = 1'b0;
            end
        if (pmod[2])
            begin
            #10 c = 1'b1;
            #10 a = 1'b0;
            end 
    end
endmodule 

module show(
    //input [3:0] A, B, C, D,
    input [12:0] number,
    output [3:0] anode,
    output [6:0] seg
    );

wire [3:0] A, B, C, D;

bcd bcd(
        .number(number),
        .thousands(D), 
        .hundreds(C), 
        .tens(B), 
        .ones(A)
        );


bcdto7segmentclocked bcdto7segmentclocked(
    .A(A), 
    .B(B), 
    .C(C), 
    .D(D),
    .anode(anode),
    .seg(seg) 
    );
    
    
endmodule

module bcd(number, thousands, hundreds, tens, ones);
   // I/O Signal Definitions
   input  [12:0] number;
   output reg [3:0] thousands;
   output reg [3:0] hundreds;
   output reg [3:0] tens;
   output reg [3:0] ones;
   
   // Internal variable for storing bits
   reg [28:0] shift;
   integer i;
   
   always @(number)
   begin
      // Clear previous number and store new number in shift register
      shift[28:13] = 0;
      shift[12:0] = number;
      
      // Loop eight times
      for (i=0; i<13; i=i+1) begin
         if (shift[16:13] >= 5)
            shift[16:13] = shift[16:13] + 3;
            
         if (shift[20:17] >= 5)
            shift[20:17] = shift[20:17] + 3;
            
         if (shift[24:21] >= 5)
            shift[24:21] = shift[24:21] + 3;
         
         if (shift[28:25] >= 5)
            shift[28:25] = shift[28:25] + 3;
         
         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
      thousands = shift[28:25];
      hundreds = shift[24:21];
      tens     = shift[20:17];
      ones     = shift[16:13];
   end
 
endmodule

module bcdto7segmentclocked(
    input [3:0] A, B, C, D,
    output [3:0] anode,
    output [6:0] seg 
    );

wire [3:0] x;
wire [3:0] an;
wire [1:0] sel;
wire clk_div;
bcdto7segment_dataflow bcdto7segment(.x(x), .an(an), .anode(anode), .seg(seg));
mux16to4 mux16to4(.A(A),.B(B),.C(C), .D(D), .sel(sel), .S(x));
demux4to1 demux4to1(.sel(sel), .A(an[0]), .B(an[1]), .C(an[2]), .D(an[3]));
endmodule

module bcdto7segment_dataflow(
    input [3:0] x,
    input [3:0] an,
    output [3:0] anode,
    output reg [6:0] seg
    );
 //reg [6:0] seg;
 
 assign anode = an;
 
 always @ (x or an) 
    case (x) 
      0 : seg = 7'b0000001; 
      1 : seg = 7'b1001111; 
      2 : seg = 7'b0010010; 
      3 : seg = 7'b0000110; 
      4 : seg = 7'b1001100; 
      5 : seg = 7'b0100100;
      6 : seg = 7'b0100000;
      7 : seg = 7'b0001111;
      8 : seg = 7'b0000000;
      9 : seg = 7'b0000100;
      default : seg = 7'b0000000;
    endcase    
endmodule

module mux16to4(
    input [3:0] A, 
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] sel,
    output reg [3:0] S
   );
   
always @ (A, B, C, D, sel)
    case (sel)
    0 : S = A;
    1 : S = B;
    2 : S = C;
    3 : S = D;
    default : S = 0;
    endcase

endmodule

module demux4to1(
    input [1:0] sel,
    output reg A, 
    output reg B,
    output reg C,
    output reg D
    );
always @ (sel)
    case (sel)
    0 : {D, C, B, A} = ~(4'b0001);
    1 : {D, C, B, A} = ~(4'b0010);
    2 : {D, C, B, A} = ~(4'b0100);
    3 : {D, C, B, A} = ~(4'b1000);
    default :  {D, C, B, A} = ~(4'b0000);
    endcase    
endmodule
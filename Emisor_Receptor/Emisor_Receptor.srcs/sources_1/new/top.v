`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.08.2019 19:53:49
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
    input [3:0] pmod,    
    output [3:0] anode,
    output [6:0] seg
    );
    
    wire [12:0] numero;
    wire suma, resta;
    
//    ands ands(.a(pmod[0]), .b(pmod[1]), .c(pmod[2]), .suma(suma), .resta(resta));
    up up(.suma(pmod[0]), .resta(pmod[2]), .numero(numero));
//    down down(.resta(resta), .numero(numero));
    show show(.number(numero), .anode(anode), .seg(seg));
endmodule

//module rst(
//    input sum, res,
//    output reg suma, resta
//    );
    
//    always @(sum, res)
//    begin
//        suma <= sum;
//        resta <= res;
//    end
//endmodule

module ands(
    input a, b, c,
    output suma, resta
    );
    
    assign suma = a;
    assign resta = c;
//    always @(a, c)
//    begin
//        if(a == 1'b1)
//        begin
//            suma <= 1'b1;
//            resta <= 1'b0;
//        end
//        else if(c == 1'b1)
//        begin          
//            resta <= 1'b1;
//            suma <= 1'b0;          
//        end
//    end
endmodule

module up (
    input suma, resta,
    output reg [12:0] numero
    );
    
    always @ (posedge(suma), posedge(resta))
        begin
            if (resta == 1'b1)
            begin
                numero = numero - 12'b000000000001;
//                nsuma <= ~suma;
            end
            if (suma == 1'b1)
            begin
                numero = numero + 12'b000000000001;
//                nresta <= ~resta;
            end
        end
endmodule

//module down (
//    input resta,
//    output reg [12:0] numero
//    );
      
//    always @ (posedge(resta))
//        begin
//            if (resta == 1'b1)
//                numero <= numero - 1;
//        end
//endmodule

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

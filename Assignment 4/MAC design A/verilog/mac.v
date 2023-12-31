// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

input unsigned [bw-1:0] a;
input signed [bw-1:0] b;
input signed [psum_bw-1:0] c;
output signed [psum_bw-1:0] out;

wire signed [bw:0] a_signed;
wire signed [2*bw-1:0] product;

assign a_signed = a;
assign product = a_signed * b;
assign out = c + product;


endmodule

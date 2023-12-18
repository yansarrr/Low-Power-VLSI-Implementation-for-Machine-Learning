// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac (out, a, b, c);

parameter bw = 4;
parameter psum_bw = 16;

input unsigned [4*bw-1:0] a;
input signed [4*bw-1:0] b;
input signed [psum_bw-1:0] c;
output signed [psum_bw-1:0] out;



wire signed [bw:0] a_1, a_2, a_3, a_4;
wire signed [bw:0] b_1, b_2, b_3, b_4;
wire signed [2*bw-1:0] prod_1, prod_2, prod_3, prod_4;


assign a_1 = a[bw-1:0];
assign a_2 = a[2*bw-1:0];
assign a_3 = a[3*bw-1:0];
assign a_4 = a[4*bw-1:0];

assign b_1 = b[bw-1:0];
assign b_2 = b[2*bw-1:0];
assign b_3 = b[3*bw-1:0];
assign b_4 = b[4*bw-1:0];

wire signed [2*bw:0] add_1;
wire signed [2*bw:0] add_2;

assign add_1 = (a_1 * b_1) + (a_2 * b_2);
assign add_2 = (a_3 * b_3) + (a_4 * b_4);


assign out = add_1 + add_2 + c;


endmodule

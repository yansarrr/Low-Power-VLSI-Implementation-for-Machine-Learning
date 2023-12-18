// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module mac_array (clk, reset, out_s, in_w, in_n, inst_w, valid);

  parameter bw = 4;
  parameter psum_bw = 16;
  parameter col = 8;
  parameter row = 8;

  input  clk, reset;
  output [psum_bw*col-1:0] out_s;
  input  [row*bw-1:0] in_w; // inst[1]:execute, inst[0]: kernel loading
  input  [1:0] inst_w;
  input  [psum_bw*col-1:0] in_n;
  output [col-1:0] valid;

  //passing var
  wire [psum_bw*(row+1)*col-1:0] psum_1;
  assign psum_1[0+:col*psum_bw] = in_n;
  reg [2*row-1:0] inst_w_1;
  assign out_s = psum_1[col*psum_bw*row+:psum_bw*col];
  wire [row * col-1:0] valid_1;
  assign valid = valid_1[col*(row-1)+:col];

  
  
  genvar i;
  integer j;
  for (i=1; i < row+1 ; i=i+1) begin : row_num
      mac_row #(.bw(bw), .psum_bw(psum_bw)) mac_row_instance (
	 .clk(clk),
         .reset(reset),
	 .in_w(in_w[bw*(i-1)+:bw]),
	 .inst_w(inst_w_1[(i-1)*2+:2]),
	 .in_n(psum_1[col*psum_bw*(i-1)+:col*psum_bw]),
	 .out_s(psum_1[col*psum_bw*i+:col*psum_bw]),
	 .valid(valid_1[col*(i-1)+:col]));
  end


  always @ (posedge clk) begin
	  inst_w_1[0+:2] <= inst_w;
	  for (j=1; j<1+row; j=j+1) begin
		  inst_w_1[2*j+:2] <= inst_w_1[(j-1)*2+:2];
	  end


   // inst_w flows to row0 to row7
 
  end



endmodule

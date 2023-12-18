// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 


module mac_tb;

parameter bw = 4;
parameter psum_bw = 16;

reg clk = 0;

reg  [4*bw-1:0] a;
reg  [4*bw-1:0] b;
reg  [psum_bw-1:0] c;
wire [psum_bw-1:0] out;
reg  [psum_bw-1:0] expected_out = 0;

integer w_file ; // file handler
integer w_scan_file ; // file handler

integer x_file ; // file handler
integer x_scan_file ; // file handler

integer x_dec;
integer w_dec;
integer i; 
integer j;
integer u; 
integer x[3:0];
integer w[3:0];

function [3:0] w_bin;
  input integer  weight ;
  begin

    if (weight>-1)
     w_bin[3] = 0;
    else begin
     w_bin[3] = 1;
     weight = weight + 8;
    end

    if (weight>3) begin
     w_bin[2] = 1;
     weight = weight - 4;
    end
    else 
     w_bin[2] = 0;

    if (weight>1) begin
     w_bin[1] = 1;
     weight = weight - 2;
    end
    else 
     w_bin[1] = 0;

    if (weight>0) 
     w_bin[0] = 1;
    else 
     w_bin[0] = 0;

  end
endfunction



function [3:0] x_bin ;
	input integer x;
	begin
		if (x > 7) begin
			x_bin[3] = 1;
			x = x - 8;
		end
		else begin
			x_bin[3] = 0;
		end
		if (x > 3) begin
			x_bin[2] = 1;
			x = x - 4;
		end
		else begin
			x_bin[2] = 0;
		end
		if (x > 1) begin
			x_bin[1] = 1;
			x = x - 2;
		end
		else begin
			x_bin[1] = 0;
		end
		if (x > 0) begin
			x_bin[0] = 1;
		end
		else begin
			x_bin[0] = 0;
		end
	end



endfunction


// Below function is for verification
function [psum_bw-1:0] mac_predicted;
	input unsigned [4*bw-1:0] a;
	input signed [4*bw-1:0] b;
	input signed [psum_bw-1:0] c;
	reg signed [bw:0] a_1, a_2, a_3, a_4;
	reg signed [bw-1:0] b_1, b_2, b_3, b_4;
	reg signed [2*bw-1:0] prod_1, prod_2, prod_3, prod_4;

	reg signed [2*bw:0] add_1, add_2;


	begin
		a_1 = a[bw-1:0];
		a_2 = a[2*bw-1:0];
		a_3 = a[3*bw-1:0];
		a_4 = a[4*bw-1:0];

		b_1 = b[bw-1:0];
		b_2 = b[2*bw-1:0];
		b_3 = b[3*bw-1:0];
		b_4 = b[4*bw-1:0];


		add_1 = (a_1 * b_1) + (a_2 * b_2);
		add_2 = (a_3 * b_3) + (a_4 * b_4);


		mac_predicted = add_1 + add_2 + c;

	end
  

endfunction



mac_wrapper #(.bw(bw), .psum_bw(psum_bw)) mac_wrapper_instance (
	.clk(clk), 
        .a(a), 
        .b(b),
        .c(c),
	.out(out)
); 
 

initial begin 

  w_file = $fopen("b_data.txt", "r");  //weight data
  x_file = $fopen("a_data.txt", "r");  //activation

  $dumpfile("mac_tb.vcd");
  $dumpvars(0,mac_tb);
 
  #1 clk = 1'b0;  
  #1 clk = 1'b1;  
  #1 clk = 1'b0;

  $display("-------------------- Computation start --------------------");
  

  for (i=0; i<5; i=i+1) begin  // Data lenght is 10 in the data files

     #1 clk = 1'b1;
     #1 clk = 1'b0;

     for (j=0; j<4; j=j+1) begin
	     w_scan_file = $fscanf(w_file, "%d\n", w[j]);
	     x_scan_file = $fscanf(x_file, "%d\n", x[j]);
	end

     a = {x_bin(x[0]), x_bin(x[1]), x_bin(x[2]), x_bin(x[3])}; // unsigned numbe
     b = {w_bin(w[0]), w_bin(w[1]), w_bin(w[2]), w_bin(w[3])}; 
    
     c = expected_out;

     expected_out = mac_predicted(a, b, c);

  end



  #1 clk = 1'b1;
  #1 clk = 1'b0;

  $display("-------------------- Computation completed --------------------");

  #10 $finish;


end

endmodule





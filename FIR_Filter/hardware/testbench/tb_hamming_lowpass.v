`timescale 1ps/1ps
`define T_CLK 10

module tb_hamming_lowpass();


reg clk, n_rst;
reg[7:0] xn;
reg [7:0] xn_mem[0:1499]; 
reg [10:0] r_addr;
wire[7:0] yn;

always #5 clk = ~clk;
initial begin
	clk = 1'b0;
	n_rst = 1'b0;
	#7 n_rst = 1'b1;
end

integer i;

initial $readmemh("../tb/xn_data1.txt",xn_mem);

initial begin
	r_addr = 11'h0; 
	wait(n_rst==1'b1);

	for (i = 0; i<1500;i=i+1) begin
		xn = xn_mem[r_addr]; 
		#(`T_CLK*1) r_addr = r_addr + 11'h1; 
	end
	#(`T_CLK*10) $finish;

end

initial begin
	$fsdbDumpfile("test.fsdb");
	$fsdbDumpvars(0);
end

hamming_lowpass u_hamming_lowpass(
	.clk(clk),
	.n_rst(n_rst),
	.xn(xn),
	.yn(yn)
);

endmodule


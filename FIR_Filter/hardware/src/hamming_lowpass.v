`timescale 1ps/1ps

module hamming_lowpass(
	clk,
	n_rst,
	xn,
	yn
);

input clk;
input n_rst;
input[7:0] xn;

output reg signed[7:0] yn; 

reg signed[7:0] x0;
reg signed[7:0] x1;
reg signed[7:0] x2;
reg signed[7:0] x3;
reg signed[7:0] x4;
reg signed[7:0] x5;
reg signed[7:0] x6;
reg signed[7:0] x7;
reg signed[7:0] x8;
reg signed[7:0] x9;
reg signed[7:0] x10;
reg signed[7:0] x11;
reg signed[7:0] x12;
reg signed[7:0] x13;
reg signed[7:0] x14;
reg signed[7:0] x15;
reg signed[7:0] x16;
reg signed[7:0] x17;
reg signed[7:0] x18;

always@(posedge clk or negedge n_rst)begin
	if (!n_rst) begin
		x0 <=  8'h0;
		x1 <=  8'h0;
		x2 <=  8'h0;
		x3 <=  8'h0;
		x4 <=  8'h0;
		x5 <=  8'h0;
		x6 <=  8'h0;
		x7 <=  8'h0;
		x8 <=  8'h0;
		x9 <=  8'h0;
		x10 <= 8'h0;
		x11 <= 8'h0;
		x12 <= 8'h0;
		x13 <= 8'h0;
		x14 <= 8'h0;
		x15 <= 8'h0;
		x16 <= 8'h0;
		x17 <= 8'h0;
		x18 <= 8'h0;
	end     

	else begin
		x0 <= xn;
		x1 <= x0;
		x2 <= x1;
		x3 <= x2;
		x4 <= x3;
		x5 <= x4;
		x6 <= x5;
		x7 <= x6;
		x8 <= x7;
		x9 <= x8;
		x10 <= x9;
		x11 <= x10;
		x12 <= x11;
		x13 <= x12;
		x14 <= x13;
		x15 <= x14;
		x16 <= x15;
		x17 <= x16;
		x18 <= x17;
	end
end


wire signed[7:0] h0;
wire signed[7:0] h1;
wire signed[7:0] h2;
wire signed[7:0] h3;
wire signed[7:0] h4;
wire signed[7:0] h5;
wire signed[7:0] h6;
wire signed[7:0] h7;
wire signed[7:0] h8;
wire signed[7:0] h9;

assign h0 = 8'hA;
assign h1 = 8'h0;
assign h2 = 8'hF2;
assign h3 = 8'hE8;
assign h4 = 8'hEB;
assign h5 = 8'h0;
assign h6 = 8'h25;
assign h7 = 8'h50;
assign h8 = 8'h72;
assign h9 = 8'h7F;

reg signed[8:0] x_add0, x_add1, x_add2, x_add3, x_add4, x_add5, x_add6, x_add7, x_add8, x_add9;

always@(*)begin
		x_add0 = xn + x18;
		x_add1 = x0 + x17;
		x_add2 = x1 + x16;
		x_add3 = x2 + x15;
		x_add4 = x3 + x14;
		x_add5 = x4 + x13;
		x_add6 = x5 + x12;
		x_add7 = x6 + x11;
		x_add8 = x7 + x10;
		x_add9 = x8 + x9;
end

reg signed[16:0] mul0, mul1, mul2, mul3, mul4, mul5, mul6, mul7, mul8, mul9;
reg signed[17:0] result;

always@(*)begin
	mul0 = x_add0 * h0;
	mul1 = x_add1 * h1;
	mul2 = x_add2 * h2;
	mul3 = x_add3 * h3;
	mul4 = x_add4 * h4;
	mul5 = x_add5 * h5;
	mul6 = x_add6 * h6;
	mul7 = x_add7 * h7;
	mul8 = x_add8 * h8;
	mul9 = x_add9 * h9;
end

always@(*)begin
	result = mul0 + mul1 + mul2 + mul3 + mul4 + mul5 + mul6 + mul7 + mul8 + mul9; 
end

reg signed[7:0] result_cp;

always@(*)begin
	if (result > 18'sh007f && result[17] == 1'b1) begin
		result_cp = 8'sh7f;
	end
	else if(result < 18'sb11_1111_1111_1000_0000 && result[17] != 1'b1) begin
		result_cp = 8'sh80;
	end
	else begin
		result_cp = {result[17],result[16:10]};
	end
end

always@(posedge clk or negedge n_rst) begin
	if(!n_rst) begin
		yn <= 8'h0;
	end
	else begin
		yn <= result_cp;
	end
end

endmodule

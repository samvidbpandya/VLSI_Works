`timescale 1ns/10ps

//1 bit fulladder
module FA(sum_fa, cout_fa, op1_fa, op2_fa, cin);
output sum_fa, cout_fa;
input op1_fa, op2_fa, cin;

assign sum_fa = op1_fa ^ op2_fa ^ cin;
assign cout_fa = ((op1_fa ^ op2_fa) & cin) | (op1_fa & op2_fa);

endmodule

//4 bit CSA
module CSA4(sum_4, cout_4, op1_4, op2_4, cin_4);
output [3:0]sum_4;
output cout_4;
input [3:0]op1_4,op2_4;
input cin_4;
wire [3:0]sum0,sum1;
wire cout0, cout1;
wire c1, c2, c3, c4, c5, c6;
//sum for carry 0

FA f1(.sum_fa(sum0[0]), .cout_fa(c1), .op1_fa(op1_4[0]), .op2_fa(op2_4[0]), .cin(1'b0));
FA f2(.sum_fa(sum0[1]), .cout_fa(c2), .op1_fa(op1_4[1]), .op2_fa(op2_4[1]), .cin(c1));
FA f3(.sum_fa(sum0[2]), .cout_fa(c3), .op1_fa(op1_4[2]), .op2_fa(op2_4[2]), .cin(c2));
FA f4(.sum_fa(sum0[3]), .cout_fa(cout0), .op1_fa(op1_4[3]), .op2_fa(op2_4[3]), .cin(c3));

//sum for carry 1

FA f5(.sum_fa(sum1[0]), .cout_fa(c4), .op1_fa(op1_4[0]), .op2_fa(op2_4[0]), .cin(1'b1));
FA f6(.sum_fa(sum1[1]), .cout_fa(c5), .op1_fa(op1_4[1]), .op2_fa(op2_4[1]), .cin(c4));
FA f7(.sum_fa(sum1[2]), .cout_fa(c6), .op1_fa(op1_4[2]), .op2_fa(op2_4[2]), .cin(c5));
FA f8(.sum_fa(sum1[3]), .cout_fa(cout1), .op1_fa(op1_4[3]), .op2_fa(op2_4[3]), .cin(c6));

mux_sum m1(.sum(sum_4), .sum0(sum0), .sum1(sum1), .Cin(cin_4));
mux_carry m2(.cout(cout_4), .cout0(cout0), .cout1(cout1), .Cin(cin_4));

endmodule

//64 bit CSA

module CSA64EQG(sum, crout, op1, op2, clock, reset);
output [63:0]sum;
output crout;
input [63:0]op1;
input [63:0]op2;
input clock, reset;
reg [63:0]sum;
reg crout;
reg [63:0]op1f;
reg [63:0]op2f;
wire [63:0]sumf;
wire C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15, croutf;

assign CIN = 0;

CSA4 s1(.sum_4(sumf[3:0]), .cout_4(C1), .op1_4(op1f[3:0]), .op2_4(op2f[3:0]), .cin_4(CIN));
CSA4 s2(.sum_4(sumf[7:4]), .cout_4(C2), .op1_4(op1f[7:4]), .op2_4(op2f[7:4]), .cin_4(C1));
CSA4 s3(.sum_4(sumf[11:8]), .cout_4(C3), .op1_4(op1f[11:8]), .op2_4(op2f[11:8]), .cin_4(C2));
CSA4 s4(.sum_4(sumf[15:12]), .cout_4(C4), .op1_4(op1f[15:12]), .op2_4(op2f[15:12]), .cin_4(C3));
CSA4 s5(.sum_4(sumf[19:16]), .cout_4(C5), .op1_4(op1f[19:16]), .op2_4(op2f[19:16]), .cin_4(C4));
CSA4 s6(.sum_4(sumf[23:20]), .cout_4(C6), .op1_4(op1f[23:20]), .op2_4(op2f[23:20]), .cin_4(C5));
CSA4 s7(.sum_4(sumf[27:24]), .cout_4(C7), .op1_4(op1f[27:24]), .op2_4(op2f[27:24]), .cin_4(C6));
CSA4 s8(.sum_4(sumf[31:28]), .cout_4(C8), .op1_4(op1f[31:28]), .op2_4(op2f[31:28]), .cin_4(C7));
CSA4 s9(.sum_4(sumf[35:32]), .cout_4(C9), .op1_4(op1f[35:32]), .op2_4(op2f[35:32]), .cin_4(C8));
CSA4 s10(.sum_4(sumf[39:36]), .cout_4(C10), .op1_4(op1f[39:36]), .op2_4(op2f[39:36]), .cin_4(C9));
CSA4 s11(.sum_4(sumf[43:40]), .cout_4(C11), .op1_4(op1f[43:40]), .op2_4(op2f[43:40]), .cin_4(C10));
CSA4 s12(.sum_4(sumf[47:44]), .cout_4(C12), .op1_4(op1f[47:44]), .op2_4(op2f[47:44]), .cin_4(C11));
CSA4 s13(.sum_4(sumf[51:48]), .cout_4(C13), .op1_4(op1f[51:48]), .op2_4(op2f[51:48]), .cin_4(C12));
CSA4 s14(.sum_4(sumf[55:52]), .cout_4(C14), .op1_4(op1f[55:52]), .op2_4(op2f[55:52]), .cin_4(C13));
CSA4 s15(.sum_4(sumf[59:56]), .cout_4(C15), .op1_4(op1f[59:56]), .op2_4(op2f[59:56]), .cin_4(C14));
CSA4 s16(.sum_4(sumf[63:60]), .cout_4(croutf), .op1_4(op1f[63:60]), .op2_4(op2f[63:60]), .cin_4(C15));

always @(posedge clock or posedge reset)
begin
if(reset == 1)
begin
op1f <= 64'b0;
op2f <= 64'b0;
sum <= 64'b0;
crout <= 64'b0;
end

else 
begin 
op1f <= op1;
$display ("op1f= %h",op1f);
op2f <= op2;
$display ("op2f= %h",op2f);
sum <= sumf;
$display ("sumf= %h",sumf);
crout <= croutf;
$display ("op1f= %h",croutf);
end
end
endmodule



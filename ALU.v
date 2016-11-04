`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// 
// ## Date: October 29, 2016 
// ## main_ALU.v - This is the main module file. Various modules present are:
//																									1.	takeand    - for bitwise AND operation
//																									2.	takexor    - for bitwise XOR operation
//																									3.	adder      - for ripple carry adder
//																									4.	fulladd    - as a utility for adder module
//																									5.	multiplier - for implementing Booth's Algorithm for multiplicatiom
//																									6.	sec_adder  - as a utility for addition in multiplier module
// 
////////////////////////////////////////////////////////////////////////////////

module main_ALU(
		input[1:0]  		OPCode,
		input					clock,
		input[7:0]			A,
		input[7:0]			B,
		output reg[7:0]	Y,
		output reg[7:0]	Z,
		output      		O,
		output				C
	);
	assign C=0;
	wire[7:0] Y_adder;
	wire Cin=0;
	wire c;
	adder s1(A,B,Cin,Y_adder,c);
	assign O=(((~A[7])&(~B[7])&Y_adder[7])|(A[7]&B[7]&(~Y_adder[7])));
	
	wire[7:0] Y_xor;
	takexor xor1(Y_xor,A,B);
	
	wire[7:0] Y_and;
	takeand and1(Y_and,A,B);
	
	reg[7:0] Y_mult;
	reg[7:0] Z_mult;
	wire[7:0]Y_mult_w;
	wire[7:0]Z_mult_w;
	multiplier m1(clock,A,B,Y_mult_w,Z_mult_w);
	
	always @(posedge clock) begin
			if(OPCode==2'b00) begin
					if(O==1'b1) begin
							Y=8'b00000000;
					end else begin
							Y=Y_adder;
					end
			end else if(OPCode==2'b01) begin
					Y=Y_and;
			end else if(OPCode==2'b10) begin
					Y=Y_xor;
			end else if(OPCode==2'b11) begin
					Y=Y_mult_w;
					Z=Z_mult_w;
			end
	end
	
endmodule

module takeand(
		output[7:0] Y,
		input[7:0]  A,
		input[7:0]  B
	);
	and(Y[0],A[0],B[0]);
	and(Y[1],A[1],B[1]);
	and(Y[2],A[2],B[2]);
	and(Y[3],A[3],B[3]);
	and(Y[4],A[4],B[4]);
	and(Y[5],A[5],B[5]);
	and(Y[6],A[6],B[6]);
	and(Y[7],A[7],B[7]);
	
endmodule

module takexor(
		output[7:0] Y,
		input[7:0]  A,
		input[7:0]  B
	);
	xor(Y[0],A[0],B[0]);
	xor(Y[1],A[1],B[1]);
	xor(Y[2],A[2],B[2]);
	xor(Y[3],A[3],B[3]);
	xor(Y[4],A[4],B[4]);
	xor(Y[5],A[5],B[5]);
	xor(Y[6],A[6],B[6]);
	xor(Y[7],A[7],B[7]);
endmodule

module adder(
		input [07:0] 	a,
		input [07:0] 	b,
		input 			cin,
		output [7:0]	sum,
		output 			cout
	);
		wire[6:0] c;
				fulladd a1(a[0],b[0],cin,sum[0],c[0]);
				fulladd a2(a[1],b[1],c[0],sum[1],c[1]);
				fulladd a3(a[2],b[2],c[1],sum[2],c[2]);
				fulladd a4(a[3],b[3],c[2],sum[3],c[3]);
				fulladd a5(a[4],b[4],c[3],sum[4],c[4]);
				fulladd a6(a[5],b[5],c[4],sum[5],c[5]);
				fulladd a7(a[6],b[6],c[5],sum[6],c[6]);
				fulladd a8(a[7],b[7],c[6],sum[7],cout);
endmodule

module fulladd(
		input a,
		input b,
		input cin,
		output sum,
		output cout
	);
		assign sum=(a^b^cin);
		assign cout=((a&b)|(b&cin)|(a&cin));
endmodule

module multiplier(
		input					clock,
		input[7:0] 			N,
		input[7:0] 			B,
		output[7:0] 	Y_mult,
		output[7:0] 	Z_mult
	);
		reg[7:0] A=8'b00000000;
		reg[7:0] Q;
		reg[7:0] M;
		reg 		Q_1=1'b0;
		reg[3:0] count=4'b0000;
		reg[7:0] temp;
		wire [7:0] sum, difference;
		reg start=1'b1;
		
		always @(posedge clock) begin
				 if (start) begin
						 A <= 8'b0;
						 M <= N;
						 Q <= B;
						 Q_1 <= 1'b0;
						 count <= 4'b0;
						 start=1'b0;
				 end
				 else if(count<8) begin
						 case ({Q[0], Q_1})
						 2'b0_1 : {A, Q, Q_1} <= {sum[7], sum, Q};
						 2'b1_0 : {A, Q, Q_1} <= {difference[7], difference, Q};
						 default: {A, Q, Q_1} <= {A[7], A, Q};
				 endcase
				 count <= count + 1'b1;
				 end
				 else begin
						#100;start=1'b1;
				 end
		end

		sec_adder adder (sum, A, M, 1'b0);
		sec_adder subtracter (difference, A, ~M, 1'b1);
		assign Y_mult = Q;
		assign Z_mult = A;

	
endmodule

module sec_adder(out, a, b, cin);
	output [7:0] 	out;
	input [7:0] 	a;
	input [7:0] 	b;
	input cin;
	assign out = a + b + cin;
endmodule

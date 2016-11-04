`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Engineer: AKASH GUPTA
//
// Create Date:   15:03:40 11/04/2016
// Design Name:   main_ALU
// Module Name:   E:/Xilinx/ALU/ALU_testBench.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: main_ALU
//
// 
// Revision:
// Revision 0.01 - File Created
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_testBench;

	// Inputs
	reg [1:0] OPCode;
	reg clock;
	reg [7:0] A;
	reg [7:0] B;

	// Outputs
	wire [7:0] Y;
	wire [7:0] Z;
	wire O;
	wire C;

	// Instantiate the Unit Under Test (UUT)
	main_ALU uut (
		.OPCode(OPCode), 
		.clock(clock), 
		.A(A), 
		.B(B), 
		.Y(Y), 
		.Z(Z), 
		.O(O), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		OPCode = 0;
		clock = 0;
		A = 0;
		B = 0;

		// Wait 100 ns for global reset to finish
		#10;
				OPCode=2'b00; A=8'b00010011; B=8'b00101100;
		#10	OPCode=2'b00; A=8'b01111111; B=8'b00000101;
		#10	OPCode=2'b01; A=8'b01111111; B=8'b00000001;
		#10	OPCode=2'b10; A=8'b01111111; B=8'b00000001;
		#10	OPCode=2'b11; A=8'b00000100; B=8'b00000011;
		#250	OPCode=2'b11; A=8'b01111111; B=8'b00001000;
		// Add stimulus here

	end
			always begin
					#5 clock = ~clock;
			end
      
endmodule


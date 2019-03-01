`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:07:29 08/01/2018 
// Design Name: 
// Module Name:    hdr_ram 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Header_RAM2( input [7:0] Address,
input [7:0] data_in1,
input [7:0] data_in2,
input [7:0] data_in3,
input [7:0] data_in4,
input [7:0] data_in5,
input [7:0] data_in6,
input [7:0] data_in7,
input [7:0] data_in8,
input rd_en, 
//input rd_clk,
output reg [7:0] data_out
    );
reg [7:0] Mem [49:0];

initial begin
Mem[0]=8'h00; // Destination MAC
Mem[1]=8'h1C;
Mem[2]=8'hC0;
Mem[3]=8'h98;
Mem[4]=8'h6D;
Mem[5]=8'h10; 
Mem[6]=8'h00; // Source MAC
Mem[7]=8'h11;
Mem[8]=8'h22;
Mem[9]=8'h33;
Mem[10]=8'h44;
Mem[11]=8'h55; //end of source MAC
Mem[12]=8'h08;
Mem[13]=8'h00;
Mem[14]=8'h45;
Mem[15]=8'h00;
Mem[16]=8'h04;
Mem[17]=8'h32;
Mem[18]=8'h00;
Mem[19]=8'h00;
Mem[20]=8'h40;
Mem[21]=8'h00;
Mem[22]=8'h40;
Mem[23]=8'h11;
Mem[24]=8'h2E;
Mem[25]=8'hAA;
Mem[26]=8'h01;
Mem[27]=8'h02;
Mem[28]=8'h03;
Mem[29]=8'h05;
Mem[30]=8'h01;
Mem[31]=8'h02;
Mem[32]=8'h03;
Mem[33]=8'h09;
Mem[34]=8'hd6;
Mem[35]=8'hd8;
Mem[36]=8'hd6;
Mem[37]=8'hd9;
Mem[38]=8'h04;
Mem[39]=8'h10;
Mem[40]=8'h00;
Mem[41]=8'h00;
Mem[42]=8'h00;
Mem[43]=8'h00;
Mem[44]=8'h00;
Mem[45]=8'h00;
Mem[46]=8'h00;
Mem[47]=8'h00;
Mem[48]=8'h00;
Mem[49]=8'h00;
end

always @*
begin
Mem[42]=data_in1;
Mem[43]=data_in2;
Mem[44]=data_in3;
Mem[45]=data_in4;
Mem[46]=data_in5;
Mem[47]=data_in6;
Mem[48]=data_in7;
Mem[49]=data_in8;
end


always @(Address) begin
if(rd_en) begin
	data_out=Mem[Address];
end 
end
endmodule

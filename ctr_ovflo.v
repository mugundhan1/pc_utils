`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:30:44 07/20/2018 
// Design Name: 
// Module Name:    ctr_ovflo 
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
module ctr_ovflo( input clk, en,
output reg [2:0] count=0,
output reg ovflo
    );

always @ (posedge clk)
begin
	if (en)
	begin	count<=count+1;
	end
end

always @(count)
begin
if (count==3'b111)
	ovflo=1;
else
	ovflo=0;
end

endmodule

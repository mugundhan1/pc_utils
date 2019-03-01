`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:19:32 08/01/2018 
// Design Name: 
// Module Name:    pkt_ctr 
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
module fr_ctr_new( input clk, input sig,
output [7:0] cnt1, cnt2, cnt3, cnt4
    );

reg [31:0] count=0;

fe_det det1 (
    .sig(sig), 
    .clk(clk), 
    .pulse(pulse)
    );


always@(posedge clk)
begin
	if (pulse)
		count<=count+1;
end

assign cnt1=count[7:0];
assign cnt2=count[15:8];
assign cnt3=count[23:16];
assign cnt4=count[31:24];
endmodule

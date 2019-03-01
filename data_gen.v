`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:16:30 08/01/2018 
// Design Name: 
// Module Name:    data_gen 
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
module data_gen(input clk,
//input en,
output fifo_wr_en,
output [7:0] data
    );

reg [16:0] count=0;
reg [7:0] data_int=0;
reg fifo_wr_en_int=0;

always@(posedge clk)
//begin if(en)
		begin
			count<=count+1;
		end
//end

always@(posedge clk)
//begin if(en)
	begin
		if (count<1024)
		begin
			data_int<=data_int+1;
			fifo_wr_en_int<=1;
		end	
		else
		begin
			data_int<=0;
			fifo_wr_en_int<=0;
		end
	end
//end

assign fifo_wr_en=fifo_wr_en_int;
assign data=data_int;

endmodule

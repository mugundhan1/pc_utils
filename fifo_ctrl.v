`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:29:23 08/01/2018 
// Design Name: 
// Module Name:    fifo_ctrl 
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
module fifo_ctrl(input clk125MHz,
input prog_full,
output reg sofn=1,
output reg eofn=1,
output reg src_rdyn=1,
output reg fifo_rd_en=0,
output reg h_en=0,
output reg [7:0] hdr_addr=0
    );

parameter hdrsize=49;
parameter datalen=1024;
reg [15:0]count=0;

always@(posedge clk125MHz)
begin
if (prog_full & (count==0))
	begin
		src_rdyn<=0;
		sofn<=0;
		//fifo_rd_en<=1;
		h_en<=1;
	end
if (src_rdyn==0)
	begin
		count<=count+1;
	if (h_en)
		begin
			hdr_addr<=hdr_addr+1;
		end
		else begin
			hdr_addr<=0; end
	if (count==0)
		begin
			sofn<=1;
		end
	if (count==hdrsize)
		begin
			h_en<=0;
			fifo_rd_en<=1;
		end
	if (count==datalen+hdrsize-1)
		begin
			eofn<=0;
		end
	if (count==datalen+hdrsize)
		begin
			eofn<=1;
			src_rdyn<=1;
			count<=0;
			fifo_rd_en<=0;
		end
	end
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:28:38 02/26/2018 
// Design Name: 
// Module Name:    pulse_disc 
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
module pulse_disc( input pd_pulse, clk,
output pulse_out
    );

//reg pre=0;
//reg pfe=0;
wire pre,pfe,lfe;
reg en=0;
reg rst=0;
reg latch=0;
reg [4:0] count=0;
reg [4:0] preg=0;


fe_det fe1 (
    .sig(pd_pulse), 
    .clk(clk), 
    .pulse(pfe)
    );

re_det re1 (
    .sig(pd_pulse), 
    .clk(clk), 
    .pulse(pre)
    );

fe_det latch_fe(
	.sig(latch),
	.clk(clk),
	.pulse(lfe)
	);
	 
always@(posedge clk)
begin
	if (pre)
		en<=1;
	if (en)
		count<=count+1;
	if (pfe)
	begin	
		rst<=1;
		latch<=1;
		en<=0;
	end
	if (latch)
	begin	
		preg<=count;
		latch<=0;
	end	
	if (rst)
	begin
		count<=0;
		rst<=0;
	end
end

assign pulse_out= lfe & (preg>4);
	 
	 
endmodule

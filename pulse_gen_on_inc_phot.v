`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2019 11:38:16
// Design Name: 
// Module Name: pulse_gen_on_inc_phot
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pulse_gen_on_inc_phot( input clk,
                              input phot_in,
                              input [31:0] pulse_width, //in clocks
                              output pulse
    );
    
reg [31:0] pul_width_counter=0;
wire pulse_int;
reg en=0;
reg pul_int=0;

re_det re_det1(.sig(phot_in),.clk(clk),.pulse(pulse_int));

always @(posedge clk)
begin
if (pulse_int & (pul_width_counter==0))
begin
    en<=1;    
end
if (en)
begin
    pul_width_counter<=pul_width_counter+1;
    if (pul_width_counter<pulse_width)
    begin pul_int<=1; end
    if (pul_width_counter==pulse_width)
    begin
        pul_int<=0;
        pul_width_counter<=0;
        en<=0;
    end
end
end

assign pulse = pul_int;

endmodule

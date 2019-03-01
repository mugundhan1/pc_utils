`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:50:58 02/26/2018 
// Design Name: 
// Module Name:    fe_det 
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
module fe_det(input sig,
input clk,
output pulse
    );

reg sig_del;
reg sig_2del;

always@(posedge clk)
begin	
	sig_del<=sig;
	sig_2del<=sig_del;
end	

assign pulse= !sig_del & sig_2del;
	
endmodule 
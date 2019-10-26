`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2019 14:57:12
// Design Name: 
// Module Name: tx_cntrl
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


module tx_cntrl ( input clk,
                  output reset,
                  output [15:0] tx_data,
                  output dv
                  );

reg [20:0] cntr=0;
reg dv_reg=0;
reg spi_rst=1;
reg [15:0] tx_data_reg;

always @ (posedge clk)
begin
    cntr<=cntr+1;
    if (cntr == 0)
        spi_rst<=0;
    else
        spi_rst<=1;
    if (cntr == 1937)
    begin    tx_data_reg<=cntr[15:0];
             dv_reg<=1;
    end
    else
    begin
            tx_data_reg<=0;
            dv_reg<=0;
    end
 end
 
 assign tx_data = tx_data_reg;
 assign dv  = dv_reg;
 assign reset = spi_rst;
 
 endmodule
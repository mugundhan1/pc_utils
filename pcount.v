`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:08:08 02/26/2018 
// Design Name: 
// Module Name:    pcount 
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
module pcount( input pulse_in1,pulse_in2,pulse_in3,pulse_in4,clk,en,
output trig,
output reg [7:0] latch_reg=0
    );

wire pulse_out1, pulse_out2, pulse_out3, pulse_out4;
//reg [7:0] latch_reg=0;
wire overflow;
wire [2:0] count;

pulse_disc pd1 (
    .pd_pulse(pulse_in1), 
    .clk(clk), 
    .pulse_out(pulse_out1)
    );

pulse_disc pd2 (
    .pd_pulse(pulse_in2), 
    .clk(clk), 
    .pulse_out(pulse_out2)
    );

pulse_disc pd3 (
    .pd_pulse(pulse_in3), 
    .clk(clk), 
    .pulse_out(pulse_out3)
    );

pulse_disc pd4 (
    .pd_pulse(pulse_in4), 
    .clk(clk), 
    .pulse_out(pulse_out4)
    );


ctr_ovflo ctr1 (
    .clk(clk), 
    .en(en), 
    .count(count), 
    .ovflo(overflow)
    );

assign trig=pulse_out1 | pulse_out2 | pulse_out3 | pulse_out4 | overflow;

always @(trig)
begin
latch_reg<={overflow,count,pulse_out1,pulse_out2,pulse_out3,pulse_out4};
end


endmodule

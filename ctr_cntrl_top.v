`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:09:51 08/01/2018 
// Design Name: 
// Module Name:    ctr_cntrl_top 
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
module spad_acq_module( 
input ch1_p, ch1_n, ch2_p, ch2_n, ch3_p, ch3_n, ch4_p, ch4_n,
input clk_p, clk_n,
output TXP_0,TXN_0,
input RXP_0,RXN_0,
input MGTCLK_N, MGTCLK_P,
input RESET,
output locked,
output eth_tx_led   );

wire clk;
wire [7:0] data;
wire wr_en;
wire rd_en;
wire [7:0] fifo_data_out;
wire prog_full;
wire sofn,eofn,src_rdyn;
wire trig;
wire [7:0] latch_reg;

IBUFDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("LVDS_25")) Ch1_ibufds(.O(ch1_int),.I(ch1_p),.IB(ch1_n));
IBUFDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("LVDS_25")) Ch2_ibufds(.O(ch2_int),.I(ch2_p),.IB(ch2_n));
IBUFDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("LVDS_25")) Ch3_ibufds(.O(ch3_int),.I(ch3_p),.IB(ch3_n));
IBUFDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("LVDS_25")) Ch4_ibufds(.O(ch4_int),.I(ch4_p),.IB(ch4_n));

clkgen clk1 (
    .CLKIN_N_IN(clk_n), 
    .CLKIN_P_IN(clk_p), 
    .RST_IN(), 
    .CLKIN_IBUFGDS_OUT(), 
    .CLKOUT0_OUT(clk), 
    .LOCKED_OUT(locked)
    );

pcount pcnt1 (
    .pulse_in1(~(ch1_int)), 
    .pulse_in2(~(ch2_int)), 
    .pulse_in3(~(ch3_int)), 
    .pulse_in4(~(ch4_int)), 
    .clk(clk), 
    .en(locked), 
    .trig(trig), 
    .latch_reg(latch_reg)
    );
//data_gen ctr (
//    .clk(clk), 
//    //.en(locked), 
//    .fifo_wr_en(wr_en), 
//    .data(data)
//    );



wire rst;
assign rst= ~RESET;
	 
data_fifo fifo (
  .rst(rst), // input rst
  .wr_clk(clk), // input wr_clk
  .rd_clk(clk125MHz), // input rd_clk
  .din(latch_reg), // input [7 : 0] din
  .wr_en(trig), // input wr_en
  .rd_en(fifo_rd_en), // input rd_en
  .dout(fifo_data_out), // output [7 : 0] dout
  .full(full), // output full
  .empty(empty), // output empty
  .prog_full(prog_full) // output prog_full
);

wire [7:0] hdr_addr;
wire h_en;

fifo_ctrl fctl1 (
    .clk125MHz(clk125MHz), 
    .prog_full(prog_full), 
    .sofn(sofn), 
    .eofn(eofn), 
    .src_rdyn(src_rdyn), 
    .fifo_rd_en(fifo_rd_en), 
    .h_en(h_en), 
    .hdr_addr(hdr_addr)
    );

wire [7:0] cnt1,cnt2,cnt3,cnt4,cnt5,cnt6,cnt7,cnt8;

fr_ctr_new frctr1(
    .clk(clk125MHz), 
    .sig(sofn), 
    .cnt1(cnt1), 
    .cnt2(cnt2), 
    .cnt3(cnt3), 
    .cnt4(cnt4)
    );

fr_ctr_new frctr2(
    .clk(clk125MHz), 
    .sig(eofn), 
    .cnt1(cnt5), 
    .cnt2(cnt6), 
    .cnt3(cnt7), 
    .cnt4(cnt8)
    );
	 
wire [7:0] hdr_data;
	 
Header_RAM2 ram1 (
    .Address(hdr_addr), 
    .data_in1(cnt1), 
    .data_in2(cnt2), 
    .data_in3(cnt3), 
    .data_in4(cnt4), 
    .data_in5(cnt5), 
    .data_in6(cnt6), 
    .data_in7(cnt7), 
    .data_in8(cnt8), 
    .rd_en(h_en), 
    .data_out(hdr_data)
    );

wire [7:0] pkt_data;

assign pkt_data= (h_en==1) ? hdr_data : fifo_data_out;

eth_example_design eth0 (
    .TXP_0(TXP_0), 
    .TXN_0(TXN_0), 
    .RXP_0(RXP_0), 
    .RXN_0(RXN_0), 
    .MGTCLK_N(MGTCLK_N), 
    .MGTCLK_P(MGTCLK_P), 
    .RESET(RESET), 
    .sof_n(sofn), 
    .eof_n(eofn), 
    .src_rdy_n(src_rdyn), 
    .tx_data(pkt_data), 
    .clk125MHz(clk125MHz)
    );

assign eth_tx_led=~(src_rdyn);

endmodule

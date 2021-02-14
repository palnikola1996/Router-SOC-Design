module blck(
input clk,
input reset,            

input tod_ctl,
input [7:0] tod_data,

input re,

output full, empty,

output frm_ctl,
output [7:0] frm_data
);

logic pushin,stopin,firstin,firstout;
logic [63:0] din;
logic [2:0] m1ax,m1ay,m1wx,m1wy,m2ax,m2ay,m2wx,m2wy,m3ax,m3ay,m3wx,m3wy,m4ax,m4ay,m4wx,m4wy;
logic m1wr,m2wr,m3wr,m4wr;
logic [63:0] m1rd,m1wd,m2rd,m2wd,m3rd,m3wd,m4rd,m4wd;


logic pushout;
logic stopout;
logic [63:0] dout;
logic frm_ctl_internal; 
logic [7:0] frm_data_internal;


perm_blk p(clk,reset,pushin,stopin,firstin,din,
    m1ax,m1ay,m1rd,m1wx,m1wy,m1wr,m1wd,
    m2ax,m2ay,m2rd,m2wx,m2wy,m2wr,m2wd,
    m3ax,m3ay,m3rd,m3wx,m3wy,m3wr,m3wd,
    m4ax,m4ay,m4rd,m4wx,m4wy,m4wr,m4wd,
    pushout,stopout,firstout,dout);
    
m55 m1(clk,reset,m1ax,m1ay,m1rd,m1wx,m1wy,m1wr,m1wd);
m55 m2(clk,reset,m2ax,m2ay,m2rd,m2wx,m2wy,m2wr,m2wd);
m55 m3(clk,reset,m3ax,m3ay,m3rd,m3wx,m3wy,m3wr,m3wd);
m55 m4(clk,reset,m4ax,m4ay,m4rd,m4wx,m4wy,m4wr,m4wd);

noc_intf n(clk,reset,
    tod_ctl,tod_data,frm_ctl_internal,frm_data_internal,
    pushin,firstin,stopin,din,pushout,firstout,stopout,dout);

wrapper w(
 .clk(clk),
 .reset(reset),

 .re(re),

 .noc_from_dev_ctl(frm_ctl_internal),
 .noc_from_dev_data(frm_data_internal),
 
 .full(full),
 .empty(empty),

 .from_fifo_to_tb_ctl(frm_ctl),
 .from_fifo_to_tb_data(frm_data)
);

endmodule
`include "perm.sv"
`include "m55.sv"
`include "nochw2.sv"
`include "wrapper.sv"

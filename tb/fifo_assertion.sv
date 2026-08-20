// tb/fifo_assertion.sv
module fifo_assertion #(parameter DEPTH = 8, parameter DATA_WIDTH = 8) (
  input logic clk,
  input logic rst_n,
  input logic wr_en,
  input logic rd_en,
  input logic full,
  input logic empty,

  input logic [$clog2(DEPTH):0] write_ptr,
  input logic [$clog2(DEPTH):0] read_ptr
);

  assert property (
    @(negedge rst_n) ($realtime > 0) |-> (!full & empty) until rst_n
  ) else $error("'full' & 'empty' signals not reseted correctly (@%0t)",
    $realtime);

  assert property (@(posedge clk) disable iff (!rst_n)
    full && wr_en |=> $stable(write_ptr))
  else $error("'write_ptr' moved while full");

  assert property (@(posedge clk) disable iff (!rst_n)
    empty && rd_en |=> $stable(read_ptr))
  else $error("'read_ptr' moved while empty");

endmodule

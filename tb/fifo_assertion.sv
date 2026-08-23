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

  // FIFO is empty during reset (!full, empty)
  sva_empty_on_reset:
    assert property (@(negedge rst_n)
      ($realtime > 0) && !rst_n |-> (!full & empty) until rst_n
    ) else $error("[SVA] 'full' & 'empty' signals not reseted correctly",
    $realtime);

  // write_ptr does not move if write on full ($stable(write_ptr))
  sva_write_on_full:
    assert property (@(posedge clk) disable iff (!rst_n)
      !rd_en && full && wr_en |=> $stable(write_ptr)
    ) else $error("[SVA] 'write_ptr' moved while full");

  // read_ptr does not move if read on empty ($stable(write_ptr))
  sva_read_on_empty:
    assert property (@(posedge clk) disable iff (!rst_n)
      empty && rd_en |=> $stable(read_ptr)
    ) else $error("[SVA] 'read_ptr' moved while empty");

  // if empty and write requested, fifo is not empty anymore
  sva_write_on_empty:
    assert property (@(posedge clk) disable iff (!rst_n)
      empty && wr_en && !rd_en |=> !empty
    ) else $error("[SVA] empty still high after write during empty");

  // if full and read requested, fifo is not full anymore
  sva_read_on_full:
    assert property (@(posedge clk) disable iff (!rst_n)
      full && !wr_en && rd_en |=> !full
    ) else $error("[SVA] Full still high after read during full");

  // if write and read operation while not empty,
  sva_rw_simultaneous_flags:
    assert property (
      @(posedge clk) disable iff (!rst_n)
      (!empty && wr_en && rd_en) |=> $stable(full) && $stable(empty)
    ) else $error("[SVA] Flags changed unexpectedly during simultaneous R/W!");

  // ...
endmodule

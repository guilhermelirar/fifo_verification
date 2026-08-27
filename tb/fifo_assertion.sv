// tb/fifo_assertion.sv
module fifo_assertion #(parameter DEPTH = 8, parameter DATA_WIDTH = 8) (
  sync_fifo_if   fifo_io,
  input logic [$clog2(DEPTH):0] write_ptr,
  input logic [$clog2(DEPTH):0] read_ptr
);

  // FIFO is empty during reset (!fifo_io.full, fifo_io.empty)
  sva_empty_on_reset:
    assert property (@(negedge fifo_io.rst_n)
      ($realtime > 0) && !fifo_io.rst_n |->
        (!fifo_io.full & fifo_io.empty) until fifo_io.rst_n
    ) else $error("[SVA] 'full' & 'empty' signals not reseted correctly",
    $realtime);

  // write_ptr does not move if write on full ($stable(write_ptr))
  sva_write_on_full:
    assert property (@(posedge fifo_io.clk) disable iff (!fifo_io.rst_n)
      !fifo_io.rd_en && fifo_io.full && fifo_io.wr_en |=> $stable(write_ptr)
    ) else $error("[SVA] 'write_ptr' moved while full");

  // read_ptr does not move if read on empty ($stable(write_ptr))
  sva_read_on_empty:
    assert property (@(posedge fifo_io.clk) disable iff (!fifo_io.rst_n)
      fifo_io.empty && fifo_io.rd_en |=> $stable(read_ptr)
    ) else $error("[SVA] 'read_ptr' moved while fifo_io.empty");

  // if empty and write requested, fifo is not empty anymore
  sva_write_on_empty:
    assert property (@(posedge fifo_io.clk) disable iff (!fifo_io.rst_n)
      fifo_io.empty && fifo_io.wr_en && !fifo_io.rd_en |=> !fifo_io.empty
    ) else $error("[SVA] fifo_io.empty still high after write during fifo_io.empty");

  // if full and read requested, fifo is not full anymore
  sva_read_on_full:
    assert property (@(posedge fifo_io.clk) disable iff (!fifo_io.rst_n)
      fifo_io.full && !fifo_io.wr_en && fifo_io.rd_en |=> !fifo_io.full
    ) else $error("[SVA] full still high after read during full");

  // if write and read operation while not empty,
  sva_rw_simultaneous_flags:
    assert property (
      @(posedge fifo_io.clk) disable iff (!fifo_io.rst_n)
      (!fifo_io.empty && fifo_io.wr_en && fifo_io.rd_en) |=>
        $stable(fifo_io.full) && $stable(fifo_io.empty)
    ) else $error("[SVA] Flags changed unexpectedly during simultaneous R/W!");

endmodule

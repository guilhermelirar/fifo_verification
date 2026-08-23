// top.sv
import tb_pkg::*;
module top;
  logic clk = 0;
  sync_fifo_if fifo_io(clk);
  sync_fifo dut(
    .clk(clk),
    .rst_n(fifo_io.rst_n),
    .wr_en(fifo_io.wr_en),
    .rd_en(fifo_io.rd_en),
    .data_in(fifo_io.data_in),
    .data_out(fifo_io.data_out),
    .full(fifo_io.full),
    .empty(fifo_io.empty)
  );

  bind dut fifo_assertion fiscal_inst(.*);

  // TODO test & environment
  Driver drv;
  Generator gnr;
  Monitor mon;
  Scoreboard scbd;

  typedef mailbox #(fifo_transaction) tx_mailbox;
  tx_mailbox gen_mbx, wr_mbx, rd_mbx;

  int run_for_n_txn = 100;

  always begin
    #5 clk = ~clk;
  end

  initial begin
    reset();
    // TODO configure $realtime
    $display("[%m] Initializing test");
    gen_mbx = new();
    wr_mbx = new();
    rd_mbx = new();

    gnr = new(gen_mbx);
    drv = new(fifo_io, gen_mbx);
    mon = new(fifo_io, wr_mbx, rd_mbx);
    scbd = new(wr_mbx, rd_mbx);
    mon.log_enable = 1;

    fork
      gnr.run(run_for_n_txn);
      drv.run();
      mon.run();
      scbd.run();
    join_none

    wait(drv.pkt_count == run_for_n_txn);
    disable fork;
    repeat (5) @(fifo_io.cb);
    reset();
    repeat (5) @(fifo_io.cb);
    $finish();
  end

  task reset();
    fifo_io.rst_n = 1'b0;
    fifo_io.cb.wr_en <= 1'b0;
    fifo_io.cb.rd_en <= 1'b0;
    @(fifo_io.cb);
    fifo_io.rst_n = 1'b1;
  endtask

endmodule

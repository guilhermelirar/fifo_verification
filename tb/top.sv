// top.sv
import tb_pkg::*;
module top;
  parameter int DATA_WIDTH = 16;

  logic clk = 0;
  sync_fifo_if #(DATA_WIDTH) fifo_io (clk);
  sync_fifo #(.DATA_WIDTH(DATA_WIDTH)) dut(
    .clk(clk),
    .rst_n(fifo_io.rst_n),
    .wr_en(fifo_io.wr_en),
    .rd_en(fifo_io.rd_en),
    .data_in(fifo_io.data_in),
    .data_out(fifo_io.data_out),
    .full(fifo_io.full),
    .empty(fifo_io.empty)
  );

  bind dut fifo_assertion #(.DATA_WIDTH(DATA_WIDTH)) fiscal_inst(.*);

  Environment #(DATA_WIDTH) env;

  always begin
    #5 clk = ~clk;
  end

  initial begin
    reset();
    // TODO configure $realtime
    $display("[%m] Initializing test");
    env = new(fifo_io);
    env.run();

    $display("[FINISH] Coverage percent: %d%%", $get_coverage());
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

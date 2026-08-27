// top.sv
import tb_pkg::*;
module top;
  parameter int DATA_WIDTH = 16;

  logic clk = 0;
  sync_fifo_if #(DATA_WIDTH) fifo_io (clk);
  sync_fifo #(.DATA_WIDTH(DATA_WIDTH)) dut(
    fifo_io.DUT
  );

  bind dut fifo_assertion #(.DATA_WIDTH(DATA_WIDTH)) fiscal_inst (
    .fifo_io(fifo_io),
    .read_ptr(dut.read_ptr),
    .write_ptr(dut.write_ptr)
  );

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
    fifo_io.drv_cb.wr_en <= 1'b0;
    fifo_io.drv_cb.rd_en <= 1'b0;
    @(fifo_io.drv_cb);
    fifo_io.rst_n = 1'b1;
  endtask

endmodule

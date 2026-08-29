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

  Test #(DATA_WIDTH) test;
  TestDefault #(DATA_WIDTH) test_default;
  TestWriteHeavy #(DATA_WIDTH) test_wr_heavy;

  always begin
    #5 clk = ~clk;
  end

  initial begin
    test_wr_heavy = new(fifo_io);
    test = test_wr_heavy;
//    test_default = new(fifo_io);
//    test = test_default;
    test.run();
    $display("[FINISH] Coverage percent: %d%%", $get_coverage());
    $finish();
  end

endmodule

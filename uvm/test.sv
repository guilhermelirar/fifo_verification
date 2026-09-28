module test;
  import uvm_pkg::*;
  import tb_pkg::*;

  bit clk;
  always #10 clk = ~clk;

  sync_fifo_if #(DATA_WIDTH) fifo_if0 (clk);  
  sync_fifo #(DEPTH, DATA_WIDTH) dut0 (fifo_if0);

  initial begin
    fifo_if0.rst_n = 0; 
    #50;                
    fifo_if0.rst_n = 1;
  end

  initial begin
    $timeformat(-9, 1, "ns", 10);

    uvm_config_db #(virtual sync_fifo_if#(DATA_WIDTH))::set(null, 
        "*", "vif", fifo_if0);
    run_test();
  end

endmodule: test

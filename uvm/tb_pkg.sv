package tb_pkg;
  import uvm_pkg::*;

  parameter int DATA_WIDTH = 8;

  `include "uvm_macros.svh"
  `include "fifo_item.sv"
  `include "fifo_sequences.sv"
  `include "fifo_driver.sv"
  `include "fifo_coverage.sv"
  `include "fifo_monitor.sv"
  `include "test_suite.sv"
endpackage

package tb_pkg;
  import uvm_pkg::*;

  parameter int DATA_WIDTH = 8;
  parameter int DEPTH      = 8;

  `include "uvm_macros.svh"
  `include "fifo_item.sv"
  `include "fifo_sequences.sv"
  `include "fifo_sequencer.sv"
  `include "fifo_driver.sv"
  `include "fifo_coverage.sv"
  `include "fifo_monitor.sv"
  `include "fifo_scoreboard.sv"
  `include "fifo_agent.sv"
  `include "fifo_env.sv"
  `include "test_suite.sv"
endpackage

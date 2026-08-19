// tb/tb_pkg.sv
// package for testbench
package tb_pkg;
  `include "fifo_transaction.sv"
  `include "generator.sv"
  `include "driver.sv"
  `include "monitor.sv"
endpackage

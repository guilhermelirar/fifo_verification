// tb/fifo_assertion.sv
// assertion module to be bound to RTL
module fifo_assertion #(parameter DEPTH = 8, parameter DATA_WIDTH = 8);
  logic clk, rst_n, wr_en, rd_en, full, empty;

  parameter BIT_WIDTH = $clog2(DEPTH);
  logic [BIT_WIDTH:0] write_ptr, read_ptr;
endmodule

// fifo.sv
// Synchronous FIFO

module Sync_FIFO #(parameter DEPTH=8, parameter DATA_WIDTH=8) (
  input logic [DATA_WIDTH-1:0] data_in,
  input logic rst_n, clk, wr_en, rd_en,

  output logic [DATA_WIDTH-1:0] data_out,
  output full, empty
);

endmodule

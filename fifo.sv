// fifo.sv
// Synchronous FIFO

module Sync_FIFO #(parameter DEPTH=8, parameter DATA_WIDTH=8) (
  input logic [DATA_WIDTH-1:0] data_in,
  input logic rst_n, clk, wr_en, rd_en,

  output logic [DATA_WIDTH-1:0] data_out,
  output full, empty
);

  parameter BIT_WIDTH = $clog2(DEPTH); // ceiling log 2

  // One extra bit is used to differentiate
  // FIFO EMPTY of FIFO FULL
  reg [BIT_WIDTH:0] write_ptr;
  reg [BIT_WIDTH:0] read_ptr;

  assign full = {~write_ptr[BIT_WIDTH], write_ptr[BIT_WIDTH-1:0]} == read_ptr;
  assign empty = write_ptr == read_ptr;

endmodule: Sync_FIFO

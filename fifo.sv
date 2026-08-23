// fifo.sv
// Synchronous FIFO
module sync_fifo #(parameter DEPTH=8, parameter DATA_WIDTH=8) (
  input logic [DATA_WIDTH-1:0] data_in,
  input logic rst_n, clk, wr_en, rd_en,

  output logic [DATA_WIDTH-1:0] data_out,
  output full, empty
);

  parameter BIT_WIDTH = $clog2(DEPTH); // ceiling log 2
  logic [DEPTH-1:0] [DATA_WIDTH-1:0] data;

  // One extra bit is used to differentiate
  // FIFO EMPTY of FIFO FULL
  logic [BIT_WIDTH:0] write_ptr;
  logic [BIT_WIDTH:0] read_ptr;

  assign full = {~write_ptr[BIT_WIDTH], write_ptr[BIT_WIDTH-1:0]} == read_ptr;
  assign empty = write_ptr == read_ptr;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      write_ptr <= '0;
    // r/w enabled when full (?)
    end else if (wr_en && (!full || rd_en)) begin
      data[write_ptr[BIT_WIDTH-1:0]] <= data_in;
      write_ptr <= write_ptr + 1'b1;
    end
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      read_ptr <= '0;
    end else if (rd_en && !empty) begin
      data_out <= data[read_ptr[BIT_WIDTH-1:0]];
      read_ptr <= read_ptr + 1'b1;
    end
  end

endmodule: sync_fifo

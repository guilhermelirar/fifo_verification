// fifo.sv
// Synchronous FIFO
module sync_fifo #(parameter DEPTH=8, parameter DATA_WIDTH=8) (
  sync_fifo_if.DUT fifo_io
);

  parameter BIT_WIDTH = $clog2(DEPTH); // ceiling log 2
  logic [DEPTH-1:0] [DATA_WIDTH-1:0] data;

  // One extra bit is used to differentiate
  // FIFO EMPTY of FIFO FULL
  logic [BIT_WIDTH:0] write_ptr;
  logic [BIT_WIDTH:0] read_ptr;

  assign fifo_io.full = {~write_ptr[BIT_WIDTH], write_ptr[BIT_WIDTH-1:0]} == read_ptr;
  assign fifo_io.empty = write_ptr == read_ptr;

  always_ff @(posedge fifo_io.clk or negedge fifo_io.rst_n) begin
    if (!fifo_io.rst_n) begin
      write_ptr <= '0;
    // r/w enabled when full (?)
    end else if (fifo_io.wr_en && (!fifo_io.full || fifo_io.rd_en)) begin
      data[write_ptr[BIT_WIDTH-1:0]] <= fifo_io.data_in;
      write_ptr <= write_ptr + 1'b1;
    end
  end

  always_ff @(posedge fifo_io.clk or negedge fifo_io.rst_n) begin
    if (!fifo_io.rst_n) begin
      read_ptr <= '0;
    end else if (fifo_io.rd_en && !fifo_io.empty) begin
      fifo_io.data_out <= data[read_ptr[BIT_WIDTH-1:0]];
      read_ptr <= read_ptr + 1'b1;
    end
  end

endmodule: sync_fifo

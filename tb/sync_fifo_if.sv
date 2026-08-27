// sync_fifo_if.sv
// Interface for Synchronous FIFO signals with clocking block

interface sync_fifo_if #(parameter DATA_WIDTH = 8) (input clk);
  logic [DATA_WIDTH-1:0] data_in,
                         data_out;

  logic rst_n,
        wr_en,
        rd_en,
        full,
        empty;

  clocking drv_cb @(posedge clk);
    input data_out, full, empty;
    output data_in, wr_en, rd_en;
  endclocking

  clocking mon_cb @(posedge clk);
    input wr_en, rd_en, data_in, data_out, full, empty;
  endclocking

  modport TB(clocking drv_cb, output rst_n);

  modport MON(clocking mon_cb, input rst_n);

  modport DUT(input clk, rst_n, wr_en, rd_en, data_in,
              output full, empty, data_out);

endinterface

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

  clocking cb @(posedge clk);
    input data_out, full, empty;
    output data_in, wr_en, rd_en;
  endclocking

  modport TB(clocking cb, output rst_n);
  
endinterface

// fifo_transaction.sv
class fifo_transaction #(parameter WIDTH = 8);
  // Random attributes
  rand bit wr_en,
           rd_en;

  rand bit [WIDTH-1:0] data;

  // Sampling attributes
  logic full, empty;

  function bit compare(fifo_transaction tx2);
      if (tx2 == null) return 0;
      return (this.data == tx2.data);
  endfunction

  function display(string prefix = "[fifo_transaction.display]");
    $display(prefix);
    $display("\twr_en: %b\n\trd_en: %b\n\tfull: %b \n\tempty: %b\n\tdata: 0x%h",
      wr_en, rd_en,
      full, empty,
      data);
  endfunction

endclass: fifo_transaction

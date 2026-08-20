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
    $display("{\n\twr_en: %b\n\trd_en: %b\n\tfull: %b \n\tempty: %b\n\tdata: 0x%h\n}",
      wr_en, rd_en,
      full, empty,
      data);
  endfunction

  constraint c_operation_dist {
    {wr_en, rd_en} dist {
      2'b00 := 10,
      2'b01 := 40,
      2'b10 := 40,
      2'b11 := 10
    };
  }

endclass: fifo_transaction

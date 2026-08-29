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
    string operation;
    if (rd_en && wr_en) operation = "(R/W) ";
    else if (!rd_en & wr_en) operation = "( W ) ";
    else if (rd_en) operation = "( R ) ";
    else operation = "(NOP) ";

    $display(
      {prefix, operation,
      $sformatf("EMPTY: %b FULL: %b DATA: 0x%h", empty, full, data)}
    );
  endfunction

endclass: fifo_transaction

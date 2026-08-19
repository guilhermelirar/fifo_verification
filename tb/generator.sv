// tb/generator.sv
// Class that generates transactions
class Generator;
  mailbox #(fifo_transaction) mbx_out;

  function new(mailbox #(fifo_transaction) mbx_out);
    this.mbx_out = mbx_out; // mbx to Driver
  endfunction

  task run(int n_txn);
    repeat (n_txn) begin
      fifo_transaction txn = new();
      txn.randomize();
      mbx_out.put(txn);
    end

    mbx_out.put(null);
  endtask

endclass: Generator

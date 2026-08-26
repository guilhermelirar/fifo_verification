// tb/generator.sv
// Class that generates transactions
class Generator #(parameter D_WIDTH = 8);
  typedef fifo_transaction #(D_WIDTH) transaction_t;
  mailbox #(transaction_t) mbx_out;
  Config cfg;

  function new(Config cfg, mailbox #(transaction_t) mbx_out);
    this.mbx_out = mbx_out; // mbx to Driver
    if (cfg == null) $fatal("[Generator] null configuration object passed!");
    this.cfg = cfg;
  endfunction

  task run();
    repeat (cfg.max_transactions) begin
      transaction_t txn = new();
      txn.randomize();
      mbx_out.put(txn);
    end

    mbx_out.put(null);
  endtask

endclass: Generator

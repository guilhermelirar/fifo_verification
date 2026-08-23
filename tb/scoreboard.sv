// tb/scoreboard.sv
// Checks the correctness of the DUT through a golden_queue
// fed by a mailbox (wr_mbx, rd_mbx)

// #1 mailboxes
// #2 golden_queue + logic for correctness check
typedef mailbox #(fifo_transaction) tx_mailbox;
class Scoreboard;
  tx_mailbox wr_mbx, rd_mbx;
  fifo_transaction golden_queue [$];
  int fifo_depth = 8; // TODO: better place

  function new(tx_mailbox wr_mbx, rd_mbx);
    this.wr_mbx = wr_mbx;
    this.rd_mbx = rd_mbx;
  endfunction

  task run();
  endtask

endclass: Scoreboard

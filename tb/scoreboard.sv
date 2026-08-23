// tb/scoreboard.sv
// Checks the correctness of the DUT through a golden_queue
// fed by a mailbox

// #1 mailbox
// #2 golden_queue + logic for correctness check
typedef mailbox #(fifo_transaction) tx_mailbox;
class Scoreboard;
  tx_mailbox mbx;

  function new(tx_mailbox mbx);
    this.mbx = mbx;
  endfunction

  task run();
    // ...
  endtask

endclass: Scoreboard

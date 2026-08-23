// tb/scoreboard.sv
// Checks the correctness of the DUT through a golden_queue
// fed by a mailbox (wr_mbx, rd_mbx)

// #1 mailboxes
// #2 golden_queue + logic for correctness check
typedef mailbox #(fifo_transaction) tx_mailbox;
class Scoreboard;
  tx_mailbox wr_mbx, rd_mbx;
  int golden_queue [$];
  int fifo_depth = 8; // TODO: better place

  function new(tx_mailbox wr_mbx, rd_mbx);
    this.wr_mbx = wr_mbx;
    this.rd_mbx = rd_mbx;
  endfunction

  task handle_write();
    fifo_transaction tx;
    forever begin
      wr_mbx.get(tx); // gets write request from wr_mbx
      if (golden_queue.size() < fifo_depth) golden_queue.push_back(tx.data);
    end
  endtask

  task handle_read();
    fifo_transaction tx;
    forever begin
      rd_mbx.get(tx);
      if (golden_queue.size() == 0) begin
        $display("[Scoreboard] read on empty"); // error?
      end else begin
        if (int'(tx.data) != golden_queue.pop_front()) begin
          $error(
            "[Scoreboard] retrieved value after read does not match first-in"
          );
        end
      end
    end
  endtask

  task run();
    // possible issue with threads
    fork
      handle_write();
      handle_read();
    join
  endtask

endclass: Scoreboard

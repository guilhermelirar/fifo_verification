// tb/scoreboard.sv
// Checks the correctness of the DUT through a golden_queue
// fed by a mailbox (wr_mbx, rd_mbx)

class Scoreboard #(parameter D_WIDTH = 8);
  typedef fifo_transaction #(D_WIDTH) transaction_t;
  mailbox #(transaction_t) wr_mbx, rd_mbx;
  int golden_queue [$];
  int fifo_depth = 8; // TODO: better place

  function new(mailbox #(transaction_t) wr_mbx, rd_mbx);
    this.wr_mbx = wr_mbx;
    this.rd_mbx = rd_mbx;
  endfunction

  task handle_write();
      transaction_t tx;
      forever begin
        wr_mbx.get(tx);
        // simultaneous write and read behavior
        if (!tx.full || (tx.wr_en && tx.rd_en)) begin
          golden_queue.push_back(tx.data);
        end
      end
    endtask

  task handle_read();
    transaction_t tx;
    forever begin
      rd_mbx.get(tx);
      if (golden_queue.size() == 0) begin
        $display("[Scoreboard] read on empty"); // error?
      end else begin
        if (int'(tx.data) != golden_queue.pop_front()) begin
          $fatal(
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

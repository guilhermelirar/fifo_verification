// tb/driver.sv
// Drives inputs to the DUT

class Driver #(parameter D_WIDTH = 8);
  typedef fifo_transaction #(D_WIDTH) transaction_t;
  mailbox #(transaction_t) mbx;
  virtual sync_fifo_if #(D_WIDTH).TB fifo_io;

  bit log_enable = 0;
  int pkt_count = 0;

  function new(virtual sync_fifo_if #(D_WIDTH).TB fifo_io,
               mailbox #(transaction_t) mbx);
    this.mbx = mbx;
    this.fifo_io = fifo_io;
  endfunction

  task drive_input(transaction_t txn);
    fifo_io.drv_cb.wr_en <= txn.wr_en;
    fifo_io.drv_cb.rd_en <= txn.rd_en;
    fifo_io.drv_cb.data_in <= txn.data;
    @(fifo_io.drv_cb);
    pkt_count++;
  endtask

  task run();
    transaction_t txn;
    if (log_enable) $display("[Driver] %m starting (@%0t)", $realtime);

    // run loop
    while (1) begin
      this.mbx.get(txn);
      if (txn == null) begin
        fifo_io.drv_cb.wr_en <= 1'b0;
        fifo_io.drv_cb.rd_en <= 1'b0;
        @(fifo_io.drv_cb);
        return;
      end

      if (log_enable) begin
        txn.display(
          $sformatf("[Driver] %m got a transaction from Generator (@%0t)",
          $realtime));
      end

      drive_input(txn);
    end
  endtask

endclass

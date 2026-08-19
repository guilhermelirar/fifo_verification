// tb/driver.sv
// Drives inputs to the DUT

class Driver;
  mailbox #(fifo_transaction) mbx;
  virtual sync_fifo_if.TB fifo_io;

  function new(virtual sync_fifo_if fifo_io, mailbox #(fifo_transaction) mbx);
    this.mbx = mbx;
    this.fifo_io = fifo_io;
  endfunction

  task drive_input(fifo_transaction txn);
    fifo_io.cb.wr_en <= txn.wr_en;
    fifo_io.cb.rd_en <= txn.rd_en;
    fifo_io.cb.data_in <= txn.data;
    @(fifo_io.cb);
  endtask

  task run();
    fifo_transaction txn;
    $display("%t [Driver] %m starting", $realtime);

    // run loop
    while (1) begin
      this.mbx.get(txn);
      if (txn == null) return;
      txn.display(
        $sformatf("%t [Driver] %m got a transaction from Generator: ",
        $realtime));

      drive_input(txn);
    end
  endtask

endclass

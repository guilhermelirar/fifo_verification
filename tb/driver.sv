// tb/driver.sv
// Drives inputs to the DUT
class Driver;
  mailbox #(fifo_transaction) mbx;
  virtual sync_fifo_if.TB fifo_io;

  function new(virtual sync_fifo_if fifo_io, mailbox #(fifo_transaction) mbx);
    this.mbx = mbx;
    this.fifo_io = fifo_io;
  endfunction

endclass

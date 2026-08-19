// tb/monitor.sv
class Monitor;
  virtual sync_fifo_if vif;
  bit rd_en_q = 0;

  function new(virtual sync_fifo_if vif);
    this.vif = vif;
  endfunction

  task run();
    $display("[Monitor] %m: monitoring interface to DUT... (@%t)", $realtime);
    forever begin
      @(vif.mon_cb);

      if (rd_en_q) begin
        fifo_transaction tx = new();
        tx.rd_en = 1'b1;
        tx.data  = vif.mon_cb.data_out;
        tx.empty = vif.mon_cb.empty;
        tx.full  = vif.mon_cb.full;
        tx.display("[Monitor] read attempt:");
      end

      if (vif.mon_cb.wr_en == 1'b1) begin
        fifo_transaction tx = new();
        tx.wr_en = 1'b1;
        tx.data  = vif.mon_cb.data_in;
        tx.empty = vif.mon_cb.empty;
        tx.full  = vif.mon_cb.full;
        tx.display("[Monitor] write attempt:");
      end

      rd_en_q = (vif.mon_cb.rd_en == 1'b1);
    end
  endtask

endclass

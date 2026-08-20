// tb/monitor.sv
class Monitor;
  virtual sync_fifo_if vif;
  bit log_enable = 0;
  bit rd_en_q = 0;

  function new(virtual sync_fifo_if vif);
    this.vif = vif;
  endfunction

  // Constructs a transaction based in the current state of the virtual
  // interface
  task sample_vif(fifo_transaction tx, bit data_sel = 0);
    tx.wr_en = vif.mon_cb.wr_en;
    tx.rd_en = vif.mon_cb.rd_en;
    tx.data  = data_sel ? vif.mon_cb.data_out : vif.mon_cb.data_in;
    tx.empty = vif.mon_cb.empty;
    tx.full  = vif.mon_cb.full;
  endtask

  task run();
    if (log_enable) 
      $display("[Monitor] %m: monitoring interface to DUT... (@%0t)", $realtime);
    
    forever begin
      @(vif.mon_cb);

      if (rd_en_q) begin
        fifo_transaction tx = new();
        sample_vif(tx, 1);
        if (log_enable) tx.display(
          $sformatf("(@%0t) [Monitor] Read response: ", $realtime
        ));      
      end

      if (vif.mon_cb.wr_en) begin
        fifo_transaction tx = new();
        sample_vif(tx);
        if (log_enable) tx.display(
          $sformatf("(@%0t) [Monitor] Write request: ", $realtime
        ));
      end

      if (vif.mon_cb.rd_en) begin
        fifo_transaction tx = new();
        sample_vif(tx);
        tx.data = 'x;
        if (log_enable) tx.display(
          $sformatf("(@%0t) [Monitor] Read request:  ", $realtime
        ));
      end

      rd_en_q = (vif.mon_cb.rd_en == 1'b1);
    end
  endtask

endclass

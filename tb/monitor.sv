// tb/monitor.sv
class Monitor #(parameter D_WIDTH = 8);;
  virtual sync_fifo_if vif;
  bit log_enable = 0;
  bit rd_en_q = 0;

  typedef fifo_transaction #(D_WIDTH) transaction_t;
  mailbox #(transaction_t) wr_mbx;
  mailbox #(transaction_t) rd_mbx;
  int total_transactions;

  fifo_coverage cov_inst;

  function new(virtual sync_fifo_if vif,
               mailbox #(transaction_t) wr_mbx,
               mailbox #(transaction_t) rd_mbx);
    this.vif = vif;
    this.wr_mbx = wr_mbx;
    this.rd_mbx = rd_mbx;
  endfunction

  // Constructs a transaction based in the current state of the virtual
  // interface
  task sample_vif(transaction_t tx, bit data_sel = 0);
    tx.wr_en = vif.mon_cb.wr_en;
    tx.rd_en = vif.mon_cb.rd_en;
    tx.data  = data_sel ? vif.mon_cb.data_out : vif.mon_cb.data_in;
    tx.empty = vif.mon_cb.empty;
    tx.full  = vif.mon_cb.full;
  endtask


  task run();
    transaction_t tx;
    total_transactions = 0;

    if (log_enable)
      $display("[Monitor] %m: monitoring interface to DUT... (@%0t)", $realtime);

    forever begin

      @(vif.mon_cb);
      tx = new();
      sample_vif(tx);
      total_transactions++;

      // Samples the result of a read request, and sends it to
      // the scoreboard mailbox of read responses
      if (rd_en_q) begin
        transaction_t tx_resp = new();
        sample_vif(tx_resp, 1);
        if (log_enable) tx.display(
          $sformatf("(@%0t) [Monitor] Read response: ", $realtime
        ));
        rd_mbx.put(tx_resp);
      end

      // Samples requests (write or read) and sends the write
      // requests to the wr_mbx (to the Scoreboard instance)
      if (vif.mon_cb.wr_en || vif.mon_cb.rd_en)
      begin
        if (log_enable) tx.display(
          $sformatf("(@%0t) [Monitor] Request: ", $realtime
        ));
        if (vif.mon_cb.wr_en) wr_mbx.put(tx);
      end

      if (cov_inst != null) cov_inst.sample(tx);
      rd_en_q = ((vif.mon_cb.rd_en == 1'b1) && !vif.mon_cb.empty);
    end
  endtask

endclass

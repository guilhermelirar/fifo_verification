// monitor to capture transactions from DUT Interface
// Captures write requests to the FIFO and the response
// of read requests (one cycle after rd_en rise). It also
// calls cov.sample(tr) when coverage collection is enabled
class fifo_monitor #(DATA_WIDTH = 8) extends uvm_monitor;
  `uvm_component_utils(fifo_monitor)

  int unsigned tr_cnt = 0;
  virtual sync_fifo_if #(DATA_WIDTH) vif;
  uvm_analysis_port #(fifo_item #(DATA_WIDTH)) mon_analysis_port;

  function new(string name = "fifo_monitor", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "%m Monitor instantiated", UVM_HIGH)
  endfunction

  // Retrieves virutal interface and coverage options
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual sync_fifo_if #(DATA_WIDTH))::get(
      this, "", "vif", vif)
    ) begin
      `uvm_fatal(get_type_name(), "%m Failed to retrieve virtual interface");
    end

    `uvm_info(get_type_name(), "%m Monitor was built" , UVM_HIGH)
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_item #(DATA_WIDTH) tr;
    bit rd_requested = 0;

    if (phase == null) begin end // disable warnings

    wait (vif.rst_n == 1'b1);

    forever begin
      @(vif.mon_cb);

      if (vif.mon_cb.wr_en || rd_requested || vif.mon_cb.rd_en) begin
        tr = fifo_item#(DATA_WIDTH)::type_id::create(
          $sformatf("tr#%0d", tr_cnt)
        );

        tr.wr_en    = vif.mon_cb.wr_en;
        tr.rd_en    = vif.mon_cb.rd_en;
        tr.data_in  = vif.mon_cb.data_in;
        tr.data_out = vif.mon_cb.data_out;
        mon_analysis_port.write(tr);
      end

      rd_requested = vif.mon_cb.rd_en;
    end

  endtask
endclass

// fifo_driver.sv
class fifo_driver #(parameter DATA_WIDTH = 8)
extends uvm_driver #(fifo_item #(DATA_WIDTH));

  `uvm_component_utils(fifo_driver);

  virtual sync_fifo_if #(DATA_WIDTH).TB vif;

  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "%m Driver instantiated!", UVM_HIGH);
  endfunction

  // Retrieves the virtual interface through the uvm_config_db
  virtual function build_phase(uvm_phase phase);
    if (uvm_config_db #(virtual sync_fifo_if #(DATA_WIDTH))::get(
      this, "", "vif", vif
    ))
    begin
      `uvm_info(get_type_name(),
        "%m Retrieved virtual interface successfully", UVM_HIGH);
    end else begin
      `uvm_fatal(get_type_name(), "%m Failed to retrieve virtual interface");
    end
  endfunction

  // Drivers signals into the interface using the clocking block
  virtual task run_phase(uvm_phase phase);
    fifo_item #(DATA_WIDTH) tr;

    wait (vif.rst_n == 1'b1); // Avoids driving signals through reset

    forever begin
      seq_item_port.get_next_item(tr);

      @(vif.drv_cb);
      vif.drv_cb.wr_en <= tr.wr_en;
      vif.drv_cb.rd_en <= tr.rd_en;
      vif.drv_cb.data_in <= tr.data_in;

      /** -- only needed if sequence needs to know outputs
      @(vif.drv_cb);
      // Deassert control signals to prevent duplicate operations in the next cycle
      vif.drv_cb.wr_en <= 1'b0;
      vif.drv_cb.rd_en <= 1'b0;

      @(vif.drv_cb);
      tr.full <= vif.drv_cb.full;
      tr.empty <= vif.drv_cb.empty;
      if (tr.rd_en) tr.data_out <= vif.drv_cb.data_out;
      **/

      seq_item_port.item_done();
    end

  endtask

endclass

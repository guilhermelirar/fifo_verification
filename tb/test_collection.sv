// test_collection.sv
// Classes that consists in diferent test scenarios
class Test #(parameter DATA_WIDTH = 8);
  string name;
  Config cfg;
  Environment #(DATA_WIDTH) env;
  virtual interface sync_fifo_if #(DATA_WIDTH) vif;

  function new(
    virtual interface sync_fifo_if #(DATA_WIDTH) vif,
    string name = "Test"
  );
    if (vif == null) $fatal("[%m] Null interface passed to test");
    this.vif = vif;
    this.name = name;
    this.cfg = new();
  endfunction

  virtual task run();
    $display({"Running: ", name});
  endtask

  task reset(int n_cycles = 1);
    vif.rst_n = 1'b0;
    vif.drv_cb.wr_en <= 1'b0;
    vif.drv_cb.rd_en <= 1'b0;
    repeat (n_cycles) @(vif.drv_cb);
    vif.rst_n = 1'b1;
  endtask

endclass

// Default test
class TestDefault #(parameter DATA_WIDTH = 8) extends Test #(DATA_WIDTH);
  function new(
    virtual interface sync_fifo_if #(DATA_WIDTH) vif,
    string name = "Default"
  );
    super.new(vif, name);
    this.env = new(vif);
  endfunction

  task run();
    super.run();
    reset();
    env.cfg = cfg; // passing default configuration
    env.mon.log_enable = 1;
    env.run();
  endtask
endclass

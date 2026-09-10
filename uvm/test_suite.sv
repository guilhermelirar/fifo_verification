class test_base extends uvm_test;
  `uvm_component_utils(test_base)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  function void build_phase(uvm_phase phase); endfunction

  function void start_of_simulation();
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_item item = new("fifo_item #1");
    phase.raise_objection(this);
    // [PLACEHOLDER] Should use sequence
    item.print();

    item.print();
    phase.drop_objection(this);
  endtask

endclass: test_base

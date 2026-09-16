class test_base extends uvm_test;
  `uvm_component_utils(test_base)

  function new(string name = "test_base", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    uvm_top.print_topology();
  endfunction

  virtual task run_phase(uvm_phase phase);
    fifo_sequence#(DATA_WIDTH) seq;
    seq = fifo_sequence#(DATA_WIDTH)::type_id::create("seq");

    phase.raise_objection(this);
    // seq.start(env.sequencer);
    phase.drop_objection(this);
  endtask
endclass: test_base

class test_write_heavy extends test_base;
  `uvm_component_utils(test_write_heavy)

  function new(string name = "test_write_heavy", uvm_component parent);
    super.new(name, parent);
  endfunction

endclass

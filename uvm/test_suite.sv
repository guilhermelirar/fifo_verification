class test_base extends uvm_test
  `uvm_component_utils(test_base)

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
  endfunction

  extern function void build_phase(uvm_phase phase);
  extern function void start_of_simulation_phase(phase);

endclass: test_base

// fifo_sequencer
class fifo_sequencer #(int DATA_WIDTH = 8) extends uvm_sequencer #(fifo_item #(DATA_WIDTH));
  `uvm_component_param_utils(fifo_sequencer #(DATA_WIDTH))

  function new(string name = "fifo_sequencer", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info(get_type_name(), "%m Sequencer instantiated", UVM_HIGH);
  endfunction
endclass

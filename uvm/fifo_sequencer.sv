// fifo_sequencer
class fifo_sequencer extends uvm_sequencer #(fifo_item);
  `uvm_component_utils(fifo_sequencer)

  function new(string name = "fifo_sequencer", uvm_component parent);
    super.new(name, parent);
    `uvm_info(this.get_type_name(), "%m", UVM_HIGH);
  endfunction

endclass

// uvm/fifo_env.sv 
// Environment that connects the agent ant scoreboard
class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

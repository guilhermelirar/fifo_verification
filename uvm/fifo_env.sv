// uvm/fifo_env.sv 
// Environment that connects the agent ant scoreboard
class fifo_env #(parameter int DATA_WIDTH = 8, 
                 parameter int DEPTH = 8) extends uvm_env;
  
  `uvm_component_param_utils(fifo_env #(DATA_WIDTH, DEPTH))

  fifo_agent #(DATA_WIDTH)              agt;
  fifo_scoreboard #(DATA_WIDTH, DEPTH) scbd;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass

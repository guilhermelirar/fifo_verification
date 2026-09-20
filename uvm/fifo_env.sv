// uvm/fifo_env.sv 
// Environment that connects the agent ant scoreboard
class fifo_env #(parameter int DATA_WIDTH = 8, 
                 parameter int DEPTH = 8) extends uvm_env;
  
  `uvm_component_param_utils(fifo_env #(DATA_WIDTH, DEPTH))

  fifo_agent #(DATA_WIDTH)             m_agent;
  fifo_scoreboard #(DATA_WIDTH, DEPTH) m_scoreboard;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "%m Environment instantiated", UVM_HIGH);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agent = fifo_agent #(DATA_WIDTH)::type_id::create("m_agent", this);
    m_scoreboard = fifo_scoreboard #(DATA_WIDTH, DEPTH)::type_id::create(
        "m_scoreboard",
        this
      );

    `uvm_info(get_type_name(), "%m Environment built", UVM_HIGH);
  endfunction

  // Connects monitor analysis port to the scoreboard's analysis port 
  // implementation 
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_agent.monitor.mon_analysis_port.connect(m_scoreboard.ap_imp);
      `uvm_info(get_type_name(), "%m Environment connected", UVM_HIGH);
  endfunction

endclass

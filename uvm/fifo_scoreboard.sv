// uvm/fifo_scoreboard.sv
// Check if the FIFO protocol is being implemented,
// receiving transactions observed at the interface from the Monitor
class fifo_scoreboard #(DATA_WIDTH = 8) extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  uvm_analysis_imp #(fifo_item #(DATA_WIDTH),
                     fifo_scoreboard #(DATA_WIDTH)) ap_imp;

  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "%m Scoreboard instantiated", UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_imp = new("ap_imp", this);
  endfunction

  virtual function void write(fifo_item #(DATA_WIDTH) tr);
    // TODO
  endfunction

endclass

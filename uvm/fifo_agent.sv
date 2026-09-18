// uvm/fifo_agent.sv
// Encapsulates monitor, sequencer, driver and coverage
// Instantiates and connects them
class fifo_agent extends uvm_agent;
  `uvm_component_utils(fifo_agent)

  fifo_sequencer#(DATA_WIDTH) sequencer;
  fifo_monitor #(DATA_WIDTH)  monitor;
  fifo_coverage #(DATA_WIDTH) coverage;
  fifo_driver #(DATA_WIDTH) driver;

  bit enable_coverage = 1;

  function new(string name = "fifo_agent", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "%m Agent instantiated", UVM_HIGH);
  endfunction

  // Instantiates monitor and coverage, and also sequencer and driver
  // in case of active agent
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(bit)::get(this, "", "enable_coverage", enable_coverage))
    begin
      `uvm_info(
        get_type_name(),
        "Using default value of 1 for enable_coverage",
        UVM_WARNING
      );
    end

    // Active components
    if (get_is_active()) begin
      driver = fifo_driver #(DATA_WIDTH)::type_id::create(
        "fifo_driver", this
      );

      sequencer = fifo_sequencer #(DATA_WIDTH)::type_id::create(
        "fifo_sequencer", this
      );
    end

    // Passive components
    monitor = fifo_monitor #(DATA_WIDTH)::type_id::create(
      "fifo_monitor", this
    );

    if (enable_coverage) begin
      coverage = fifo_coverage #(DATA_WIDTH)::type_id::create(
        "fifo_coverage", this
      );
    end
  endfunction

  // Connects condicionally the ports (who calls the methods on it)
  // To the respective exports
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Only connect if instantiated
    if (get_is_active()) begin
      // driver asks for new items
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end

    // monitor sends (write) items
    if (enable_coverage) begin
      monitor.mon_analysis_port.connect(coverage.analysis_export);
    end
  endfunction

endclass

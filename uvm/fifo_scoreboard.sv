// uvm/fifo_scoreboard.sv
// Check if the FIFO protocol is being implemented,
// receiving transactions observed at the interface from the Monitor
class fifo_scoreboard #(parameter int DATA_WIDTH = 8, parameter int DEPTH=8)
extends uvm_scoreboard;
  `uvm_component_param_utils(fifo_scoreboard #(DATA_WIDTH, DEPTH))

  uvm_analysis_imp #(fifo_item #(DATA_WIDTH),
                     fifo_scoreboard #(DATA_WIDTH)) ap_imp;

  logic [DATA_WIDTH-1:0] golden_queue[$];
  bit rd_requested   = 1'b0;
  bit empty          = 1'b1;
  bit full           = 1'b0;

  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Scoreboard instantiated", UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_imp = new("ap_imp", this);
  endfunction

  // Operates the golden_queue according to the FIFO expected behavior
  // push_back data_in when wr_en is high and FIFO is not full, and pop_front
  // if FIFO is not empty and rd_en is high. In case of rd_en high, the popped
  // data is compared with the next tr.data_out (as well as empty/full) to check
  // the correctness of the FIFO
  virtual function void write(fifo_item #(DATA_WIDTH) tr);
    logic [DATA_WIDTH-1:0] first_in;

    if ((tr.empty != empty) || (tr.full != full)) begin
      `uvm_error(get_type_name(),
        $sformatf(
          "Transaction flags (empty|full) %b%b different from expected %b%b",
          tr.empty, tr.full, empty, full
        ));
    end

    if (rd_requested && !empty) begin
      first_in = golden_queue.pop_front();
      if (!(first_in === tr.data_out)) begin
        `uvm_error(get_type_name(),
          $sformatf("Data retrieved '0x%h' != expected '0x%h'",
                    tr.data_out, first_in));
      end
    end

    // Write occurs when not full (including full with rd_en high, since
    // write is performed but state remains full)
    if (tr.wr_en && (!full | tr.rd_en)) begin
      if ($isunknown(tr.data_in)) `uvm_fatal(
        "TESTBENCH ERROR",
        "FIFO input data has unknown bit(s)"
      );

      golden_queue.push_back(tr.data_in);
    end

    rd_requested = tr.rd_en;
    empty        = golden_queue.size() == 0;
    full         = golden_queue.size() == DEPTH;
  endfunction
endclass

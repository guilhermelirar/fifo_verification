// uvm/fifo_scoreboard.sv
// Check if the FIFO protocol is being implemented,
// receiving transactions observed at the interface from the Monitor
class fifo_scoreboard #(parameter int DATA_WIDTH = 8, parameter int DEPTH=8)
extends uvm_scoreboard;
  `uvm_component_param_utils(fifo_scoreboard #(DATA_WIDTH, DEPTH))

  uvm_analysis_imp #(fifo_item #(DATA_WIDTH),
                     fifo_scoreboard #(DATA_WIDTH, DEPTH)) ap_imp;

  logic [DATA_WIDTH-1:0] golden_queue[$];
  logic [DATA_WIDTH-1:0] dout_expected;
  bit rd_requested   = 1'b0;

  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info(get_type_name(), "Scoreboard instantiated", UVM_HIGH);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap_imp = new("ap_imp", this);
  endfunction

  virtual function void write(fifo_item #(DATA_WIDTH) tr);
    `uvm_info(get_type_name(),
      $sformatf("TR RECEIVED: wr_en=%b rd_en=%b data_in=0x%h data_out=0x%h empty=%b full=%b | rd_req=%b queue_size=%0d",
                tr.wr_en, tr.rd_en, tr.data_in, tr.data_out, tr.empty, tr.full, rd_requested, golden_queue.size()),
      UVM_LOW);

    // Check if flags are coherent with golden_queue state
    if (tr.full != golden_queue.size() == DEPTH) begin
      `uvm_error("FIFO_FLAG_MISMATCH",
        $sformatf("retrieved full != expected '%b'", !tr.full))
    end

    if (tr.empty != golden_queue.size() == 0) begin
      `uvm_error("FIFO_FLAG_MISMATCH",
        $sformatf("retrieved empty != expected '%b'", !tr.empty))
    end

    // Compare data_out if valid data_out expected
    if (rd_requested == 1) begin
      if (!(tr.data_out === dout_expected)) begin
        `uvm_error("FIFO ITEM MISMATCH",
          $sformatf("Data retrieved '0x%h' != expected '0x%h'",
                    tr.data_out, dout_expected));
      end
      rd_requested = 0;
    end

    // Handle current read request for next cycle (read if not empty)
    if (tr.rd_en && golden_queue.size() > 0) begin
      rd_requested = 1;
      dout_expected = golden_queue.pop_front();
    end

    // Handle write request (write if not full)
    if (tr.wr_en && golden_queue.size() < DEPTH) begin
      golden_queue.push_back(tr.data_in);
    end

  endfunction

endclass

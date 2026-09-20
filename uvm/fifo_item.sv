// uvm_seq_item for fifo transaction item
class fifo_item #(DATA_WIDTH = 8) extends uvm_sequence_item;
  rand bit wr_en, rd_en;
  rand bit [DATA_WIDTH-1:0] data_in;

  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty;

  // register into factory and field automation
  `uvm_object_param_utils_begin(fifo_item #(DATA_WIDTH))
    `uvm_field_int(data_in, UVM_ALL_ON)
    `uvm_field_int(data_out, UVM_ALL_ON)
    `uvm_field_int(wr_en, UVM_BIN)
    `uvm_field_int(rd_en, UVM_BIN)
    `uvm_field_int(empty, UVM_BIN)
    `uvm_field_int(full, UVM_BIN)
  `uvm_object_utils_end

  function new(string name = "fifo_item");
    super.new(name);
  endfunction
endclass

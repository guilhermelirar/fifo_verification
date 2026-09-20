// fifo_sequence
// random transactions (no write or read heavy)
class fifo_sequence #(DATA_WIDTH=8) 
  extends uvm_sequence #(fifo_item #(DATA_WIDTH));
  `uvm_object_param_utils(fifo_sequence #(DATA_WIDTH))

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

endclass

class fifo_sequence_heavy_write #(DATA_WIDTH=8) 
  extends fifo_sequence #(DATA_WIDTH);
  `uvm_object_param_utils(fifo_sequence_heavy_write #(DATA_WIDTH))

  function new(string name = "fifo_sequence_heavy_write");
    super.new(name);
  endfunction

  virtual task body();
    repeat(100) begin
      req = fifo_item #(DATA_WIDTH)::type_id::create("req");
      start_item(req);
      req.randomize() with { wr_en dist {0 := 2, 1 := 8}; };
      finish_item(req);
    end
  endtask
endclass

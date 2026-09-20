// fifo_sequence
// random transactions (no write or read heavy)
class fifo_sequence #(DATA_WIDTH=8) 
  extends uvm_sequence #(fifo_item #(DATA_WIDTH));
  `uvm_object_param_utils(fifo_sequence #(DATA_WIDTH))

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(100) begin
      req = fifo_item #(DATA_WIDTH)::type_id::create("req");
      start_item(req);
      req.randomize();
      finish_item(req);
    end
  endtask
endclass


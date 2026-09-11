// fifo_sequence
// random transactions (no write or read heavy)
class fifo_sequence extends uvm_sequence #(fifo_item);
  `uvm_object_utils(fifo_sequence)

  function new(string name = "fifo_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat (50) begin
      req = fifo_item::type_id::create();
      start_item(req); // blocks until sequencer is ready to receive
      assert(req.randomize());
      finish_item(req);
    end
  endtask

endclass

// top.sv
// Currently useless
module top;
  fifo_transaction t1, t2;

  initial begin
    // TODO configure $realtime
    t1 = new();
    t2 = new();
    t1.randomize();
    t1.compare(t2);
  end

endmodule

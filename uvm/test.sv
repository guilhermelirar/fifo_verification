program automatic test;
  import uvm_pkg::*;
  import tb_pkg::*;

  initial begin
    $timeformat(-9, 1, "ns", 10);
    run_test();
  end

endprogram: test

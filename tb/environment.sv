// environment.sv
// A class that encapsulates testbench structural components
// such as Generator, Driver, Monitor, Scoreboard, Coverage
// and instantiates them.
class Environment #(parameter D_WIDTH = 8);
  Config cfg;
  virtual interface sync_fifo_if #(D_WIDTH) vif;
  Driver      #(D_WIDTH) drv;
  Generator   #(D_WIDTH) gnr;
  Monitor     #(D_WIDTH) mon;
  Scoreboard  #(D_WIDTH) scbd;
  fifo_coverage cov_inst;

  typedef mailbox #(fifo_transaction #(D_WIDTH)) tx_mailbox;
  tx_mailbox gen_mbx, wr_mbx, rd_mbx;

  extern function new(virtual interface sync_fifo_if #(D_WIDTH) vif);
  extern task run();

endclass: Environment

function Environment::new(virtual interface sync_fifo_if #(D_WIDTH) vif);
  this.vif = vif;
  this.cfg = new();

  if (vif == null) $fatal("[Environment] null interface");

  // mailboxes & coverage
  gen_mbx  = new();
  wr_mbx   = new();
  rd_mbx   = new();
  cov_inst = new();

  gnr = new(cfg, gen_mbx);
  drv = new(vif, gen_mbx);
  // monitor with coverage instance
  mon = new(vif, wr_mbx, rd_mbx);
  mon.cov_inst = cov_inst;

  scbd = new(wr_mbx, rd_mbx);
endfunction

task Environment::run();
  $display("[Environment] running components until %d transactions",
    cfg.max_transactions);

  fork
    gnr.run();
    drv.run();
    mon.run();
    scbd.run();
  join_none;

  wait(mon.total_transactions == cfg.max_transactions);
  disable fork;

  $display("[Environment] max transactions (%d) reached", cfg.max_transactions);
endtask: run

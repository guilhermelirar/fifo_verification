// tb/coverage.sv
// coverage collector class
class fifo_coverage;

  covergroup fifo_cg with function sample(fifo_transaction tr);
    cp_full: coverpoint tr.full {
      bins not_full = {0};
      bins full     = {1};
    }

    cp_empty: coverpoint tr.empty {
      bins not_empty = {0};
      bins empty     = {1};
    }

    cp_op_read: coverpoint tr.rd_en {
      bins rd_inacitve  = {0};
      bins rd_active = {1};
    }

    cp_op_write: coverpoint tr.rd_en {
      bins wr_inactive      = {0};
      bins wr_active = {1};
    }

    cp_op_simultaneous: cross cp_op_read, cp_op_write {
      bins simultaneous =
        binsof(cp_op_write.wr_active) &&
        binsof(cp_op_read.rd_active);
    }
  endgroup

endclass

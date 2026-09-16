// uvm/fifo_coverage.sv
// Class that subscribes to monitor's analysis port
// and samples coverage
class fifo_coverage #(DATA_WIDTH=8) extends uvm_subscriber #(fifo_item #(DATA_WIDTH));
  `uvm_component_utils(fifo_coverage)

  fifo_item #(DATA_WIDTH) tr;

  covergroup fifo_cg;
    cp_full: coverpoint tr.full {
      bins not_full = {0};
      bins full     = {1};
    }

    cp_empty: coverpoint tr.empty {
      bins not_empty = {0};
      bins empty     = {1};
    }

    cp_op_read: coverpoint tr.rd_en {
      bins no_read  = {0};
      bins read_req = {1};
    }

    cp_op_write: coverpoint tr.wr_en {
      bins no_write  = {0};
      bins write_req = {1};
    }

    cp_op_simultaneous: cross cp_op_read, cp_op_write {
      bins simultaneous = binsof(cp_op_write.write_req)
                          && binsof(cp_op_read.read_req);
    }

    // covering write on full & empty cases
    cp_write_cross: cross cp_op_write, cp_full, cp_empty {
      bins write_on_full  = binsof(cp_op_write.write_req) && binsof(cp_full.full);
      bins write_on_empty = binsof(cp_op_write.write_req) && binsof(cp_empty.empty);
    }

    // covering read on empty & full cases
    cp_read_cross: cross cp_op_read, cp_full, cp_empty {
      bins read_on_full  = binsof(cp_op_read.read_req) && binsof(cp_full.full);
      bins read_on_empty = binsof(cp_op_read.read_req) && binsof(cp_empty.empty);
    }
  endgroup

  function new(string name = "fifo_coverage", uvm_component parent);
    super.new(name, parent);
    fifo_cg = new();
    `uvm_info(get_type_name(), "%m Coverage class instantiated!", UVM_HIGH);
  endfunction

  virtual function write(fifo_item #(DATA_WIDTH) tr);
    this.tr = tr;
    fifo_cg.sample();
  endfunction

endclass

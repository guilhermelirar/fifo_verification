UVM_DEFINES = UVM_NO_DEPRECATED
UVM_VER = uvm-1.2
VERBOSITY = UVM_MEDIUM
BUILD_DIR = ./build
SRC = files.f
LOG = simv.log
TEST = test_base
INCDIR = .

COMPILE_UVM_OPTS = -ntb_opts $(UVM_VER) +define+$(UVM_DEFINES)
COMPILE_OPTS = -sverilog -q -full64 -lca -debug_access+all -kdb -timescale="1ns/100ps" -l comp.log

RUNTIME_OPTS = -q -no_save -l $(LOG) +UVM_TESTNAME=${TEST} +UVM_VERBOSITY=$(VERBOSITY) +UVM_NO_RELNOTES

all: simv run

simv:
		@mkdir -p $(BUILD_DIR)
		cd $(BUILD_DIR) && vcs +incdir+../$(INCDIR) $(COMPILE_OPTS) $(COMPILE_UVM_OPTS) -f ../$(SRC)

run:
	  cd $(BUILD_DIR) && ./simv $(RUNTIME_OPTS)

clean:
	  rm -rf $(BUILD_DIR)

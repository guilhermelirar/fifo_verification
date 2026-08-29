TB_DIR = tb
FILES = files.f
BUILD_DIR = build
VCS_OPTIONS = -sverilog -full64 +incdir+$(TB_DIR) -f $(FILES)
COMP_LOG = vcs.log
SIMV_LOG = simv.log

all: compile run

compile: $(BUILD_DIR)/simv

$(BUILD_DIR)/simv: $(FILES)
	mkdir -p $(BUILD_DIR)
	vcs $(VCS_OPTIONS) -Mdir=$(BUILD_DIR)/csrc -o $(BUILD_DIR)/simv -l $(BUILD_DIR)/$(COMP_LOG)

run: compile
	cd $(BUILD_DIR) && ./simv -q -no_save -l $(SIMV_LOG)

cov:
	urg -dir $(BUILD_DIR)/simv.vdb -report $(BUILD_DIR)/urgReport

clean:
	rm -rf $(BUILD_DIR) *.log csrc simv* ucli.key

.PHONY: all compile run cov clean

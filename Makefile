# Makefile

all: analyze compile run

analyze:
	mkdir -p build
	cd build && vlogan -sverilog -full64 -q -l vlogan.log \
		+incdir+../tb \
		../fifo.sv \
		../tb/sync_fifo_if.sv \
		../tb/tb_pkg.sv \
		../tb/top.sv

compile:
	cd build && vcs -sverilog -full64 -q -l compile.log +incdir+../tb -f ../files.f

run:
	cd build && ./simv -q -no_save -l simv.log

cov:
	cd build && urg -dir simv.vdb

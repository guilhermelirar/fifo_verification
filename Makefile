# Makefile
all:
	@echo "Nothing to do here (Makefile not ready)"
	@exit 1

analyze: build/vlogan.log
	# TODO: clean this (use variables)
	cd build && vlogan -sverilog -full64 -q -l vlogan.log ../tb/*.sv

compile:
	# TODO: improve this also
	cd build && vcs -sverilog -full64 -q -l compile.log -f ../files.f

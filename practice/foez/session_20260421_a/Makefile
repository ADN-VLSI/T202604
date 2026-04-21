GUI := 0

ifeq ($(GUI), 0)
	XSIM_FLAGS := -runall
else
	XSIM_FLAGS := -gui --autoloadwcfg --view ../potato_tb.wcfg
endif

build:
	@mkdir -p build
	@echo "*" > build/.gitignore

.PHONY: run
run:
	@make -s build
	@cd build && xvlog -sv ../potato.sv ../potato_tb.sv
	@cd build && xelab potato_tb -s potato_tb -debug all
	@cd build && xsim potato_tb $(XSIM_FLAGS)

.PHONY: clean
clean:
	@rm -rf build

.PHONY: all
all:
	@make -s clean
	@make -s run

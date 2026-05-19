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
	@cd build && xvlog -sv ../regif.sv ../regif_tb.sv
	@cd build && xelab regif_tb -s regif_tb -debug all
	@cd build && xsim regif_tb -runall

.PHONY: clean
clean:
	@rm -rf build

.PHONY: all
all:
	@make -s clean
	@make -s run
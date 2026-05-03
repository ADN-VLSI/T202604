export SHELL=/bin/bash

export ROOT=$(realpath ../../..)
export RUN_DIR=$(realpath .)
export APB_UART=$(ROOT)/submodule/apb-uart

FLIST += ${APB_UART}/rtl/apb_memif.sv
FLIST += ${RUN_DIR}/rtl/memory.sv
FLIST += ${RUN_DIR}/rtl/apb_mem.sv
FLIST += ${RUN_DIR}/tb/apb_mem_tb.sv

BUILD_DIR = $(ROOT)/build
LOG_DIR = $(ROOT)/log

EW_HL := | grep -E "WARNING:|ERROR:|" --color=auto

$(BUILD_DIR) $(LOG_DIR):
	@mkdir -p $@
	@echo "*" > $@/.gitignore

.PHONY: clean
clean:
	@rm -rf $(BUILD_DIR) $(LOG_DIR)

.PHONY: all
all:
	@make -s clean
	@make -s $(BUILD_DIR)
	@make -s $(LOG_DIR)
	@cd $(BUILD_DIR) && xvlog -sv $(FLIST) -log $(LOG_DIR)/xvlog.log ${EW_HL}
	@cd $(BUILD_DIR) && xelab -debug all apb_mem_tb -s apb_mem_tb -log $(LOG_DIR)/xelab.log ${EW_HL}
	@cd $(BUILD_DIR) && xsim apb_mem_tb -runall -log $(LOG_DIR)/xsim.log ${EW_HL}
